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
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Mobile development with\nQt for the Symbian Platform", 75)
        \ , textClip("2 of 3 - Setting up Qt for Symbian\nand the Qt SDK for Windows", 80)
        \ , gDissolveLength)
}

function videoWelcome_960x720
{
    DirectShowSource(gMediaDir + "qtsymbian_qtsetup.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Crop(400, 0, 1280, 960)
        \ .Lanczos4Resize(gClipWidth, gClipHeight)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtsymbian_qtsetup.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Crop(200, 40, 1568, 880)
        \ .Lanczos4Resize(gClipWidth, gClipHeight)
}

function welcome
{
    AudioDub(videoWithClipSize("videoWelcome"), WAVSource(gMediaDir + "qtsymbian_qtsetup.wav"))
        \ .DelayAudio(-1.75)
        \ .Trim(10, 325)
}

function audioQtSymbian
{
    audioNoise(10)
\[*
    #n We visit qt.nokia.com
    #t qt.nokia.com
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There, we click on "Download"...
    #n ...and on LGPL / Free
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Now, we choose the Qt libraries for the Symbian Platform and download the installer.
    #n No authentification is required.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The installer will detect our previously installed S60 SDK and install the Qt libraries into it.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We keep in mind that we need to install Qt on the same drive on which the S60 SDK was installed.
    #n I add dash 'symbian' to the installation directory in case I want to install Qt for other platforms, later.
    #t -symbian
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Qt for Symbian is now installed on the computer.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioQtSisPackage
{
    audioNoise(10)
\[*
    #n We also want to install Qt on our phone
    #t qt.nokia.com
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In the folder where we installed Qt for symbian we find a file called 'qt_demos.sis'
    #n That is a one-in all installer which will install...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The Qt requirements:
    #n That is a one-in all installer which will install:
    #n The required
    #n POSIX on Symbian, ...
    #n ...Secure Sockets Layer...
    #n ...and the Standard C++ and Boost libraries
    #n The Qt libraries themselves
    #n And 'Fluidluncher', with couple of Qt examples, demonstrating different modules of Qt.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n If you have previous versions of Qt or Fluidlauncher on your phone, they need to be uninstalled before proceeding.
    #n Now, we execute the installer, ...
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...confirm the installation on the phone !once! and wait until everything is installed.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n After the installation, the Fluidlauncher opens, and we can play around a bit with the demos.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioQtSdk
{
    audioNoise(10)
\[*
    #n Let's now download and install the Qt SDK for Windows which includes QtCreator.
    #n From the Qt download page we get the 'Qt SDK for Windows'...
    #t qt.nokia.com
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and install it.
*]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n After launching QtCreator, we check Tools...
    #n ...Options...
    #n ...Qt4...
    #n ...Qt Versions...
    #n ...to verify if QtCreator correctly detected the S60 SDK and Qt for Symbian.
\[*
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioOutro
{
    audioNoise(10)
\[*
    #n That's it, now we are ready to develop Qt applications for the Symbian Platform.
\[*
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoOutro
{
    simpleQtorialsElements("qtlogobig", 100)
}

function outro
{
    AudioDub(videoOutro, audioOutro)
}

function completeclip
{
    return
        \ Dissolve(
            \   intro
            \ , welcome.converttorgb
            \ , gDissolveLength)
        \ .overlayQtorialsElements("qtlogosmall, oldstyle")
        \ .FadeIO(gDissolveLength)
#        \ .creativeCommons
}

#completeclip
#videoS60SdksVideo.overlayQtorialsElements("qtlogosmall, oldstyle")
#videoS60Sdks
#videoOverview

completeclip

#converttoyv12