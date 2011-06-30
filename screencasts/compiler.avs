# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin ("qtavisynth.dll")
Import("tools.avsi")

global withAudio = false

global gClipWidth = (withAudio ? 1920 : 960)
global gClipHeight = (withAudio ? 1080 : 720)

global qSourceClipPath = "d:\Compiler\"

function RawFootageA()
{
    DirectShowSource(qSourceClipPath + "clipA.01.MTS")
}

function TweakedFootage(clip)
{
    clip
    crop(410, 0, 600, 980)
    TemporalSoften(2, 4, 4, mode = 2)
    Lanczos4Resize(200, 246)
}

function ScreenRecordingA()
{
    DirectShowSource(qSourceClipPath + "ScreenRecordingA.mov", audio = false)
}

function text(string text, int frames)
{
    textClip(text, frames)
    withAudio != true ? killaudio : NOP
    Converttoyv12
}

function completeclip
{
    Dissolve(
        \   text("Roberto Raggi\nNokia, Qt Development Frameworks", 90)
        \ , withAudio ? RawClippedFootage : TweakedFootage
        \ , gDissolveLength
    \)
    QtorialsElements("qtlogosmall")
    FadeIO(gDissolveLength)
}

#TweakedFootage(RawFootageA)
ScreenRecordingA