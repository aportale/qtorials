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

    m_renderControl = new QQuickRenderControl(rootObject);
    QQuickItem *rootItem = qobject_cast<QQuickItem *>(rootObject);
    if (!rootItem)
        env->ThrowError("QtAviSynthQmlAnimation: Root needs to be an Item.");

    m_openGLContext->makeCurrent(m_offscreenSurface);
    m_quickWindow = new QQuickWindow(m_renderControl);

    rootItem->setParentItem(m_quickWindow->contentItem());
    rootItem->setWidth(vi.width);
    rootItem->setHeight(vi.height);
    m_quickWindow->setGeometry(0, 0, vi.width, vi.height);

    m_openGLFramebufferObject =
            new QOpenGLFramebufferObject(vi.width, vi.height,
                                         QOpenGLFramebufferObject::CombinedDepthStencil);
    m_quickWindow->setRenderTarget(m_openGLFramebufferObject);
    m_renderControl->initialize(m_openGLContext);
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
    m_renderControl->polishItems();
    m_renderControl->sync();
    m_renderControl->render();

    m_openGLContext->functions()->glFlush();
    QImage frameImage = m_openGLFramebufferObject->toImage();
    p.drawImage(0, 0, frameImage);

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
