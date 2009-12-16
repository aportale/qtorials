#ifndef TOOLS_H
#define TOOLS_H

#include <windows.h>
#include <QString>
#include <QColor>
#include "avisynth.h"

class Tools
{
public:
    static QString cleanFileName(const QString &file);
    static void checkSvgAndThrow(const QString &svgFileName,
                                 const QString &svgElement,
                                 IScriptEnvironment* env);

    static const int defaultClipWidth;
    static const int defaultClipHeight;
    static const QRgb transparentColor;
};

#endif // TOOLS_H
