/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#pragma once

#include <QRectF>
#include <QSizeF>
#include <QStringList>

QT_FORWARD_DECLARE_CLASS(QColor)
QT_FORWARD_DECLARE_CLASS(QPainter)

namespace Painting {

enum SvgResult {
    SvgOk,
    SvgFileNotValid,
    SvgElementNotFound
};

void paintTitle(QPainter *p, const QRect &rect, const QString &titleText,
                const QString &fontFace, const QColor &textColor);
bool elementAvailable(const QString &element);
void paintElements(QPainter *p, const QStringList &elements, const QRect &rect);
SvgResult checkSvg(const QString &svgFileName, const QString &element);
SvgResult paintSvgElements(QPainter *p, const QString &svgFileName,
                           const QStringList &svgElements, const QRect &rect,
                           const QRectF &viewBox = QRectF());
QSizeF svgViewBoxSize(const QString &svgFileName);
SvgResult paintBlendedSvgElement(QPainter *p,
                                 const QString &svgFileName, const QString &svgElement,
                                 qreal opacity, qreal scale,
                                 const QRect &rect, const QRectF &viewBox = QRectF());
void paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                           qreal slipIn, qreal blendIn, const QRect &rect);
void paintHighlight(QPainter *p, const QRectF &highlightRect,
                    qreal opacity);

} // namespace Painting
