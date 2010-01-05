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
    Q_PROPERTY(qreal slip READ slip WRITE setSlip);
    Q_PROPERTY(qreal blend READ blend WRITE setBlend);

public:

    SubtitleProperties(const Subtitle::Data &data);
    QString title() const;
    QString subTitle() const;
    qreal slip() const;
    void setSlip(qreal slip);
    qreal blend() const;
    void setBlend(qreal blend);

    static const QByteArray slipPropertyName;
    static const QByteArray blendPropertyName;

protected:
    Subtitle::Data m_subtitleData;
    qreal m_slip;
    qreal m_blend;
};

const QByteArray SubtitleProperties::slipPropertyName = "slip";
const QByteArray SubtitleProperties::blendPropertyName = "blend";
const int Subtitle::m_slipFrames = 10;
const int Subtitle::m_blendDelayFrames = 6;
const int Subtitle::m_blendFrames = 8;

SubtitleProperties::SubtitleProperties(const Subtitle::Data &data)
    : QObject()
    , m_subtitleData(data)
    , m_slip(0.0)
    , m_blend(0.0)
{
}

QString SubtitleProperties::title() const
{
    return m_subtitleData.title;
}

QString SubtitleProperties::subTitle() const
{
    return m_subtitleData.subtitle;
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
                   const QList<Data> &titles,
                   IScriptEnvironment* env)
    : m_videoInfo(backgroundVideoInfo)
{
    Q_UNUSED(env)

    m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

    foreach (const Data &data, titles) {
        SubtitleProperties *properties = new SubtitleProperties(data);
        QSequentialAnimationGroup *slipSequence = new QSequentialAnimationGroup;
        QSequentialAnimationGroup *blendSequence = new QSequentialAnimationGroup;

        const struct Animation {
            QSequentialAnimationGroup *sequence;
            const QByteArray &propertyName;
            int pauseBefore;
            int duration;
            qreal startValue;
            qreal endValue;
        } animations[] = {
            { slipSequence, SubtitleProperties::slipPropertyName, data.startFrame, m_slipFrames, 0.0, 1.0 },
            { slipSequence, SubtitleProperties::slipPropertyName, data.endFrame - data.startFrame - 2*m_slipFrames, m_slipFrames, 1.0, 0.0 },
            { blendSequence, SubtitleProperties::blendPropertyName, data.startFrame + m_blendDelayFrames, m_blendFrames, 0.0, 1.0 },
            { blendSequence, SubtitleProperties::blendPropertyName, data.endFrame - data.startFrame - 2*m_blendDelayFrames - 2*m_blendFrames, m_blendFrames, 1.0, 0.0 },
        };

        for (int i = 0; i < int(sizeof animations / sizeof animations[0]); ++i) {
            const struct Animation &a = animations[i];
            a.sequence->addPause(a.pauseBefore);
            QPropertyAnimation *animation =
                    new QPropertyAnimation(properties, a.propertyName);
            animation->setDuration(a.duration);
            animation->setStartValue(a.startValue);
            animation->setEndValue(a.endValue);
            animation->setEasingCurve(QEasingCurve::InOutQuad);
            a.sequence->addAnimation(animation);
        }

        slipSequence->addPause(100000);
        blendSequence->addPause(100000);
        m_titleAnimations.addAnimation(slipSequence);
        m_titleAnimations.addAnimation(blendSequence);

        m_titleData.append(properties);
    }
    m_titleAnimations.start();
    m_titleAnimations.pause();
}

Subtitle::~Subtitle()
{
    qDeleteAll(m_titleData);
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
    foreach (const SubtitleProperties *titleData, m_titleData) {
        Filters::paintAnimatedSubTitle(
                &p, titleData->title(), titleData->subTitle(),
                titleData->slip(), titleData->blend(),
                image.rect());
    }
    return frame;
}

AVSValue __cdecl Subtitle::CreateSubtitle(AVSValue args, void* user_data,
                                          IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    static const int valuesPerTitle = 4;

    const AVSValue &titleValues = args[1];
    if (titleValues.ArraySize() % valuesPerTitle != 0)
        env->ThrowError("QtorialsSubtitle: Mismatching number of arguments.\nThe title arguments must be dividable by 4.");

    QList<Data> titles;
    for (int i = 0; i < titleValues.ArraySize(); i += valuesPerTitle) {
        if (!(titleValues[i].IsString() && titleValues[i+1].IsString()
              && titleValues[i+2].IsInt() && titleValues[i+3].IsInt()))
            env->ThrowError("QtorialsSubtitle: Wrong title argument data types in title set %i.",
                            i / valuesPerTitle + 1);
        const Data title = {
            QLatin1String(titleValues[i].AsString()),
            QLatin1String(titleValues[i+1].AsString()),
            titleValues[i+2].AsInt(),
            titleValues[i+3].AsInt()};
        titles.append(title);
    }
    PClip background = args[0].AsClip();
    PClip subtitle = new Subtitle(background->GetVideoInfo(), titles, env);
    return new RgbOverlay(background, subtitle, env);
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

void __stdcall Subtitle::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
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
