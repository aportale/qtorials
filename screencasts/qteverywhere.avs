# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's demos on different Qt devices

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000
global gDetailsExpansionBorder = 10
global gDetailsTransitionDefaultFrameCount = 15
global gLongDissolveLength = 25

global gDeviceNameN95 = "Symbian / Nokia N95"
global gDeviceNameXP5800 = "Symbian / Nokia XpressMusic 5800"
global gDeviceNameN900 = "Maemo / Nokia N900"
global gDeviceNameI900 = "Windows Mobile / Samsung Omnia i900"

function devicename(clip, string name)
{
    return clip
        \ .Subtitle(name, align = 2, size = clip.height / 15, text_color = $40FFFFFF, halo_color = $40000000)
}

function zoompan(clip,
    \ float leftStart, float topStart, float widthStart, float heightStart,
    \ float leftEnd, float topEnd, float widthEnd, float heightEnd)
{
    return clip
        \ .addBorders(gDetailsExpansionBorder, gDetailsExpansionBorder, gDetailsExpansionBorder, gDetailsExpansionBorder)
        \ .animate(0, clip.FrameCount, "Lanczos4Resize",
        \   gClipWidth, gClipHeight, float(leftStart + gDetailsExpansionBorder), float(topStart + gDetailsExpansionBorder), float(widthStart), float(heightStart),
        \   gClipWidth, gClipHeight, float(leftEnd + gDetailsExpansionBorder), float(topEnd + gDetailsExpansionBorder), float(widthEnd), float(heightEnd))
}

function digiflip
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_digiflip_5800.MTS")
        \ .trim(10, 170)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "qteverywhere_digiflip_n900.MTS")
        \ .trim(160, 340)
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
        \ .zoompan(0, -230, 1920, 1536,   130, -126, 1662, 1328)
        \ .devicename(gDeviceNameN900)

    Dissolve(clip_5800, clip_n900, gLongDissolveLength)
}

function flickable
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_5800.MTS")
        \ .trim(10, 300)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_n900.MTS")
        \ .trim(10, 170)
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
        \ .zoompan(130, -126, 1662, 1328,   0, -230, 1920, 1536)
        \ .devicename(gDeviceNameN900)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_omnia.MTS")
        \ .trim(100, 250)
        \ .Tweak(bright = 3)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-484, 142, 2046, 1638,   -228, 346, 1536, 1230)
        \ .devicename(gDeviceNameI900)

    Dissolve(clip_5800, clip_n900, clip_omnia, gLongDissolveLength)
}

function weatherinfo
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_weatherinfo_5800.MTS")
        \ .trim(30, 320)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-316, 276, 1712, 1370,   -572, 72, 2222, 1778)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_weatherinfo_omnia.MTS")
        \ .trim(10, 140)
        \ .Tweak(bright = 3)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-228, 346, 1536, 1230,   -484, 142, 2046, 1638)
        \ .devicename(gDeviceNameI900)

    Dissolve(clip_5800, clip_omnia, gLongDissolveLength)
}

function lightmaps
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_lightmaps_5800.MTS")
        \ .trim(0, 280)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_lightmaps_omnia.MTS")
        \ .trim(20, 300)
        \ .Tweak(bright = 3)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-484, 142, 2046, 1638,   -228, 346, 1536, 1230)
        \ .devicename(gDeviceNameI900)

    Dissolve(clip_5800, clip_omnia, gLongDissolveLength)
}

function raycasting
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_5800.MTS")
        \ .trim(0, 310)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_omnia.MTS")
        \ .trim(0, 240)
        \ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-228, 346, 1536, 1230,   -484, 142, 2046, 1638)
        \ .devicename(gDeviceNameI900)

    clip_n95 =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_n95.MTS")
        \ .trim(0, 240)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-472, 152, 2022, 1618,   -282, 302, 1644, 1316)
        \ .devicename(gDeviceNameN95)

    Dissolve(clip_5800, clip_omnia, clip_n95, gLongDissolveLength)
}

function all
{
    return Dissolve (
        \   textClip("Qt demos on mobile devices").killaudio.converttoyv12
        \ , textClip("Digital clock", 50).killaudio.converttoyv12
        \ , digiflip.killaudio
        \ , textClip("Kinetic scrolling").killaudio.converttoyv12
        \ , flickable.killaudio
        \ , textClip("Weather info").killaudio.converttoyv12
        \ , weatherinfo.killaudio
        \ , textClip("OpenStreetMap viewer").killaudio.converttoyv12
        \ , lightmaps.killaudio
        \ , textClip("Ray casting").killaudio.converttoyv12
        \ , raycasting.killaudio
        \ , textClip("http://qt.nokia.com", 100).killaudio.converttoyv12
        \ , gDissolveLength).creativeCommons.qtlogosmall.oldStyle.FadeIO(10)
}

all
#flickable
