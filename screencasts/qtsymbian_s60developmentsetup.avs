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

function welcome
{
    #n Hi, I am Alessandro Portale from Nokia, Qt Development Frameworks.
    #n Qt 4.6 comes with many new features. One of them is that you can now develop applications for phones which run the Symbian platform.
    #n This first of three videos will guide you through the most challenging part of Qt for Symbian development:
    #n That is: how to set up a Symbian Development environment on your Windows PC.
}

function audioOverview
{
    audioNoise(10)
\[*
    #n Here an overview:
    #n A Symbian development environment usually consists of...
    #n ...The Nokia PC suite for an easy installation of applications on our phone...
    #n ...Carbide.c++, an Eclipse based IDE. We will just install it for the completeness. But, in the following, we use QtCreator with it's preliminary Symbian support as our IDE...
    #n ...ActivePerl-5.6.1, build 658. Yes, we need that specific version, otherwise, the Symbian tool chain does not work...
    #n ...An S60 Platform SDK. It contains the Symbian specific header files, libraries, and the cross compiling toolchain compiler for the device...
    #n ...We also want the "Open C/C++" Plugin. It will be installed on top of the S60 Platform SDK, and later also to our phone...
    #n ...And last but not least, we want to install the 'Application TRK' on our phone. That is needed for on-device debugging and automated deployment...
    #  Slide with components
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Let's start with the Nokia PC Suite
    #  Slide with "Nokia PC Suite+"
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoOverview
{
    Dissolve(
        \   textClip("Overview", 200)
        \ , textClip("", 200)
        \ , textClip("Nokia PC Suite\n\n\n\n\n", 200)
        \ , textClip("Nokia PC Suite\nCarbide.c++\n\n\n\n", 200)
        \ , textClip("Nokia PC Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\n\n\n", 200)
        \ , textClip("Nokia PC Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\n\n", 200)
        \ , textClip("Nokia PC Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\n", 200)
        \ , textClip("Nokia PC Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\nApplication TRK", 200)
        \ , textClip("", 200)
        \ , textClip("Nokia PC Suite", 200)
        \ , gDissolveLength)
}

function audioNokiaPCSuite
{
    audioNoise(10)
\[*
    #n We visit the Nokia PC suite download site.
    #t bit.ly/nokiapcsuite
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n On the bottom of the page we click "Download"...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and and install it.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n If we see this icon, the nokia PC suite is running and our device is connected.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioCarbide
{
    audioNoise(10)
\[*
    #n We visit the Carbide c++ Download page at Forum Nokia.
    #t bit.ly/carbidecpp
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We click on "Download now"...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and 'oops', we need to login into Forum Nokia. If you do not have an account yet, you can get it through the registration form.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n I am sorry for that. And I promise that this will be the only account that you need to create in order to use Symbian.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n After logging in we need to click that file name link to download Carbide c++.
    #t qtsymbiandeveloper
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n During the installation we can leave all settings as they are.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n After the installation, we start the shortcut called 'Configure environment for WINSCW command line' in order to add the required environment variables to our system.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioS60Sdk
{
    audioNoise(10)
\[*
    #n We visit the S60 SDK download site at Forum Nokia.
    #t bit.ly/s60sdk
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We have the choice between three SDKs... Now, which is the one for us?
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Normally, we use a specific S60 SDK, for example third edition... feature pack 2 to build our application.
    #n And that application would run on a S60 third edition, feature pack 2 based phone.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Or we would use the S60 SDK fifth edition to build our application and run that on a phone with S60 fifth edition.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n But in effect, since we will use the Qt Api, all those version differences do not matter. Our Qt application can be built with any S60 SDK since the third edition featurepack 1.
    #n And we can run our application on any S60 phone with at least the 3rd edition feature pack 1.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n That means that we have a free choice, here. I simply chose the fifth edition and click on Download.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We need to make sure that we have enough space on the drive where we install the SDK. We will need to install Qt on the same drive, later on.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioActivePerl
{
    audioNoise(10)
\[*
    #n We visit the ActiveState Download page of Active Perl 5.6.
    #t bit.ly/activeperl56
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There, we chose the version 5.6.1, build 635...
    #n ...and install it.
    #n This is the recommended version by Forum Nokia. Any other perl version might deter the Symbain toolchain from working properly.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg("qtsymbian_s60developmentsetup.svg", elementsCsv, gClipWidth, gClipHeight)
    overlayRgbClip(BlankClip(clip, color = gBackgroundColor), clip)
}

function videoS60Sdks
{
    clip = Dissolve(
        \   svgSnippet("", 100)
        \ , svgSnippet("s60logo32", 100)
        \ , svgSnippet("s60logo32, sdk3", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50s60", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32s60, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50s60, phonearrow50, phone50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, myapp32, myapp32qt, phonearrow32, phone32, s60sdk50, division, myapp50, myapp50qt, phonearrow50, phone50", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal", 100)
        \ , svgSnippet("s60logo32, sdk3, fp2, phone32, s60sdk50, phone50, myappuniversal, phonearrowsuniversal", 100)
        \ , gDissolveLength)

    clip
}

function S60Sdks
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
#videoS60Sdks
videoOverview

overlayQtorialsElements("qtlogosmall, oldstyle")

#converttoyv12