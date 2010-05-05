# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gClipWidth = 480
global gClipHeight = 360
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Qt for Symbian\n", 75)
        \ , textClip("Qt for Symbian\nSpectrum Analyser", 75)
        \ , gDissolveLength)
}

function video
{
    clip = \
         directShowSource(gMediaDir + "spectrum.mts") \
        .Trim(240, 0) \
        .TemporalSoften(2, 2, 4, mode = 2) \
        .TurnRight
    clip.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                -390,  322,     1678, 1258
        \ ,   45,  -1,        0,  664,      790,  592
        \ ,  655,  -1,        0,  532,     1080,  810
        \ ,  880,  -1,        0,  664,      790,  592
        \ )
}

function completeclip
{
    return
        \ Dissolve(
            \   AudioDub(intro, BlankClip(audio_rate = 48000, channels = 2))
            \ , video.converttorgb
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength * 2)
}

completeclip
