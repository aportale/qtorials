#include "filters.h"
#include "svganimation.h"
#include "tools.h"

SvgAnimationProperties::SvgAnimationProperties(const Data &data, QObject *parent)
    : QObject(parent)
    , m_data(data)
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
        env->ThrowError("QtAviSynthSvgAnimation: Invalid blending type '%s'.", blendingKey);
    return Blending(blending);
}

const QByteArray SvgAnimationProperties::scalePropertyName = "scale";
const QByteArray SvgAnimationProperties::opacityPropertyName = "opacity";

SvgAnimation::SvgAnimation(const QString &svgFile,
                           const QVector<SvgAnimationProperties::Data> &dataSets, double fps,
                           const QSize &size, IScriptEnvironment* env)
    : m_svgFile(svgFile)
{
    m_properties.reserve(dataSets.size());
    int longestAnimationDuration = 0;
    const int maxTransformDuration =
            qMax(SvgAnimationProperties::scaleDuration, SvgAnimationProperties::opacityDuration);
    for (const SvgAnimationProperties::Data &dataSet : dataSets) {
        auto *properties =
                new SvgAnimationProperties(dataSet, &m_animation);
        m_properties.append(properties);

        auto *scaleSequence = new QSequentialAnimationGroup;
        auto *opacitySequence = new QSequentialAnimationGroup;
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

        for (const auto & a : animations) {
            a.sequence->addPause(a.pauseBefore);
            auto *animation =
                    new QPropertyAnimation(properties, a.propertyName);
            animation->setDuration(a.duration);
            animation->setEasingCurve(a.easingCurve);
            animation->setStartValue(a.startValue);
            animation->setEndValue(a.endValue);
            a.sequence->addAnimation(animation);
        }
        longestAnimationDuration =
                qMax(longestAnimationDuration, dataSet.endFrame + maxTransformDuration);

        scaleSequence->addPause(m_vi.num_frames - scaleSequence->duration());
        opacitySequence->addPause(m_vi.num_frames - opacitySequence->duration());

        m_animation.addAnimation(scaleSequence);
        m_animation.addAnimation(opacitySequence);
    }

    m_animation.start();
    m_animation.pause();

    setFps(fps, env);
    setSize(size.isValid() ? size : Filters::svgViewBoxSize(m_svgFile).toSize());
    m_vi.num_frames = longestAnimationDuration;
}

PVideoFrame __stdcall SvgAnimation::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(env)
    PVideoFrame frame = env->NewVideoFrame(m_vi);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, m_vi.width, m_vi.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    m_animation.setCurrentTime(n);
    for (const SvgAnimationProperties *properties : qAsConst(m_properties)) {
        if (properties->opacity() > SvgAnimationProperties::opacityStart) {
            Filters::paintBlendedSvgElement(
                    &p,
                    m_svgFile,
                    properties->svgElement(),
                    properties->opacity(),
                    properties->scale(),
                    image.rect()
                    );
        }
    }

    return frame;
}

AVSValue __cdecl SvgAnimation::CreateSvgAnimation(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].ArraySize() == 1 ? args[0][0].AsClip() : PClip();
    const VideoInfo backGroundVi = background ? background->GetVideoInfo() : defaultVi();
    const QString svgFileName =
            Tools::cleanFileName(QLatin1String(args[1].AsString()));
    const double fps = background
            ? double(backGroundVi.fps_numerator) / backGroundVi.fps_denominator
            : args[2].AsFloat(30);
    const QSize size = background
            ? QSize(backGroundVi.width, backGroundVi.height)
            : QSize();
    const AVSValue &detailValues = args[3];
    static const int valuesPerDetail = 5;
    if (detailValues.ArraySize() % valuesPerDetail != 0) {
        env->ThrowError("QtAviSynthSvgAnimation: Mismatching number of arguments.\n"
                        "They need to be %d per keyframe.", valuesPerDetail);
    }

    QVector<SvgAnimationProperties::Data> details;
    details.reserve(detailValues.ArraySize() / valuesPerDetail);
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

    const PClip svgAnimation = new SvgAnimation(svgFileName, details, fps, size, env);
    return Tools::rgbOverlay(background, svgAnimation, env);
}
