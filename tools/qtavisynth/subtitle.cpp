#include "filters.h"
#include "subtitle.h"
#include "tools.h"

#include <QImage>
#include <QPainter>
#include <QPropertyAnimation>
#include <QSequentialAnimationGroup>

const QByteArray SubtitleProperties::slipPropertyName = "slip";
const QByteArray SubtitleProperties::blendPropertyName = "blend";
const int Subtitle::m_slipFrames = 10;
const int Subtitle::m_blendDelayFrames = 6;
const int Subtitle::m_blendFrames = 8;

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

Subtitle::Subtitle(PClip background, const QString &title, const QString &subtitle,
                   int startFrame, int endFrame)
    : GenericVideoFilter(background)
    , m_title(title)
    , m_subtitle(subtitle)
{
    vi.pixel_type = VideoInfo::CS_BGR32;

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
        auto *animation = new QPropertyAnimation(&m_properties, a.propertyName);
        animation->setDuration(a.duration);
        animation->setStartValue(a.startValue);
        animation->setEndValue(a.endValue);
        animation->setEasingCurve(QEasingCurve::InOutQuad);
        a.sequence->addAnimation(animation);
    }

    slipSequence->addPause(vi.num_frames - slipSequence->duration());
    blendSequence->addPause(vi.num_frames - blendSequence->duration());
    m_titleAnimations.addAnimation(slipSequence);
    m_titleAnimations.addAnimation(blendSequence);

    m_titleAnimations.start();
    m_titleAnimations.pause();
}

PVideoFrame __stdcall Subtitle::GetFrame(int n, IScriptEnvironment* env)
{
    PVideoFrame frame = env->NewVideoFrame(vi);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, vi.width, vi.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    m_titleAnimations.setCurrentTime(n);
    Filters::paintAnimatedSubTitle(
            &p, m_title, m_subtitle,
            m_properties.slip(), m_properties.blend(),
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
    const PClip subtitleClip = new Subtitle(background, title, subtitle, start, end);
    return Tools::rgbOverlay(background, subtitleClip, env);
}
