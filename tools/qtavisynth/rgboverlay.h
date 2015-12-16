#ifndef RGBOVERLAY_H
#define RGBOVERLAY_H

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#ifdef LINUXIZED_VERSION
using namespace avxsynth;
#endif

class PaintedRgbClip;

class RgbOverlay : public IClip
{
public:
    RgbOverlay(const PClip &backgroundClip, const PClip &foregroundClip,
               IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    const PaintedRgbClip *paintedRgbClip() const;

    const PClip m_foregroundClip;
    PClip m_overlaidClip;
};

#endif // RGBOVERLAY_H
