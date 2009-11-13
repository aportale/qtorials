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

class QtorialsOldstyle : public GenericVideoFilter
{
public:
    QtorialsOldstyle(PClip _child, IScriptEnvironment* env)
        : GenericVideoFilter(_child)
        , m_gradient(vi.width, vi.height, QImage::Format_ARGB32)
    {
        if (!vi.IsRGB())
            env->ThrowError("QtorialsOldstyle: input to filter must be in RGB24 or RGB32");

        m_gradient.fill(0);
        QPainter p(&m_gradient);
        paintOldStyle(&p, m_gradient.rect());
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame src = child->GetFrame(n, env);
        const unsigned char* srcp = src->GetReadPtr();
        const int src_width = src->GetRowSize();
        const int src_height = src->GetHeight();
        const int src_pitch = src->GetPitch();

        PVideoFrame dst = env->NewVideoFrame(vi);
        unsigned char* frameBits = dst->GetWritePtr();

        if (vi.IsRGB()) {
            const QImage::Format imageFormat = vi.IsRGB24() ? QImage::Format_RGB888 : QImage::Format_RGB32;
            QImage i(frameBits, vi.width, src_height, src_pitch, imageFormat);
            memcpy(frameBits, srcp, src_width * src_height);
            QPainter p(&i);
            p.drawImage(0, 0, m_gradient);
        }

        return dst;
    }

    static AVSValue __cdecl Create(AVSValue args, void* user_data, IScriptEnvironment* env)
    {
        return new QtorialsOldstyle(args[0].AsClip(), env);
    }

protected:
    QImage m_gradient;
};

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
        memcpy(frameBits, image.bits(), image.bytesPerLine() * image.height());
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) { return m_frame; }
    bool __stdcall GetParity(int n) { return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env) { }

protected:
    PVideoFrame m_frame;
    VideoInfo m_videoInfo;
};

AVSValue __cdecl CreateRgbPatterns(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    QImage image(args[0].AsInt(640), args[1].AsInt(480), QImage::Format_ARGB32_Premultiplied);
    QPainter p(&image);
    paintRgbPatterns(&p, image.rect());
    return new QtorialsStillImage(image, args[2].AsInt(100), env);
}

AVSValue __cdecl CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    const QString title = QString::fromLatin1(args[3].AsString("Title")).replace(QLatin1String("\\n"), QLatin1String("\n"));
    QImage image(args[0].AsInt(640), args[1].AsInt(480), QImage::Format_ARGB32_Premultiplied);
    QPainter p(&image);
    paintTitle(&p, image.rect(), title);
    return new QtorialsStillImage(image, args[2].AsInt(100), env);
}

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtorialsOldstyle", "c", QtorialsOldstyle::Create, 0);
    env->AddFunction("QtorialsRgbPatterns", "[width]i[height]i[frames]i", CreateRgbPatterns, 0);
    env->AddFunction("QtorialsTitle", "[width]i[height]i[frames]i[text]s", CreateTitle, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
