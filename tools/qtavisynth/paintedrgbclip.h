#ifndef PAINTEDRGBCLIP_H
#define PAINTEDRGBCLIP_H

#include "windows.h"
#include "avisynth.h"
#include <QRect>

class QPainter;

class PaintedRgbClip
{
public:
    virtual void paintFrame(QPainter *painter, int frameNumber, const QRect &rect) const = 0;
};

#endif // PAINTEDRGBCLIP_H
