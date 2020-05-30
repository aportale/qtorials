#include "filters.h"
#include "rgboverlay.h"
#include "stillimage.h"
#include "tools.h"

StillImage::StillImage(const VideoInfo &backgroundVideoInfo, const QImage &image,
                       IScriptEnvironment* env)
    : m_videoInfo(backgroundVideoInfo)
{
    m_videoInfo.pixel_type =
            (image.format() == QImage::Format_ARGB32
                || image.format() == QImage::Format_ARGB32_Premultiplied) ?
                    VideoInfo::CS_BGR32 : VideoInfo::CS_BGR24;
    m_frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = m_frame->GetWritePtr();
    env->BitBlt(frameBits, m_frame->GetPitch(), image.mirrored(false, true).constBits(),
                m_frame->GetPitch(), image.bytesPerLine(), image.height());
}

AVSValue __cdecl StillImage::CreateElements(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const VideoInfo backgroundVI = background->GetVideoInfo();
    const AVSValue &elementValues = args[1];
    QStringList elements;
    for (int i = 0; i < elementValues.ArraySize(); ++i) {
        const QLatin1String element(elementValues[i].AsString());
        if (Filters::elementAvailable(element))
            env->ThrowError("QtAviSynthElements: Invalid element '%s'.", element.latin1());
        elements.append(element);
    }
    QImage image(backgroundVI.width, backgroundVI.height, QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    Filters::paintElements(&p, elements, image.rect());
    const PClip elementsClip = new StillImage(backgroundVI, image, env);
    return new RgbOverlay(background, elementsClip, env);
}

AVSValue __cdecl StillImage::CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const VideoInfo backgroundVI = background->GetVideoInfo();
    const QString svgFileName =
        Tools::cleanFileName(QLatin1String(args[1].AsString()));
    const AVSValue &elementValues = args[2];
    QStringList elements;
    for (int i = 0; i < elementValues.ArraySize(); ++i) {
        const QLatin1String element(elementValues[i].AsString());
        Tools::checkSvgAndThrow(svgFileName, element, env);
        elements.append(element);
    }
    QImage image(backgroundVI.width, backgroundVI.height, QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    Filters::paintSvgElements(&p, svgFileName, elements, image.rect());
    const PClip svgClip = new StillImage(backgroundVI, image, env);
    return new RgbOverlay(background, svgClip, env);
}

PVideoFrame __stdcall StillImage::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(n)
    Q_UNUSED(env)
    return m_frame;
}

bool __stdcall StillImage::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall StillImage::GetVideoInfo()
{
    return m_videoInfo;
}

int __stdcall StillImage::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
    return 0;
}

void __stdcall StillImage::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}
