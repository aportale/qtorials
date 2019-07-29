#pragma once

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

    SvgAnimationProperties(const Data &data, QObject *parent = nullptr);
    QString svgElement() const;
    qreal scale() const;
    void setScale(qreal scale);
    qreal opacity() const;
    void setOpacity(qreal opacity);
    static Blending findBlendingOrThrow(const char *blendingKey,
                                        IScriptEnvironment* env);

    static const QByteArray scalePropertyName;
    static const QByteArray opacityPropertyName;

    constexpr static const int scaleDuration = 5;
    constexpr static const qreal scaleStart = 0.2;
    constexpr static const qreal scaleEnd = 1.0;
    constexpr static const int opacityDuration = scaleDuration;
    constexpr static const qreal opacityStart = 0.0;
    constexpr static const qreal opacityEnd = 1.0;

protected:
    Data m_data;
    qreal m_scale = scaleStart;
    qreal m_opacity = opacityStart;
};

class SvgAnimation : public IClip
{
public:
    SvgAnimation(const VideoInfo &videoInfo, const QString &svgFile,
                 const QList<SvgAnimationProperties::Data> &dataSets);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateSvgAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);
    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env) override;

protected:
    const QString m_svgFile;
    VideoInfo m_videoInfo;
    QParallelAnimationGroup m_animation;
    QList<SvgAnimationProperties*> m_properties;
};
