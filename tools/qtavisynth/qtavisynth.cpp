/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "windows.h"
#include "avisynth.h"
#include "filters.h"
#include <QtGui>

#if !defined(QT_SHARED) && !defined(QT_DLL)
Q_IMPORT_PLUGIN(qgif)
Q_IMPORT_PLUGIN(qjpeg)
Q_IMPORT_PLUGIN(qtiff)
Q_IMPORT_PLUGIN(qsvg)
#endif

const int defaultClipWidth = 640;
const int defaultClipHeight = 480;
const QRgb transparentColor = qRgba(0x00, 0x00, 0x00, 0x00);

class QtorialsStillImage : public IClip
{
public:
    QtorialsStillImage(const QImage &image, int frames, IScriptEnvironment* env)
    {
        memset(&m_videoInfo, 0, sizeof(VideoInfo));
        m_videoInfo.width = image.width();
        m_videoInfo.height = image.height();
        m_videoInfo.fps_numerator = 25;
        m_videoInfo.fps_denominator = 1;
        m_videoInfo.num_frames = frames;
        m_videoInfo.pixel_type =
                (image.format() == QImage::Format_ARGB32
                    || image.format() == QImage::Format_ARGB32_Premultiplied) ?
                        VideoInfo::CS_BGR32 : VideoInfo::CS_BGR24;
        m_frame = env->NewVideoFrame(m_videoInfo);
        unsigned char* frameBits = m_frame->GetWritePtr();
        env->BitBlt(frameBits, m_frame->GetPitch(), image.mirrored(false, true).bits(), m_frame->GetPitch(), image.bytesPerLine(), image.height());
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) { Q_UNUSED(n) Q_UNUSED(env) return m_frame; }
    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    PVideoFrame m_frame;
    VideoInfo m_videoInfo;
};

struct SubtitleData
{
    QString title;
    QString subtitle;
    int startFrame;
    int endFrame;
};

class SubtitleProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal slip READ slip WRITE setSlip);
    Q_PROPERTY(qreal blend READ blend WRITE setBlend);

public:
    SubtitleProperties(const SubtitleData &data)
        : QObject()
        , m_subtitleData(data)
        , m_slip(0.0)
        , m_blend(0.0)
    {
    }

    QString title() const
    {
        return m_subtitleData.title;
    }

    QString subTitle() const
    {
        return m_subtitleData.subtitle;
    }

    qreal slip() const
    {
        return m_slip;
    }

    void setSlip(qreal slipin)
    {
        m_slip = slipin;
    }

    qreal blend() const
    {
        return m_blend;
    }

    void setBlend(qreal blendin)
    {
        m_blend = blendin;
    }

    static const QByteArray slipPropertyName;
    static const QByteArray blendPropertyName;

protected:
    SubtitleData m_subtitleData;
    qreal m_slip;
    qreal m_blend;
};

const QByteArray SubtitleProperties::slipPropertyName = "slip";
const QByteArray SubtitleProperties::blendPropertyName = "blend";

class QtorialsSubtitle : public IClip
{
public:
    QtorialsSubtitle(int width, int height,
                     const QList<SubtitleData> &titles,
                     IScriptEnvironment* env)
    {
        Q_UNUSED(env)

        memset(&m_videoInfo, 0, sizeof(VideoInfo));
        m_videoInfo.width = width;
        m_videoInfo.height = height;
        m_videoInfo.fps_numerator = 25;
        m_videoInfo.fps_denominator = 1;
        m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

        foreach (const SubtitleData &data, titles) {
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
            m_videoInfo.num_frames = qMax(data.endFrame + 1 // +1, so that we have a clear frame at the end
                                          , m_videoInfo.num_frames);
        }
        m_titleAnimations.start();
        m_titleAnimations.pause();
    }

    ~QtorialsSubtitle()
    {
        qDeleteAll(m_titleData);
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
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

    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    VideoInfo m_videoInfo;
    QList<SubtitleProperties*> m_titleData;
    QParallelAnimationGroup m_titleAnimations;
    static const int m_slipFrames = 10;
    static const int m_blendDelayFrames = 6;
    static const int m_blendFrames = 8;
};

class ZoomNPanProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRectF rect READ rect WRITE setRect);

public:
    QRectF rect() const
    {
        return m_rect;
    }

    void setRect(const QRectF &rect)
    {
        m_rect = rect;
    }

    static const QByteArray propertyName;

protected:
    QRectF m_rect;
};

const QByteArray ZoomNPanProperties::propertyName = "rect";

class QtorialsZoomNPan : public IClip
{
public:
    struct Detail {
        int keyFrame;
        int transitionLength;
        QRectF detail;
    };

    QtorialsZoomNPan(PClip originClip, int width, int height,
                     int extensionColor, int defaultTransitionFrames, const char *resizeFilter,
                     const QRectF &startDetail, const QList<Detail> &details,
                     IScriptEnvironment* env)
        : m_targetVideoInfo(originClip->GetVideoInfo())
        , m_resizeFilter(resizeFilter)
        , m_extendedClip(extendedClip(originClip, extensionColor, env))
    {
        m_targetVideoInfo.width = width;
        m_targetVideoInfo.height = height;

        Detail previousDetail = { 0, 0, QRectF() };

        {
            QPropertyAnimation *start =
                    new QPropertyAnimation(&m_animationProperties, ZoomNPanProperties::propertyName);
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
            const int transitionFrames =
                    detail.transitionLength > -1 ? detail.transitionLength : defaultTransitionFrames;
            const int pauseLength = detail.keyFrame - transitionFrames - previousDetail.keyFrame;
            if (pauseLength > 0)
                m_animation.addPause(pauseLength);
            QPropertyAnimation *rectAnimation =
                    new QPropertyAnimation(&m_animationProperties, ZoomNPanProperties::propertyName);
            rectAnimation->setDuration(transitionFrames);
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

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        Q_UNUSED(env)
        m_animation.setCurrentTime(n);
        QRectF rect = m_animationProperties.rect();
        if (rect != m_resizedRect) {
            int target_width = m_targetVideoInfo.width;
            int target_height = m_targetVideoInfo.height;
            if (rect.size() == QSizeF(target_width, target_height))
                rect = rect.toRect(); // If native resolution, do not offset at fraction coordinate.
            float src_left = rect.left();
            float src_top = rect.top();
            float src_width = rect.width();
            float src_height = rect.height();
            AVSValue resizedParams[] = { m_extendedClip, target_width, target_height, src_left, src_top, src_width, src_height };
            m_resizedClip = env->Invoke( m_resizeFilter, AVSValue(resizedParams, sizeof resizedParams / sizeof resizedParams[0])).AsClip();
        }
        return m_resizedClip->GetFrame(n, env);
    }
    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_targetVideoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    static const PClip extendedClip(const PClip &originClip, int extensionColor, IScriptEnvironment* env)
    {
        AVSValue extensionParams[] =
            { originClip, m_extensionWidth, m_extensionWidth, m_extensionWidth, m_extensionWidth, extensionColor };
        return env->Invoke("AddBorders",
                           AVSValue(extensionParams, sizeof extensionParams / sizeof extensionParams[0])).AsClip();
    }

    static QRectF fixedDetailRect(const VideoInfo &originVideoInfo,
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

    static const int m_extensionWidth = 16;
    VideoInfo m_targetVideoInfo;
    QByteArray m_resizeFilter;
    PClip m_extendedClip;
    QSequentialAnimationGroup m_animation;
    ZoomNPanProperties m_animationProperties;
    PClip m_resizedClip;
    QRectF m_resizedRect;
};

struct SvgAnimationData
{
    QString svgElement;
    int startFrame;
    int endFrame;
};

class SvgAnimationProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal scale READ scale WRITE setScale);
    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity);

public:
    SvgAnimationProperties(const SvgAnimationData &data)
        : QObject()
        , m_data(data)
        , m_scale(1.0)
        , m_opacity(1.0)
    {
    }

    QString svgElement() const
    {
        return m_data.svgElement;
    }

    qreal scale() const
    {
        return m_scale;
    }

    void setScale(qreal scale)
    {
        m_scale = scale;
    }

    qreal opacity() const
    {
        return m_opacity;
    }

    void setOpacity(qreal opacity)
    {
        m_opacity = opacity;
    }

    static const QByteArray scalePropertyName;
    static const QByteArray opacityPropertyName;

protected:
    SvgAnimationData m_data;
    qreal m_scale;
    qreal m_opacity;
};

const QByteArray SvgAnimationProperties::scalePropertyName = "scale";
const QByteArray SvgAnimationProperties::opacityPropertyName = "opacity";

class QtorialsSvgAnimation : public IClip
{
public:
    QtorialsSvgAnimation(int width, int height,
                         const QString &svgFile, const QList<SvgAnimationData> &dataSets,
                         IScriptEnvironment* env)
        : m_svgFile(svgFile)
    {
        Q_UNUSED(env)
        memset(&m_videoInfo, 0, sizeof(VideoInfo));
        m_videoInfo.width = width;
        m_videoInfo.height = height;
        m_videoInfo.fps_numerator = 25;
        m_videoInfo.fps_denominator = 1;
        m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

        foreach(const SvgAnimationData &dataSet, dataSets) {
            SvgAnimationProperties *properties = new SvgAnimationProperties(dataSet);
            m_properties.append(properties);

            static const int scaleDuration = 5;
            static const qreal startScale = 0.2;
            static const qreal endScale = 1.0;
            QSequentialAnimationGroup *scaleSequence = new QSequentialAnimationGroup;
            {
                QPropertyAnimation *scaleStart =
                        new QPropertyAnimation(properties, SvgAnimationProperties::scalePropertyName);
                scaleStart->setStartValue(startScale);
                scaleStart->setEndValue(startScale);
                scaleStart->setDuration(0);
                scaleSequence->addAnimation(scaleStart);
            }
            scaleSequence->addPause(dataSet.startFrame - scaleDuration);
            {
                QPropertyAnimation *scaleAppear =
                        new QPropertyAnimation(properties, SvgAnimationProperties::scalePropertyName);
                scaleAppear->setStartValue(startScale);
                scaleAppear->setEndValue(endScale);
                scaleAppear->setDuration(scaleDuration);
                scaleSequence->addAnimation(scaleAppear);
            }
            scaleSequence->addPause(dataSet.endFrame - dataSet.startFrame);
            {
                QPropertyAnimation *scaleDisappear =
                        new QPropertyAnimation(properties, SvgAnimationProperties::scalePropertyName);
                scaleDisappear->setStartValue(endScale);
                scaleDisappear->setEndValue(startScale);
                scaleDisappear->setDuration(scaleDuration);
                scaleSequence->addAnimation(scaleDisappear);
            }
            scaleSequence->addPause(10000);

            m_animation.addAnimation(scaleSequence);

            m_videoInfo.num_frames = qMax(dataSet.endFrame + scaleDuration + 1 // +1, so that we have a clear frame at the end
                                          , m_videoInfo.num_frames);
        }

        m_animation.start();
        m_animation.pause();
    }

    ~QtorialsSvgAnimation()
    {
        qDeleteAll(m_properties);
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
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
            Filters::paintBlendedSvgElement(&p,
                                            m_svgFile,
                                            properties->svgElement(),
                                            properties->opacity(),
                                            properties->scale(),
                                            image.rect()
                                            );
        }

        return frame;
    }
    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    QString m_svgFile;
    VideoInfo m_videoInfo;
    QParallelAnimationGroup m_animation;
    QList<SvgAnimationProperties*> m_properties;
};


AVSValue __cdecl CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const QString title =
        QString::fromLatin1(args[0].AsString("Title")).replace(QLatin1String("\\n"), QLatin1String("\n"));
    QImage image(args[2].AsInt(defaultClipWidth), args[3].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    Filters::paintTitle(&p, image.rect(), title,
                        args[1].AsInt(qRgba(0x0, 0x0, 0x0, 0xff)));
    return new QtorialsStillImage(image, args[4].AsInt(100), env);
}

AVSValue __cdecl CreateSubtitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const AVSValue &titleValues = args[2];
    if (titleValues.ArraySize() % 4 != 0)
        env->ThrowError("QtorialsSubtitle: Mismatching number of arguments.\nThe title arguments must be dividable by 4.");

    QList<SubtitleData> titles;
    for (int i = 0; i < titleValues.ArraySize(); i += 4) {
        if (!(titleValues[i].IsString() && titleValues[i+1].IsString()
              && titleValues[i+2].IsInt() && titleValues[i+3].IsInt()))
            env->ThrowError("QtorialsSubtitle: Wrong title argument data types in title set %i.", i / 4 + 1);
        SubtitleData title = {
            QLatin1String(titleValues[i].AsString()),
            QLatin1String(titleValues[i+1].AsString()),
            titleValues[i+2].AsInt(),
            titleValues[i+3].AsInt()};
        titles.append(title);
    }
    return new QtorialsSubtitle(args[0].AsInt(defaultClipWidth),
                                args[1].AsInt(defaultClipHeight),
                                titles,
                                env);
}

AVSValue __cdecl CreateElements(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    QImage image(args[1].AsInt(defaultClipWidth), args[2].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    Filters::paintElements(&p, QString::fromLatin1(args[0].AsString("qtlogosmall")), image.rect());
    return new QtorialsStillImage(image, args[3].AsInt(100), env);
}

void CheckSvgAndThrow(const QString &svgFileName, const QString &svgElement, IScriptEnvironment* env)
{
    const Filters::SvgResult result =
            Filters::checkSvg(svgFileName, svgElement);
    switch (result) {
        case Filters::SvgFileNotValid:
                env->ThrowError("Svg: File '%s'' was not found or is invalid SVG.",
                                svgFileName.toAscii().data());
            break;
        case Filters::SvgElementNotFound:
                env->ThrowError("Svg: Svg element '%s' was not found.",
                                svgElement.toAscii().data());
            break;
        default:
            break;
    }
}

AVSValue __cdecl CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const QString svgFileName = QString::fromLatin1(args[0].AsString());
    const QString svgElementsCSV =
            QString::fromLatin1(args[1].AsString());
    QStringList svgElements;
    foreach(const QString &element, svgElementsCSV.split(QLatin1Char(','), QString::SkipEmptyParts)) {
        const QString trimmedElement = element.trimmed();
        CheckSvgAndThrow(svgFileName, trimmedElement, env);
        svgElements.append(trimmedElement);
    }

    QImage image(args[2].AsInt(defaultClipWidth), args[3].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    Filters::paintSvgElements(&p, svgFileName, svgElements, image.rect());
    return new QtorialsStillImage(image, args[4].AsInt(100), env);
}

AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data, IScriptEnvironment* env)
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

    QList<QtorialsZoomNPan::Detail> details;
    for (int i = 0; i < detailValues.ArraySize(); i += valuesPerDetail) {
        const int keyFrame = detailValues[i+0].AsInt();
        const int transitionLength = detailValues[1].AsInt();
        const QRectF rect(detailValues[i+2].AsFloat(), detailValues[i+3].AsFloat(),
                          detailValues[i+4].AsFloat(), detailValues[i+5].AsFloat());
        const QtorialsZoomNPan::Detail detail =
            {keyFrame, transitionLength, rect};
        details.append(detail);
    }

    return new QtorialsZoomNPan(args[0].AsClip(),
                                args[1].AsInt(defaultClipWidth),
                                args[2].AsInt(defaultClipHeight),
                                args[3].AsInt(0xffffff),
                                args[4].AsInt(15),
                                args[5].AsString(),
                                start,
                                details,
                                env);
}

AVSValue __cdecl CreateSvgAnimation(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    static const int valuesPerDetail = 3;

    const AVSValue &detailValues = args[3];
    if (detailValues.ArraySize() % valuesPerDetail != 0)
        env->ThrowError("QtorialsSvgAnimation: Mismatching number of arguments.\n"
                        "They need to be %d per keyframe.", valuesPerDetail);

    const QString svgFileName = QLatin1String(args[0].AsString());

    QList<SvgAnimationData> details;
    for (int i = 0; i < detailValues.ArraySize(); i += valuesPerDetail) {
        const SvgAnimationData animationDetail = {
            QLatin1String(detailValues[i].AsString()),
            detailValues[i+1].AsInt(),
            detailValues[i+2].AsInt()
        };
        CheckSvgAndThrow(svgFileName, animationDetail.svgElement, env);
        details.append(animationDetail);
    }

    return new QtorialsSvgAnimation(args[1].AsInt(),
                                    args[2].AsInt(),
                                    svgFileName,
                                    details,
                                    env);
}

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtorialsTitle",
                     "[text]s[textcolor]i[width]i[height]i[frames]i", CreateTitle, 0);
    env->AddFunction("QtorialsSubtitle", "[width]i[height]i.*", CreateSubtitle, 0);
    env->AddFunction("QtorialsElements", "[elements]s[width]i[height]i[frames]i", CreateElements, 0);
    env->AddFunction("QtorialsSvg", "[svgfile]s[elements]s[width]i[height]i[frames]i", CreateSvg, 0);
    env->AddFunction("QtorialsZoomNPan",
                     "[clip]c[width]i[height]i[extensioncolor]i[defaulttransitionframes]i[resizefiter]s"
                     "[startleft]i[starttop]i[startwidth]i[startheight]i[details]i*", CreateZoomNPan, 0);
    env->AddFunction("QtorialsSvgAnimation",
                     "[svgfile]s[width]i[height]i.*", CreateSvgAnimation, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}

#include "qtavisynth.moc"
