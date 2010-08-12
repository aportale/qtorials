# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin ("qtavisynth.dll")
LoadPlugin ("c:\Program Files\DGAvcDecode\DGAVCDecode.dll")
Import("tools.avsi")

global withAudio = false

global gClipWidth = (withAudio ? 1920 : 960)
global gClipHeight = (withAudio ? 1080 : 720)

function RawFootage()
{
    AVCSource(gMediaDir + "roberto\cppfrontend_tsdoctor_merged.dga")
#    withAudio ? AudioDub(DirectShowSource(gMediaDir + "roberto\cppfrontend_tsdoctor_merged PID 1100 2_0ch 48KHz 256Kbps DELAY -80ms.ac3")).GetLeftChannel.SSRC(44100, false) : NOP
}

function RawClippedFootage()
{
    clip = RawFootage()
    clip.trim(2625, 10100) + clip.trim(11300, 0)
}

function TweakedFootage()
{
    RawClippedFootage()
    TemporalSoften(2, 4, 4, mode = 2)
    Lanczos4Resize(gClipWidth, gClipHeight, 386, 166, 1182, 886)
    Levels(0, 0.75, 180, 0, 255)
    Sharpen(0.1)
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
        \ , text("The D Programming Language", 90)
        \ , withAudio ? RawClippedFootage : TweakedFootage
        \ , gDissolveLength
    \)
    QtorialsElements("qtlogosmall")
    FadeIO(gDissolveLength)
}

completeclip

