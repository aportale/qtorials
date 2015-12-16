#ifndef PAINTEDRGBCLIP_H
#define PAINTEDRGBCLIP_H

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#include <QRect>

class QPainter;

class PaintedRgbClip
{
public:
    virtual void paintFrame(QPainter *painter, int frameNumber, const QRect &rect) const = 0;
};

#endif // PAINTEDRGBCLIP_H
