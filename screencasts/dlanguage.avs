# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
loadplugin("deflicker.dll")
Import("tools.avsi")

global gClipWidth = 920
global gClipHeight = 520

function RawFootage
{
    DirectShowSource(gMediaDir + "dlanguage.01.MTS", audio = false)
        \ + DirectShowSource(gMediaDir + "dlanguage.02.MTS", audio = false)
        \ + DirectShowSource(gMediaDir + "dlanguage.03.MTS", audio = false)
        \ + DirectShowSource(gMediaDir + "dlanguage.04.MTS", audio = false)
        \ + DirectShowSource(gMediaDir + "dlanguage.05.MTS", audio = false)
        \ + DirectShowSource(gMediaDir + "dlanguage.06.MTS", audio = false)
}

function TweakedFootage
{
    RawFootage
        \ .Converttoyuy2
        \ .SpatialSoften(2, 2, 4)
        \ .TemporalSoften(4, 8, 12)
        \ .Spline64Resize(gClipWidth, gClipHeight, 404, 204, 1280, 720)
        \ .Levels(0, 0.9, 190, 0, 255)
        \ .SpatialSoften(2, 2, 8)
        \ .Sharpen(0.2)
}

Dissolve(
    \   textClip("Christian Kamm\nNokia, Qt Development Frameworks", 90).Converttoyv12.killaudio
    \ , textClip("The D Programming Language", 90).Converttoyv12.killaudio
    \ , TweakedFootage.Converttoyv12
    \ , gDissolveLength
\   ).overlayQtorialsElements("qtlogosmall").FadeIO(gDissolveLength)
