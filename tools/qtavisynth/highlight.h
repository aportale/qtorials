#ifndef HIGHLIGHT_H
#define HIGHLIGHT_H

#include "windows.h"
#include "avisynth.h"
#include <QRect>
#include <QSequentialAnimationGroup>

class HighlightProperties;

class Highlight : public IClip
{
public:
    Highlight(const VideoInfo &backgroundVideoInfo,
              const QRect &rectangle, int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateHighlight(AVSValue args, void* user_data,
                                            IScriptEnvironment* env);

    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);

protected:
    VideoInfo m_videoInfo;
    QRect m_rectangle;
    HighlightProperties *m_properties;
    QSequentialAnimationGroup m_highlightAnimation;
    static const int m_blendFrames;
};

#endif // HIGHLIGHT_H
