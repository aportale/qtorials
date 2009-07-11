#include <QtGui>

struct mode{
    QString name;
    void (*function)(QPainter &, const QSize&);
};

static const char* const focusPattern[] = {
"26 16 2 1",
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
        p.scale(size.width(), size.height());

        const qreal gradientWidth = qreal(1) / 12;
        QLinearGradient gradient(QPoint(), QPoint(0, 1));

        gradient.setColorAt(0, Qt::black);
        gradient.setColorAt(1, Qt::red);
        p.fillRect(QRectF(0 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(1, Qt::green);
        p.fillRect(QRectF(2 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(1, Qt::blue);
        p.fillRect(QRectF(4 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(1, Qt::white);
        p.fillRect(QRectF(6 * gradientWidth, 0, 3*gradientWidth, 1), gradient);

        gradient.setColorAt(1, Qt::black);
        gradient.setColorAt(0, Qt::red);
        p.fillRect(QRectF(1 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(0, Qt::green);
        p.fillRect(QRectF(3 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(0, Qt::blue);
        p.fillRect(QRectF(5 * gradientWidth, 0, gradientWidth, 1), gradient);
        gradient.setColorAt(0, Qt::white);
        p.fillRect(QRectF(9 * gradientWidth, 0, 3*gradientWidth, 1), gradient);

        p.resetMatrix();
        p.setOpacity(0.1);

        const int stripeThickness = 5;
        const int stripeEveryNth = 4;
        const int stripesCount = size.height() / (stripeEveryNth * stripeThickness);
        const QBrush brush(qRgb(128, 128, 128));
        for (int i = 0; i < stripesCount; i++)
            p.fillRect(0, stripeThickness * i * stripeEveryNth,
                size.width(), stripeThickness, brush);
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

    return a.exec();
}

#include "main.moc"
