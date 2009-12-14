#ifndef SUBTITLE_H
#define SUBTITLE_H

#include <windows.h>
#include "avisynth.h"
#include <QParallelAnimationGroup>

class SubtitleProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal slip READ slip WRITE setSlip);
    Q_PROPERTY(qreal blend READ blend WRITE setBlend);

public:
    struct Data
    {
        QString title;
        QString subtitle;
        int startFrame;
        int endFrame;
    };

    SubtitleProperties(const Data &data);
    QString title() const;
    QString subTitle() const;
    qreal slip() const;
    void setSlip(qreal slipin);
    qreal blend() const;
    void setBlend(qreal blendin);

    static const QByteArray slipPropertyName;
    static const QByteArray blendPropertyName;

protected:
    Data m_subtitleData;
    qreal m_slip;
    qreal m_blend;
};

class Subtitle : public IClip
{
public:
    Subtitle(int width, int height,
                     const QList<SubtitleProperties::Data> &titles,
                     IScriptEnvironment* env);
    ~Subtitle();

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);

protected:
    VideoInfo m_videoInfo;
    QList<SubtitleProperties*> m_titleData;
    QParallelAnimationGroup m_titleAnimations;
    static const int m_slipFrames;
    static const int m_blendDelayFrames;
    static const int m_blendFrames;
};

#endif // SUBTITLE_H
