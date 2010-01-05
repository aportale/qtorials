#ifndef RGBOVERLAY_H
#define RGBOVERLAY_H

#include "windows.h"
#include "avisynth.h"

class RgbOverlay : public IClip
{
public:
    RgbOverlay(PClip backgroundClip, PClip foregroundClip, IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    PClip m_overlaidClip;
};

#endif // RGBOVERLAY_H
