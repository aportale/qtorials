/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#ifndef FILTERS_H
#define FILTERS_H

#include <QtGui>

class Filters
{
public:
    enum PaintSvgResult {
        PaintSvgOk,
        PaintSvgFileNotValid,
        PaintSvgElementNotFound
    };
    static void paintTitle(QPainter *p, const QRect &rect, const QString &titleText);
    static void paintElements(QPainter *p, const QString &elementsCSV, const QRect &rect);
    static PaintSvgResult paintSvg(QPainter *p, const QString &svgFileName,
                                   const QString &elementsCSV, const QRect &rect);
    static void paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                                      int frame, int frames, const QRect &rect);\
};

#endif // FILTERS_H
