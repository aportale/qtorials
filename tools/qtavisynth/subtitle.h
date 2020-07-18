#pragma once

#include <windows.h>
#include "avisynth.h"

#include <QParallelAnimationGroup>

class SubtitleProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal slip READ slip WRITE setSlip)
    Q_PROPERTY(qreal blend READ blend WRITE setBlend)

public:
    qreal slip() const;
    void setSlip(qreal slip);
    qreal blend() const;
    void setBlend(qreal blend);

    static const QByteArray slipPropertyName;
    static const QByteArray blendPropertyName;

private:
    qreal m_slip = 0.0;
    qreal m_blend = 0.0;
};

class Subtitle : public GenericVideoFilter
{
public:
    Subtitle(PClip background, const QString &title, const QString &subtitle,
             int startFrame, int endFrame);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

protected:
    const QString m_title;
    const QString m_subtitle;
    SubtitleProperties m_properties;
    QParallelAnimationGroup m_titleAnimations;
    static const int m_slipFrames;
    static const int m_blendDelayFrames;
    static const int m_blendFrames;
};
