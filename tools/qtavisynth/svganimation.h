#ifndef SVGANIMATION_H
#define SVGANIMATION_H

#include <windows.h>
#include "avisynth.h"
#include <QParallelAnimationGroup>

class SvgAnimationProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal scale READ scale WRITE setScale);
    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity);
    Q_ENUMS(Blending);

public:
    enum Blending {
        immediate,
        fade,
        fadeandscale
    };

    struct Data
    {
        QString svgElement;
        int startFrame;
        int endFrame;
        Blending blendingIn;
        Blending blendingOut;
    };

    SvgAnimationProperties(const Data &data, QObject *parent = 0);
    QString svgElement() const;
    qreal scale() const;
    void setScale(qreal scale);
    qreal opacity() const;
    void setOpacity(qreal opacity);
    static Blending findBlendingOrThrow(const char *blendingKey,
                                        IScriptEnvironment* env);

    static const QByteArray scalePropertyName;
    static const QByteArray opacityPropertyName;

    static const int scaleDuration;
    static const qreal scaleStart;
    static const qreal scaleEnd;
    static const int opacityDuration;
    static const qreal opacityStart;
    static const qreal opacityEnd;

protected:
    Data m_data;
    qreal m_scale;
    qreal m_opacity;
};

class SvgAnimation : public IClip
{
public:
    SvgAnimation(int width, int height,
                 const QString &svgFile,
                 const QList<SvgAnimationProperties::Data> &dataSets,
                 IScriptEnvironment* env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateSvgAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);
    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env);

protected:
    QString m_svgFile;
    VideoInfo m_videoInfo;
    QParallelAnimationGroup m_animation;
    QList<SvgAnimationProperties*> m_properties;
};


#endif // SVGANIMATION_H
