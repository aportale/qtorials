#ifndef STILLIMAGE_H
#define STILLIMAGE_H

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#include <QImage>

#ifdef LINUXIZED_VERSION
using namespace avxsynth;
#endif

class StillImage : public IClip
{
public:
    StillImage(const VideoInfo &backgroundVideoInfo, const QImage &image,
               IScriptEnvironment* env);

    static AVSValue __cdecl CreateElements(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);
    static AVSValue __cdecl CreateSvg(AVSValue args, void* user_data,
                                      IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    PVideoFrame m_frame;
    VideoInfo m_videoInfo;
};

#endif // STILLIMAGE_H
