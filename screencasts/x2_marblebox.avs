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
global gDissolveLength = 12

function phoneaction
{
    DirectShowSource(gMediaDir + "marblebox.3gp", audio = false)
    ColorYUV(autowhite = true)
    TemporalSoften(4, 6, 10)
    trim(20, 470)
    ChangeFPS(25)
    Lanczos4Resize(gClipWidth, gClipHeight, 220, 0, 960, 720)
}

function completeclip
{
    return
        \ Dissolve(
            \   BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , BlankClipRGB(15).killaudio
            \ , textClip("Box of Marbles\n", 70).killaudio
            \ , textClip("Box of Marbles\nhttp://bit.ly/x2-marblebox", 95).killaudio
            \ , BlankClipRGB(15).killaudio
            \ , phoneaction.converttorgb32
            \ , BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , gDissolveLength)
        \ .QtorialsElements("oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
