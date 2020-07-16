#pragma once

#include "windows.h"
#include "avisynth.h"

class PaintedRgbClip;

class RgbOverlay : public IClip
{
public:
    RgbOverlay(const PClip &backgroundClip, const PClip &foregroundClip,
               IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env) override;

protected:
    const PClip m_foregroundClip;
    PClip m_overlaidClip;
};
