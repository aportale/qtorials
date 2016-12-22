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
#include "stillimage.h"
#include "subtitle.h"
#include "highlight.h"
#include "title.h"
#include "zoomnpan.h"
#include "svganimation.h"

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtAviSynthTitle", "[clip]c[text]s[fontface]s[color]i",
                     Title::CreateTitle, 0);
    env->AddFunction("QtAviSynthHighlight",
                     "[clip]c[left]i[top]i[width]i[height]i[start]i[end]i",
                     Highlight::CreateHighlight, 0);
    env->AddFunction("QtAviSynthElements", "[clip]c[elements]s*",
                     StillImage::CreateElements, 0);
    env->AddFunction("QtAviSynthSvg", "[clip]c[svgfile]s[elements]s*",
                     StillImage::CreateSvg, 0);
    env->AddFunction("QtAviSynthSubtitle",
                     "[clip]c[title]s[subtitle]s[start]i[end]i",
                     Subtitle::CreateSubtitle, 0);
    env->AddFunction("QtAviSynthZoomNPan",
                     "[clip]c[width]i[height]i[extensioncolor]i"
                     "[defaulttransitionframes]i[resizefiter]s"
                     "[startleft]i[starttop]i[startwidth]i[startheight]i[details]i*",
                     ZoomNPan::CreateZoomNPan, 0);
    env->AddFunction("QtAviSynthSvgAnimation", "[clip]c[svgfile]s.*",
                     SvgAnimation::CreateSvgAnimation, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
