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
    enum SvgResult {
        SvgOk,
        SvgFileNotValid,
        SvgElementNotFound
    };
    static SvgResult checkSvg(const QString &svgFileName, const QString &element);
    static void paintTitle(QPainter *p, const QRect &rect, const QString &titleText,
                           const QColor &textColor);
    static void paintElements(QPainter *p, const QString &elementsCSV, const QRect &rect);
    static SvgResult paintSvgElements(QPainter *p, const QString &svgFileName,
                                      const QStringList &svgElements, const QRect &rect);
    static SvgResult paintBlendedSvgElement(QPainter *p, const QString &svgFileName,
                                            const QString &svgElement, qreal opacity,
                                            const QRectF &elementRect);
    static void paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                                      qreal slipIn, qreal blendIn, const QRect &rect);
};

#endif // FILTERS_H
