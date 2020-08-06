#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QApplication>
#include <QQuickWindow>
#include <QQuickView>
#include <QQuickItem>
#include <QQmlProperty>
#include <QQuickRenderControl>

QmlAnimation::QmlAnimation(PClip background, const QString &qmlFile, bool useOpenGL, IScriptEnvironment* env)
    : GenericVideoFilter(background)
    , m_qmlFile(qmlFile)
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
    m_qmlComponent = new QQmlComponent(m_qmlEngine, qmlFile, QQmlComponent::PreferSynchronous);
    QCoreApplication::processEvents();

    QObject *rootObject = m_qmlComponent->create();
    if (!rootObject) {
        env->ThrowError("QtAviSynthQmlAnimation: %s",
                    m_qmlComponent->errorString().toLatin1().constData());
    }

    m_renderControl = new QQuickRenderControl(rootObject);
    m_rootItem = qobject_cast<QQuickItem *>(rootObject);
    if (!m_rootItem)
        env->ThrowError("QtAviSynthQmlAnimation: Root needs to be an Item.");

    for (auto child : m_rootItem->children()) {
        if (strcmp(child->metaObject()->className(), "QQuickTimeline") == 0) {
            m_timeLineItem = child;
            break;
        }
    }
    if (!m_timeLineItem)
        env->ThrowError("QtAviSynthQmlAnimation: Qml scene is maissing a QtQuick.Timeline element.");

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
    QCoreApplication::processEvents();
    delete m_renderControl;
    delete m_qmlComponent;
    delete m_quickWindow;
    delete m_qmlEngine;
    delete m_rootItem;
    QCoreApplication::processEvents();
}

PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    const int timeStartFrame = m_timeLineItem->property("startFrame").toInt();
    const int timeLineEndFrame = m_timeLineItem->property("endFrame").toInt();
    const int qmlFrame = qBound(timeStartFrame, n, timeLineEndFrame);
    m_timeLineItem->setProperty("currentFrame", qmlFrame);

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
    const bool useOpenGL = args[2].AsBool(true);

    Tools::createQGuiApplicationIfNeeded();

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());


    const PClip qmlAnimation = new QmlAnimation(background, qmlFile, useOpenGL, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
