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

void paintOldStyle(QPainter *p, const QRect &rect);
void paintRgbPatterns(QPainter *p, const QRect &rect);
void paintTitle(QPainter *p, const QRect &rect, const QString &titleText);

#endif // FILTERS_H
