#ifndef TOOLS_H
#define TOOLS_H

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#include <QString>
#include <QColor>

#ifdef LINUXIZED_VERSION
using namespace avxsynth;
#endif

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
