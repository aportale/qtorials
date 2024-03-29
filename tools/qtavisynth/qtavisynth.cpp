/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "Windows.h"

#include "avisynth.h"

#include "highlight.h"
#include "qmlanimation.h"
#include "qtintro.h"
#include "stillimage.h"
#include "subtitle.h"
#include "svganimation.h"
#include "zoomnpan.h"

const AVS_Linkage* AVS_linkage = nullptr;

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit3(IScriptEnvironment* env, const AVS_Linkage* const vectors)
{
    AVS_linkage = vectors;

    env->AddFunction("QtAviSynthHighlight",
                     "[clip]c[left]i[top]i[width]i[height]i[start]i[end]i",
                     Highlight::CreateHighlight, nullptr);
    env->AddFunction("QtAviSynthElements", "[clip]c[elements]s*",
                     StillImage::CreateElements, nullptr);
    env->AddFunction("QtAviSynthSvg", "[clip]c[svgfile]s[elements]s*",
                     StillImage::CreateSvg, nullptr);
    env->AddFunction("QtAviSynthTitle", "[clip]c[text]s[fontface]s[color]i",
                     StillImage::CreateTitle, nullptr);
    env->AddFunction("QtAviSynthSubtitle",
                     "[clip]c[title]s[subtitle]s[start]i[end]i",
                     Subtitle::CreateSubtitle, nullptr);
    env->AddFunction("QtAviSynthZoomNPan",
                     "[clip]c[width]i[height]i"
                     "[defaulttransitionframes]i[resizefiter]s[perspectivestrength]f"
                     "[startleft]i[starttop]i[startwidth]i[startheight]i[details]i*",
                     ZoomNPan::CreateZoomNPan, nullptr);
    env->AddFunction("QtAviSynthSvgAnimation", "[]c*[svgfile]s[fps]f.*",
                     SvgAnimation::CreateSvgAnimation, nullptr);
    env->AddFunction("QtAviSynthQmlAnimation",
                     "[]c*[qmlfile]s[fps]f[initialproperties]s[useopengl]b",
                     QmlAnimation::CreateQmlAnimation, nullptr);
    env->AddFunction("QtAviSynthQtIntro",
                     "[clip]c[title]s[subtitle]s",
                     QtIntro::CreateQtIntro, nullptr);
    env->AddFunction("QtAviSynthQtLowerThird",
                     "[clip]c[title]s",
                     QtLowerThird::CreateQtLowerThird, nullptr);
    env->AddFunction("QtAviSynthQtOutro",
                     "[clip]c[title]s[subtitle]s",
                     QtIntro::CreateQtIntro, nullptr);

    Tools::createQGuiApplicationIfNeeded();

    return "`QtAviSynth' QtAviSynth plugin";
}
