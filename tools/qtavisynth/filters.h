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
    static void paintTitle(QPainter *p, const QRect &rect, const QString &titleText,
                           const QString &fontFace, const QColor &textColor);
    static bool elementAvailable(const QString &element);
    static void paintElements(QPainter *p, const QStringList &elements, const QRect &rect);
    static SvgResult checkSvg(const QString &svgFileName, const QString &element);
    static SvgResult paintSvgElements(QPainter *p, const QString &svgFileName,
                                      const QStringList &svgElements, const QRect &rect,
                                      const QRectF &viewBox = QRectF());
    static SvgResult paintBlendedSvgElement(QPainter *p,
                                            const QString &svgFileName, const QString &svgElement,
                                            qreal opacity, qreal scale,
                                            const QRect &rect, const QRectF &viewBox = QRectF());
    static void paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                                      qreal slipIn, qreal blendIn, const QRect &rect);
    static void paintHighlight(QPainter *p, const QRectF &highlightRect,
                               qreal opacity);
};

#endif // FILTERS_H
