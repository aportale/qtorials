#ifndef TITLE_H
#define TITLE_H

#include "Windows.h"
#include "avisynth.h"
#include <QColor>

class Title : public IClip
{
public:
    Title(const VideoInfo &videoInfo,
          const QString text, const QString fontFace, const QColor color);

    static AVSValue __cdecl CreateTitle(AVSValue args, void* user_data,
                                        IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    int __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    const QString m_text;
    const QString m_fontFace;
    const QColor m_color;
    VideoInfo m_videoInfo;
};

#endif // TITLE_H
