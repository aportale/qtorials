#include "filters.h"
#include "qtintro.h"
#include "tools.h"

#include <QImage>
#include <QPainter>

QtIntro::QtIntro(PClip background, const QString &title, const QString &subtitle)
    : GenericVideoFilter(background)
{
    vi.pixel_type = VideoInfo::CS_BGR32;
    m_introPainter.setSize({vi.width, vi.height});
    m_introPainter.setTitle(title);
    m_introPainter.setSubtitle(subtitle);
}

PVideoFrame __stdcall QtIntro::GetFrame(int n, IScriptEnvironment* env)
{
    return Tools::GetAnimationPainterFrame(n, env, vi, m_introPainter);
}

AVSValue __cdecl QtIntro::CreateQtIntro(AVSValue args, void* user_data,
                                        IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const QString title = QLatin1String(args[1].AsString("Title"));
    const QString subtitle = QLatin1String(args[2].AsString());
    const PClip qtIntroClip = new QtIntro(background, title, subtitle);
    return Tools::rgbOverlay(background, qtIntroClip, env);
}


QtLowerThird::QtLowerThird(PClip background, const QString &title)
    : GenericVideoFilter(background)
{
    vi.pixel_type = VideoInfo::CS_BGR32;
    m_lowerThirdPainter.setSize({vi.width, vi.height});
    m_lowerThirdPainter.setTitle(title);
}

PVideoFrame __stdcall QtLowerThird::GetFrame(int n, IScriptEnvironment* env)
{
    return Tools::GetAnimationPainterFrame(n, env, vi, m_lowerThirdPainter);
}

AVSValue __cdecl QtLowerThird::CreateQtLowerThird(AVSValue args, void* user_data,
                                                  IScriptEnvironment* env)
{
    Q_UNUSED(user_data)
    const PClip background = args[0].AsClip();
    const QString title = QLatin1String(args[1].AsString("Title"));
    const PClip qtIntroClip = new QtLowerThird(background, title);
    return Tools::rgbOverlay(background, qtIntroClip, env);
}
