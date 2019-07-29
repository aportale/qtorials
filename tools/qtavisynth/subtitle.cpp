#include "subtitle.h"
#include "filters.h"
#include "tools.h"
#include "rgboverlay.h"
#include <QImage>
#include <QPainter>
#include <QSequentialAnimationGroup>
#include <QPropertyAnimation>

class SubtitleProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal slip READ slip WRITE setSlip)
    Q_PROPERTY(qreal blend READ blend WRITE setBlend)

public:
    SubtitleProperties(QObject *parent = nullptr);
    qreal slip() const;
    void setSlip(qreal slip);
    qreal blend() const;
    void setBlend(qreal blend);

    static const QByteArray slipPropertyName;
    static const QByteArray blendPropertyName;

protected:
    qreal m_slip = 0.0;
    qreal m_blend = 0.0;
};

const QByteArray SubtitleProperties::slipPropertyName = "slip";
const QByteArray SubtitleProperties::blendPropertyName = "blend";
const int Subtitle::m_slipFrames = 10;
const int Subtitle::m_blendDelayFrames = 6;
const int Subtitle::m_blendFrames = 8;

SubtitleProperties::SubtitleProperties(QObject *parent)
    : QObject(parent)
{
}

qreal SubtitleProperties::slip() const
{
    return m_slip;
}

void SubtitleProperties::setSlip(qreal slip)
{
    m_slip = slip;
}

qreal SubtitleProperties::blend() const
{
    return m_blend;
}

void SubtitleProperties::setBlend(qreal blend)
{
    m_blend = blend;
}

Subtitle::Subtitle(const VideoInfo &backgroundVideoInfo,
                   const QString &title, const QString &subtitle,
                   int startFrame, int endFrame)
    : m_videoInfo(backgroundVideoInfo)
    , m_title(title)
    , m_subtitle(subtitle)
{
    m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

    m_properties = new SubtitleProperties(&m_titleAnimations);
    auto *slipSequence = new QSequentialAnimationGroup;
    auto *blendSequence = new QSequentialAnimationGroup;

    const struct Animation {
        QSequentialAnimationGroup *sequence;
        const QByteArray &propertyName;
        int pauseBefore;
        int duration;
        qreal startValue;
        qreal endValue;
    } animations[] = {
        { slipSequence, SubtitleProperties::slipPropertyName, startFrame, m_slipFrames, 0.0, 1.0 },
        { slipSequence, SubtitleProperties::slipPropertyName, endFrame - startFrame - 2*m_slipFrames, m_slipFrames, 1.0, 0.0 },
        { blendSequence, SubtitleProperties::blendPropertyName, startFrame + m_blendDelayFrames, m_blendFrames, 0.0, 1.0 },
        { blendSequence, SubtitleProperties::blendPropertyName, endFrame - startFrame - 2*m_blendDelayFrames - 2*m_blendFrames, m_blendFrames, 1.0, 0.0 },
    };

    for (const auto & a : animations) {
        a.sequence->addPause(a.pauseBefore);
        auto *animation =
                new QPropertyAnimation(m_properties, a.propertyName);
        animation->setDuration(a.duration);
        animation->setStartValue(a.startValue);
        animation->setEndValue(a.endValue);
        animation->setEasingCurve(QEasingCurve::InOutQuad);
        a.sequence->addAnimation(animation);
    }

    slipSequence->addPause(m_videoInfo.num_frames - slipSequence->duration());
    blendSequence->addPause(m_videoInfo.num_frames - blendSequence->duration());
    m_titleAnimations.addAnimation(slipSequence);
    m_titleAnimations.addAnimation(blendSequence);

    m_titleAnimations.start();
    m_titleAnimations.pause();
}

PVideoFrame __stdcall Subtitle::GetFrame(int n, IScriptEnvironment* env)
{
    PVideoFrame frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    m_titleAnimations.setCurrentTime(n);
    Filters::paintAnimatedSubTitle(
            &p, m_title, m_subtitle,
            m_properties->slip(), m_properties->blend(),
            image.rect());
    return frame;
}

AVSValue __cdecl Subtitle::CreateSubtitle(AVSValue args, void* user_data,
                                          IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const QString title = QLatin1String(args[1].AsString("Title"));
    const QString subtitle = QLatin1String(args[2].AsString());
    const int start = args[3].AsInt(10);
    const int end = args[4].AsInt(30);
    const PClip subtitleClip =
            new Subtitle(background->GetVideoInfo(), title, subtitle, start, end);
    return new RgbOverlay(background, subtitleClip, env);
}

bool __stdcall Subtitle::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall Subtitle::GetVideoInfo()
{
    return m_videoInfo;
}

int __stdcall Subtitle::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
    return 0;
}

void __stdcall Subtitle::GetAudio(void* buf, __int64 start, __int64 count,
                                  IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}

#include "subtitle.moc"
