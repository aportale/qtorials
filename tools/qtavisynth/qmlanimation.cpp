#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QApplication>
#include <QQuickWindow>
#include <QQuickView>
#include <QQuickItem>
#include <QQuickRenderControl>

QmlAnimation::QmlAnimation(PClip background, const QString &qmlFile, IScriptEnvironment* env)
    : GenericVideoFilter(background)
    , m_qmlFile(qmlFile)
{
    vi.pixel_type = VideoInfo::CS_BGR32;

    QSurfaceFormat format;
    format.setDepthBufferSize(16);
    format.setStencilBufferSize(8);

    m_openGLContext = new QOpenGLContext;
    m_openGLContext->setFormat(format);
    m_openGLContext->create();

    m_offscreenSurface = new QOffscreenSurface;
    m_offscreenSurface->setFormat(m_openGLContext->format());
    m_offscreenSurface->create();

    m_qmlComponent = new QQmlComponent(&m_qmlEngine, qmlFile, QQmlComponent::PreferSynchronous);

    QObject *rootObject = m_qmlComponent->create();
    if (!rootObject && m_qmlComponent->isError())
        env->ThrowError("QtAviSynthQmlAnimation: %s",
                    m_qmlComponent->errorString().toLatin1().constData());

    m_renderControl = new QQuickRenderControl(m_qmlComponent);
    QQuickItem *contentItem = qobject_cast<QQuickItem *>(rootObject);
    if (contentItem) {
        QQuickView* view = new QQuickView(&m_qmlEngine, nullptr);
        m_quickWindow = view;
        view->setContent(qmlFile, m_qmlComponent, contentItem);
        view->setResizeMode(QQuickView::SizeRootObjectToView);
        view->setWidth(vi.width);
        view->setHeight(vi.height);
    } else {
        env->ThrowError("QtAviSynthQmlAnimation: Root needs to be an Item.");
    }

    m_openGLContext->makeCurrent(m_offscreenSurface);
    m_renderControl->initialize(m_openGLContext);

    m_openGLFramebufferObject =
            new QOpenGLFramebufferObject(vi.width, vi.height,
                                         QOpenGLFramebufferObject::CombinedDepthStencil);
    m_quickWindow->setRenderTarget(m_openGLFramebufferObject);
}

PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(env)
    PVideoFrame frame = env->NewVideoFrame(vi);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, vi.width, vi.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());

    // render frame

    return frame;
}

AVSValue __cdecl QmlAnimation::CreateQmlAnimation(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const QString qmlFile =
            QDir::fromNativeSeparators(QDir().absoluteFilePath(QLatin1String(args[1].AsString())));

    Tools::createQGuiApplicationIfNeeded();

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());


    const PClip qmlAnimation = new QmlAnimation(background, qmlFile, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
