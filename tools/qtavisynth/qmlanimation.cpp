#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

#include <QApplication>

QmlAnimation::QmlAnimation(PClip background, const QString &qmlFile, IScriptEnvironment* env)
    : GenericVideoFilter(background)
    , m_qmlFile(qmlFile)
{
    vi.pixel_type = VideoInfo::CS_BGR32;

    m_qmlComponent = new QQmlComponent(&m_qmlEngine, qmlFile, QQmlComponent::PreferSynchronous);

    QObject *topLevel = m_qmlComponent->create();
    if (!topLevel && m_qmlComponent->isError())
        env->ThrowError("QtAviSynthQmlAnimation: %s",
                    m_qmlComponent->errorString().toLatin1().constData());

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
