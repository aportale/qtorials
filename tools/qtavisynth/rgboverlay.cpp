#include "rgboverlay.h"

RgbOverlay::RgbOverlay(PClip backgroundClip, PClip foregroundClip,
                       IScriptEnvironment* env)
{
    if (backgroundClip->GetVideoInfo().IsRGB()) {
        const AVSValue params[] = { backgroundClip, foregroundClip };
        const AVSValue paramsValue =
                AVSValue(params, sizeof params / sizeof params[0]);
        m_overlaidClip = env->Invoke("Layer", paramsValue).AsClip();
    } else {
        const PClip showAlpha = env->Invoke("ShowAlpha", foregroundClip).AsClip();
        const AVSValue params[] = { backgroundClip, foregroundClip, 0, 0, showAlpha };
        const AVSValue paramsValue =
                AVSValue(params, sizeof params / sizeof params[0]);
        m_overlaidClip = env->Invoke("Overlay", paramsValue).AsClip();
    }
}

PVideoFrame __stdcall RgbOverlay::GetFrame(int n, IScriptEnvironment* env)
{
    return m_overlaidClip->GetFrame(n, env);
}

bool __stdcall RgbOverlay::GetParity(int n)
{
    return m_overlaidClip->GetParity(n);
}

const VideoInfo& __stdcall RgbOverlay::GetVideoInfo()
{
    return m_overlaidClip->GetVideoInfo();
}

void __stdcall RgbOverlay::SetCacheHints(int cachehints, int frame_range)
{
    m_overlaidClip->SetCacheHints(cachehints, frame_range);
}

void __stdcall RgbOverlay::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    m_overlaidClip->GetAudio(buf, start, count, env);
}
