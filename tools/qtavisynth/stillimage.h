#pragma once

#include "windows.h"
#include "avisynth.h"
#include <QImage>

class StillImage : public IClip
{
public:
    StillImage(const VideoInfo &backgroundVideoInfo, const QImage &image,
               IScriptEnvironment* env);

    static AVSValue __cdecl CreateElements(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);
    static AVSValue __cdecl CreateSvg(AVSValue args, void* user_data,
                                      IScriptEnvironment* env);
    static AVSValue __cdecl CreateTitle(AVSValue args, void* user_data,
                                        IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env) override;

protected:
    PVideoFrame m_frame;
    VideoInfo m_videoInfo;
};
