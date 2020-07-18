#pragma once

#include "windows.h"
#include "avisynth.h"

#include <QParallelAnimationGroup>

QT_FORWARD_DECLARE_CLASS(QRect);
class HighlightProperties;

class Highlight : public GenericVideoFilter
{
public:
    Highlight(PClip background, const QRect &rectangle, int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateHighlight(AVSValue args, void* user_data,
                                            IScriptEnvironment* env);

protected:
    HighlightProperties *m_properties;
    mutable QParallelAnimationGroup m_highlightAnimations;
    static const int m_blendInFrames;
    static const int m_blendOutFrames;
};
