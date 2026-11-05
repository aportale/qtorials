/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "avisynth.h"

#include "highlight.h"
#include "qmlanimation.h"
#include "stillimage.h"
#include "subtitle.h"
#include "svganimation.h"
#include "tools.h"
#include "zoomnpan.h"

const AVS_Linkage* AVS_linkage = nullptr;

// AviSynth+ loads every plugin in its autoload directories, also for scripts that use none of
// the QtAviSynth functions. So the application object is created by the filter factories,
// which run when the script is evaluated, before any frame is rendered.
template <AVSValue (__cdecl *createFilter)(AVSValue, void*, IScriptEnvironment*)>
static AVSValue __cdecl withApplication(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    Tools::createQGuiApplicationIfNeeded();
    return createFilter(args, user_data, env);
}

extern "C" Q_DECL_EXPORT
const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
    AVS_linkage = vectors;

    env->AddFunction("QtAviSynthHighlight",
                     "[clip]c[left]i[top]i[width]i[height]i[start]i[end]i",
                     withApplication<Highlight::CreateHighlight>, nullptr);
    env->AddFunction("QtAviSynthElements", "[clip]c[elements]s*",
                     withApplication<StillImage::CreateElements>, nullptr);
    env->AddFunction("QtAviSynthSvg", "[clip]c[svgfile]s[elements]s*",
                     withApplication<StillImage::CreateSvg>, nullptr);
    env->AddFunction("QtAviSynthTitle", "[clip]c[text]s[fontface]s[color]i",
                     withApplication<StillImage::CreateTitle>, nullptr);
    env->AddFunction("QtAviSynthSubtitle",
                     "[clip]c[title]s[subtitle]s[start]i[end]i",
                     withApplication<Subtitle::CreateSubtitle>, nullptr);
    env->AddFunction("QtAviSynthZoomNPan",
                     "[clip]c[width]i[height]i"
                     "[defaulttransitionframes]i[resizefiter]s[perspectivestrength]f"
                     "[startleft]i[starttop]i[startwidth]i[startheight]i[details]i*",
                     withApplication<ZoomNPan::CreateZoomNPan>, nullptr);
    env->AddFunction("QtAviSynthSvgAnimation", "[]c*[svgfile]s[fps]f.*",
                     withApplication<SvgAnimation::CreateSvgAnimation>, nullptr);
    env->AddFunction("QtAviSynthQmlAnimation",
                     "[]c*[qmlfile]s[fps]f[initialproperties]s[usegpu]b",
                     withApplication<QmlAnimation::CreateQmlAnimation>, nullptr);
    return "`QtAviSynth' QtAviSynth plugin";
}
