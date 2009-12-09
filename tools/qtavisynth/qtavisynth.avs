# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("..\..\screencasts\qtavisynth.dll")

QtorialsElements("rgbpatterns", 800, 800, 500)
\.QtorialsZoomNPan(800, 800, $00ffff, 100, "BilinearResize"
    \ ,               0,   0, 400, 400
                      \ ,  120,  -1,    0,  0, 800, 800
                      \ ,  360,  -1,    0,  0, 1400, 1400
    \ )
