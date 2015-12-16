#ifndef ZOOMNPAN_H
#define ZOOMNPAN_H

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#include <QSequentialAnimationGroup>
#include <QRectF>

#ifdef LINUXIZED_VERSION
using namespace avxsynth;
#endif

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
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
    static AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);

    bool __stdcall GetParity(int n);
    const VideoInfo& __stdcall GetVideoInfo();
    void __stdcall SetCacheHints(int cachehints, int frame_range);
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);

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

#endif // ZOOMNPAN_H
