#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QApplication>
#include <QQmlEngine>
#include <QQmlListReference>
#include <QQmlProperty>
#include <QQuickItem>
#include <QQuickRenderControl>
#include <QQuickView>
#include <QQuickWindow>

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

QmlAnimationRenderer::QmlAnimationRenderer(const QString &qmlFile, const QString &initialProperties, bool useOpenGL, IScriptEnvironment *env)
    : m_useOpenGL(useOpenGL)
{
    if (m_useOpenGL) {
        QSurfaceFormat format;
        format.setDepthBufferSize(16);
        format.setStencilBufferSize(8);
        m_openGLContext = new QOpenGLContext;
        m_openGLContext->setFormat(format);
        m_openGLContext->create();
        m_offscreenSurface = new QOffscreenSurface;
        m_offscreenSurface->setFormat(m_openGLContext->format());
        m_offscreenSurface->create();
    } else {
        QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
    }

    m_qmlEngine = new QQmlEngine;

    QString mainQmlFile;
    QStringList importPaths;
    handleQmlFile(qmlFile, &mainQmlFile, &importPaths, env);
    for (const QString &importPath : importPaths)
        m_qmlEngine->addImportPath(importPath);

    m_qmlComponent = new QQmlComponent(m_qmlEngine, mainQmlFile, QQmlComponent::PreferSynchronous);
    QCoreApplication::processEvents();

    QObject *rootObject = m_qmlComponent->createWithInitialProperties(initialPropertiesMap(
                                                                          initialProperties, env));
    if (!rootObject) {
        env->ThrowError("QtAviSynthQmlAnimation: %s",
                    m_qmlComponent->errorString().toLatin1().constData());
    }

    m_renderControl = new QQuickRenderControl(rootObject);
    m_rootItem = qobject_cast<QQuickItem *>(rootObject);
    if (!m_rootItem)
        env->ThrowError("QtAviSynthQmlAnimation: Root needs to be an Item.");

    m_timeLineItem = timeLineItem(m_rootItem);
    if (!m_timeLineItem) {
        QCoreApplication::processEvents(); // don't crash
        env->ThrowError("QtAviSynthQmlAnimation: Qml scene is missing a QtQuick.Timeline element.");
    }
    const QQmlListReference timeLineAnimations(m_timeLineItem, "animations", m_qmlEngine);
    for (int i = 0; i < timeLineAnimations.count(); ++i) {
        QObject *timelineAnimation = timeLineAnimations.at(i);
        const char *timelineAnimationRunningProperty = "running";
        timelineAnimation->setProperty(timelineAnimationRunningProperty, false); // We control the animation
    }
    m_timelineAnimationDuration = m_timeLineItem->property("endFrame").toDouble();
    m_timeLineStartFrame = m_timeLineItem->property("startFrame").toDouble();
    m_timeLineEndFrame = m_timeLineItem->property("endFrame").toDouble();

    if (m_useOpenGL)
        m_openGLContext->makeCurrent(m_offscreenSurface);
    m_quickWindow = new QQuickWindow(m_renderControl);
    m_quickWindow->setColor(QColor(Qt::transparent));

    m_rootItem->setParentItem(m_quickWindow->contentItem());
    m_size = m_rootItem->size().toSize();
    m_quickWindow->setGeometry(0, 0, m_size.width(), m_size.height());

    if (m_useOpenGL) {
        m_openGLFramebufferObject =
                new QOpenGLFramebufferObject(m_size.width(), m_size.height(),
                                             QOpenGLFramebufferObject::CombinedDepthStencil);
        m_quickWindow->setRenderTarget(m_openGLFramebufferObject);
        m_renderControl->initialize(m_openGLContext);
    }
}

QmlAnimationRenderer::~QmlAnimationRenderer()
{
    QMetaObject::invokeMethod(qApp, [this]{
        if (m_useOpenGL)
            m_openGLContext->makeCurrent(m_offscreenSurface);

        delete m_renderControl;
        delete m_qmlComponent;
        delete m_quickWindow;
        delete m_qmlEngine;

        if (m_useOpenGL) {
            m_openGLContext->doneCurrent();
            delete m_offscreenSurface;
            delete m_openGLContext;
        }
    });
}

void QmlAnimationRenderer::renderFrame()
{
    const double qmlFrame = qBound(m_timeLineStartFrame, double(m_frameN), m_timeLineEndFrame);
    m_timeLineItem->setProperty("currentFrame", qmlFrame);

    if (m_useOpenGL)
        m_openGLContext->makeCurrent(m_offscreenSurface);

    m_renderControl->polishItems();
    m_renderControl->sync();
    m_renderControl->render();
    if (m_useOpenGL)
        m_openGLContext->functions()->glFlush();

    m_frame = m_quickWindow->grabWindow().convertToFormat(QImage::Format_ARGB32).mirrored(false, true);
}

QmlAnimation::QmlAnimation(const QString &qmlFile, double fps,
                           const QString &initialProperties, bool useOpenGL, IScriptEnvironment* env)
    : m_renderer(qmlFile, initialProperties, useOpenGL, env)
{
    setFps(fps, env);
    m_vi.width = m_renderer.m_size.width();
    m_vi.height = m_renderer.m_size.height();
    m_vi.num_frames = qCeil(m_renderer.m_timelineAnimationDuration / 1000 * fps) + 1;
}

QMutex mutex;
PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    QMutexLocker lock(&mutex);
    const double targetFps = double(m_vi.fps_numerator) / m_vi.fps_denominator;
    const double progressInMs = n / targetFps * 1000;
    const int qmlFrame = progressInMs / m_renderer.m_timelineAnimationDuration * 1000;

    m_renderer.m_frameN = qmlFrame;
    QMetaObject::invokeMethod(qApp, [this]{ m_renderer.renderFrame(); });

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
    const bool useOpenGL = args[4].AsBool(true);

    Tools::createQGuiApplicationIfNeeded();

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());

    const PClip qmlAnimation = new QmlAnimation(qmlFile, fps, initialProperties, useOpenGL, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
