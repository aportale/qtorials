#pragma once

#include <windows.h>
#include "avisynth.h"
#include <QSequentialAnimationGroup>
#include <QRectF>

class ZoomNPanProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRectF rect READ rect WRITE setRect)

public:
    QRectF rect() const;
    void setRect(const QRectF &rect);
    static const QByteArray propertyName;

private:
    QRectF m_rect;
};

class ZoomNPan : public GenericVideoFilter
{
public:
    struct Detail {
        int keyFrame;
        int transitionLength;
        QRectF detail;
    };

    ZoomNPan(const PClip &originClip, int width, int height, int defaultTransitionLength,
             const char *resizeFilter, double perspectiveStrength, const QRectF &startDetail,
             const QVector<Detail> &details);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

private:
    static QRectF fixedDetailRect(const VideoInfo &originVideoInfo,
                                  const QSize &detailClipSize,
                                  const QRectF &specifiedDetailRect);

    const QByteArray m_resizeFilter;
    const double m_perspectiveStrength;
    ZoomNPanProperties m_animationProperties;
    QSequentialAnimationGroup m_animation;
    PClip m_resizedClip;
    QRectF m_resizedRect;
};
