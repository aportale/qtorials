# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's demos on different Qt devices

Import("tools.avsi")
LoadPlugin("SmoothDeinterlacer.dll")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000
global gDetailsExpansionBorder = 10
global gDetailsTransitionDefaultFrameCount = 15
global gLongDissolveLength = 25
global gTextClipFramesPerCharacter = 4

global gDeviceNameN95 = "Symbian / Nokia N95"
global gDeviceNameXP5800 = "Symbian / Nokia XpressMusic 5800"
global gDeviceNameN900 = "Maemo / Nokia N900"
global gDeviceNameI900 = "Windows Mobile / Samsung Omnia i900"

function textClipLegacy(String text, int "frames", int "align", int "x", int "y", string "backgroundimage")
{
    gBackgroundColor = $eeeeee
     textColor = $333333
     framesCount = Default(frames, StrLen(text) * gTextClipFramesPerCharacter)
     background = Defined(backgroundimage) ?
         \ ImageSource(backgroundimage, fps = 25, end = framesCount)
         \ : BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
    return background
        \ .Subtitle(text, align = Default(5, align), x = Default(x, -1), y = Default(y, -1), text_color = textColor, halo_color = gBackgroundColor, size = titleTextSize, lsp = 100)
}

function titleTextClip(string text, int "frames")
{
    gBackgroundColor = $eeeeee
    textColor = $333333
    result =
        \  BlankClip(Default(frames, StrLen(text) * gTextClipFramesPerCharacter), gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
        \ .Subtitle(text, y = gClipHeight - int(titleTextSize * 2), align = 2, text_color = textColor, halo_color = gBackgroundColor, size = titleTextSize, lsp = 100)
    return result.overlayQtorialImage("qt_orials")
}

function devicename(clip, string name)
{
    return clip
        \ .Subtitle(name, align = 2, size = clip.height / 15, text_color = $40FFFFFF, halo_color = $40000000)
}

function demoTitle(clip, string title)
{
    return textClipLegacy(title, backgroundimage = gArtworkDir + "Qt_VideoScreen_Title.png").killaudio.converttoyv12
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

function fixMpeg(clip)
{
    clip.SmoothDeinterlace.TemporalSoften(2, 4, 8).ConverttoYv12.Lanczos4Resize(gClipWidth, 540).addborders(0, 90, 0, 90)
}

function digiflip
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_digiflip_5800.MTS", audio=false)
        \ .trim(10, 170)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "qteverywhere_digiflip_n900.MTS", audio=false)
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
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_5800.MTS", audio=false)
        \ .trim(10, 300)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_n900.MTS", audio=false)
        \ .trim(10, 170)
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
        \ .zoompan(130, -126, 1662, 1328,   0, -230, 1920, 1536)
        \ .devicename(gDeviceNameN900)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_flickable_omnia.MTS", audio=false)
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
        \  DirectShowSource(gMediaDir + "qteverywhere_weatherinfo_5800.MTS", audio=false)
        \ .trim(30, 320)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-316, 276, 1712, 1370,   -572, 72, 2222, 1778)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_weatherinfo_omnia.MTS", audio=false)
        \ .trim(10, 140)
        \ .Tweak(bright = 3)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-228, 346, 1536, 1230,   -484, 142, 2046, 1638)
        \ .devicename(gDeviceNameI900)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "20090316135131_weather.mpg", audio=false)
        \ .trim(0, 90)
        \ .fixMpeg
        \ .devicename(gDeviceNameN900)

    Dissolve(clip_5800, clip_omnia, clip_n900, gLongDissolveLength)
}

function lightmaps
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_lightmaps_5800.MTS", audio=false)
        \ .trim(0, 280)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_lightmaps_omnia.MTS", audio=false)
        \ .trim(20, 300)
        \ .Tweak(bright = 3)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-484, 142, 2046, 1638,   -228, 346, 1536, 1230)
        \ .devicename(gDeviceNameI900)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "20090316122237_maps.mpg", audio=false)
        \ .trim(0, 180)
        \ .fixMpeg
        \ .devicename(gDeviceNameN900)

    Dissolve(clip_5800, clip_omnia, clip_n900, gLongDissolveLength)
}

function raycasting
{
    clip_5800 =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_5800.MTS", audio=false)
        \ .trim(0, 310)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-572, 72, 2222, 1778,   -316, 276, 1712, 1370)
        \ .devicename(gDeviceNameXP5800)

    clip_omnia =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_omnia.MTS", audio=false)
        \ .trim(0, 240)
        \ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-228, 346, 1536, 1230,   -484, 142, 2046, 1638)
        \ .devicename(gDeviceNameI900)

    clip_n95 =
        \  DirectShowSource(gMediaDir + "qteverywhere_raycasting_n95.MTS", audio=false)
        \ .trim(0, 240)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
        \ .zoompan(-472, 152, 2022, 1618,   -282, 302, 1644, 1316)
        \ .devicename(gDeviceNameN95)

    clip_n900 =
        \  DirectShowSource(gMediaDir + "20090316121654_raycasting1.mpg", audio=false)
        \ .trim(0, 180)
        \ .fixMpeg
        \ .devicename(gDeviceNameN900)

    Dissolve(clip_5800, clip_omnia, clip_n95, clip_n900, gLongDissolveLength)
}

function all
{
    return Dissolve (
        \   textClipLegacy("Qt Everywhere", x = 408, y = 420, align = 8,
        \       backgroundimage = gArtworkDir + "Qt_VideoScreen_Opening.png").killaudio.converttoyv12
        \ , textClipLegacy("Cross-platform deployment\non mobile devices", x = 408, y = 385, align = 8,
        \       backgroundimage = gArtworkDir + "Qt_VideoScreen_Opening.png").killaudio.converttoyv12
        \ , textClipLegacy("Symbian / S60\nMaemo / Linux X11\nWindows Mobile", x = 408, y = 360, align = 8,
        \       backgroundimage = gArtworkDir + "Qt_VideoScreen_Opening.png").killaudio.converttoyv12
        \ , textClipLegacy("", 20,
        \       backgroundimage = gArtworkDir + "Qt_VideoScreen_Title.png").killaudio.converttoyv12
        \ , demoTitle("'Ray casting'")
        \ , raycasting
        \ , demoTitle("'OpenStreetMap viewer'")
        \ , lightmaps
        \ , demoTitle("'Weather info'")
        \ , weatherinfo
        \ , demoTitle("'Digital clock'")
        \ , digiflip
        \ , demoTitle("'Kinetic scrolling'")
        \ , flickable
        \ , ImageSource(gArtworkDir + "Qt_VideoScreen_Closing.png", end = 100).converttoyv12
        \ , gDissolveLength).oldStyle.FadeIO(10)
}

AudioDub(all, WavSource(gMediaDir + "ANW1214_05_Fast-Track.wav").FadeOut(num_frames = 25, fps = 25))
#flickable
