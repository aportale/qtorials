#pragma once

#include <windows.h>
#include "avisynth.h"

#include <QtGlobal>
QT_FORWARD_DECLARE_CLASS(QString)
QT_FORWARD_DECLARE_CLASS(QColor)

class Tools
{
public:
    static QString cleanFileName(const QString &file);
    static void checkSvgAndThrow(const QString &svgFileName,
                                 const QString &svgElement,
                                 IScriptEnvironment* env);
    static PClip rgbOverlay(const PClip &backgroundClip, const PClip &overlayClip,
                            IScriptEnvironment* env);

    static const int defaultClipWidth;
    static const int defaultClipHeight;
};
