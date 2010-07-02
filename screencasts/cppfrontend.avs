# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global withAudio = false

global gClipWidth = (withAudio ? 1920 : 960)
global gClipHeight = (withAudio ? 1080 : 720)

function RawFootage
{
    clip = SegmentedDirectShowSource(gMediaDir + "roberto_remuxed/cppfrontend.MTS", audio = withAudio)
    Dissolve(clip.trim(2625, 10100), clip.trim(11300, 179300), gDissolveLength)
    # 2625 - 10100, 11300, 179300
}

function TweakedFootage
{
    RawFootage
    TemporalSoften(2, 4, 2, mode = 2)
    Lanczos4Resize(gClipWidth, gClipHeight, 386, 166, 1182, 886)
    Levels(0, 0.75, 180, 0, 255)
    Sharpen(0.1)
}

function completeclip
{
    Dissolve(
        \   textClip("Roberto Raggi\nNokia, Qt Development Frameworks", 90).Converttoyv12.killaudio
        \ , textClip("The D Programming Language", 90).Converttoyv12.killaudio
        \ , (withAudio ? RawFootage : TweakedFootage.Converttoyv12)
        \ , gDissolveLength
    \   )
    overlayQtorialsElements("qtlogosmall").FadeIO(gDissolveLength)
}

#RawFootage
TweakedFootage