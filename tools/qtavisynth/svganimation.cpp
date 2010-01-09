#include "svganimation.h"
#include "filters.h"
#include "tools.h"
#include "rgboverlay.h"

SvgAnimationProperties::SvgAnimationProperties(const Data &data, QObject *parent)
    : QObject(parent)
    , m_data(data)
    , m_scale(scaleStart)
    , m_opacity(opacityStart)
{
}

QString SvgAnimationProperties::svgElement() const
{
    return m_data.svgElement;
}

qreal SvgAnimationProperties::scale() const
{
    return m_scale;
}

void SvgAnimationProperties::setScale(qreal scale)
{
    m_scale = scale;
}

qreal SvgAnimationProperties::opacity() const
{
    return m_opacity;
}

void SvgAnimationProperties::setOpacity(qreal opacity)
{
    m_opacity = opacity;
}

SvgAnimationProperties::Blending SvgAnimationProperties::findBlendingOrThrow(
        const char *blendingKey, IScriptEnvironment* env)
{
    static const int enumIndex = staticMetaObject.indexOfEnumerator("Blending");
    Q_ASSERT(enumIndex != -1);
    static const QMetaEnum &blendEnum = staticMetaObject.enumerator(enumIndex);
    const int blending = blendEnum.keysToValue(blendingKey);
    if (blending == -1)
        env->ThrowError("QtorialsSvgAnimation: Invalid blending type '%s'.",
                        blendingKey);
    return Blending(blending);
}

const QByteArray SvgAnimationProperties::scalePropertyName = "scale";
const QByteArray SvgAnimationProperties::opacityPropertyName = "opacity";

const int SvgAnimationProperties::scaleDuration = 5;
const qreal SvgAnimationProperties::scaleStart = 0.2;
const qreal SvgAnimationProperties::scaleEnd = 1.0;
const int SvgAnimationProperties::opacityDuration = SvgAnimationProperties::scaleDuration;
const qreal SvgAnimationProperties::opacityStart = 0.0;
const qreal SvgAnimationProperties::opacityEnd = 1.0;

SvgAnimation::SvgAnimation(const VideoInfo &videoInfo, const QString &svgFile,
                           const QList<SvgAnimationProperties::Data> &dataSets)
    : m_videoInfo(videoInfo)
    , m_svgFile(svgFile)
{
    m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

    foreach(const SvgAnimationProperties::Data &dataSet, dataSets) {
        SvgAnimationProperties *properties =
                new SvgAnimationProperties(dataSet, &m_animation);
        m_properties.append(properties);

        QSequentialAnimationGroup *scaleSequence = new QSequentialAnimationGroup;
        QSequentialAnimationGroup *opacitySequence = new QSequentialAnimationGroup;
        QEasingCurve scaleInEasingCurve(QEasingCurve::OutBack);
        scaleInEasingCurve.setOvershoot(2.5);

        const bool immediateIn =
                (dataSet.blendingIn == SvgAnimationProperties::immediate);
        const bool immediateOut =
                (dataSet.blendingOut == SvgAnimationProperties::immediate);
        const struct Animation {
            QSequentialAnimationGroup *sequence;
            const QByteArray &propertyName;
            int pauseBefore;
            int duration;
            QEasingCurve easingCurve;
            qreal startValue;
            qreal endValue;
        } animations[] = {
            {
                scaleSequence,
                SvgAnimationProperties::scalePropertyName,
                dataSet.startFrame - SvgAnimationProperties::scaleDuration,
                SvgAnimationProperties::scaleDuration,
                scaleInEasingCurve,
                (dataSet.blendingIn == SvgAnimationProperties::fadeandscale) ?
                     SvgAnimationProperties::scaleStart : SvgAnimationProperties::scaleEnd,
                SvgAnimationProperties::scaleEnd
            }, {
                scaleSequence,
                SvgAnimationProperties::scalePropertyName,
                dataSet.endFrame - dataSet.startFrame,
                SvgAnimationProperties::scaleDuration,
                QEasingCurve::InCubic,
                SvgAnimationProperties::scaleEnd,
                (dataSet.blendingOut == SvgAnimationProperties::fadeandscale) ?
                     SvgAnimationProperties::scaleStart : SvgAnimationProperties::scaleEnd
            }, {
                opacitySequence,
                SvgAnimationProperties::opacityPropertyName,
                dataSet.startFrame - (immediateIn ? 1 : SvgAnimationProperties::opacityDuration),
                (immediateIn ? 1 : SvgAnimationProperties::opacityDuration),
                QEasingCurve::Linear,
                SvgAnimationProperties::opacityStart,
                SvgAnimationProperties::opacityEnd
            }, {
                opacitySequence,
                SvgAnimationProperties::opacityPropertyName,
                dataSet.endFrame - dataSet.startFrame,
                (immediateOut ? 1 : SvgAnimationProperties::opacityDuration),
                QEasingCurve::Linear,
                SvgAnimationProperties::opacityEnd,
                SvgAnimationProperties::opacityStart,
            }
        };

        for (int i = 0; i < int(sizeof animations / sizeof animations[0]); ++i) {
            const struct Animation &a = animations[i];
            a.sequence->addPause(a.pauseBefore);
            QPropertyAnimation *animation =
                    new QPropertyAnimation(properties, a.propertyName);
            animation->setDuration(a.duration);
            animation->setEasingCurve(a.easingCurve);
            animation->setStartValue(a.startValue);
            animation->setEndValue(a.endValue);
            a.sequence->addAnimation(animation);
        }

        scaleSequence->addPause(m_videoInfo.num_frames - scaleSequence->duration());
        opacitySequence->addPause(m_videoInfo.num_frames - opacitySequence->duration());

        m_animation.addAnimation(scaleSequence);
        m_animation.addAnimation(opacitySequence);
    }

    m_animation.start();
    m_animation.pause();
}

PVideoFrame __stdcall SvgAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(env)
    PVideoFrame frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    m_animation.setCurrentTime(n);
    foreach (const SvgAnimationProperties *properties, m_properties) {
        if (properties->opacity() > SvgAnimationProperties::opacityStart)
            Filters::paintBlendedSvgElement(
                    &p,
                    m_svgFile,
                    properties->svgElement(),
                    properties->opacity(),
                    properties->scale(),
                    image.rect()
                    );
    }

    return frame;
}

AVSValue __cdecl SvgAnimation::CreateSvgAnimation(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const QString svgFileName =
            Tools::cleanFileName(QLatin1String(args[1].AsString()));
    const AVSValue &detailValues = args[2];
    static const int valuesPerDetail = 5;
    if (detailValues.ArraySize() % valuesPerDetail != 0)
        env->ThrowError("QtorialsSvgAnimation: Mismatching number of arguments.\n"
                        "They need to be %d per keyframe.", valuesPerDetail);

    QList<SvgAnimationProperties::Data> details;
    for (int i = 0; i < detailValues.ArraySize(); i += valuesPerDetail) {
        const SvgAnimationProperties::Data animationDetail = {
            QLatin1String(detailValues[i].AsString()),
            detailValues[i+1].AsInt(),
            detailValues[i+2].AsInt(),
            SvgAnimationProperties::findBlendingOrThrow(detailValues[i+3].AsString(), env),
            SvgAnimationProperties::findBlendingOrThrow(detailValues[i+4].AsString(), env)
        };
        Tools::checkSvgAndThrow(svgFileName, animationDetail.svgElement, env);
        details.append(animationDetail);
    }

    const PClip svgAnimation =
            new SvgAnimation(background->GetVideoInfo(), svgFileName, details);
    return new RgbOverlay(background, svgAnimation, env);
}

bool __stdcall SvgAnimation::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall SvgAnimation::GetVideoInfo()
{
    return m_videoInfo;
}

void __stdcall SvgAnimation::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
}

void __stdcall SvgAnimation::GetAudio(void* buf, __int64 start, __int64 count,
                                      IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}
