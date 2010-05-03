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

struct mode{
    QString name;
    void (*function)(QPainter &, const QSize&);
};

static const char* const focusPattern[] = {
"26 40 2 1",
"  c #FFFFFF",
"* c #000000",
"*   *   *                 ",
"  *   *   * **            ",
"            **   ******   ",
"**********  **   ******   ",
"            **   ******   ",
"   **  *  * **   ******   ",
"  **  *  *  **   ******   ",
" **  *  *   **   ******   ",
"**  *  *    **   ******   ",
" **  *  *   **   ******   ",
"  **  *  *  **   ******   ",
"   **  *  *      ******   ",
"                 ******   ",
"**************   ******   ",
"**************            ",
"                          ",
"                          ",
"                          ",
"                          ",
"                          ",
"                          ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"******** *********        ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"******************        ",
"                          ",
"                          ",
"                          ",
"                          ",
"                          ",
"                          "
};

class PhoneScreenCalibr8: public QMainWindow
{
    Q_OBJECT

public:
    PhoneScreenCalibr8(QWidget *parent = 0)
        : QMainWindow(parent)
        , m_currentMode(0)
    {
        QSignalMapper *mapper = new QSignalMapper(this);
        connect(mapper, SIGNAL(mapped(int)), SLOT(setMode(int)));
        for (int i = 0; i < m_modesCount; i++) {
            const mode mode = m_modes[i];
            QAction *action = new QAction(mode.name, this);
            menuBar()->addAction(action);
            connect(action, SIGNAL(triggered()), mapper, SLOT(map()));
            mapper->setMapping(action, i);
        }
        setFocusPolicy(Qt::StrongFocus);
    }

    void paintEvent(QPaintEvent *event)
    {
        Q_UNUSED(event);
        QPainter p(this);
        m_modes[m_currentMode].function(p, size());
    }

    static void paintMode1(QPainter &p, const QSize &size)
    {
        static const QPixmap focus(focusPattern);
        p.fillRect(QRect(QPoint(), size), focus);
    }

    static void paintMode2(QPainter &p, const QSize &size)
    {
        p.fillRect(QRect(QPoint(), size), Qt::white);
    }

    static void paintMode3(QPainter &p, const QSize &size)
    {
        static const int gradientColumns = 6;
        static const int gradientRows = 16;
        QImage gradients(gradientColumns, gradientRows, QImage::Format_RGB32);
        for (int row = 0; row < gradientRows; ++row) {
            uchar *scanLine = gradients.scanLine(row);
            memset(scanLine, row * 17, gradientColumns * sizeof(QRgb));
            QRgb *pixel = reinterpret_cast<QRgb*>(scanLine);
            for (int i = 0; i < 3; i++)
                pixel[i] &= (0xff000000 | (0xff << (i * 8)));
        }
        QRect leftRect(QPoint(), size);
        leftRect.setWidth(leftRect.width() / 2);
        p.drawImage(leftRect, gradients);
        const QRect rightRect = leftRect.translated(leftRect.width(), 0);
        p.drawImage(rightRect, gradients.mirrored(false, true));
    }

    static void paintMode4(QPainter &p, const QSize &size)
    {
        const int segmentsCount = 4;
        const int segmentWidth = size.width() / segmentsCount;
        const int segmentHeight = size.height() / segmentsCount;
        p.fillRect(QRect(QPoint(), size), Qt::white);
        p.setPen(QPen(Qt::black, 2));
        for (int i = 1; i < segmentsCount; i++) {
            const int x = segmentWidth * i;
            const int y = segmentHeight * i;
            p.drawLine(x, 0, x, size.height());
            p.drawLine(0, y, size.width(), y);
        }
    }

    static void dumpImages(const QSize &size)
    {
        for (int i = 0; i < PhoneScreenCalibr8::m_modesCount; ++i) {
            QImage img(size, QImage::Format_RGB32);
            QPainter p(&img);
            PhoneScreenCalibr8::m_modes[i].function(p, img.size());
            img.save(QString::fromLatin1("calibrate_%1_%2_%3.png")
                    .arg(size.width()).arg(size.height())
                    .arg(PhoneScreenCalibr8::m_modes[i].name));
        }
    }

protected:
    void nextMode()
    {
        setMode((m_currentMode + 1) % m_modesCount);
    }

    void keyPressEvent(QKeyEvent *event)
    {
        Q_UNUSED(event);
        nextMode();
    }

    void mousePressEvent(QMouseEvent *event)
    {
        Q_UNUSED(event);
        nextMode();
    }

private slots:
    void setMode(int index)
    {
        m_currentMode = index;
        update();
    }

private:
    static const struct mode m_modes[];
    static const int m_modesCount;
    int m_currentMode;
};

const struct mode PhoneScreenCalibr8::m_modes[] = {
    {QLatin1String("Focus"), PhoneScreenCalibr8::paintMode1},
    {QLatin1String("White balance"), PhoneScreenCalibr8::paintMode2},
    {QLatin1String("Exposure"), PhoneScreenCalibr8::paintMode3},
    {QLatin1String("Alignment"), PhoneScreenCalibr8::paintMode4}
};

const int PhoneScreenCalibr8::m_modesCount =
    (int)(sizeof(PhoneScreenCalibr8::m_modes) / sizeof(PhoneScreenCalibr8::m_modes[0]));

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    PhoneScreenCalibr8 dlg;
#ifdef Q_WS_S60
    dlg.showFullScreen();
#else
    dlg.show();
#endif

#if 0
    PhoneScreenCalibr8::dumpImages(QSize(640, 360));
    PhoneScreenCalibr8::dumpImages(QSize(360, 640));
#endif

    return a.exec();
}

#include "main.moc"
