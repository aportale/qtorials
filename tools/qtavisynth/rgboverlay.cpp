#include "filters.h"
#include "highlight.h"
#include "rgboverlay.h"

#include <QPainter>

RgbOverlay::RgbOverlay(const PClip &backgroundClip,
                       const PClip &foregroundClip,
                       IScriptEnvironment* env)
    : m_foregroundClip(foregroundClip)
    , m_overlaidClip(backgroundClip)
{
    const PClip showAlpha = env->Invoke("ShowAlpha", foregroundClip).AsClip();
    const AVSValue params[] = { backgroundClip, foregroundClip, 0, 0, showAlpha };
    const AVSValue paramsValue = AVSValue(params, sizeof params / sizeof params[0]);
    m_overlaidClip = env->Invoke("Overlay", paramsValue).AsClip();
}

PVideoFrame __stdcall RgbOverlay::GetFrame(int n, IScriptEnvironment* env)
{
    PVideoFrame frame = m_overlaidClip->GetFrame(n, env);
    return frame;
}

bool __stdcall RgbOverlay::GetParity(int n)
{
    return m_overlaidClip->GetParity(n);
}

const VideoInfo& __stdcall RgbOverlay::GetVideoInfo()
{
    return m_overlaidClip->GetVideoInfo();
}

int __stdcall RgbOverlay::SetCacheHints(int cachehints, int frame_range)
{
    return m_overlaidClip->SetCacheHints(cachehints, frame_range);
}

void __stdcall RgbOverlay::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    m_overlaidClip->GetAudio(buf, start, count, env);
}
