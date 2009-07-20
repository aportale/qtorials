# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's flickable example
# http://labs.trolltech.com/blogs/2009/07/19/kinetic-scrolling-on-any-widgets/

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDissolveLength = 12

footagePortrait =
    \  DirectShowSource("..\..\qtorials_media\flickable.01.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .TurnRight
footageLandscape =
    \  DirectShowSource("..\..\qtorials_media\flickable.02.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .Turn180

portraitInitialTotal =
    \  footagePortrait
    \ .Trim(20, 90 + gDissolveLength)
    \ .CroppedFittedClip(0, 50, 1080, 1820)
portraitFlicking =
    \  footagePortrait
    \ .Trim(90, 310 + gDissolveLength)
    \ .CroppedFittedClip(0, 528, 1080, 900)
portraitSelecting =
    \  footagePortrait
    \ .Trim(310, 345 + gDissolveLength)
    \ .CroppedFittedClip(46, 530, 960, 720)
portraitFinalTotal =
    \  footagePortrait
    \ .Trim(345, 400)
    \ .CroppedFittedClip(0, 50, 1080, 1820)

landscapeInitialTotal =
    \ footageLandscape
    \ .Trim(140, 202 + gDissolveLength)
    \ .CroppedFittedClip(50, 0, 1820, 1080)
landscapeFlicking =
    \  footageLandscape
    \ .Trim(202, 320 + gDissolveLength)
    \ .CroppedFittedClip(158, 20, 1394, 1046)
landscapeSelecting =
    \  footageLandscape
    \ .Trim(320, 355 + gDissolveLength)
    \ .CroppedFittedClip(310, 238, 960, 720)
landscapeFinalTotal =
    \  footageLandscape
    \ .Trim(355, 440)
    \ .CroppedFittedClip(50, 0, 1820, 1080)

allTogether =
    \ Dissolve(
        \   portraitInitialTotal
        \ , portraitFlicking
        \ , portraitSelecting
        \ , portraitFinalTotal
        \ , landscapeInitialTotal
        \ , landscapeFlicking
        \ , landscapeSelecting
        \ , landscapeFinalTotal
        \ , gDissolveLength)
    \ .TemporalSoften(2, 4, 8)
    \ .qtLogoSmall

allTogether
