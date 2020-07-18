#pragma once

#include "avisynth.h"

#include <QParallelAnimationGroup>

class SvgAnimationProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal scale READ scale WRITE setScale);
    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity);

public:
    enum Blending {
        immediate,
        fade,
        fadeandscale
    };
    Q_ENUM (Blending)

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

private:
    const Data m_data;
    qreal m_scale = scaleStart;
    qreal m_opacity = opacityStart;
};

class SvgAnimation : public GenericVideoFilter
{
public:
    SvgAnimation(PClip background, const QString &svgFile,
                 const QVector<SvgAnimationProperties::Data> &dataSets);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateSvgAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    const QString m_svgFile;
    QParallelAnimationGroup m_animation;
    QVector<SvgAnimationProperties*> m_properties;
};
