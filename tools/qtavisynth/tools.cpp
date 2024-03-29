#include <animationpainter.h>
#include "tools.h"
#include "filters.h"

#include <QGuiApplication>
#include <QFileInfo>

const int Tools::defaultClipWidth = 640;
const int Tools::defaultClipHeight = 480;

QString Tools::cleanFileName(const QString &file)
{
    const QString cleanFilePath = QFileInfo(file).canonicalFilePath();
    return cleanFilePath.isEmpty() ? file : cleanFilePath;
}

void Tools::checkSvgAndThrow(const QString &svgFileName,
                             const QString &svgElement,
                             IScriptEnvironment* env)
{
    const Filters::SvgResult result =
            Filters::checkSvg(svgFileName, svgElement);
    switch (result) {
        case Filters::SvgFileNotValid:
                env->ThrowError("Svg: File '%s' was not found or is invalid SVG.",
                                svgFileName.toLatin1().data());
        case Filters::SvgElementNotFound:
                env->ThrowError("Svg: Svg element '%s' was not found.",
                                svgElement.toLatin1().data());
        case Filters::SvgOk:
            break;
    }
}

PClip Tools::rgbOverlay(const PClip &backgroundClip, const PClip &overlayClip,
                        IScriptEnvironment* env)
{
    if (!backgroundClip)
        return overlayClip;

    const PClip showAlpha = env->Invoke("ShowAlpha", overlayClip).AsClip();
    const AVSValue params[] = { backgroundClip, overlayClip, 0, 0, showAlpha };
    const AVSValue paramsValue = AVSValue(params, sizeof params / sizeof params[0]);
    return env->Invoke("Overlay", paramsValue).AsClip();
}

PVideoFrame Tools::GetAnimationPainterFrame(int n, IScriptEnvironment *env, const VideoInfo &vi,
                                            AnimationPainter &animationpainter)
{
    PVideoFrame frame = env->NewVideoFrame(vi);
    unsigned char* frameBits = frame->GetWritePtr();
    QImage image(frameBits, vi.width, vi.height, QImage::Format_ARGB32);
    image.fill(Qt::transparent);

    const qreal framesPerSecond = qreal(vi.fps_numerator) / vi.fps_denominator;
    const qreal msecsPerFrame = 1000 / framesPerSecond;
    const int msec = n * msecsPerFrame;
    if (msec > animationpainter.duration())
        return frame;

    QPainter p(&image);
    p.scale(1, -1);
    p.translate(0, -image.height());

    animationpainter.setCurrentTime(msec);
    animationpainter.paint(&p);

    return frame;
}

static char *argv[] = {(char*)"."};
static int argc = sizeof(argv) / sizeof(argv[0]);

QGuiApplication* Tools::createQGuiApplicationIfNeeded()
{
    return qGuiApp ? nullptr : new QGuiApplication(argc, argv);
}

SourceFilter::SourceFilter()
    : m_vi(defaultVi())
{
}

void __stdcall SourceFilter::GetAudio(void*, int64_t, int64_t, IScriptEnvironment*)
{
}

const VideoInfo& __stdcall SourceFilter::GetVideoInfo()
{
    return m_vi;
}

bool __stdcall SourceFilter::GetParity(int n)
{
    Q_UNUSED(n);
    return true;
}

int __stdcall SourceFilter::SetCacheHints(int cachehints, int frame_range)
{
    Q_UNUSED(cachehints);
    Q_UNUSED(frame_range);
    return 0;
}

void SourceFilter::setFps(double fps, IScriptEnvironment* env)
{
    m_vi.fps_numerator = env->Invoke("ContinuedNumerator", fps).AsInt();
    m_vi.fps_denominator = env->Invoke("ContinuedDenominator", fps).AsInt();
}

void SourceFilter::setSize(const QSize &size)
{
    m_vi.width = size.width();
    m_vi.height = size.height();
};

VideoInfo SourceFilter::defaultVi() {
    VideoInfo info;
    memset(&info, 0, sizeof(VideoInfo));
    info.pixel_type = VideoInfo::CS_BGR32;
    info.width = 640;
    info.height = 480;
    info.num_frames = 1000;
    info.fps_denominator = 1;
    info.fps_numerator = 24;
    info.SetFieldBased(false);
    return info;
}

