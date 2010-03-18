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
global gDetailsExpansionBorder = 40
global gDissolveLength = 12

function zoompan(clip,
    \ float leftStart, float topStart, float widthStart, float heightStart,
    \ float leftEnd, float topEnd, float widthEnd, float heightEnd)
{
    return clip
        \ .addBorders(gDetailsExpansionBorder, gDetailsExpansionBorder, gDetailsExpansionBorder, gDetailsExpansionBorder)
        \ .animate(0, clip.FrameCount, "Lanczos4Resize",
        \   480, 232, float(leftStart + gDetailsExpansionBorder), float(topStart + gDetailsExpansionBorder), float(widthStart), float(heightStart),
        \   480, 232, float(leftEnd + gDetailsExpansionBorder), float(topEnd + gDetailsExpansionBorder), float(widthEnd), float(heightEnd))
}

function phoneaction
{
    footage = DirectShowSource(gMediaDir + "x2_morphingclock.m2ts", audio = false)
    Dissolve(
    \   footage.trim(10, 80) + footage.trim(90, 130)
    \ , footage.trim(240, 300)
    \ , footage.trim(365, 519)
    \ , 5
    \ )
    TemporalSoften(4, 4, 8, mode = 2)
    Turn180
    zoompan(72, 96, 1814, 876, 370, 236, 1224, 592)
    addborders(0, 64, 0, 64, 0)
    converttorgb32
}

function completeclip
{
    return
        \ Dissolve(
            \   BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , BlankClipRGB(15).killaudio
            \ , textClip("Morphing Clock\n", 75).killaudio
            \ , textClip("Morphing Clock\nhttp://bit.ly/x2-morphingclock", 100).killaudio
            \ , BlankClipRGB(15).killaudio
            \ , phoneaction
            \ , BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , gDissolveLength)
        \ .QtorialsElements("oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
