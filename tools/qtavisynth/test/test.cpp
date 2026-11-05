/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include <QApplication>
#include <QComboBox>
#include <QPainter>
#include <QSettings>
#include <QVBoxLayout>
#include <QWidget>

#include <functional>

#include "painting.h"
#include "tools.h"

// Normally provided by the plugin entry point in qtavisynth.cpp. Unused here, since
// this test does not call into AviSynth.
const AVS_Linkage *AVS_linkage = nullptr;

static const QString svgFileName = QLatin1String(SCREENCASTS_DIR "/qtsymbian_development.svg");

using PaintFunction = std::function<void(QPainter *p, const QRect &rect)>;

struct PaintCase
{
    QString name;
    PaintFunction paint;
};

static PaintCase paintElementsCase(const QString &element)
{
    return {
        QLatin1String("paintElements: ") + element,
        [element](QPainter *p, const QRect &rect) {
            Painting::paintElements(p, {element}, rect);
        }
    };
}

static const QList<PaintCase> &paintCases()
{
    static const QList<PaintCase> cases = {
        {
            QLatin1String("paintTitle"),
            [](QPainter *p, const QRect &rect) {
                Painting::paintTitle(p, rect, QLatin1String("Hallo AviSynth, <b>bold</b> text"),
                                    QLatin1String("Verdana"), Qt::black);
            }
        },
        paintElementsCase(QLatin1String("vignette")),
        paintElementsCase(QLatin1String("rgbpatterns")),
        paintElementsCase(QLatin1String("qtlogosmall")),
        paintElementsCase(QLatin1String("qtlogobig")),
        paintElementsCase(QLatin1String("codecblockpattern")),
        paintElementsCase(QLatin1String("cc-by-nc-sa")),
        paintElementsCase(QLatin1String("cc-by-nc-nd")),
        paintElementsCase(QLatin1String("cc-by-sa")),
        {
            QLatin1String("paintSvgElements"),
            [](QPainter *p, const QRect &rect) {
                Painting::paintSvgElements(p, svgFileName, {QLatin1String("mainwindow"),
                                                           QLatin1String("listwidget")}, rect);
            }
        },
        {
            QLatin1String("paintBlendedSvgElement"),
            [](QPainter *p, const QRect &rect) {
                Painting::paintBlendedSvgElement(p, svgFileName, QLatin1String("pushbutton"),
                                                0.9, 3.0, rect);
            }
        },
        {
            QLatin1String("paintAnimatedSubTitle"),
            [](QPainter *p, const QRect &rect) {
                Painting::paintAnimatedSubTitle(p, QLatin1String("Title"),
                                               QLatin1String("Sub title"), 50, 100, rect);
            }
        },
        {
            QLatin1String("paintHighlight"),
            [](QPainter *p, const QRect &rect) {
                Painting::paintSvgElements(p, svgFileName, {QLatin1String("mainwindow")}, rect);
                const QRectF highlightRect(rect.width() * 0.25, rect.height() * 0.25,
                                           rect.width() * 0.5, rect.height() * 0.5);
                Painting::paintHighlight(p, highlightRect, 1.0);
            }
        },
    };
    return cases;
}

class Canvas : public QWidget
{
public:
    Canvas(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        setMinimumSize(1280, 720);
    }

    void setPaintCase(int index)
    {
        m_paintCase = index;
        update();
    }

protected:
    void paintEvent(QPaintEvent *event) override
    {
        Q_UNUSED(event)
        QPainter p(this);
        p.fillRect(rect(), Qt::white);
        if (m_paintCase >= 0 && m_paintCase < paintCases().count())
            paintCases().at(m_paintCase).paint(&p, rect());
    }

private:
    int m_paintCase = -1;
};

class FilterTest : public QWidget
{
public:
    FilterTest(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        auto *comboBox = new QComboBox;
        for (const PaintCase &paintCase : paintCases())
            comboBox->addItem(paintCase.name);

        auto *canvas = new Canvas;

        auto *layout = new QVBoxLayout(this);
        layout->addWidget(comboBox);
        layout->addWidget(canvas, 1);

        connect(comboBox, &QComboBox::currentIndexChanged, this, [comboBox, canvas](int index) {
            canvas->setPaintCase(index);
            QSettings().setValue(settingsKey, comboBox->itemText(index));
        });

        // Stored by name, so that the selection survives reordering of paintCases()
        const int storedIndex = comboBox->findText(QSettings().value(settingsKey).toString());
        comboBox->setCurrentIndex(qMax(storedIndex, 0));
        canvas->setPaintCase(comboBox->currentIndex());
    }

private:
    static constexpr char settingsKey[] = "paintCase";
};

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QApplication::setOrganizationName(QLatin1String("qtorials"));
    QApplication::setApplicationName(QLatin1String("qtavisynth_filtertest"));

    FilterTest dlg;
    dlg.show();

    return a.exec();
}
