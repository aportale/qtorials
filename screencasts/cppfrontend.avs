# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global withAudio = true

global gClipWidth = (withAudio ? 1920 : 960)
global gClipHeight = (withAudio ? 1080 : 720)

function TweakedFootage(clip raw)
{
    withAudio ? raw.GetLeftChannel :
    \ raw
    \ . TemporalSoften(2, 4, 2, mode = 2)
    \ . Lanczos4Resize(gClipWidth, gClipHeight, 386, 166, 1182, 886)
    \ . Levels(0, 0.75, 180, 0, 255)
    \ . Sharpen(0.1)
}

function CutFootage()
{
    TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.01.MTS", audio = withAudio).trim(2625, 10100))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.01.MTS", audio = withAudio).trim(11300, 0))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.02.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.03.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.04.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.05.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.06.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.07.MTS", audio = withAudio))
    \ + TweakedFootage(DirectShowSource(gMediaDir + "roberto/cppfrontend.08.MTS", audio = withAudio))
}

function completeclip
{
    Dissolve(
        \   textClip("Roberto Raggi\nNokia, Qt Development Frameworks", 90).Converttoyv12.killaudio
        \ , textClip("The D Programming Language", 90).Converttoyv12.killaudio
        \ , TweakedFootage
        \ , gDissolveLength
    \   )
    overlayQtorialsElements("qtlogosmall").FadeIO(gDissolveLength)
}

#RawFootage
#TweakedFootage
CutFootage