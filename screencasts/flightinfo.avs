# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's flightinfo info example
# http://labs.trolltech.com/blogs/2009/07/foo

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000

footage =
    \  DirectShowSource("..\..\qtorials_media\flightinfo.MTS")
    \ .TemporalSoften(2, 4, 8)
    \ .TurnRight

cut =
    \   footage.Trim(15, 415)
    \ + footage.Trim(415, 415).loop(100)  /* First flight info */
    \ + footage.Trim(415, 945)

setFullScreen(cut)
camera =
    \   showFullScreen(cut,   80 -   0)                              /* Begin */
    \ + showDetail(cut,      115 -  80, 60, 810, 960, 720)           /* Options->Today's Flight */
    \ + showDetail(cut,      375 - 115, -132, 548, 1336, 1002)       /* Searching 'dl10' */
    \ + showDetail(cut,      480 - 375, 60, 810, 960, 720)           /* Flight info */
    \ + showDetail(cut,      580 - 480, 60, 550, 960, 720)           /* Flight info map */
    \ + showDetail(cut,      615 - 580, 60, 810, 960, 720)           /* Options->Today's Flight */
    \ + showDetail(cut,      875 - 615, -132, 548, 1336, 1002)       /* Searching 'nk152' */
    \ + showDetail(cut,      930 - 875, 60, 810, 960, 720)           /* Flight info */
    \ + showDetail(cut,      990 - 930, 60, 550, 960, 720)           /* Flight info map */
    \ + showFullScreen(cut, 1030 - 990)                              /* End */

camera.TemporalSoften(2, 4, 8).qtLogoSmall
