#pragma once

#include "avisynth.h"

#include <QtGlobal>
QT_FORWARD_DECLARE_CLASS(QSize)

// Base for AviSynth "source filters": clips that generate their frames instead of
// transforming a child clip (unlike GenericVideoFilter), similar to BlankClip.
class SourceFilter : public IClip {
public:
    SourceFilter();

    void __stdcall GetAudio(void*, int64_t, int64_t, IScriptEnvironment*);
    const VideoInfo& __stdcall GetVideoInfo();
    bool __stdcall GetParity(int n);
    int __stdcall SetCacheHints(int cachehints, int frame_range);
    void setFps(double fps, IScriptEnvironment *env);
    void setSize(const QSize &size);

    static VideoInfo defaultVi();

protected:
    VideoInfo m_vi;
};
