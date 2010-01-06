#include "highlight.h"
#include "filters.h"
#include "rgboverlay.h"
#include <QPropertyAnimation>

class HighlightProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity);

public:
    HighlightProperties(QObject *parent = 0);
    qreal opacity() const;
    void setOpacity(qreal opacity);

    static const QByteArray opacityPropertyName;

protected:
    qreal m_opacity;
};

HighlightProperties::HighlightProperties(QObject *parent)
    : QObject(parent)
    , m_opacity(0)
{
}

qreal HighlightProperties::opacity() const
{
    return m_opacity;
}

void HighlightProperties::setOpacity(qreal opacity)
{
    m_opacity = opacity;
}

const QByteArray HighlightProperties::opacityPropertyName = "opacity";
const int Highlight::m_blendFrames = 5;

Highlight::Highlight(const VideoInfo &videoInfo,
                     const QRect &rectangle, int startFrame, int endFrame)
    : m_videoInfo(videoInfo)
    , m_rectangle(rectangle)
{
    m_videoInfo.pixel_type = VideoInfo::CS_BGR32;

    m_properties = new HighlightProperties(&m_highlightAnimation);

    const struct Animation {
        int pauseBefore;
        int duration;
        qreal startValue;
        qreal endValue;
    } animations[] = {
        { startFrame, m_blendFrames, 0.0, 1.0 },
        { endFrame - startFrame - 2*m_blendFrames, m_blendFrames, 1.0, 0.0 }
    };

    for (int i = 0; i < int(sizeof animations / sizeof animations[0]); ++i) {
        const struct Animation &a = animations[i];
        m_highlightAnimation.addPause(a.pauseBefore);
        QPropertyAnimation *animation =
                new QPropertyAnimation(m_properties, HighlightProperties::opacityPropertyName);
        animation->setDuration(a.duration);
        animation->setStartValue(a.startValue);
        animation->setEndValue(a.endValue);
        m_highlightAnimation.addAnimation(animation);
    }

    m_highlightAnimation.addPause(m_videoInfo.num_frames - m_highlightAnimation.duration());
    m_highlightAnimation.start();
    m_highlightAnimation.pause();
}

PVideoFrame __stdcall Highlight::GetFrame(int n, IScriptEnvironment* env)
{
    PVideoFrame frame = env->NewVideoFrame(m_videoInfo);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, m_videoInfo.width, m_videoInfo.height, QImage::Format_ARGB32);
    image.fill(0);
    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());
    m_highlightAnimation.setCurrentTime(n);
    Filters::paintHighlight(&p, m_rectangle, m_properties->opacity());
    return frame;
}

AVSValue __cdecl Highlight::CreateHighlight(AVSValue args, void* user_data,
                                            IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const QRect rect(args[1].AsInt(0), args[2].AsInt(0),
                     args[3].AsInt(100), args[4].AsInt(100));
    const int start = args[5].AsInt(10);
    const int end = args[6].AsInt(30);
    const PClip hightlightClip =
            new Highlight(background->GetVideoInfo(), rect, start, end);
    return new RgbOverlay(background, hightlightClip, env);
}

bool __stdcall Highlight::GetParity(int n)
{
    Q_UNUSED(n)
    return false;
}

const VideoInfo& __stdcall Highlight::GetVideoInfo()
{
    return m_videoInfo;
}

void __stdcall Highlight::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints)
    Q_UNUSED(frame_range)
}

void __stdcall Highlight::GetAudio(void* buf, __int64 start, __int64 count,
                                   IScriptEnvironment* env)
{
    Q_UNUSED(buf)
    Q_UNUSED(start)
    Q_UNUSED(count)
    Q_UNUSED(env)
}

#include "highlight.moc"
