#include "zoomnpan.h"
#include "filters.h"
#include "tools.h"

class ZoomNPanProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRectF rect READ rect WRITE setRect)

public:
    explicit ZoomNPanProperties(QObject *parent = nullptr);

    QRectF rect() const;
    void setRect(const QRectF &rect);
    static const QByteArray propertyName;

private:
    QRectF m_rect;
};

const QByteArray ZoomNPanProperties::propertyName = "rect";

ZoomNPanProperties::ZoomNPanProperties(QObject *parent)
    : QObject(parent)
{
}

QRectF ZoomNPanProperties::rect() const
{
    return m_rect;
}

void ZoomNPanProperties::setRect(const QRectF &rect)
{
    m_rect = rect;
}

ZoomNPan::ZoomNPan(const PClip &originClip, int width, int height,
                   int defaultTransitionLength, const char *resizeFilter,
                   const QRectF &startDetail, const QVector<Detail> &details)
    : GenericVideoFilter(originClip)
    , m_resizeFilter(resizeFilter)
{
    m_animationProperties = new ZoomNPanProperties(&m_animation);
    vi.width = width;
    vi.height = height;

    Detail previousDetail = { 0, 0, {} };

    {
        auto *start =
                new QPropertyAnimation(m_animationProperties, ZoomNPanProperties::propertyName);
        start->setDuration(0);
        previousDetail.detail =
                fixedDetailRect(originClip->GetVideoInfo(), QSize(width, height), startDetail);
        start->setStartValue(previousDetail.detail);
        start->setEndValue(previousDetail.detail);
        m_animation.addAnimation(start);
    }

    for (const Detail &detail : details) {
        const QRectF detailRect =
                fixedDetailRect(originClip->GetVideoInfo(), QSize(width, height), detail.detail);
        const int transitionLength =
                detail.transitionLength > -1 ? detail.transitionLength : defaultTransitionLength;
        const int pauseLength = detail.keyFrame - transitionLength - previousDetail.keyFrame;
        if (pauseLength > 0)
            m_animation.addPause(pauseLength);
        auto *rectAnimation =
                new QPropertyAnimation(m_animationProperties, ZoomNPanProperties::propertyName);
        rectAnimation->setDuration(transitionLength);
        rectAnimation->setStartValue(previousDetail.detail);
        rectAnimation->setEndValue(detailRect);
        rectAnimation->setEasingCurve(QEasingCurve::InOutQuad);
        m_animation.addAnimation(rectAnimation);

        previousDetail.keyFrame = detail.keyFrame;
        previousDetail.detail = detailRect;
    }

    m_animation.addPause(vi.num_frames - previousDetail.keyFrame);

    m_animation.start();
    m_animation.pause();
}

PVideoFrame __stdcall ZoomNPan::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(env)
    m_animation.setCurrentTime(n);
    QRectF rect = m_animationProperties->rect();
    if (rect != m_resizedRect) {
        m_resizedRect = rect;
        const int target_width = vi.width;
        const int target_height = vi.height;
        if (rect.size() == QSizeF(target_width, target_height))
            rect = rect.toRect(); // If native resolution, do not offset at fraction coordinate.
        const qreal src_left = rect.left();
        const qreal src_top = rect.top();
        const qreal src_width = rect.width();
        const qreal src_height = rect.height();
        const AVSValue resizedParams[] = { child, target_width, target_height, src_left, src_top, src_width, src_height };
        m_resizedClip = env->Invoke( m_resizeFilter, AVSValue(resizedParams, sizeof resizedParams / sizeof resizedParams[0])).AsClip();
    }
    return m_resizedClip->GetFrame(n, env);
}

AVSValue __cdecl ZoomNPan::CreateZoomNPan(AVSValue args, void* user_data,
                                          IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    static const int valuesPerDetail = 6;

    if (!env->FunctionExists(args[4].AsString()))
        env->ThrowError("QtAviSynthZoomNPan: Invalid resize filter '%s'.", args[4].AsString());

    const AVSValue &detailValues = args[9];
    if (detailValues.ArraySize() % valuesPerDetail != 0)
        env->ThrowError("QtAviSynthZoomNPan: Mismatching number of arguments.\n"
                        "They need to be %d per detail.", valuesPerDetail);

    const QRectF start(args[5].AsInt(), args[6].AsInt(), args[7].AsInt(), args[8].AsInt());

    QVector<Detail> details;
    details.reserve(detailValues.ArraySize() / valuesPerDetail);
    for (int i = 0; i < detailValues.ArraySize(); i += valuesPerDetail) {
        const int keyFrame = detailValues[i+0].AsInt();
        const int transitionLength = detailValues[i+1].AsInt();
        const QRectF rect(detailValues[i+2].AsFloat(), detailValues[i+3].AsFloat(),
                          detailValues[i+4].AsFloat(), detailValues[i+5].AsFloat());
        const Detail detail = { keyFrame, transitionLength, rect };
        details.append(detail);
    }

    return new ZoomNPan(args[0].AsClip(),
                        args[1].AsInt(Tools::defaultClipWidth),
                        args[2].AsInt(Tools::defaultClipHeight),
                        args[3].AsInt(15),
                        args[4].AsString(),
                        start,
                        details);
}

QRectF ZoomNPan::fixedDetailRect(const VideoInfo &originVideoInfo,
                                 const QSize &detailClipSize,
                                 const QRectF &specifiedDetailRect)
{
    QRectF result = specifiedDetailRect;
    if (qFuzzyCompare(result.left(), -1) || qFuzzyCompare(result.top(), -1)) {
        // Fullscreen
        QSizeF zoomNPanSize(detailClipSize);
        zoomNPanSize.scale(originVideoInfo.width, originVideoInfo.height,
                           Qt::KeepAspectRatioByExpanding);
        result.setSize(zoomNPanSize);
        result.moveLeft((originVideoInfo.width - result.width()) / 2);
        result.moveTop((originVideoInfo.height - result.height()) / 2);
    } else if (qFuzzyCompare(result.width(), -1) || qFuzzyCompare(result.height(), -1)) {
        // Native resolution
        result.setSize(detailClipSize);
    }
    return result;
}

#include "zoomnpan.moc"
