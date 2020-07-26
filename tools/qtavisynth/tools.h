#pragma once

#include <windows.h>
#include "avisynth.h"

#include <QtGlobal>
QT_FORWARD_DECLARE_CLASS(QColor)
QT_FORWARD_DECLARE_CLASS(QGuiApplication)
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

    static QGuiApplication *createQGuiApplicationIfNeeded();
    static void deleteQGuiApplicationIfNeeded(QGuiApplication *&app);

    static const int defaultClipWidth;
    static const int defaultClipHeight;
};
