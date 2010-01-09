#ifndef HIGHLIGHT_H
#define HIGHLIGHT_H

#include "windows.h"
#include "avisynth.h"
#include "paintedrgbclip.h"
#include <QRect>
#include <QParallelAnimationGroup>

class HighlightProperties;
class QPainter;

class Highlight : public IClip, public PaintedRgbClip
{
public:
    Highlight(const VideoInfo &backgroundVideoInfo,
              const QRect &rectangle, int startFrame, int endFrame);

    void paintFrame(QPainter *painter, int frameNumber, const QRect &rect) const;

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateHighlight(AVSValue args, void* user_data,
                                            IScriptEnvironment* env);

    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);


protected:
    VideoInfo m_videoInfo;
    HighlightProperties *m_properties;
    mutable QParallelAnimationGroup m_highlightAnimations;
    static const int m_blendInFrames;
    static const int m_blendOutFrames;
};

#endif // HIGHLIGHT_H
