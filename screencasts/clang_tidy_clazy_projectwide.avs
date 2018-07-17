# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

# Qt Creator window has 1280*728 pixels in the raw footage (ratio 17.6:10)
global gClipWidth = 688
global gClipHeight = 390

raw_clip = DirectShowSource("clangtidy_complete.avi")

function fullscreenResize(clip sourceClip)
{
    sourceClip.BilinearResize(gClipWidth, gClipHeight)
}

function detailCrop(clip sourceClip, int x, int y)
{
    sourceClip.crop(x, y, gClipWidth, gClipHeight)
}

raw_clip.detailCrop(0, 200)
