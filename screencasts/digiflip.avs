# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's digiflip example
# http://labs.trolltech.com/blogs/2009/07/15/digital-clock-in-a-phone/

Import("tools.avsi")

global gClipWidth = 480
global gClipHeight = 360
global gDissolveLength = 12

footage =
    \  SegmentedDirectShowSource("..\..\qtorials_media\digiflip.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .TurnRight

initialTotal =
    \  footage
    \ .Trim(0, 50 + gDissolveLength)
    \ .CroppedFittedClip(0, 72, 1080, 1752)
selectingSlide =
    \ (footage.Trim(50, 80) + footage.Trim(80, 80).loop(20))
    \ .CroppedFittedClip(0, 786, 1080, 810)
slide =
    \  footage
    \ .Trim(240, 320)
    \ .CroppedFittedClip(84, 554, 928, 696)
selectingFlip =
    \ (footage.Trim(480, 537) + footage.Trim(537, 537).loop(20))
    \ .CroppedFittedClip(0, 786, 1080, 810)
flip =
    \  footage
    \ .Trim(740, 820)
    \ .CroppedFittedClip(84, 554, 928, 696)
selectingRotate =
    \ (footage.Trim(980, 1055) + footage.Trim(1055, 1055).loop(20))
    \ .CroppedFittedClip(0, 786, 1080, 810)
rotate =
    \  footage
    \ .Trim(1260, 1370 + gDissolveLength)
    \ .CroppedFittedClip(84, 554, 928, 696)
endTotal =
    \  footage
    \ .Trim(1370, 1450)
    \ .CroppedFittedClip(0, 72, 1080, 1752)

allTogether =
    \ Dissolve(
        \   initialTotal
        \ , selectingSlide
        \ , slide
        \ , selectingFlip
        \ , flip
        \ , selectingRotate
        \ , rotate
        \ , endTotal
        \ , gDissolveLength)
        \ .TemporalSoften(2, 4, 8)
        \ .qtLogoSmall

allTogether