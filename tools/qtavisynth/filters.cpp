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
#include "qglobal.h"
#include <QtSvg>

static const int codecBlockSize = 16;

Q_GLOBAL_STATIC_WITH_INITIALIZER(QSvgRenderer, svgRenderer, {
    x->load(QLatin1String(":/artwork.svg"));
});

static char *argv[] = {"."};
static int argc = sizeof(argv) / sizeof(argv[0]);

QApplication* createQApplicationIfNeeded()
{
    return qApp ? 0 : new QApplication(argc, argv);
}

void deleteQApplicationIfNeeded(QApplication* &app)
{
    if (app) {
        delete app;
        app = 0;
    }
}

void paintQtLogoSmall(QPainter *p, const QRect &rect);
//void paintQtLogoBig(QPainter *p, const QRect &rect);
void paintCodecBlockPattern(QPainter *p, const QRect &rect);
void paintOldStyle(QPainter *p, const QRect &rect)
{
    svgRenderer()->render(p, QLatin1String("oldstyle"), rect);
    paintCodecBlockPattern(p, rect);
    paintQtLogoSmall(p, rect);
    //paintQtLogoBig(p, rect);
}

void paintRgbPatterns(QPainter *p, const QRect &rect)
{
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

    p->fillRect(rect, rgbMarkerImage);

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
            p->fillRect(0, gradientNumber * gradientHeight, 256, gradientHeight, gradient);
            gradientNumber++;
        }
}

void paintTitle(QPainter *p, const QRect &rect, const QString &titleText)
{
//    QApplication *a = createQApplicationIfNeeded();
    p->fillRect(rect, 0xeeeeee);
    QFont font;
    font.setPixelSize(qMax(8, rect.height() / 14));
    font.setBold(true);
    p->setFont(font);
    p->setTransform(QTransform().rotate(0.00000000001, Qt::YAxis));
    p->setRenderHint(QPainter::Antialiasing);
    p->setPen(0x333333);
    p->drawText(rect, Qt::AlignCenter | Qt::TextWordWrap, titleText);
//    deleteQApplicationIfNeeded(a);
}

void paintQtLogoSmall(QPainter *p, const QRect &rect)
{
    const QLatin1String svgId("qtlogo");
    const int logoWidthForRectHeight =
            qBound(codecBlockSize, rect.height() / 11, codecBlockSize * 3);
    const int logoWidth =
            logoWidthForRectHeight - (logoWidthForRectHeight % codecBlockSize);
    const QRectF logoElementBounds = svgRenderer()->boundsOnElement(svgId);
    const int logoHeight = logoElementBounds.height() / logoElementBounds.width() * logoWidth;
    QImage logo(logoWidth, logoHeight, QImage::Format_ARGB32);
    logo.fill(0);
    {
        QPainter imagePainter(&logo);
        svgRenderer()->render(&imagePainter, svgId, logo.rect());
    }
    const int logoX = (rect.width() - logoWidth - codecBlockSize) / codecBlockSize * codecBlockSize;
    const int logoY = rect.height() - logoHeight - (codecBlockSize * 0.75);
    p->save();
    p->setOpacity(0.7);
    p->drawImage(logoX, logoY, logo);
    p->restore();
}

void paintCodecBlockPattern(QPainter *p, const QRect &rect)
{
    QImage brush(codecBlockSize * 2, codecBlockSize * 2, QImage::Format_RGB32);
    QPainter brushPainter(&brush);
    brushPainter.fillRect(brush.rect(), Qt::lightGray);
    const QRect blockRect(0, 0, codecBlockSize, codecBlockSize);
    brushPainter.fillRect(blockRect, Qt::gray);
    brushPainter.fillRect(blockRect.translated(codecBlockSize, codecBlockSize), Qt::gray);
    p->fillRect(rect, QBrush(brush));
}
