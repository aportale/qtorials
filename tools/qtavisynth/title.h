#pragma once

#include "Windows.h"
#include "avisynth.h"
#include <QColor>

class Title : public IClip
{
public:
    Title(const VideoInfo &videoInfo,
          const QString &text, const QString &fontFace, const QColor color);

    static AVSValue __cdecl CreateTitle(AVSValue args, void* user_data,
                                        IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env) override;

protected:
    const QString m_text;
    const QString m_fontFace;
    const QColor m_color;
    VideoInfo m_videoInfo;
};
