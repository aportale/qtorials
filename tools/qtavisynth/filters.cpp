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

#include <QGuiApplication>
#include <QtSvg>

inline static int codecBlockSize(int clipHeight)
{
    // Ideal values for YouTube (experimented)
    // return clipHeight == 720 ? 24 : 8; // Legacy ?
    return 4;
}

inline static int snappedToBlockSize(int value, int clipHeight)
{
    const int blockSize = codecBlockSize(clipHeight);
    return qCeil(value / qreal(blockSize)) * blockSize;
}

class SvgRendererStore
{
public:
    ~SvgRendererStore()
    {
        qDeleteAll(m_svgRenderers);
    }

    QSvgRenderer* svgRenderer(const QString &svgFileName,
                              Filters::SvgResult *error)
    {
        const QFileInfo fileInfo(svgFileName);
        if (!fileInfo.exists()) {
            *error = Filters::SvgFileNotValid;
            return nullptr;
        }
        const QString saneSvgFileName =
                fileInfo.canonicalFilePath();
        if (!m_svgRenderers.contains(saneSvgFileName)) {
            auto *renderer = new QSvgRenderer(svgFileName);
            if (!renderer->isValid()) {
                *error = Filters::SvgFileNotValid;
                return nullptr;
            }
            m_svgRenderers.insert(saneSvgFileName, renderer);
        }
        *error = Filters::SvgOk;
        return m_svgRenderers.value(saneSvgFileName);
    }

    static QSvgRenderer* artworkSvgRenderer();

private:
    QHash<QString, QSvgRenderer*> m_svgRenderers;
};

Q_GLOBAL_STATIC(SvgRendererStore, svgRendererStore);

QSvgRenderer* SvgRendererStore::artworkSvgRenderer()
{
    Filters::SvgResult error;
    return svgRendererStore()->svgRenderer(QLatin1String(":/artwork.svg"), &error);
}

static char *argv[] = {(char*)"."};
static int argc = sizeof(argv) / sizeof(argv[0]);

QGuiApplication* createQGuiApplicationIfNeeded()
{
    return qGuiApp ? nullptr : new QGuiApplication(argc, argv);
}

void deleteQGuiApplicationIfNeeded(QGuiApplication* &app)
{
    return; // TODO: find out whether deleting the application is needed
    if (app) {
        delete app;
        app = nullptr;
    }
}

Filters::SvgResult Filters::checkSvg(const QString &svgFileName, const QString &element)
{
    SvgResult result;
    const QSvgRenderer *renderer = svgRendererStore()->svgRenderer(svgFileName, &result);
    if (result != SvgOk)
        return result;
    if (!renderer->elementExists(element))
        return SvgElementNotFound;
    return SvgOk;
}

void Filters::paintTitle(QPainter *p, const QRect &rect, const QString &titleText,
                         const QString &fontFace, const QColor &textColor)
{
    QGuiApplication *a = createQGuiApplicationIfNeeded();
    QFont font(fontFace);
    font.setPixelSize(qMax(24, rect.height() / 14));
    font.setHintingPreference(QFont::PreferFullHinting);
    p->setFont(font);
    p->setPen(textColor);
    p->drawText(rect, Qt::AlignCenter | Qt::TextWordWrap, titleText);
    deleteQGuiApplicationIfNeeded(a);
}

static QImage gradientImage()
{
    QSvgRenderer *renderer = SvgRendererStore::artworkSvgRenderer();
    const QString gradientId("vignettegradient");
    Q_ASSERT(renderer->boundsOnElement(gradientId).size().toSize() == QSize(256, 1));
    QImage result(256, 1, QImage::Format_ARGB32);
    result.fill(0);
    QPainter p(&result);
    renderer->render(&p, gradientId, result.rect());
#if 0
    // for debugging
    p.fillRect(0, 0, 16, 1, Qt::red);
    p.fillRect(120, 0, 32, 1, Qt::green);
    p.fillRect(240, 0, 16, 1, Qt::blue);
#endif
    return result;
}

static void drawGradient(QImage &image)
{
    const int imageWidth = image.width();
    const int imageHeight = image.height();
    if (imageWidth < 1 || imageHeight < 1)
        return;
    const QImage gradient = gradientImage();
    const auto *gradientRgb = reinterpret_cast<const QRgb*>(gradient.constBits());
    auto *imageRgb = reinterpret_cast<QRgb*>(image.bits());
    const int quarterWidth = imageWidth / 2;
    const int quarterHeight = imageHeight / 2;
    // Right triangle with a, b = 181.0193359837561662; c = 256.
    const qreal xScaleFactor = 181.0193359837561662 / quarterWidth;
    const qreal yScaleFactor = 181.0193359837561662 / quarterHeight;

    for (int y = 0; y <= quarterHeight; y++) {
        const auto scaledY = int(yScaleFactor * y);
        const int scaledYSquare = scaledY * scaledY;
        const int offsetYPlusQuarterWidth = quarterWidth + imageWidth * (quarterHeight - y);
        for (int x = 0; x <= quarterWidth; x++) {
            const auto scaledX = int(xScaleFactor * x);
            const auto gradientColorIndex = int(sqrt(qreal(scaledYSquare + scaledX * scaledX)));
            const QRgb gradientColor = gradientRgb[gradientColorIndex];
            imageRgb[offsetYPlusQuarterWidth - x] = gradientColor;
            imageRgb[offsetYPlusQuarterWidth + x] = gradientColor;
        }
    }
    const int bytesPerLine = image.bytesPerLine();
    QRgb *dst = imageRgb + imageWidth * image.height() - imageWidth;
    QRgb *src = imageRgb;
    for (int row = 0; row < quarterHeight; row++) {
        memcpy(dst, src, size_t(bytesPerLine));
        dst -= imageWidth;
        src += imageWidth;
    }
}

void paintVignette(QPainter *p, const QRect &rect)
{
    QImage vignette(rect.width(), rect.height(), QImage::Format_ARGB32);
    vignette.fill(Qt::transparent);
    drawGradient(vignette);
    p->drawImage(0, 0, vignette);
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

    static const QRgb gradientColors[] = {
        0xffff0000, 0xff00ff00, 0xff0000ff,
        0xff00ffff, 0xffff00ff, 0xffffff00,
        0xff000000, 0xffffffff
    };

    static const auto gradientColorsCount =
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

    p->fillRect(QRect(256, 0, rect.right(), gradientNumber * gradientHeight), rgbMarkerImage);
}

void paintQtLogoSmall(QPainter *p, const QRect &rect)
{
    const QLatin1String svgId("qtlogo");
    const int logoWidthForRectHeight =
            qBound(codecBlockSize(qMin(rect.height(), rect.width())),
                                  qMin(rect.height(), rect.width()) / 11, 48);
    const int logoWidth =
            logoWidthForRectHeight - (logoWidthForRectHeight % codecBlockSize(rect.height()));
    const QRectF logoElementBounds =
            SvgRendererStore::artworkSvgRenderer()->boundsOnElement(svgId);
    const int logoHeight = logoElementBounds.height() / logoElementBounds.width() * logoWidth;
    QImage logo(logoWidth, logoHeight, QImage::Format_ARGB32);
    logo.fill(0);
    {
        QPainter imagePainter(&logo);
        SvgRendererStore::artworkSvgRenderer()->render(&imagePainter, svgId, logo.rect());
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
    const QRectF logoElementBounds =
            SvgRendererStore::artworkSvgRenderer()->boundsOnElement(svgId);
    const int logoHeight = logoElementBounds.height() / logoElementBounds.width() * logoWidth;
    const int logoY = (rect.height() - logoHeight) / 2;
    SvgRendererStore::artworkSvgRenderer()->render(p, svgId, QRect(logoX, logoY, logoWidth, logoHeight));
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

void paintCC(QPainter *p, const QRect &rect, const QString &ccSuffix)
{
    const QString svgId = QLatin1String("cc-") + ccSuffix;
    const int logoHeightForRectHeight = int(qMin(rect.height() / 4.0, rect.width() * 0.15));
    const int logoY =
            snappedToBlockSize((rect.height() - logoHeightForRectHeight) / 2, rect.height());
    const int logoHeight =
            snappedToBlockSize(rect.height() - 2*logoY, rect.height());
    const QRectF logoElementBounds =
            SvgRendererStore::artworkSvgRenderer()->boundsOnElement(svgId);
    const int logoWidth =
            snappedToBlockSize(logoElementBounds.width() / logoElementBounds.height()
                               * logoHeight, rect.height());
    const int logoX = snappedToBlockSize((rect.width() - logoWidth) / 2, rect.height());
    SvgRendererStore::artworkSvgRenderer()->render(p, svgId, QRect(logoX, logoY, logoWidth, logoHeight));
}

void paintCCByNcSa(QPainter *p, const QRect &rect)
{
    paintCC(p, rect, QLatin1String("by-nc-sa"));
}

void paintCCByNcNd(QPainter *p, const QRect &rect)
{
    paintCC(p, rect, QLatin1String("by-nc-nd"));
}

void paintCCBySa(QPainter *p, const QRect &rect)
{
    paintCC(p, rect, QLatin1String("by-sa"));
}

QTransform fitRect1InRect2Centered(const QRectF &rect1, const QRectF &rect2)
{
    const qreal widthFactor = rect2.width() / rect1.width();
    const qreal heightFactor = rect2.height() / rect1.height();
    const qreal sizeFactor = qMin(widthFactor, heightFactor);
    return QTransform()
            .translate(-rect1.top(), -rect1.left())
            .scale(sizeFactor, sizeFactor)
            .translate((rect2.width() / sizeFactor - rect1.width()) / 2,
                       (rect2.height() / sizeFactor - rect1.height()) / 2);
}

Filters::SvgResult
Filters::paintSvgElements(QPainter *p, const QString &svgFileName,
                          const QStringList &svgElements, const QRect &rect,
                          const QRectF &viewBox)
{
    SvgResult result;
    QSvgRenderer *renderer = svgRendererStore()->svgRenderer(svgFileName, &result);
    if (result != SvgOk)
        return result;
    const QTransform painterTransform = fitRect1InRect2Centered(
            (viewBox.isValid() ? viewBox : renderer->viewBoxF()), rect);
    p->save();
    p->setTransform(p->transform() * painterTransform);
    foreach (const QString &element, svgElements) {
        if (!renderer->elementExists(element))
            return SvgElementNotFound;
        const QRectF elementBounds = renderer->boundsOnElement(element);
        renderer->render(p, element, elementBounds);
    }
    p->restore();
    return SvgOk;
}

Filters::SvgResult
Filters::paintBlendedSvgElement(QPainter *p,
                                const QString &svgFileName, const QString &svgElement,
                                qreal opacity, qreal scale, const QRect &rect, const QRectF &viewBox)
{
    SvgResult result;
    QSvgRenderer *renderer = svgRendererStore()->svgRenderer(svgFileName, &result);
    if (result != SvgOk)
        return result;
    if (!renderer->elementExists(svgElement))
        return SvgElementNotFound;
    const QTransform painterTransform = fitRect1InRect2Centered(
            (viewBox.isValid() ? viewBox : renderer->viewBoxF()), rect);
    const QRectF elementBounds = renderer->boundsOnElement(svgElement);
    QRectF scaledBounds(elementBounds.topLeft(), elementBounds.size() * scale);
    scaledBounds.moveCenter(elementBounds.center());
    p->save();
    if (opacity < 1.0) {
        QImage elementImage(rect.size(), QImage::Format_ARGB32);
        elementImage.fill(0);
        QPainter elementPainter(&elementImage);
        elementPainter.setTransform(painterTransform);
        renderer->render(&elementPainter, svgElement, scaledBounds);
        p->setOpacity(opacity);
        p->drawImage(0, 0, elementImage);
    } else {
        p->setTransform(painterTransform, true);
        renderer->render(p, svgElement, scaledBounds);
    }
    p->restore();
    return SvgOk;
}

using ElementAndPainterHash = QHash<QString, void (*)(QPainter *, const QRect&)>;

const ElementAndPainterHash& elementsAndPaintersHash()
{
    const static ElementAndPainterHash hash = {
        { QLatin1String("vignette"),            paintVignette },
        { QLatin1String("rgbpatterns"),         paintRgbPatterns },
        { QLatin1String("blockpattern"),        paintCodecBlockPattern },
        { QLatin1String("qtlogosmall"),         paintQtLogoSmall },
        { QLatin1String("qtlogobig"),           paintQtLogoBig },
        { QLatin1String("codecblockpattern"),   paintCodecBlockPattern },
        { QLatin1String("cc-by-nc-sa"),         paintCCByNcSa },
        { QLatin1String("cc-by-nc-nd"),         paintCCByNcNd },
        { QLatin1String("cc-by-sa"),            paintCCBySa }
    };
    return hash;
}

bool Filters::elementAvailable(const QString &element)
{
    return !elementsAndPaintersHash().contains(element);
}

void Filters::paintElements(QPainter *p, const QStringList &elements, const QRect &rect)
{
    foreach (const QString &element, elements)
        if (elementsAndPaintersHash().contains(element))
            elementsAndPaintersHash().value(element)(p, rect);
    p->end();
}

void Filters::paintAnimatedSubTitle(QPainter *p, const QString &title, const QString &subTitle,
                           qreal slipIn, qreal blendIn, const QRect &rect)
{
    if (slipIn <= 0)
        return;

    QFont titleFont(QLatin1String("Verdana"));
    QFont subTitleFont(titleFont);
    subTitleFont.setPixelSize(rect.height() / (subTitle.isEmpty() ? 18 : 20));
    titleFont.setPixelSize(rect.height() / 14);
    titleFont.setBold(true);

    const int padding = rect.height() / 45;
    const int textLineDistance = rect.height() / 80;
    int backgroundHeight = padding + titleFont.pixelSize() + padding;
    if (!subTitle.isEmpty())
        backgroundHeight += textLineDistance + subTitleFont.pixelSize();
    backgroundHeight = snappedToBlockSize(backgroundHeight, rect.height());
    int tweakedPadding = backgroundHeight - titleFont.pixelSize();
    if (!subTitle.isEmpty())
        tweakedPadding -= textLineDistance + subTitleFont.pixelSize();
    tweakedPadding /= 2;

    const auto backgroundTop = int(rect.height() - slipIn * backgroundHeight);
    const QRect background(0, backgroundTop, rect.width(), backgroundHeight);
    SvgRendererStore::artworkSvgRenderer()->render(p, QLatin1String("subtitlebackground"), background);

    QGuiApplication *a = createQGuiApplicationIfNeeded();
    p->save();
    p->setPen(QColor(245, 235, 170));
    p->setCompositionMode(QPainter::CompositionMode_Lighten);
    p->setOpacity(blendIn + 0.2);
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
        p->drawText(int(padding * 1.68),
                    tweakedPadding + titleFont.pixelSize() + textLineDistance + subTitleFont.pixelSize(),
                    subTitle);
    }
    p->restore();
    deleteQGuiApplicationIfNeeded(a);
}

void Filters::paintHighlight(QPainter *p, const QRectF &highlightRect,
                             qreal opacity)
{
    if (opacity <= 0)
        return;

    const QColor color(0xfeee0b);
    const QRectF outerRect =
            highlightRect.adjusted(-1, -1, 1, 1); // Plus half pen width

    p->save();
    p->setOpacity(opacity * 0.25);
    p->fillRect(highlightRect, color);
    p->setPen(QPen(color, 2, Qt::SolidLine, Qt::SquareCap, Qt::MiterJoin));
    p->setOpacity(opacity * 0.75);
    p->setRenderHint(QPainter::Antialiasing);
    p->drawRect(outerRect);
    p->restore();
}
