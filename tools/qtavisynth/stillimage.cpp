#include "stillimage.h"
#include "filters.h"
#include "tools.h"

StillImage::StillImage(const QImage &image, int frames, IScriptEnvironment* env)
{
    memset(&m_videoInfo, 0, sizeof(VideoInfo));
    m_videoInfo.width = image.width();
    m_videoInfo.height = image.height();
    m_videoInfo.fps_numerator = 25;
    m_videoInfo.fps_denominator = 1;
    m_videoInfo.num_frames = frames;
    m_videoInfo.pixel_type =
            (image.format() == QImage::Format_ARGB32
                || image.format() == QImage::Format_ARGB32_Premultiplied) ?
                    VideoInfo::CS_BGR32 : VideoInfo::CS_BGR24;
    m_frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = m_frame->GetWritePtr();
    env->BitBlt(frameBits, m_frame->GetPitch(), image.mirrored(false, true).bits(), m_frame->GetPitch(), image.bytesPerLine(), image.height());
}

AVSValue __cdecl StillImage::CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const QString title =
        QString::fromLatin1(args[0].AsString("Title")).replace(QLatin1String("\\n"),
                                                               QLatin1String("\n"));
    QImage image(args[2].AsInt(Tools::defaultClipWidth),
                 args[3].AsInt(Tools::defaultClipHeight),
                 QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    Filters::paintTitle(&p, image.rect(), title,
                        args[1].AsInt(qRgba(0x0, 0x0, 0x0, 0xff)));
    return new StillImage(image, args[4].AsInt(100), env);
}

AVSValue __cdecl StillImage::CreateElements(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const QStringList elements = QString::fromLatin1(args[0].AsString())
                           .split(QLatin1Char(','), QString::SkipEmptyParts);
    QStringList trimmedElements;
    foreach (const QString &element, elements) {
        const QString trimmedElement = element.trimmed();
        if (Filters::elementAvailable(trimmedElement))
            env->ThrowError("QtorialsElements: Invalid element '%s'.", trimmedElement.toLatin1().constData());
        trimmedElements.append(trimmedElement);
    }

    QImage image(args[1].AsInt(Tools::defaultClipWidth),
                 args[2].AsInt(Tools::defaultClipHeight),
                 QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    Filters::paintElements(&p, trimmedElements, image.rect());
    return new StillImage(image, args[3].AsInt(100), env);
}

AVSValue __cdecl StillImage::CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const QString svgFileName =
        Tools::cleanFileName(QLatin1String(args[0].AsString()));
    const QString svgElementsCSV =
            QString::fromLatin1(args[1].AsString());
    QStringList svgElements;
    foreach(const QString &element, svgElementsCSV.split(QLatin1Char(','), QString::SkipEmptyParts)) {
        const QString trimmedElement = element.trimmed();
        Tools::CheckSvgAndThrow(svgFileName, trimmedElement, env);
        svgElements.append(trimmedElement);
    }

    QImage image(args[2].AsInt(Tools::defaultClipWidth),
                 args[3].AsInt(Tools::defaultClipHeight),
                 QImage::Format_ARGB32);
    image.fill(Tools::transparentColor);
    QPainter p(&image);
    Filters::paintSvgElements(&p, svgFileName, svgElements, image.rect());
    return new StillImage(image, args[4].AsInt(100), env);
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

void __stdcall StillImage::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
}

void __stdcall StillImage::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}
