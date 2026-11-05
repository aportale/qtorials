#pragma once

#include "avisynth.h"

#include <QtGlobal>

#include <functional>

QT_FORWARD_DECLARE_CLASS(QColor)
QT_FORWARD_DECLARE_CLASS(QString)

class Tools
{
public:
    static QString cleanFileName(const QString &file);
    static void checkSvgAndThrow(const QString &svgFileName,
                                 const QString &svgElement,
                                 IScriptEnvironment* env);
    static PClip rgbOverlay(const PClip &backgroundClip, const PClip &overlayClip,
                            IScriptEnvironment* env);

    static void createQGuiApplicationIfNeeded();
    static void runInApplicationThread(const std::function<void()> &function);

    static const int defaultClipWidth;
    static const int defaultClipHeight;
};
