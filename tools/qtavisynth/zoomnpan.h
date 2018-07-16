#pragma once

#include <windows.h>
#include "avisynth.h"
#include <QSequentialAnimationGroup>
#include <QRectF>

class ZoomNPanProperties;

class ZoomNPan : public IClip
{
public:
    struct Detail {
        int keyFrame;
        int transitionLength;
        QRectF detail;
    };

    ZoomNPan(PClip originClip, int width, int height,
             int extensionColor, int defaultTransitionLength, const char *resizeFilter,
             const QRectF &startDetail, const QList<Detail> &details,
             IScriptEnvironment* env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

    bool __stdcall GetParity(int n) override;
    const VideoInfo& __stdcall GetVideoInfo() override;
    int __stdcall SetCacheHints(int cachehints, int frame_range) override;
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env) override;

protected:
    static const PClip extendedClip(const PClip &originClip, int extensionColor,
                                    IScriptEnvironment* env);
    static QRectF fixedDetailRect(const VideoInfo &originVideoInfo,
                                  const QSize &detailClipSize,
                                  const QRectF &specifiedDetailRect);

    static const int m_extensionWidth;
    VideoInfo m_targetVideoInfo;
    const QByteArray m_resizeFilter;
    const PClip m_extendedClip;
    ZoomNPanProperties *m_animationProperties;
    QSequentialAnimationGroup m_animation;
    PClip m_resizedClip;
    QRectF m_resizedRect;
};
