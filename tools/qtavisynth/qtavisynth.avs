# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")

function overlayRgbClipOnRgb(clip background, clip overlay)
{
    return background.layer(overlay)
}

function overlayRgbClipOnNonRgb(clip background, clip overlay)
{
    return background.Overlay(overlay, 0, 0, overlay.showAlpha)
}

function overlayRgbClip(clip background, clip overlay)
{
    return background.IsRGB ?
        \ overlayRgbClipOnRgb(background, overlay)
        \ : overlayRgbClipOnNonRgb(background, overlay)
}

QtorialsTitle("huhuasdf adf sdfsfd asdf asdf asdf asdf", 640, 360).ConvertToYUY2
\ .overlayRgbClip(QtorialsElements("oldstyle, qtlogosmall, symbianlogobig, qtlogobig", 640, 360))

