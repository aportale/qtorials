# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")

QtorialsTitle("asdfasd fahsdkjlfh asjkldfasdfas fasd asd", 640, 360)
\ .overlayRgbClip(QtorialsSvg("artwork.svg", "qtlogobig", 640, 360))
\ .overlayRgbClip(QtorialsElements("qtlogosmall", 640, 360))
\ .overlayRgbClip(QtorialsSubtitle(640, 360,
   \ "Alessandro", "Funny guy with long name", 20, 80,
   \ "Alessandro", "", 120, 180,
   \ "Alessandro", "Funny guy with long name", 250, 280))
