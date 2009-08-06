# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's lightmaps example
# http://labs.trolltech.com/blogs/2009/08/04/openstreetmap-and-qt-and-s60/

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000

function Berlin
{
    footage =
        \  DirectShowSource(gMediaDir + "lightmaps.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight

    resetCurrentDetail
    setFullScreen(footage)
    return
        \   showFullScreen(footage,   45)
        \ + showDetail(footage,       90, 0, 732, 1080, 810)        [* Selecting Berlin *]
        \ + showDetail(footage,      270, -232, 372, 1544, 1158)    [* Panning around *]
        \ + showDetail(footage,      450, 54, 378)                  [* Zooming around *]
        \ + showFullScreen(footage,  500)
}

function Oslo
{
    footage =
        \  DirectShowSource(gMediaDir + "lightmaps.02.MTS")
        \ .Trim(20, 417)
        \ .Turn180

    resetCurrentDetail
    setFullScreen(footage)
    return
        \   showFullScreen(footage,   25)
        \ + showDetail(footage,      165, 310, 54, 1280, 960)       [* Selecting Oslo, Panning around *]
        \ + showDetail(footage,      370, 364, 182)                 [* Zooming around *]
        \ + showFullScreen(footage,  397)
}

function Jakarta
{
    footage =
        \  DirectShowSource(gMediaDir + "lightmaps.03.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight

    footagecut = Dissolve(
        \   footage.Trim(70, 170)
        \ , footage.Trim(220, 620)
        \ , gDissolveLength)

    resetCurrentDetail
    setFullScreen(footagecut)
    return
        \   showFullScreen(footagecut,   15)
        \ + showDetail(footagecut,       45, 0, 732, 1080, 810)     [* Selecting Jakarta *]
        \ + showDetail(footagecut,      150, -232, 372, 1544, 1158) [* Panning around *]
        \ + showDetail(footagecut,      180, 0, 732, 1080, 810)     [* Selecting Night Mode *]
        \ + showDetail(footagecut,      240, -232, 372, 1544, 1158) [* Admiring night mode *]
        \ + showDetail(footagecut,      350, 58, 646)               [* Zooming around *]
        \ + showFullScreen(footagecut,  425)
}

Dissolve(Berlin, Oslo, Jakarta, 10).qtLogoSmall.FadeIO(10)
