#include "sourcefilter.h"
#include "tools.h"

#include <QSize>

SourceFilter::SourceFilter()
    : m_vi(defaultVi())
{
}

void __stdcall SourceFilter::GetAudio(void*, int64_t, int64_t, IScriptEnvironment*)
{
}

const VideoInfo& __stdcall SourceFilter::GetVideoInfo()
{
    return m_vi;
}

bool __stdcall SourceFilter::GetParity(int n)
{
    Q_UNUSED(n);
    return true;
}

int __stdcall SourceFilter::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints);
    Q_UNUSED(frame_range);
    return 0;
}

void SourceFilter::setFps(double fps, IScriptEnvironment* env)
{
    m_vi.fps_numerator = env->Invoke("ContinuedNumerator", fps).AsInt();
    m_vi.fps_denominator = env->Invoke("ContinuedDenominator", fps).AsInt();
}

void SourceFilter::setSize(const QSize &size)
{
    m_vi.width = size.width();
    m_vi.height = size.height();
}

VideoInfo SourceFilter::defaultVi() {
    VideoInfo info;
    memset(&info, 0, sizeof(VideoInfo));
    info.pixel_type = VideoInfo::CS_BGR32;
    info.width = Tools::defaultClipWidth;
    info.height = Tools::defaultClipHeight;
    info.num_frames = 1000;
    info.fps_denominator = 1;
    info.fps_numerator = 24;
    info.SetFieldBased(false);
    return info;
}
