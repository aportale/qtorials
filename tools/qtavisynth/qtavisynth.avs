# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("..\..\screencasts\qtavisynth.dll")
Import("..\..\screencasts\tools.avsi")

gClipWidth = 640
gClipHeight = 360

QtorialsElements("rgbpatterns", 800, 800, 500)
\.QtorialsZoomNPan(gClipWidth, gClipHeight, $ffffff, 100, "BilinearResize"
    \ ,               0,   0, gClipWidth * 2, gClipHeight * 2
                      \ ,  120,  -1,    0,  0, -1, -1
                      \ ,  360,  -1,    -1, -1, -1, -1
    \ )
\.overlayRgbClip(QtorialsSubtitle(gClipWidth, gClipHeight, "Title", "Subtitle", 10, 200))
\.overlayRgbClip(QtorialsSubtitle(gClipWidth, gClipHeight, "Title", "Subtitle", 40, 100))
\.overlayRgbClip(QtorialsSubtitle(gClipWidth, gClipHeight, "Title", "Subtitle", 50, 80))
\.overlayRgbClip(QtorialsSvg("..\..\screencasts\qtsymbian_development.svg", "listwidget, pushbutton", gClipWidth, gClipHeight, 100))
