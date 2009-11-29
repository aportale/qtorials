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
    #n This video will guide you through the first challenge of software development for the Symbian Platform.
    #n Setting up a Symbian development environment on your Windows PC.
}

function audioOverview
{
    audioNoise(10)
\[*
    #n A Symbian development environment usually consists of...
    #n ...The Nokia Ovi Suite for easy application installation to our phone...
    #n ...Carbide.c++, which is an Eclipse based IDE for Symbian development. We install it for the sake of completeness. In the following, we will use the IDE QtCreator with it's preliminary Symbian support...
    #n ...ActivePerl-5.6.1, build 658. Yes, we need that specific version. Otherwise, the Symbian tool chain might not work...
    #n ...An S60 SDK. It contains the Symbian platform specific tools, header files, libraries, and the cross compiling toolchain for the phone...
    #n ...We also want the an updated "Open C" Plugin. It will be installed on top of the S60 SDK, and later also on our phone...
    #n ...And last but not least, we want to install the 'Application TRK' on our phone. That is needed for on-device debugging and automated deployment...
    #  Slide with components
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Let's start with the Nokia Ovi Suite
    #  Slide with "Nokia Ovi Suite"
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoOverview
{
    Dissolve(
        \   textClip("Overview", 200)
        \ , textClip("", 200)
        \ , textClip("Nokia Ovi Suite\n\n\n\n\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\n\n\n\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\n\n\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\n\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\n", 200)
        \ , textClip("Nokia Ovi Suite\nCarbide.c++\nActivePerl-5.6.1, build 658\nS60 Platform SDK\nOpen C/C++\nApplication TRK", 200)
        \ , textClip("", 200)
        \ , textClip("Nokia Ovi Suite", 200)
        \ , gDissolveLength)
}

function audioNokiaPCSuite
{
    audioNoise(10)
\[*
    #n We visit the Nokia Ovi Suite download site.
    #t bit.ly/ovisuite
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There, we click "Download"...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and and install it.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n If after the installation, we see such an icon, the Nokia Ovi Suite is connected to our device.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioCarbide
{
    audioNoise(10)
\[*
    #n We visit the Carbide.c++ download page at Forum Nokia.
    #t bit.ly/carbidecpp
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There, we click on "Download now"...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and 'oops', we need to login into Forum Nokia. If you do not have an account yet, you can get it through the registration form.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n I am sorry for that. But this is the only registration that you need for Symbian development.
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
    #n After the installation, we start the shortcut called 'Configure environment for WINSCW command line' in order to add s few required environment variables to our system.
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
    #n This is the recommended version by Forum Nokia. Any other perl version might deter the Symbain toolchain from working properly.
    #n When installing it, we make sure that Perl is added to the PATH environment variable.
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
    #n This time, we will get a big .zip file. We need to unzip it somewhere in order to execute the zipped installer.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n If the installer complains about a missing Java Runtime Environment, we don't care.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We need to make sure that we have enough space on the drive where we install the SDK. Qt has to be installed on the same drive, later on.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The installer offers to install the 'CSL Arm Toolchain', which we accept. It is needed to build our applications for the phone.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioOpenC
{
    audioNoise(10)
\[*
    #n We visit the Open C Plugin download site at Forum Nokia.
    #t bit.ly/openc
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There, we click on Download.
    #n And again we ge a .zip file with an installer, inside.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The installer will ask us for the S60 SDK on top of which we want to install the Open C plugin. The preselcted one should be fine.
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