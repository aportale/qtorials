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
global gClipWidth = 480
global gClipHeight = 360
global gBackgroundColor = $FFFFFF

function welcome
{
    #n Hi, I am Alessandro Portale from Nokia, Qt Development Frameworks.
    #n Qt 4.6 comes with many new features. One very important one is that you can now develop applications for phones running the Symbian Platform.
    #n This video will show you how to set up a Symbian Development environment on your Windows PC.
}

function audioOverview
{
    audioNoise(10)
\[*
    #n Such a development environment usually consists of...
    #n ...Carbide.c++, an Eclipse based IDE, plus some more tools that we need, later..
    #n ...ActivePerl-5.6.1, build 658. Yes, we need that specific version, otherwise, the Symbian tool chain does not work...
    #n ...An S60 Platform SDK. It will contains the Symbian specific header files, libraries, Emulator, and compiler for the device.
    #n ...We also need the "Open C/C++" Plugin. That will be installed on top of the S60 Platform SDK, and we will also install some "Open C" packages to our phone.
    #n ...And last but not lease we need the Nokia PC suite for an easy installation of applications on our phone
    #  Slide with components
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Let's start with Carbide.c++
    #  Slide with "Carbide.c++"
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoOverview
{
    Dissolve(
        \   QtorialsTitle("Carbide.c++\n\n\n\n", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("Carbide.c++\nActivePerl-5.6.1, build 658\n\n\n", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("Carbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\n\n", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("Carbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\n", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("Carbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\nNokia PC Suite", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("", gClipWidth, gClipHeight, 200)
        \ , QtorialsTitle("Carbide.c++", gClipWidth, gClipHeight, 200)
        \ , gDissolveLength)
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg("qtsymbian_s60developmentsetup.svg", elementsCsv, gClipWidth, gClipHeight)
    overlayRgbClip(BlankClip(clip, color = gBackgroundColor), clip)
}

function videoS60SdksVideo
{
    clip = Dissolve(
        \   svgSnippet("s60logo32", 100)
        \ , svgSnippet("s60logo32, sdk3", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50, division", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50, division, myapp50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, phonearrow32, phone32, s60sdk50, division, myapp50, phonearrow50, phone50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal, phonearrowsuniversal", 100)
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
#videoS60SdksVideo.overlayQtorialsElements("qtlogosmall, oldstyle")
videoOverview

overlayQtorialsElements("qtlogosmall, oldstyle")