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

    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::Software);
    m_qmlComponent = new QQmlComponent(&m_qmlEngine, qmlFile, QQmlComponent::PreferSynchronous);

    QObject *rootObject = m_qmlComponent->create();
    if (!rootObject && m_qmlComponent->isError())
        env->ThrowError("QtAviSynthQmlAnimation: %s",
                    m_qmlComponent->errorString().toLatin1().constData());

    m_renderControl = new QQuickRenderControl(rootObject);
    QQuickItem *rootItem = qobject_cast<QQuickItem *>(rootObject);
    if (!rootItem)
        env->ThrowError("QtAviSynthQmlAnimation: Root needs to be an Item.");

    m_quickWindow = new QQuickWindow(m_renderControl);
    m_quickWindow->setColor(QColor(Qt::transparent));

    rootItem->setParentItem(m_quickWindow->contentItem());
    rootItem->setWidth(vi.width);
    rootItem->setHeight(vi.height);
    m_quickWindow->setGeometry(0, 0, vi.width, vi.height);
}

PVideoFrame __stdcall QmlAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    QCoreApplication::processEvents();
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

    Tools::createQGuiApplicationIfNeeded();

    if (!QFileInfo::exists(qmlFile))
        env->ThrowError("Invalid file name: %s",
                        QDir::toNativeSeparators(qmlFile).toLatin1().constData());


    const PClip qmlAnimation = new QmlAnimation(background, qmlFile, env);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
