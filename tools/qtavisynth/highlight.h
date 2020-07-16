#pragma once

#include "windows.h"
#include "avisynth.h"
#include <QRect>
#include <QParallelAnimationGroup>

class HighlightProperties;
class QPainter;

class Highlight : public IClip
{
public:
    Highlight(const VideoInfo &backgroundVideoInfo,
              const QRect &rectangle, int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateHighlight(AVSValue args, void* user_data,
                                            IScriptEnvironment* env);

    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env) override;

protected:
    VideoInfo m_videoInfo;
    HighlightProperties *m_properties;
    mutable QParallelAnimationGroup m_highlightAnimations;
    static const int m_blendInFrames;
    static const int m_blendOutFrames;
};
