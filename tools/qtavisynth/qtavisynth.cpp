/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#ifndef LINUXIZED_VERSION
#include "windows.h"
#include "avisynth.h"
#else
#include "avxplugin.h"
#endif

#include "stillimage.h"
#include "subtitle.h"
#include "highlight.h"
#include "title.h"
#include "zoomnpan.h"
#include "svganimation.h"

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtorialsTitle", "[clip]c[text]s[textcolor]i",
                     Title::CreateTitle, 0);
    env->AddFunction("QtorialsHighlight",
                     "[clip]c[left]i[top]i[width]i[height]i[start]i[end]i",
                     Highlight::CreateHighlight, 0);
    env->AddFunction("QtorialsElements", "[clip]c[elements]s*",
                     StillImage::CreateElements, 0);
    env->AddFunction("QtorialsSvg", "[clip]c[svgfile]s[elements]s*",
                     StillImage::CreateSvg, 0);
    env->AddFunction("QtorialsSubtitle",
                     "[clip]c[title]s[subtitle]s[start]i[end]i",
                     Subtitle::CreateSubtitle, 0);
    env->AddFunction("QtorialsZoomNPan",
                     "[clip]c[width]i[height]i[extensioncolor]i"
                     "[defaulttransitionframes]i[resizefiter]s"
                     "[startleft]i[starttop]i[startwidth]i[startheight]i[details]i*",
                     ZoomNPan::CreateZoomNPan, 0);
    env->AddFunction("QtorialsSvgAnimation", "[clip]c[svgfile]s.*",
                     SvgAnimation::CreateSvgAnimation, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
