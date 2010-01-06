#ifndef SUBTITLE_H
#define SUBTITLE_H

#include <windows.h>
#include "avisynth.h"
#include <QParallelAnimationGroup>

class SubtitleProperties;

class Subtitle : public IClip
{
public:
    Subtitle(const VideoInfo &backgroundVideoInfo,
             const QString title, const QString subtitle,
             int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);

protected:
    VideoInfo m_videoInfo;
    const QString m_title;
    const QString m_subtitle;
    SubtitleProperties* m_properties;
    QParallelAnimationGroup m_titleAnimations;
    static const int m_slipFrames;
    static const int m_blendDelayFrames;
    static const int m_blendFrames;
};

#endif // SUBTITLE_H
