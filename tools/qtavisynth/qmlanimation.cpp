#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QApplication>
#include <QQuickWindow>
#include <QQuickView>
#include <QQuickItem>
#include <QQmlListReference>
#include <QQmlProperty>
#include <QQuickRenderControl>

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

QmlAnimation::QmlAnimation(PClip background, const QString &qmlFile, const QString &initialProperties,
                           bool useOpenGL, IScriptEnvironment* env)
    : GenericVideoFilter(background)
    , m_useOpenGL(useOpenGL)
{
    vi.pixel_type = VideoInfo::CS_BGR32;

    if (m_useOpenGL) {
        m_openGLContext = new QOpenGLContext;
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
    const char *timelineAnimationRunningProperty = "running";
    for (int i = 0; i < timeLineAnimations.count(); ++i) {
        QObject *timelineAnimation = timeLineAnimations.at(i);
        if (timelineAnimation->property(timelineAnimationRunningProperty).toBool()) {
            if (m_timelineAnimationDuration < 0) // First running animation determins animation duration
                m_timelineAnimationDuration = timelineAnimation->property("duration").toDouble();
            timelineAnimation->setProperty(timelineAnimationRunningProperty, false); // We control the animation
        }
    }
    if (m_timelineAnimationDuration < 0) // No running animation? Deduce duration from timeline "frame count"
        m_timelineAnimationDuration = m_timeLineItem->property("endFrame").toDouble();
    m_timeLineStartFrame = m_timeLineItem->property("startFrame").toDouble();
    m_timeLineEndFrame = m_timeLineItem->property("endFrame").toDouble();

    if (m_useOpenGL)
        m_openGLContext->makeCurrent(m_offscreenSurface);
    m_quickWindow = new QQuickWindow(m_renderControl);
    m_quickWindow->setColor(QColor(Qt::transparent));

    m_rootItem->setParentItem(m_quickWindow->contentItem());
    m_rootItem->setWidth(vi.width);
    m_rootItem->setHeight(vi.height);
    m_quickWindow->setGeometry(0, 0, vi.width, vi.height);

    if (m_useOpenGL) {
        m_openGLFramebufferObject =
                new QOpenGLFramebufferObject(vi.width, vi.height,
                                             QOpenGLFramebufferObject::CombinedDepthStencil);
        m_quickWindow->setRenderTarget(m_openGLFramebufferObject);
        m_renderControl->initialize(m_openGLContext);
    }
}

QmlAnimation::~QmlAnimation()
{
    m_renderControl->deleteLater();
    m_qmlComponent->deleteLater();
    m_quickWindow->deleteLater();
    m_qmlEngine->deleteLater();

    if (m_useOpenGL) {
        m_openGLContext->doneCurrent();
        m_offscreenSurface->deleteLater();
        m_openGLContext->deleteLater();
    }
}

PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    const double targetFps = double(vi.fps_numerator) / vi.fps_denominator;
    const double progressInMs = n / targetFps * 1000;
    const double qmlFrame = qBound(m_timeLineStartFrame,
                                   progressInMs / m_timelineAnimationDuration * 1000,
                                   m_timeLineEndFrame);
    m_timeLineItem->setProperty("currentFrame", qmlFrame);

    if (m_useOpenGL)
        m_openGLContext->makeCurrent(m_offscreenSurface);

    m_renderControl->polishItems();
    m_renderControl->sync();
    m_renderControl->render();
    QCoreApplication::processEvents();
    if (m_useOpenGL)
        m_openGLContext->functions()->glFlush();

    const QImage frameImage = m_quickWindow->grabWindow();

    PVideoFrame frame = env->NewVideoFrame(vi);
    unsigned char* frameBits = frame->GetWritePtr();
    env->BitBlt(frameBits, frame->GetPitch(),
                frameImage.convertToFormat(QImage::Format_ARGB32).mirrored(false, true).constBits(),
                frameImage.bytesPerLine(), frameImage.bytesPerLine(), frameImage.height());

    return frame;
}

AVSValue __cdecl QmlAnimation::CreateQmlAnimation(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const QString qmlFile =
            QDir::fromNativeSeparators(QDir().absoluteFilePath(QLatin1String(args[1].AsString())));
    const QString initialProperties = args[2].AsString("{}");
    const bool useOpenGL = args[3].AsBool(true);

    Tools::createQGuiApplicationIfNeeded();

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());

    const PClip qmlAnimation =
            new QmlAnimation(background, qmlFile, initialProperties, useOpenGL, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
