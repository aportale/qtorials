# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's weather info example
# http://labs.trolltech.com/blogs/2009/07/22/weather-info-for-qts60/

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDissolveLength = 12
global gDetailsExpansionColor = $000000

footagePortrait =
    \  DirectShowSource("..\..\qtorials_media\weatherinfo.01.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .TurnRight
footageLandscape =
    \  DirectShowSource("..\..\qtorials_media\weatherinfo.02.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .Turn180


setFullScreen(footagePortrait)
portrait =
    \   showFullScreen(footagePortrait, 50)
    \ + showDetail(footagePortrait, 70, 16, 788, 1042, 782)
    \ + showDetail(footagePortrait, 155, -244, 380, 1545, 1160)
    \ + showDetail(footagePortrait, 60, 16, 788, 1042, 782)
    \ + showDetail(footagePortrait, 120, -244, 380, 1545, 1160)

resetCurrentDetail
setFullScreen(footageLandscape)
landscape =
    \   showFullScreen(footageLandscape, 70)
    \ + showDetail(footageLandscape, 280, 326, 64, 1280, 960)
    \ + showFullScreen(footageLandscape, 70)

allTogether =
    \ Dissolve(
        \ portrait,
        \ landscape,
        \ gDissolveLength
    \ ).TemporalSoften(2, 4, 8)
    \ .qtLogoSmall

allTogether