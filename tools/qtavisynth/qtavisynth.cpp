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

class TitleData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal slip READ slip WRITE setSlip);
    Q_PROPERTY(qreal blend READ blend WRITE setBlend);

public:
    TitleData(const QString &title, const QString &subTitle)
        : QObject()
        , m_title(title)
        , m_subTitle(subTitle)
        , m_slip(0.0)
        , m_blend(0.0)
    {
    }

    QString title() const
    {
        return m_title;
    }

    QString subTitle() const
    {
        return m_subTitle;
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
    QString m_title;
    QString m_subTitle;
    qreal m_slip;
    qreal m_blend;
};

const QByteArray TitleData::slipPropertyName = "slip";
const QByteArray TitleData::blendPropertyName = "blend";

class QtorialsSubtitle : public IClip
{
public:
    QtorialsSubtitle(int width, int height,
                     int titleArumentsCount, const AVSValue* titleArguments,
                     IScriptEnvironment* env)
    {
        memset(&m_videoInfo, 0, sizeof(VideoInfo));
        if (titleArumentsCount % 4 != 0)
            env->ThrowError("QtorialsSubtitle: Mismatching number of arguments.\nThe title arguments must be dividable by 4.");
        for (int i = 0; i < titleArumentsCount; i += 4) {
            if (!(titleArguments[i].IsString() && titleArguments[i+1].IsString()
                  && titleArguments[i+2].IsInt() && titleArguments[i+3].IsInt()))
                env->ThrowError("QtorialsSubtitle: Wrong title argument data type in title set %i.", i / 4 + 1);
            TitleData *data = new TitleData(
                QLatin1String(titleArguments[i].AsString()),
                QLatin1String(titleArguments[i+1].AsString()));
            const int startFrame = titleArguments[i+2].AsInt();
            const int endFrame = titleArguments[i+3].AsInt();
            const int slipFrames = 10;
            const int blendDelayFrames = 6;
            const int blendFrames = 8;

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
                { slipSequence, TitleData::slipPropertyName, startFrame, slipFrames, 0.0, 1.0 },
                { slipSequence, TitleData::slipPropertyName, endFrame - startFrame - 2*slipFrames, slipFrames, 1.0, 0.0 },
                { blendSequence, TitleData::blendPropertyName, startFrame + blendDelayFrames, blendFrames, 0.0, 1.0 },
                { blendSequence, TitleData::blendPropertyName, endFrame - startFrame - 2*blendDelayFrames - 2*blendFrames, blendFrames, 1.0, 0.0 },
            };

            for (int i = 0; i < int(sizeof animations / sizeof animations[0]); ++i) {
                const struct Animation &a = animations[i];
                a.sequence->addPause(a.pauseBefore);
                QPropertyAnimation *animation =
                        new QPropertyAnimation(data, a.propertyName);
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

            m_titleData.append(data);
            m_videoInfo.num_frames = qMax(endFrame + 1 // +1, so that we have a clear fram at the end
                                          , m_videoInfo.num_frames);
        }
        m_videoInfo.width = width;
        m_videoInfo.height = height;
        m_videoInfo.fps_numerator = 25;
        m_videoInfo.fps_denominator = 1;
        m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

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
        QImage image(m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
        image.fill(0);
        QPainter p(&image);
        m_titleAnimations.setCurrentTime(n);
        foreach (const TitleData *titleData, m_titleData) {
            Filters::paintAnimatedSubTitle(
                    &p, titleData->title(), titleData->subTitle(),
                    titleData->slip(), titleData->blend(),
                    image.rect());
        }
        env->BitBlt(frameBits, frame->GetPitch(), image.mirrored(false, true).bits(), frame->GetPitch(), image.bytesPerLine(), image.height());
        return frame;
    }

    bool __stdcall GetParity(int n) { Q_UNUSED(n) return false; }
    const VideoInfo& __stdcall GetVideoInfo() { return m_videoInfo; }
    void __stdcall SetCacheHints(int cachehints, int frame_range) { Q_UNUSED(cachehints) Q_UNUSED(frame_range) }
    void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env)
    { Q_UNUSED(buf) Q_UNUSED(start) Q_UNUSED(count) Q_UNUSED(env) }

protected:
    VideoInfo m_videoInfo;
    QList<TitleData*> m_titleData;
    QParallelAnimationGroup m_titleAnimations;
};

class RectAnimation : public QObject
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

const QByteArray RectAnimation::propertyName = "rect";

class QtorialsZoomNPan : public IClip
{
public:
    QtorialsZoomNPan(PClip originClip, int width, int height,
                     int extensionColor, int defaultTransitionFrames, const char *resizeFilter,
                     int zoomNPanArgumentsCount, const AVSValue* zoomNPanArguments,
                     IScriptEnvironment* env)
        : m_targetVideoInfo(originClip->GetVideoInfo())
        , m_resizeFilter(resizeFilter)
        , m_extendedClip(extendedClip(originClip, extensionColor, env))
    {
        if (zoomNPanArgumentsCount % 6 != 4)
            env->ThrowError("QtorialsZoomNPan: Mismatching number of arguments.\nThere must be one start size and consecutive values (dividible by 6)");
        m_targetVideoInfo.width = width;
        m_targetVideoInfo.height = height;
        int previousFrame = 0;
        QRectF previousRect;
        for (int i = -2; i < zoomNPanArgumentsCount; i += 6) {
            const bool isStart = i < 0;
            const bool isEnd = i + 6 >= zoomNPanArgumentsCount;
            const int frame = isStart? 0 : zoomNPanArguments[i].AsInt();
            if (frame < previousFrame)
                env->ThrowError("QtorialsZoomNPan: Wrong order of keypoints.\nThere is a %d followed by a %d.", previousFrame, frame);

            const QRectF specifiedRect(zoomNPanArguments[i + 2].AsFloat(),
                                       zoomNPanArguments[i + 3].AsFloat(),
                                       zoomNPanArguments[i + 4].AsFloat(),
                                       zoomNPanArguments[i + 5].AsFloat());
            const QRectF rect =
                    detailRect(originClip->GetVideoInfo(), QSize(width, height), specifiedRect);

            if (isStart) {
                QPropertyAnimation *start =
                        new QPropertyAnimation(&m_animationTarget, RectAnimation::propertyName);
                start->setDuration(0);
                start->setStartValue(rect);
                start->setEndValue(rect);
                m_animation.addAnimation(start);
            } else {
                const int transitionFrames = isStart? 0 : (zoomNPanArguments[i + 1].AsInt() != -1 ?
                                             zoomNPanArguments[i + 1].AsInt() : defaultTransitionFrames);
                const int pauseLength = frame - transitionFrames - previousFrame;
                if (pauseLength > 0)
                    m_animation.addPause(pauseLength);
                QPropertyAnimation *rectAnimation =
                        new QPropertyAnimation(&m_animationTarget, RectAnimation::propertyName);
                rectAnimation->setDuration(transitionFrames);
                rectAnimation->setStartValue(previousRect);
                rectAnimation->setEndValue(rect);
                rectAnimation->setEasingCurve(QEasingCurve::InOutQuad);
                m_animation.addAnimation(rectAnimation);
            }

            if (isEnd) {
                m_animation.addPause(m_targetVideoInfo.num_frames - frame);
            } else {
                previousFrame = frame;
                previousRect = rect;
            }
        }
        m_animation.start();
        m_animation.pause();
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        Q_UNUSED(env)
        int target_width = m_targetVideoInfo.width;
        int target_height = m_targetVideoInfo.height;
        m_animation.setCurrentTime(n);
        QRectF rect = m_animationTarget.rect();
        if (rect.size() == QSizeF(target_width, target_height))
            rect = rect.toRect(); // If native resolution, do not offset at fraction coordinate.
        float src_left = rect.left();
        float src_top = rect.top();
        float src_width = rect.width();
        float src_height = rect.height();
        AVSValue resizedParams[] = { m_extendedClip, target_width, target_height, src_left, src_top, src_width, src_height };
        PClip resizedClip = env->Invoke( m_resizeFilter, AVSValue(resizedParams, sizeof resizedParams / sizeof resizedParams[0])).AsClip();
        return resizedClip->GetFrame(n, env);
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

    static QRectF detailRect(const VideoInfo &originVideoInfo,
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
    RectAnimation m_animationTarget;
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
    return new QtorialsSubtitle(args[0].AsInt(defaultClipWidth),
                                args[1].AsInt(defaultClipHeight),
                                args[2].ArraySize(),
                                &args[2][0],
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

AVSValue __cdecl CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    QImage image(args[2].AsInt(defaultClipWidth), args[3].AsInt(defaultClipHeight), QImage::Format_ARGB32);
    image.fill(transparentColor);
    QPainter p(&image);
    const Filters::PaintSvgResult result =
            Filters::paintSvg(&p, QString::fromLatin1(args[0].AsString()),
                              QString::fromLatin1(args[1].AsString()), image.rect());
    switch (result) {
        case Filters::PaintSvgFileNotValid:
                env->ThrowError("QtorialsSvg: File '%s'' was not found or is invalid.",
                                args[0].AsString());
            break;
        case Filters::PaintSvgElementNotFound:
                env->ThrowError("QtorialsSvg: One of the Svg elements '%s' was not found.",
                                args[1].AsString());
            break;
        default:
            break;
    }
    return new QtorialsStillImage(image, args[4].AsInt(100), env);
}

AVSValue __cdecl CreateZoomNPan(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    return new QtorialsZoomNPan(args[0].AsClip(),
                                args[1].AsInt(defaultClipWidth),
                                args[2].AsInt(defaultClipHeight),
                                args[3].AsInt(0xffffff),
                                args[4].AsInt(15),
                                args[5].AsString("Lanczos4Resize"),
                                args[6].ArraySize(),
                                &args[6][0],
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
                     "[clip]c[width]i[height]i[extensioncolor]i[defaulttransitionframes]i[resizefiter]s.*", CreateZoomNPan, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}

#include "qtavisynth.moc"
