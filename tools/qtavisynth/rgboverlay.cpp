#include "rgboverlay.h"
#include "paintedrgbclip.h"
#include "filters.h"
#include "highlight.h"
#include <QPainter>

RgbOverlay::RgbOverlay(const PClip &backgroundClip,
                       const PClip &foregroundClip,
                       IScriptEnvironment* env)
    : m_foregroundClip(foregroundClip)
    , m_overlaidClip(backgroundClip)
{
    if (backgroundClip->GetVideoInfo().IsRGB()) {
        if (!paintedRgbClip()) {
            const bool isRgb24 = backgroundClip->GetVideoInfo().IsRGB24();
            const PClip backgroundClipRgb32 = isRgb24?
                    env->Invoke("ConvertToRgb32", backgroundClip).AsClip()
                    : backgroundClip;
            const AVSValue params[] = { backgroundClipRgb32, foregroundClip };
            const AVSValue paramsValue =
                    AVSValue(params, sizeof params / sizeof params[0]);
            const PClip overlaidClipRgb32 = env->Invoke("Layer", paramsValue).AsClip();
            m_overlaidClip = isRgb24?
                    env->Invoke("ConvertToRgb24", overlaidClipRgb32).AsClip()
                    : overlaidClipRgb32;
        }
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
    PVideoFrame frame = m_overlaidClip->GetFrame(n, env);
    if (const PaintedRgbClip *currentPaintedRgbClip = paintedRgbClip()) {
        const VideoInfo &videoInfo = m_overlaidClip->GetVideoInfo();
        PVideoFrame background = env->NewVideoFrame(videoInfo);
        unsigned char* backgroundBits = background->GetWritePtr();
        env->BitBlt(backgroundBits, background->GetPitch(),
                    frame->GetReadPtr(), frame->GetPitch(),
                    frame->GetRowSize(), frame->GetHeight());
        QImage image(backgroundBits, videoInfo.width, videoInfo.height, QImage::Format_ARGB32_Premultiplied);
        QPainter p(&image);
        p.scale(1, -1);
        p.translate(0, -image.height());
        currentPaintedRgbClip->paintFrame(&p, n, QRect());
        frame = background;
    }
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

void __stdcall RgbOverlay::SetCacheHints(int cachehints, int frame_range)
{
    m_overlaidClip->SetCacheHints(cachehints, frame_range);
}

void __stdcall RgbOverlay::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
{
    m_overlaidClip->GetAudio(buf, start, count, env);
}

const PaintedRgbClip *RgbOverlay::paintedRgbClip() const
{
    return m_overlaidClip->GetVideoInfo().IsRGB() ?
            dynamic_cast<const PaintedRgbClip*>((m_foregroundClip.operator->()))
            : 0;
}
