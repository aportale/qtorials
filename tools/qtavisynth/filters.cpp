/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "filters.h"

void paintOldStyle(QPainter *p, const QRect &rect)
{
    static QImage gradientCache;
    if (gradientCache.size() != rect.size()) {
        QRadialGradient gradient(QPointF(.5, .5), 0.8);
        gradient.setColorAt(  0, QColor(  0,   0,   0,   0));
        gradient.setColorAt(0.4, QColor(  0,   0,   0,   0));
        gradient.setColorAt(0.8, QColor(  0,   0,   0,  15));
        gradient.setColorAt(1.0, QColor(  0,   0,   0,  40));

        QImage newGradientImage(rect.size(), QImage::Format_ARGB32);
        newGradientImage.fill(Qt::transparent);

        QPainter newP(&newGradientImage);
        newP.setRenderHint(QPainter::Antialiasing);
        newP.scale(rect.width(), rect.height());
        newP.fillRect(rect, QBrush(gradient));

        gradientCache = newGradientImage;
    }
    p->drawImage(rect.topLeft(), gradientCache);
}

void paintRgbPatterns(QPainter *p, const QRect &rect)
{
    static QImage patternsCache;
    if (patternsCache.size() != rect.size()) {
        static const QRgb dotsData[] = {
            0xffff0000, 0xff00ffff,
            0xff00ff00, 0xffff00ff,
            0xff0000ff, 0xffffff00
        };
        QImage dotsImage(reinterpret_cast<const uchar *>(dotsData), 2, 3, QImage::Format_ARGB32);

        const int pointBorder = 1;
        const QSize rgbMarkerSize(
             dotsImage.width() * (dotsImage.width() + 2*pointBorder),
             dotsImage.height() * (dotsImage.height() + 2*pointBorder)
        );
        QImage rgbMarkerImage(rgbMarkerSize + QSize(1, 1), QImage::Format_ARGB32);
        rgbMarkerImage.fill(Qt::black);
        QPainter rgbMarkerP(&rgbMarkerImage);
        rgbMarkerP.drawImage(QRect(QPoint(), rgbMarkerSize), dotsImage);

        for (int x = 0; x < dotsImage.width(); ++x)
            for (int y = 0; y < dotsImage.height(); ++y)
                rgbMarkerP.drawImage(
                    QPoint(
                        x * (dotsImage.width() + 2 * pointBorder) + pointBorder,
                        y * (dotsImage.height() + 2 * pointBorder) + pointBorder
                    ), dotsImage
                );

        QImage newPatternsImage(rect.size(), QImage::Format_ARGB32);
        newPatternsImage.fill(Qt::black);
        QPainter newP(&newPatternsImage);
        newP.fillRect(rect, rgbMarkerImage);

        static const QRgb gradientColors[] = {
            0xffff0000, 0xff00ff00, 0xff0000ff,
            0xff00ffff, 0xffff00ff, 0xffffff00,
            0xff000000, 0xffffffff
        };

        static const int gradientColorsCount =
            int(sizeof gradientColors / sizeof gradientColors[0]);

        const int gradientHeight = 5;
        int gradientNumber = 0;
        for (int a = 0; a < gradientColorsCount; a++)
            for (int b = a + 1; b < gradientColorsCount; b++) {
                QLinearGradient gradient(0, 0, 256, 0);
                gradient.setColorAt(0, gradientColors[a]);
                gradient.setColorAt(1, gradientColors[b]);
                newP.fillRect(0, gradientNumber * gradientHeight, 256, gradientHeight, gradient);
                gradientNumber++;
            }

        patternsCache = newPatternsImage;
    }
    p->drawImage(rect.topLeft(), patternsCache);
}
