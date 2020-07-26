#include "filters.h"
#include "qmlanimation.h"
#include "tools.h"

QmlAnimation::QmlAnimation(PClip background, const QString &qmlFile)
    : GenericVideoFilter(background)
    , m_qmlFile(qmlFile)
{
    vi.pixel_type = VideoInfo::CS_BGR32;
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
    const QString qmlFileName =
            Tools::cleanFileName(QLatin1String(args[1].AsString()));

    // initialize Qml scene

    const PClip qmlAnimation = new QmlAnimation(background, qmlFileName);
    return Tools::rgbOverlay(background, qmlAnimation, env);
}
