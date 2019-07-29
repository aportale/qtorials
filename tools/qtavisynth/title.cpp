#include "title.h"
#include "filters.h"
#include "tools.h"
#include "rgboverlay.h"
#include <QImage>

Title::Title(const VideoInfo &videoInfo,
             const QString &text, const QString &fontFace, const QColor color)
    : m_text(text)
    , m_fontFace(fontFace)
    , m_color(color)
    , m_videoInfo(videoInfo)
{
    m_videoInfo.pixel_type = VideoInfo::CS_BGR32;
}

AVSValue __cdecl Title::CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const QString text =
        QString::fromLatin1(args[1].AsString("Title")).replace(QLatin1String("\\n"),
                                                               QLatin1String("\n"));
    const QString fontFace =
        QString::fromLatin1(args[2].AsString());
    const QColor color = QRgb(args[3].AsInt(int(qRgba(0x0, 0x0, 0x0, 0xff))));
    const PClip title = new Title(background->GetVideoInfo(), text, fontFace, color);
    return new RgbOverlay(background, title, env);
}

PVideoFrame __stdcall Title::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(n)
    PVideoFrame frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    Filters::paintTitle(&p, image.rect(), m_text, m_fontFace, m_color);
    return frame;
}

bool __stdcall Title::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall Title::GetVideoInfo()
{
    return m_videoInfo;
}

int __stdcall Title::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
    return 0;
}

void __stdcall Title::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}
