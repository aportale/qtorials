/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "windows.h"
#include "avisynth.h"
#include "filters.h"
#include <QtGui>

#if !defined(QT_SHARED) && !defined(QT_DLL)
Q_IMPORT_PLUGIN(qgif)
Q_IMPORT_PLUGIN(qjpeg)
Q_IMPORT_PLUGIN(qtiff)
Q_IMPORT_PLUGIN(qsvg)
#endif

const int defaultClipWidth = 640;
const int defaultClipHeight = 480;
const QRgb transparentColor = qRgba(0x00, 0x00, 0x00, 0x00);

class QtorialsStillImage : public IClip
{
public:
    QtorialsStillImage(const QImage &image, int frames, IScriptEnvironment* env)
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

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) { Q_UNUSED(n) Q_UNUSED(env) return m_frame; }
    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    PVideoFrame m_frame;
    VideoInfo m_videoInfo;
};

class QtorialsSubtitle : public IClip
{
public:
    QtorialsSubtitle(int width, int height,
                     int titleArumentsCount, const AVSValue* titleArguments,
                     IScriptEnvironment* env)
    {
        memset(&m_videoInfo, 0, sizeof(VideoInfo));
        if (titleArumentsCount % 4 != 0)
            env->ThrowError("QtorialsSubtitle: Mismatching number of arguments.\nThe title arguments must be dividable by 4.");
        for (int i = 0; i < titleArumentsCount; i += 4) {
            if (!(titleArguments[i].IsString() && titleArguments[i+1].IsString()
                  && titleArguments[i+2].IsInt() && titleArguments[i+3].IsInt()))
                env->ThrowError("QtorialsSubtitle: Wrong title argument data type in title set %i.", i / 4 + 1);
            const TitleData data = {
                QLatin1String(titleArguments[i].AsString()),
                QLatin1String(titleArguments[i+1].AsString()),
                titleArguments[i+2].AsInt(),
                titleArguments[i+3].AsInt()};
            m_titleData.append(data);
            m_videoInfo.num_frames = qMax(data.endFrame, m_videoInfo.num_frames);
        }
        m_videoInfo.width = width;
        m_videoInfo.height = height;
        m_videoInfo.fps_numerator = 25;
        m_videoInfo.fps_denominator = 1;
        m_videoInfo.pixel_type = VideoInfo::CS_BGR32;
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame frame = env->NewVideoFrame(m_videoInfo);
        unsigned char* frameBits = frame->GetWritePtr();
        QImage image(m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
        image.fill(0);
        QPainter p(&image);
        foreach (const TitleData &titleData, m_titleData) {
            if (n >= titleData.startFrame && n <= titleData.endFrame) {
                Filters::paintAnimatedSubTitle(
                        &p, titleData.title, titleData.subTitle,
                        n - titleData.startFrame,
                        titleData.endFrame - titleData.startFrame,
                        image.rect());
            }
        }
        env->BitBlt(frameBits, frame->GetPitch(), image.mirrored(false, true).bits(), frame->GetPitch(), image.bytesPerLine(), image.height());
        return frame;
    }

    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    struct TitleData {
        QString title;
        QString subTitle;
        int startFrame;
        int endFrame;
    };
    VideoInfo m_videoInfo;
    QList<TitleData> m_titleData;
};

AVSValue __cdecl CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const QString title =
        QString::fromLatin1(args[0].AsString("Title")).replace(QLatin1String("\\n"), QLatin1String("\n"));
    QImage image(args[2].AsInt(defaultClipWidth), args[3].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    Filters::paintTitle(&p, image.rect(), title,
                        args[1].AsInt(qRgba(0x0, 0x0, 0x0, 0xff)));
    return new QtorialsStillImage(image, args[5].AsInt(100), env);
}

AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    return new QtorialsSubtitle(args[0].AsInt(defaultClipWidth),
                                args[1].AsInt(defaultClipHeight),
                                args[2].ArraySize(),
                                &args[2][0],
                                env);
}

AVSValue __cdecl CreateElements(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    QImage image(args[1].AsInt(defaultClipWidth), args[2].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    Filters::paintElements(&p, QString::fromLatin1(args[0].AsString("qtlogosmall")), image.rect());
    return new QtorialsStillImage(image, args[3].AsInt(100), env);
}

AVSValue __cdecl CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    QImage image(args[2].AsInt(defaultClipWidth), args[3].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    const Filters::PaintSvgResult result =
            Filters::paintSvg(&p, QString::fromLatin1(args[0].AsString()),
                              QString::fromLatin1(args[1].AsString()), image.rect());
    switch (result) {
        case Filters::PaintSvgFileNotValid:
                env->ThrowError("QtorialsSvg: File '%s'' was not found or is invalid.",
                                args[0].AsString());
            break;
        case Filters::PaintSvgElementNotFound:
                env->ThrowError("QtorialsSvg: One of the Svg elements '%s' was not found.",
                                args[1].AsString());
            break;
        default:
            break;
    }
    return new QtorialsStillImage(image, args[4].AsInt(100), env);
}

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtorialsTitle",
                     "[text]s[textcolor]i[width]i[height]i[frames]i", CreateTitle, 0);
    env->AddFunction("QtorialsSubtitle", "[width]i[height]i.*", CreateSubtitle, 0);
    env->AddFunction("QtorialsElements", "[elements]s[width]i[height]i[frames]i", CreateElements, 0);
    env->AddFunction("QtorialsSvg", "[svgfile]s[elements]s[width]i[height]i[frames]i", CreateSvg, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
