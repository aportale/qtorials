# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

#global gAudioClip = WAVSource(gMediaDir + "sdkinstallation_windows.wav")
#global gAudioNoiseStart = 1829888 / 44100.0
#global gAudioNoiseEnd = 1912832 / 44100.0
global gClipWidth = 640
global gClipHeight = 360

function audioWelcome
{
    #n ...and afterwards take a look at the installed components.
#    a1 = audioNoise(2) + audioClip(4.075, 11.563, 1)

#    return a1 + audioNoise(10)
}

function videoWelcome
{
#    return Dissolve(
#        \   titleTextClip("Qt SDK installation on Windows", 175)
#        \ , titleTextClip("QtDemo, QtCreator, QtLinguist ...", 100)
#        \ , gDissolveLength)
}

function welcome
{
#    return AudioDub(videoWelcome, audioWelcome)
}

function audioDownload
{
    return
\[*
    #n We visit qtsoftware.com,...
    #  In browser address bar, typing in "qtsoftware.com" -> click "Go"
    #t qtsoftware.com
*]
        \   audioNoise(3)
        \ + audioClip(12.387, 14.442, 2)
\[*
    #n ...and go straight to the "Downloads"...
    #  Clicking on "Downloads"
*]
        \ + audioClip(14.843, 16.875, 2)
\[*
    #n ...there, we choose the "LGPL / Free" tab,
    #  Clicking on "LGPL / Free"...
*]
        \ + audioClip(17.339, 20.172, 1)
\[*
    #n ...and click on "Download Qt SDK for Windows",...
    #  Click on "Download Qt SDK for Windows"
*]
        \ + audioClip(20.572, 23.957, 1)

        \ + audioNoise(10)
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg(gArtworkDir + "qtsymbian_s60sdksetup.svg", elementsCsv, gClipWidth, gClipHeight)
    overlayRgbClip(BlankClip(clip, color = $FFFFFF), clip)
}

function videoS60SdksVideo
{
    clip = Dissolve(
        \   svgSnippet("s60logo32", 100)
        \ , svgSnippet("s60logo32, sdk3", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50, myapp50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50, myapp50, phonearrow50, phone50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal", 100)
        \ , gDissolveLength)
        
    clip
}

function videoS60Sdks
{
    return AudioDub(videoS60SdksVideo, videoS60SdksVideo)
}

function completeclip
{
    return
        \ Dissolve(
            \   welcome
            \ , download
            \ , installation
            \ , components
            \ , outro
            \ , gDissolveLength)
        \ .creativeCommons
        \ .oldStyle
        \ .qtLogoSmall
        \ .FadeIO(gDissolveLength)
}

#completeclip
videoS60SdksVideo