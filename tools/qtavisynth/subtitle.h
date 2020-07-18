#pragma once

#include <windows.h>
#include "avisynth.h"

#include <QParallelAnimationGroup>

class SubtitleProperties;

class Subtitle : public GenericVideoFilter
{
public:
    Subtitle(PClip background, const QString &title, const QString &subtitle,
             int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

protected:
    const QString m_title;
    const QString m_subtitle;
    SubtitleProperties* m_properties;
    QParallelAnimationGroup m_titleAnimations;
    static const int m_slipFrames;
    static const int m_blendDelayFrames;
    static const int m_blendFrames;
};
