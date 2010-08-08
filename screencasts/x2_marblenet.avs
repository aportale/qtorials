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
    DirectShowSource(gMediaDir + "marblenet.3gp", audio = false)
    ColorYUV(autowhite = true)
    TemporalSoften(4, 6, 10)
    trim(295, 0)
    ChangeFPS(25)
    QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                 530,  140,      480,  360       [* First time loading marbles *]
        \ ,  170,  -1,      114,    0,      920,  690       [* Total showing the transfer *]
        \ ,  425,  -1,      530,  110,      480,  360       [* Second time loading marbles *]
        \ ,  527,  -1,      530,    0,      480,  360       [* Moving up a bit *]
        \ ,  600,  -1,      114,    0,      920,  690       [* Total showing the transfer *]
        \ )
}

function completeclip
{
    return
        \ Dissolve(
            \   BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , BlankClipRGB(15).killaudio
            \ , textClip("Network-based Marble Transfer\n", 85).killaudio
            \ , textClip("Network-based Marble Transfer\nhttp://bit.ly/x2-marblenet", 100).killaudio
            \ , BlankClipRGB(15).killaudio
            \ , phoneaction.converttorgb32
            \ , BlankClipRGB(75).QtorialsElements("x2logobig").killaudio
            \ , gDissolveLength)
        \ .QtorialsElements("oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
