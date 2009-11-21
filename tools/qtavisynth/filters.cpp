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

inline static int codecBlockSize(int clipHeight)
{
    // Ideal values for YouTube (experimented)
    return clipHeight == 720 ? 24 : 8;
}

inline static int snappedToBlockSize(int value, int clipHeight)
{
    const int blockSize = codecBlockSize(clipHeight);
    return qCeil(value / qreal(blockSize)) * blockSize;
}

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

void paintTitle(QPainter *p, const QRect &rect, const QString &titleText)
{
    QApplication *a = createQApplicationIfNeeded();
    p->fillRect(rect, 0xeeeeee);
    QFont font;
    font.setPixelSize(qMax(8, rect.height() / 14));
    font.setBold(true);
    p->setFont(font);
    p->setPen(0x333333);
    p->drawText(rect, Qt::AlignCenter | Qt::TextWordWrap, titleText);
    deleteQApplicationIfNeeded(a);
}

void paintOldStyle(QPainter *p, const QRect &rect)
{
    svgRenderer()->render(p, QLatin1String("oldstyle"), rect);
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

    const int gradientHeight = codecBlockSize(rect.height());
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

void paintQtLogoSmall(QPainter *p, const QRect &rect)
{
    const QLatin1String svgId("qtlogo");
    const int logoWidthForRectHeight =
            qBound(codecBlockSize(qMin(rect.height(), rect.width())),
                                  qMin(rect.height(), rect.width()) / 11, 48);
    const int logoWidth =
            logoWidthForRectHeight - (logoWidthForRectHeight % codecBlockSize(rect.height()));
    const QRectF logoElementBounds = svgRenderer()->boundsOnElement(svgId);
    const int logoHeight = logoElementBounds.height() / logoElementBounds.width() * logoWidth;
    QImage logo(logoWidth, logoHeight, QImage::Format_ARGB32);
    logo.fill(0);
    {
        QPainter imagePainter(&logo);
        svgRenderer()->render(&imagePainter, svgId, logo.rect());
    }
    const int logoX = (rect.width() - logoWidth - codecBlockSize(rect.height()))
                      / codecBlockSize(rect.height()) * codecBlockSize(rect.height());
    const int logoY = rect.height() - logoHeight - (codecBlockSize(rect.height()) * 0.75);
    p->save();
    p->setOpacity(0.7);
    p->drawImage(logoX, logoY, logo);
    p->restore();
}

void paintQtLogoBig(QPainter *p, const QRect &rect)
{
    const QLatin1String svgId("qtlogo");
    const int logoWidthForRectHeight = int(qMin(rect.height(), rect.width()) / 2.5);
    const int logoX = (rect.width() - logoWidthForRectHeight)
             / 2 / codecBlockSize(rect.height()) * codecBlockSize(rect.height());
    const int logoWidth = (rect.width() - 2*logoX)
             / codecBlockSize(rect.height()) * codecBlockSize(rect.height());
    const QRectF logoElementBounds = svgRenderer()->boundsOnElement(svgId);
    const int logoHeight = logoElementBounds.height() / logoElementBounds.width() * logoWidth;
    const int logoY = (rect.height() - logoHeight) / 2;
    svgRenderer()->render(p, svgId, QRect(logoX, logoY, logoWidth, logoHeight));
}

void paintSymbianLogoBig(QPainter *p, const QRect &rect)
{
    const QLatin1String svgId("symbianlogo");
    const QRectF logoElementBounds = svgRenderer()->boundsOnElement(svgId);
    const int logoHeight = qMin(rect.height() / 3, rect.width() / 4);
    const int logoWidth = logoElementBounds.width() / logoElementBounds.height() * logoHeight;
    const int logoY = (rect.height() - logoHeight) / 2;
    const int logoX = (rect.width() - logoWidth) / 2;
    svgRenderer()->render(p, svgId, QRect(logoX, logoY, logoWidth, logoHeight));
}

void paintCodecBlockPattern(QPainter *p, const QRect &rect)
{
    QImage brush(codecBlockSize(rect.height()) * 2, codecBlockSize(rect.height()) * 2,
                 QImage::Format_RGB32);
    brush.fill(QColor(Qt::red).rgb());
    QPainter brushPainter(&brush);
    const QRect blockRect(0, 0, codecBlockSize(rect.height()), codecBlockSize(rect.height()));
    brushPainter.fillRect(blockRect, Qt::blue);
    brushPainter.fillRect(blockRect.translated(codecBlockSize(rect.height()), codecBlockSize(rect.height())), Qt::blue);
    p->fillRect(rect, QBrush(brush));
}

void paintElements(QPainter *p, const QString &elementsCSV, const QRect &rect)
{
    static QHash<QString, void (*)(QPainter *, const QRect&)> elementFunctions;
    if (elementFunctions.isEmpty()) {
        static const struct {
            QString name;
            void (*function)(QPainter *, const QRect&);
        } elementFunctionArray [] = {
            { QLatin1String("oldstyle"),            paintOldStyle },
            { QLatin1String("rgbpatterns"),         paintRgbPatterns },
            { QLatin1String("blockpattern"),        paintCodecBlockPattern },
            { QLatin1String("qtlogosmall"),         paintQtLogoSmall },
            { QLatin1String("qtlogobig"),           paintQtLogoBig },
            { QLatin1String("symbianlogobig"),      paintSymbianLogoBig },
            { QLatin1String("codecblockpattern"),   paintCodecBlockPattern }
        };
        for (int i = 0; i < int(sizeof elementFunctionArray / sizeof elementFunctionArray[0]); i++)
            elementFunctions.insert(elementFunctionArray[i].name, elementFunctionArray[i].function);
    }
    foreach (const QString &element, elementsCSV.split(QLatin1Char(','), QString::SkipEmptyParts)) {
        const QString cleanElement = element.toLower().trimmed();
        if (elementFunctions.contains(cleanElement))
            elementFunctions.value(cleanElement)(p, rect);
    }
}

qreal inOutAnimationValue(int inOffset, int inLength, QEasingCurve::Type inType,
                          int outOffset, int outLength, QEasingCurve::Type outType,
                          int frame, int framesCount)
{
    qreal result = qreal(1);
    if (frame < inOffset || frame > framesCount - outOffset)
        result = 0;
    if (frame <= inOffset + inLength)
        result = QEasingCurve(inType)
            .valueForProgress(qreal(1) / inLength * (frame - inOffset));
    else if (frame >= framesCount - outOffset - outLength)
        result = QEasingCurve(outType)
            .valueForProgress(qreal(1) / outLength * (framesCount - frame - outOffset - 1));
    return result;
}

void paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                           int frame, int framesCount, const QRect &rect)
{
    static const int slideInFrames = 7;
    const qreal slideInFactor =
            inOutAnimationValue(0, slideInFrames, QEasingCurve::OutQuad,
                                0, slideInFrames, QEasingCurve::OutQuad,
                                frame, framesCount);

    if (slideInFactor <= 0)
        return;

    QFont titleFont(QLatin1String("Verdana"));
    QFont subTitleFont(titleFont);
    subTitleFont.setPixelSize(rect.height() / (subTitle.isEmpty() ? 18 : 20));
    titleFont.setPixelSize(rect.height() / 14);
    titleFont.setBold(true);

    const int padding = rect.height() / 45;
    const int textLineDistance = rect.height() / 80;
    qreal backgroundHeight = padding + titleFont.pixelSize() + padding;
    if (!subTitle.isEmpty())
        backgroundHeight += textLineDistance + subTitleFont.pixelSize();
    backgroundHeight = snappedToBlockSize(backgroundHeight, rect.height());
    int tweakedPadding = backgroundHeight - titleFont.pixelSize();
    if (!subTitle.isEmpty())
        tweakedPadding -= textLineDistance + subTitleFont.pixelSize();
    tweakedPadding /= 2;

    const int backgroundTop = rect.height() - slideInFactor * backgroundHeight;
    const QRect background(0, backgroundTop, rect.width(), backgroundHeight);
    QLinearGradient gradient(background.topLeft(), background.topRight());
    gradient.setColorAt(0.65, QColor(64, 64, 64, 192));
    gradient.setColorAt(0.85, QColor(64, 64, 64, 0));
    p->fillRect(background, gradient);


    static const int blendInFrames = 6;
    const qreal textOpacity =
            inOutAnimationValue(slideInFrames * 0.7, blendInFrames, QEasingCurve::Linear,
                                slideInFrames * 0.7, blendInFrames, QEasingCurve::Linear,
                                frame, framesCount);
    QApplication *a = createQApplicationIfNeeded();
    p->save();
    p->setPen(QColor(245, 235, 170));
    p->setCompositionMode(QPainter::CompositionMode_Lighten);
    p->setOpacity(textOpacity + 0.2);
    p->translate(background.topLeft());
    p->setFont(titleFont);
    int titleTextTop = tweakedPadding + titleFont.pixelSize();
    if (subTitle.isEmpty()) {
        const QFontMetrics fm(titleFont);
        titleTextTop =
            tweakedPadding + fm.ascent() - fm.xHeight()/2;
    }
    p->drawText(padding, titleTextTop, title);
    if (!subTitle.isEmpty()) {
        p->setFont(subTitleFont);
        p->drawText(padding * 1.68,
                    tweakedPadding + titleFont.pixelSize() + textLineDistance + subTitleFont.pixelSize(),
                    subTitle);
    }
    p->restore();
    deleteQApplicationIfNeeded(a);
}
