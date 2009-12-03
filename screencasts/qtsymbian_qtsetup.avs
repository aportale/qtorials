# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "qtsymbian_qtsetup_narration.wav")
global gAudioNoiseStart = 1 / 44100.0
global gAudioNoiseEnd = 1 / 44100.0
global gClipWidth = 640
global gClipHeight = 360
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Mobile development with\nQt for the Symbian Platform", 75)
        \ , textClip("Setting up Qt for Symbian\nand the Qt SDK for Windows", 80)
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
    audioNoise(1)
\[*
    #n We visit qt.nokia.com
    #t qt.nokia.com
*]
        \ + audioClip(0.034, 2.144, 1)
\[*
    #n There, we click on "Download"...
    #n ...and on the LGPL / Free Tab
*]
        \ + audioClip(2.702, 6.730, 1)
\[*
    #n Now, we choose the Qt libraries for the Symbian Platform and download the installer.
*]
        \ + audioClip(7.415, 12.234, 1)
\[*
    #n The installer will detect our previously installed S60 SDK and install the Qt libraries into it.
*]
        \ + audioClip(12.361, 18.236, 1)
\[*
    #n We keep in mind that we need to install Qt on the same drive on which the S60 SDK was installed.
    #n I add dash 'symbian' to the installation directory in case I want to install Qt for other platforms, later on.
    #t -symbian
*]
        \ + audioClip(18.596, 30.705, 1)
\[*
    #n Qt for Symbian is now installed on the computer.
*]
        \ + audioClip(31.680, 34.443, 1)

        \ + audioNoise(10)
}

function videoQtSymbian_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbiandesktop.avi")
    footage.trim(1, 141)                                                [* Entering Url *]
}

function videoQtSymbian_640x360
{
    setDetailClip(videoQtSymbian_960x720)
    setDetail(0, 0)
    showDetail(75, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(150, -140, 0, 1240, 720)                          [* Page loads *]
}

function qtSymbian
{
    AudioDub(videoWithClipSize("videoQtSymbian").urlSubTitle("qt.nokia.com"), audioNokiaOviSuite).converttorgb32
}

function audioQtSisPackage
{
    audioNoise(1)
\[*
    #n We also want to install Qt on our phone
    #t qt.nokia.com
*]
        \ + audioClip(35.720, 38.275, 1)
\[*
    #n In the folder where we installed Qt for symbian we find a file called 'qt_demos.sis'
    #n That is a one-in all installer which will install...
*]
        \ + audioClip(39.111, 45.032, 1)

        \ + audioNoise(10)
}

function videoQtSisPackage_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbianphone.avi")
    footage.trim(1, 141)                                                [* Entering Url *]
}

function videoQtSisPackage_640x360
{
    setDetailClip(videoQtSisPackage_960x720)
    setDetail(0, 0)
    showDetail(75, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(150, -140, 0, 1240, 720)                          [* Page loads *]
}

function qtSisPackage
{
    AudioDub(videoWithClipSize("videoQtSisPackage"), audioQtSisPackage).converttorgb32
}

function audioQtDemoContent
{
    audioNoise(1)
\[*
    #n The required
    #n POSIX on Symbian, ...
    #n ...Secure Sockets Layer...
    #n ...and the Standard C++ and Boost libraries
    #n The Qt libraries themselves
    #n And 'Fluidluncher', with a set of Qt examples, demonstrating different modules of Qt.
*]
        \ + audioClip(45.380, 62.238, 1)

        \ + audioNoise(10)
}

function videoQtDemoContent
{
    Dissolve(
        \   textClip("", 110)
        \ , textClip("pips_s60_1_6_SS.sis\n\n\n\n", 250)
        \ , textClip("pips_s60_1_6_SS.sis\nopenc_ssl_s60_1_6_SS.sis\n\n\n", 250)
        \ , textClip("pips_s60_1_6_SS.sis\nopenc_ssl_s60_1_6_SS.sis\nSTDCPP_s60_1_6_SS.sis\n\n", 250)
        \ , textClip("pips_s60_1_6_SS.sis\nopenc_ssl_s60_1_6_SS.sis\nSTDCPP_s60_1_6_SS.sis\nqt.sis\n", 250)
        \ , textClip("pips_s60_1_6_SS.sis\nopenc_ssl_s60_1_6_SS.sis\nSTDCPP_s60_1_6_SS.sis\nqt.sis\nfluidlauncher.sis", 250)
        \ , textClip("", 40)
        \ , gDissolveLength)
}

function qtDemoContent
{
    AudioDub(videoQtDemoContent, audioQtDemoContent).converttorgb32
}


function audioSisExecution
{
    audioNoise(1)
\[*
    #n If you have previous versions of Qt or Fluidlauncher on your phone, they need to be uninstalled before proceeding.
    #n Now, we execute the installer, ...
*]
        \ + audioClip(62.854, 71.294, 1)

        \ + audioNoise(10)
}

function videoSisExecution_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbianphone.avi")
    footage.trim(1, 141)                                                [* Entering Url *]
}

function videoSisExecution_640x360
{
    setDetailClip(videoSisExecution_960x720)
    setDetail(0, 0)
    showDetail(75, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(150, -140, 0, 1240, 720)                          [* Page loads *]
}

function sisExecution
{
    AudioDub(videoWithClipSize("videoSisExecution"), audioSisExecution).converttorgb32
}

function audioSisInstallation
{
    audioNoise(1)
\[*
    #n ...confirm the installation on the phone !once! and wait until everything is installed.
*]
        \ + audioClip(73.140, 77.691, 1)
\[*
    #n After the installation, the Fluidlauncher opens, and we can play around a bit with the demos.
*]
        \ + audioClip(80.443, 85.493, 1)

        \ + audioNoise(10)
}

function videoSisInstallation
{
    appTrkInstall = 
        \  DirectShowSource(gMediaDir + "qtsymbian_s60developmentsetup_apptrk.MTS", audio = false)
        \ .trim(220, 380)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(0, 330, 1080, 1280)
        \ .Lanczos4Resize(304, 360)
        \ .addborders(168, 0, 168, 0, $000000)
        \ .converttorgb32
}

function sisInstallation
{
    AudioDub(videoSisInstallation, audioSisInstallation).converttorgb32
}

function audioQtSdk
{
    audioNoise(1)
\[*
    #n Let's now download and install the Qt SDK for Windows which includes QtCreator.
    #n From the Qt download page we get the 'Qt SDK for Windows'...
    #t qt.nokia.com
*]
        \ + audioClip(85.911, 95.013, 1)
\[*
    #n ...and install it.
*]
        \ + audioClip(95.443, 96.418, 1)
\[*
    #n After launching QtCreator, we check...
*]
        \ + audioClip(96.847, 99.331, 1)
\[*
    #n ...Tools...
*]
        \ + audioClip(99.354, 99.993, 1)
\[*
    #n ...Options...
*]
        \ + audioClip(100.167, 100.956, 1)
\[*
    #n ...Qt4...
*]
        \ + audioClip(101.165, 102.141, 1)
\[*
    #n ...Qt Versions...
*]
        \ + audioClip(102.245, 103.255, 1)
\[*
    #n ...to verify if QtCreator correctly detected the S60 SDK and Qt for Symbian.
*]
        \ + audioClip(103.545, 109.095, 1)

        \ + audioNoise(10)
}

function videoQtSdk_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsdkinstall.avi")
    footage.trim(1, 141)                                                [* Entering Url *]
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsdkcheckqtversions.avi")
}

function videoQtSdk_640x360
{
    setDetailClip(videoQtSdk_960x720)
    setDetail(0, 0)
    showDetail(75, 0, 0)                                                 [* Entering Url *]
        \ + showDetail(150, -140, 0, 1240, 720)                          [* Page loads *]
}

function qtSdk
{
    AudioDub(videoWithClipSize("videoSisExecution").urlSubTitle("bit.ly/ovisuite"), audioSisExecution).converttorgb32
}

function audioOutro
{
    audioNoise(1)
\[*
    #n That's it, now we are ready to develop Qt applications for the Symbian Platform.
    #n thanks for watching
*]
        \ + audioClip(110.036, 115.620, 1)

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

qtDemoContent

#converttoyv12