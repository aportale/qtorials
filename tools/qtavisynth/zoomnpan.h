#pragma once

#include <windows.h>
#include "avisynth.h"
#include <QSequentialAnimationGroup>
#include <QRectF>

class ZoomNPanProperties;

class ZoomNPan : public GenericVideoFilter
{
public:
    struct Detail {
        int keyFrame;
        int transitionLength;
        QRectF detail;
    };

    ZoomNPan(const PClip &originClip, int width, int height,
             int extensionColor, int defaultTransitionLength, const char *resizeFilter,
             const QRectF &startDetail, const QVector<Detail> &details,
             IScriptEnvironment* env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

private:
    static PClip extendedClip(const PClip &originClip, int extensionColor,
                              IScriptEnvironment* env);
    static QRectF fixedDetailRect(const VideoInfo &originVideoInfo,
                                  const QSize &detailClipSize,
                                  const QRectF &specifiedDetailRect);

    static const int m_extensionWidth = 16;
    const QByteArray m_resizeFilter;
    const PClip m_extendedClip;
    ZoomNPanProperties *m_animationProperties;
    QSequentialAnimationGroup m_animation;
    PClip m_resizedClip;
    QRectF m_resizedRect;
};
