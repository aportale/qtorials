#ifndef TITLE_H
#define TITLE_H

#include "windows.h"
#include "avisynth.h"
#include <QColor>

class Title : public IClip
{
public:
    Title(const VideoInfo &videoInfo,
          const QString text, const QColor color);

    static AVSValue __cdecl CreateTitle(AVSValue args, void* user_data,
                                        IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    QString m_text;
    QColor m_color;
    VideoInfo m_videoInfo;
};

#endif // TITLE_H
