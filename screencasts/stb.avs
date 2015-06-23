LoadPlugin("ffms2.dll")
LoadPlugin("qtavisynth.dll")
LoadPlugin("SmoothDeinterlacer.dll")
LoadPlugin("WhiteBalance.dll")
Import("tools.avsi")

global gClipWidth = 1920
global gClipHeight = 1080
global gTextClipFramesPerCharacter = 3
global gMediaPrefix = gMediaDir + "stb_"
global raw = FFVideoSource(gMediaPrefix + "00011.MTS").SmoothDeinterlace(tff = false).AssumeFps(25).WhiteBalance(r1=183, g1=204, b1=255, r2=1, g2=3, b2=10).TemporalSoften(3, 5, 8)
# global raw = AviSource(gMediaPrefix + "00011.avi")
global rawScreencast = FFVideoSource(gMediaPrefix + "screencast.mov").convertToYV12
# global rawScreencast = DirectShowSource(gMediaPrefix + "screencast.avi").convertToYV12

function titleAndClip(String titleText, clip theClip)
{
    Dissolve(textClip(titleText).convertToYV12.killAudio.FadeIn(8, color = $ffffff), theClip, gDissolveLength)
}

function intro
{
    textClip("Qt 5.4 with QML\non a set-top box", 175).convertToYV12.killAudio
}

function qtcDevelopment
{
    cut =
    \   rawScreencast.trim(800, 3700).SelectEvery(16, 0).AssumeFps(25) [* Editing EGB in Qt Quick Designer *]
    \ + rawScreencast.trim(3840, 4080)                                 [* EPG launches on Desktop *]
    titleAndClip("Development of an EPG\nin Qt Creator", cut)
}

function epgdemo
{
    launching =
    \   rawScreenCast.trim(4225, 4288)                                   [* Switching Kit *]
    \ + rawScreenCast.trim(4355, 4385)                                   [* Pressing Play *]
    \ + rawScreenCast.trim(4411, 4800).SelectEvery(8, 0).AssumeFps(25)   [* Compiling *]
    running =
    \   raw.trim(3830 * 2, 4200 * 2)   [* EPG demo *]
    cut = Dissolve(launching, running, gDissolveLength)
    titleAndClip("EPG demo running\non a set-top box", cut)
}

function qtfdcdemo
{
    cut =
    \   raw.trim(840 * 2, 937 * 2)     [* "Boot 2 Qt" demo starts, first screenshot pulsates *]
    \ + raw.trim(1010 * 2, 1220 * 2)   [* Go to funny EPG and launch it. TV is ready. *]
    \ + raw.trim(1570 * 2, 1870 * 2)   [* Hand with remote zaps programs. *]
    titleAndClip("'Boot 2 Qt' demo\nrunning on a set-top box", cut)
}

function outro
{
    textClip("Call us if you are interested\nin something similar").convertToYV12.killAudio
}

function completeclip
{
    sequence = Dissolve(
        \   intro
        \ , qtcDevelopment
        \ , epgdemo
        \ , qtfdcdemo
        \ , outro
        \ , gDissolveLength)

    qtlogo = ImageSource("qt_logo_small_1920x1080.png", pixel_type = "RGB32")

    return sequence.Overlay(qtlogo, opacity = 0.65, mask = qtlogo.ShowAlpha).FadeIO(gDissolveLength)
}

completeclip

#raw
#rawScreencast
#intro
#qtcDevelopment
#epgdemo
#qtfdcdemo
#outro
