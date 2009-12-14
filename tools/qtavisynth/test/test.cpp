/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include <QtGui>
#include "filters.h"

class FilterTest : public QWidget
{
public:
    FilterTest(QWidget *parent = 0)
        : QWidget(parent)
    {
    }

    void paintEvent(QPaintEvent *event)
    {
        Q_UNUSED(event);
        QPainter p(this);
        p.fillRect(rect(), Qt::white);
//        paintRgbPatterns(&p, rect());
//        paintTitle(&p, rect(), "Hallo AviSynth sdfg<b>sdf</b>gsdf gsdfgsd fgsdfg sdfgsd fgs dfg");
        Filters::paintElements(&p, "qtlogosmall", rect());
        QStringList svgElements;
        svgElements << QLatin1String("mainwindow")
                << QLatin1String("listwidget");
        Filters::paintSvgElements(&p, "../../../screencasts/qtsymbian_development.svg",
                                  svgElements, rect());
        Filters::paintBlendedSvgElement(&p, "../../../screencasts/qtsymbian_development.svg",
                                        QLatin1String("pushbutton"), 0.9, 3.0, rect());
        Filters::paintAnimatedSubTitle(&p, "huhu", "huih iuh iuhi", 50, 100, rect());
    }
};

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    FilterTest dlg;
    dlg.show();

    return a.exec();
}
