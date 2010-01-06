#include "zoomnpan.h"
#include "filters.h"
#include "tools.h"

class ZoomNPanProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRectF rect READ rect WRITE setRect);

public:
    ZoomNPanProperties(QObject *parent = 0);
    QRectF rect() const;
    void setRect(const QRectF &rect);
    static const QByteArray propertyName;

protected:
    QRectF m_rect;
};

const QByteArray ZoomNPanProperties::propertyName = "rect";
const int ZoomNPan::m_extensionWidth = 16;

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

ZoomNPan::ZoomNPan(PClip originClip, int width, int height,
                   int extensionColor, int defaultTransitionLength, const char *resizeFilter,
                   const QRectF &startDetail, const QList<Detail> &details,
                   IScriptEnvironment* env)
    : m_targetVideoInfo(originClip->GetVideoInfo())
    , m_resizeFilter(resizeFilter)
    , m_extendedClip(extendedClip(originClip, extensionColor, env))
{
    m_animationProperties = new ZoomNPanProperties(&m_animation);
    m_targetVideoInfo.width = width;
    m_targetVideoInfo.height = height;

    Detail previousDetail = { 0, 0, QRectF() };

    {
        QPropertyAnimation *start =
                new QPropertyAnimation(m_animationProperties, ZoomNPanProperties::propertyName);
        start->setDuration(0);
        previousDetail.detail =
                fixedDetailRect(originClip->GetVideoInfo(), QSize(width, height), startDetail);
        start->setStartValue(previousDetail.detail);
        start->setEndValue(previousDetail.detail);
        m_animation.addAnimation(start);
    }

    foreach (const Detail &detail, details) {
        const QRectF detailRect =
                fixedDetailRect(originClip->GetVideoInfo(), QSize(width, height), detail.detail);
        const int transitionLength =
                detail.transitionLength > -1 ? detail.transitionLength : defaultTransitionLength;
        const int pauseLength = detail.keyFrame - transitionLength - previousDetail.keyFrame;
        if (pauseLength > 0)
            m_animation.addPause(pauseLength);
        QPropertyAnimation *rectAnimation =
                new QPropertyAnimation(m_animationProperties, ZoomNPanProperties::propertyName);
        rectAnimation->setDuration(transitionLength);
        rectAnimation->setStartValue(previousDetail.detail);
        rectAnimation->setEndValue(detailRect);
        rectAnimation->setEasingCurve(QEasingCurve::InOutQuad);
        m_animation.addAnimation(rectAnimation);

        previousDetail.keyFrame = detail.keyFrame;
        previousDetail.detail = detailRect;
    }

    m_animation.addPause(m_targetVideoInfo.num_frames - previousDetail.keyFrame);

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
        const int target_width = m_targetVideoInfo.width;
        const int target_height = m_targetVideoInfo.height;
        if (rect.size() == QSizeF(target_width, target_height))
            rect = rect.toRect(); // If native resolution, do not offset at fraction coordinate.
        const float src_left = rect.left();
        const float src_top = rect.top();
        const float src_width = rect.width();
        const float src_height = rect.height();
        const AVSValue resizedParams[] = { m_extendedClip, target_width, target_height, src_left, src_top, src_width, src_height };
        m_resizedClip = env->Invoke( m_resizeFilter, AVSValue(resizedParams, sizeof resizedParams / sizeof resizedParams[0])).AsClip();
    }
    return m_resizedClip->GetFrame(n, env);
}

AVSValue __cdecl ZoomNPan::CreateZoomNPan(AVSValue args, void* user_data,
                                          IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    static const int valuesPerDetail = 6;

    if (!env->FunctionExists(args[5].AsString()))
        env->ThrowError("QtorialsZoomNPan: Invalid resize filter '%s'.", args[5].AsString());

    const AVSValue &detailValues = args[10];
    if (detailValues.ArraySize() % valuesPerDetail != 0)
        env->ThrowError("QtorialsZoomNPan: Mismatching number of arguments.\n"
                        "They need to be %d per detail.", valuesPerDetail);

    const QRectF start(args[6].AsInt(), args[7].AsInt(), args[8].AsInt(), args[9].AsInt());

    QList<Detail> details;
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
                        args[3].AsInt(0xffffff),
                        args[4].AsInt(15),
                        args[5].AsString(),
                        start,
                        details,
                        env);
}

const PClip ZoomNPan::extendedClip(const PClip &originClip, int extensionColor, IScriptEnvironment* env)
{
    const AVSValue extensionParams[] =
        { originClip, m_extensionWidth, m_extensionWidth, m_extensionWidth, m_extensionWidth, extensionColor };
    return env->Invoke("AddBorders",
                       AVSValue(extensionParams, sizeof extensionParams / sizeof extensionParams[0])).AsClip();
}

QRectF ZoomNPan::fixedDetailRect(const VideoInfo &originVideoInfo,
                                 const QSize &detailClipSize,
                                 const QRectF &specifiedDetailRect)
{
    QRectF result = specifiedDetailRect;
    if (result.left() == -1 || result.top() == -1) {
        // Fullscreen
        QSizeF zoomNPanSize(detailClipSize);
        zoomNPanSize.scale(originVideoInfo.width, originVideoInfo.height,
                           Qt::KeepAspectRatioByExpanding);
        result.setSize(zoomNPanSize);
        result.moveLeft((originVideoInfo.width - result.width()) / 2);
        result.moveTop((originVideoInfo.height - result.height()) / 2);
    } else if (result.width() == -1 || result.height() == -1) {
        // Native resolution
        result.setSize(detailClipSize);
    }
    return result.translated(m_extensionWidth, m_extensionWidth);
}

bool __stdcall ZoomNPan::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall ZoomNPan::GetVideoInfo()
{
    return m_targetVideoInfo;
}

void __stdcall ZoomNPan::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
}

void __stdcall ZoomNPan::GetAudio(void* buf, __int64 start, __int64 count,
                                  IScriptEnvironment* env)
{
    m_extendedClip->GetAudio(buf, start, count, env);
}

#include "zoomnpan.moc"
