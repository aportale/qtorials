#include "painting.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QGuiApplication>
#include <QJsonDocument>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQmlListReference>
#include <QQmlProperty>
#include <QQuickItem>
#include <QQuickRenderControl>
#include <QQuickRenderTarget>
#include <QQuickWindow>
#include <QRegularExpression>
#include <QtMath>

#include <rhi/qrhi.h>

static QVariantMap initialPropertiesMap(const QString &initialProperties, IScriptEnvironment* env)
{
    QJsonParseError jsonError;
    const QJsonDocument jsonDocument =
            QJsonDocument::fromJson(initialProperties.toUtf8(), &jsonError);
    if (jsonDocument.isNull()) {
        env->ThrowError("QtAviSynthQmlAnimation:\n%s\n%s",
                        initialProperties.toLatin1().constData(),
                        jsonError.errorString().toLatin1().constData());
    }
    return jsonDocument.toVariant().toMap();
}

static QObject *timeLineItem(const QObject *parentItem)
{
    for (auto child : parentItem->children()) {
        if (strcmp(child->metaObject()->className(), "QQuickTimeline") == 0)
            return child;
        auto found = timeLineItem(child);
        if (found)
            return found;
    }
    return {};
}

static void parseQmlprojectFile(const QString &fileName, QString *mainFile, QStringList *importPaths)
{
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly))
        return;
    const QString text = QString::fromUtf8(file.readAll());
    const QRegularExpression mainFileRegExp("mainFile:\\s*\"(.*)\"");
    const QRegularExpressionMatch mainFileMatch = mainFileRegExp.match(text);
    if (mainFileMatch.hasMatch()) {
        const QString basePath = QFileInfo(fileName).path() + "/";
        *mainFile = basePath + mainFileMatch.captured(1);

        const QRegularExpression importPathsRegExp("importPaths:\\s*\\[\\s*(.*)\\s*\\]");
        const QRegularExpressionMatch importPathsMatch = importPathsRegExp.match(text);
        if (importPathsMatch.hasMatch()) {
            for (const QString &path : importPathsMatch.captured(1).split(",")) {
                QString cleanedPath = path.trimmed();
                cleanedPath = basePath + cleanedPath.mid(1, cleanedPath.length() - 2);
                if (QFileInfo::exists(cleanedPath))
                    *importPaths << cleanedPath;
            }
        }
    } else {
        return;
    }
}

static void handleQmlFile(const QString &qmlFile, QString *mainQmlFile, QStringList *importPaths,
                          IScriptEnvironment* env)
{
    if (qmlFile.endsWith(".qmlproject")) {
        parseQmlprojectFile(qmlFile, mainQmlFile, importPaths);
        if (mainQmlFile->isEmpty())
            env->ThrowError("QtAviSynthQmlAnimation: Could not find \"mainFile\" in %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());
    } else {
        *mainQmlFile = qmlFile;
    }
    if (!QFileInfo::exists(*mainQmlFile))
        env->ThrowError("QtAviSynthQmlAnimation: Main .qml file %s not found",
                    QDir::toNativeSeparators(*mainQmlFile).toLatin1().constData());
}

QmlAnimationRenderer::QmlAnimationRenderer(bool useGpu)
    : m_useGpu(useGpu)
{
}

QString QmlAnimationRenderer::initialize(const QString &mainQmlFile,
                                         const QStringList &importPaths,
                                         const QVariantMap &initialProperties)
{
    // Qt Quick mixes subpixel and gray text antialiasing, depending on the frames rendered
    // before. Always use gray, which also suits video with alpha. Must be set before the first
    // QQuickWindow.
    const char antialiasingVariable[] = "QSG_DISTANCEFIELD_ANTIALIASING";
    if (!qEnvironmentVariableIsSet(antialiasingVariable))
        qputenv(antialiasingVariable, "gray");

    // The Direct3D backends start a thread that waits for the vertical blank of the screen,
    // which offscreen rendering does not need. It is only cleaned up with the application
    // object, which the plugin never deletes, so Qt would warn at process exit.
    const char vblankThreadVariable[] = "QT_D3D_NO_VBLANK_THREAD";
    if (!qEnvironmentVariableIsSet(vblankThreadVariable))
        qputenv(vblankThreadVariable, "1");

    // Unknown lets Qt Quick use its default graphics API: Direct3D 11 on Windows, unless
    // QSG_RHI_BACKEND selects another one
    QQuickWindow::setGraphicsApi(m_useGpu ? QSGRendererInterface::Unknown
                                          : QSGRendererInterface::Software);

    m_qmlEngine = new QQmlEngine;
    for (const QString &importPath : importPaths)
        m_qmlEngine->addImportPath(importPath);

    m_qmlComponent = new QQmlComponent(m_qmlEngine, mainQmlFile, QQmlComponent::PreferSynchronous);
    QCoreApplication::processEvents();

    QObject *rootObject = m_qmlComponent->createWithInitialProperties(initialProperties);
    if (!rootObject)
        return m_qmlComponent->errorString();

    m_renderControl = new QQuickRenderControl(rootObject);
    m_rootItem = qobject_cast<QQuickItem *>(rootObject);
    if (!m_rootItem)
        return QLatin1String("Root needs to be an Item.");

    m_timeLineItem = timeLineItem(m_rootItem);
    if (!m_timeLineItem) {
        QCoreApplication::processEvents(); // don't crash
        return QLatin1String("Qml scene is missing a QtQuick.Timeline element.");
    }
    const QQmlListReference timeLineAnimations(m_timeLineItem, "animations");
    for (int i = 0; i < timeLineAnimations.count(); ++i) {
        QObject *timelineAnimation = timeLineAnimations.at(i);
        const char *timelineAnimationRunningProperty = "running";
        timelineAnimation->setProperty(timelineAnimationRunningProperty, false); // We control the animation
    }
    // Timeline frames are milliseconds
    m_timeLineStartFrame = m_timeLineItem->property("startFrame").toDouble();
    m_timeLineEndFrame = m_timeLineItem->property("endFrame").toDouble();
    m_timelineAnimationDuration = m_timeLineEndFrame - m_timeLineStartFrame;

    m_quickWindow = new QQuickWindow(m_renderControl);
    m_quickWindow->setColor(QColor(Qt::transparent));

    m_rootItem->setParentItem(m_quickWindow->contentItem());
    m_size = m_rootItem->size().toSize();
    m_quickWindow->setGeometry(0, 0, m_size.width(), m_size.height());

    if (m_useGpu) {
        // Creates the QRhi of the scene graph
        if (!m_renderControl->initialize())
            return QLatin1String("Failed to initialize the scene graph.");
        QRhi *rhi = m_renderControl->rhi();
        m_texture = rhi->newTexture(QRhiTexture::RGBA8, m_size, 1,
                                    QRhiTexture::RenderTarget | QRhiTexture::UsedAsTransferSource);
        if (!m_texture->create())
            return QLatin1String("Failed to create the render target texture.");
        m_depthStencil = rhi->newRenderBuffer(QRhiRenderBuffer::DepthStencil, m_size, 1);
        if (!m_depthStencil->create())
            return QLatin1String("Failed to create the depth stencil buffer.");
        QRhiTextureRenderTargetDescription renderTargetDescription{QRhiColorAttachment(m_texture)};
        renderTargetDescription.setDepthStencilBuffer(m_depthStencil);
        m_renderTarget = rhi->newTextureRenderTarget(renderTargetDescription);
        m_renderPassDescriptor = m_renderTarget->newCompatibleRenderPassDescriptor();
        m_renderTarget->setRenderPassDescriptor(m_renderPassDescriptor);
        if (!m_renderTarget->create())
            return QLatin1String("Failed to create the render target.");
        m_quickWindow->setRenderTarget(QQuickRenderTarget::fromRhiRenderTarget(m_renderTarget));
    } else {
        // Render into an image of the clip size. QQuickWindow::grabWindow() would return an
        // image scaled by the device pixel ratio of the screen.
        m_softwareImage = QImage(m_size, QImage::Format_ARGB32_Premultiplied);
        m_softwareImage.fill(Qt::transparent);
        QQuickRenderTarget renderTarget = QQuickRenderTarget::fromPaintDevice(&m_softwareImage);
        renderTarget.setDevicePixelRatio(1);
        m_quickWindow->setRenderTarget(renderTarget);
    }
    return {};
}

QmlAnimationRenderer::~QmlAnimationRenderer()
{
    Tools::runInApplicationThread([this]{
        // The QRhi resources go before the QRhi, which belongs to the render control
        delete m_renderPassDescriptor;
        delete m_renderTarget;
        delete m_depthStencil;
        delete m_texture;

        delete m_renderControl;
        delete m_qmlComponent;
        delete m_quickWindow;
        delete m_qmlEngine;
    });
}

void QmlAnimationRenderer::renderFrame()
{
    const double qmlFrame = qBound(m_timeLineStartFrame, m_frameN, m_timeLineEndFrame);
    m_timeLineItem->setProperty("currentFrame", qmlFrame);

    m_renderControl->polishItems();

    // The software backend must not use beginFrame() and endFrame()
    if (!m_useGpu) {
        m_renderControl->sync();
        m_renderControl->render();
        // AviSynth RGB32 frames are stored bottom-up
        m_frame = m_softwareImage.convertToFormat(QImage::Format_ARGB32).flipped(Qt::Vertical);
        return;
    }

    m_renderControl->beginFrame();
    m_renderControl->sync();
    m_renderControl->render();
    QRhi *rhi = m_renderControl->rhi();
    QRhiReadbackResult readback;
    QRhiResourceUpdateBatch *readbackBatch = rhi->nextResourceUpdateBatch();
    readbackBatch->readBackTexture(m_texture, &readback);
    m_renderControl->commandBuffer()->resourceUpdate(readbackBatch);
    // Ends an offscreen frame, which waits for the GPU, so the readback is complete afterwards
    m_renderControl->endFrame();

    const QImage image(reinterpret_cast<const uchar *>(readback.data.constData()),
                       readback.pixelSize.width(), readback.pixelSize.height(),
                       QImage::Format_RGBA8888_Premultiplied);
    m_frame = image.convertToFormat(QImage::Format_ARGB32);
    // AviSynth RGB32 frames are stored bottom-up, like the framebuffers of OpenGL
    if (!rhi->isYUpInFramebuffer())
        m_frame = m_frame.flipped(Qt::Vertical);
}

QmlAnimation::QmlAnimation(const QString &qmlFile, double fps,
                           const QString &initialProperties, bool useGpu, IScriptEnvironment* env)
    : m_renderer(useGpu)
{
    QString mainQmlFile;
    QStringList importPaths;
    handleQmlFile(qmlFile, &mainQmlFile, &importPaths, env);
    const QVariantMap initialPropertiesValues = initialPropertiesMap(initialProperties, env);

    // AviSynth errors are C++ exceptions, which must not be thrown in the application thread
    QString error;
    Tools::runInApplicationThread([&] {
        error = m_renderer.initialize(mainQmlFile, importPaths, initialPropertiesValues);
    });
    if (!error.isEmpty())
        env->ThrowError("QtAviSynthQmlAnimation: %s", error.toLatin1().constData());

    setFps(fps, env);
    m_vi.width = m_renderer.m_size.width();
    m_vi.height = m_renderer.m_size.height();
    m_vi.num_frames = qCeil(m_renderer.m_timelineAnimationDuration / 1000 * fps) + 1;
}

PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    QMutexLocker lock(&m_mutex);
    const double targetFps = double(m_vi.fps_numerator) / m_vi.fps_denominator;
    const double progressInMs = n / targetFps * 1000;

    m_renderer.m_frameN = m_renderer.m_timeLineStartFrame + progressInMs;
    Tools::runInApplicationThread([this]{ m_renderer.renderFrame(); });

    if (m_renderer.m_frame.size() != QSize(m_vi.width, m_vi.height)) {
        env->ThrowError("QtAviSynthQmlAnimation: Rendered a %dx%d frame for a %dx%d clip.",
                        m_renderer.m_frame.width(), m_renderer.m_frame.height(),
                        m_vi.width, m_vi.height);
    }

    PVideoFrame frame = env->NewVideoFrame(m_vi);
    unsigned char* frameBits = frame->GetWritePtr();
    env->BitBlt(frameBits, frame->GetPitch(), m_renderer.m_frame.constBits(),
                m_renderer.m_frame.bytesPerLine(), m_renderer.m_frame.bytesPerLine(),
                m_renderer.m_frame.height());

    return frame;
}

AVSValue __cdecl QmlAnimation::CreateQmlAnimation(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].ArraySize() == 1 ? args[0][0].AsClip() : PClip();
    const VideoInfo backGroundVi = background ? background->GetVideoInfo() : defaultVi();
    const QString qmlFile =
            QDir::fromNativeSeparators(QDir().absoluteFilePath(QLatin1String(args[1].AsString())));
    const double fps = background
            ? double(backGroundVi.fps_numerator) / backGroundVi.fps_denominator
            : args[2].AsFloat(30);
    const QString initialProperties = args[3].AsString("{}");
    // The GPU renders with Qt Quick's default graphics API, which is Direct3D 11 on Windows
    const bool useGpu = args[4].AsBool(true);

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());

    const PClip qmlAnimation = new QmlAnimation(qmlFile, fps, initialProperties, useGpu, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
