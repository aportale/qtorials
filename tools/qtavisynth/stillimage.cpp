#include "filters.h"
#include "stillimage.h"
#include "tools.h"

StillImage::StillImage(PClip background, const QImage &image, IScriptEnvironment* env)
    : GenericVideoFilter(background)
{
    vi.pixel_type =
            (image.format() == QImage::Format_ARGB32
                || image.format() == QImage::Format_ARGB32_Premultiplied) ?
                    VideoInfo::CS_BGR32 : VideoInfo::CS_BGR24;
    m_frame = env->NewVideoFrame(vi);
    unsigned char* frameBits = m_frame->GetWritePtr();
    env->BitBlt(frameBits, m_frame->GetPitch(), image.mirrored(false, true).constBits(),
                image.bytesPerLine(), image.bytesPerLine(), image.height());
}

AVSValue __cdecl StillImage::CreateElements(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const VideoInfo backgroundVI = background->GetVideoInfo();
    const AVSValue &elementValues = args[1];
    QStringList elements;
    for (int i = 0; i < elementValues.ArraySize(); ++i) {
        const QLatin1String element(elementValues[i].AsString());
        if (Filters::elementAvailable(element))
            env->ThrowError("QtAviSynthElements: Invalid element '%s'.", element.latin1());
        elements.append(element);
    }

    QImage image(backgroundVI.width, backgroundVI.height, QImage::Format_ARGB32_Premultiplied);
    image.fill(Qt::transparent);
    QPainter p(&image);
    Filters::paintElements(&p, elements, image.rect());

    const PClip elementsClip = new StillImage(background, image, env);
    return Tools::rgbOverlay(background, elementsClip, env);
}

AVSValue __cdecl StillImage::CreateSvg(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const VideoInfo backgroundVI = background->GetVideoInfo();
    const QString svgFileName =
        Tools::cleanFileName(QLatin1String(args[1].AsString()));
    const AVSValue &elementValues = args[2];
    QStringList elements;
    for (int i = 0; i < elementValues.ArraySize(); ++i) {
        const QLatin1String element(elementValues[i].AsString());
        Tools::checkSvgAndThrow(svgFileName, element, env);
        elements.append(element);
    }

    QImage image(backgroundVI.width, backgroundVI.height, QImage::Format_ARGB32_Premultiplied);
    image.fill(Qt::transparent);
    QPainter p(&image);
    Filters::paintSvgElements(&p, svgFileName, elements, image.rect());

    const PClip svgClip = new StillImage(background, image, env);
    return Tools::rgbOverlay(background, svgClip, env);
}

AVSValue __cdecl StillImage::CreateTitle(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Q_UNUSED(user_data)

    const PClip background = args[0].AsClip();
    const VideoInfo backgroundVI = background->GetVideoInfo();
    const QString text =
        QString::fromLatin1(args[1].AsString("Title")).replace(QLatin1String("\\n"),
                                                               QLatin1String("\n"));
    const QString fontFace =
        QString::fromLatin1(args[2].AsString());
    const QColor color = QRgb(args[3].AsInt(int(qRgba(0x0, 0x0, 0x0, 0xff))));

    QImage image(backgroundVI.width, backgroundVI.height, QImage::Format_ARGB32_Premultiplied);
    image.fill(Qt::transparent);
    QPainter p(&image);
    Filters::paintTitle(&p, image.rect(), text, fontFace, color);

    const PClip titleClip = new StillImage(background, image, env);
    return Tools::rgbOverlay(background, titleClip, env);
}

PVideoFrame __stdcall StillImage::GetFrame(int n, IScriptEnvironment* env)
{
    Q_UNUSED(n)
    Q_UNUSED(env)
    return m_frame;
}
