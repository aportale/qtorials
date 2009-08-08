# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's raycasting example
# http://labs.trolltech.com/blogs/2009/08/foo

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000

function Portrait
{
    footage =
        \  DirectShowSource(gMediaDir + "raycasting.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .Trim(20, 753)
        \ .TurnRight

    resetCurrentDetail
    setFullScreen(footage)
    return
        \   showFullScreen(footage,   70)
        \ + showDetail(footage,      180, -376, 302, 1834, 1376)    [* Screen and finger *]
        \ + showDetail(footage,      400, -96, 310, 1266, 950)      [* Screen only *]
        \ + showFullScreen(footage,  475)
}

function Landscape
{
    footage =
        \  DirectShowSource(gMediaDir + "raycasting.02.MTS")
        \ .TemporalSoften(2, 4, 8)

    resetCurrentDetail
    setFullScreen(footage)
    return
        \   showFullScreen(footage,   45)
        \ + showDetail(footage,      100, 296, 0, 1440, 1080)       [* Screen and finger *]
        \ + showDetail(footage,      200, 298, 178, 960, 720)       [* Screen only *]
        \ + showFullScreen(footage,  275)
}

Dissolve(Portrait, Landscape, 10).qtLogoSmall.FadeIO(10)
