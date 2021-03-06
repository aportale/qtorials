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
global gAudioNoiseStart = 71.787906
global gAudioNoiseEnd = 72.223758
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
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtsymbian_qtsetup.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 200, 40, 1568, 880)
}

function welcome
{
    AudioDub(videoWithClipSize("videoWelcome"), WAVSource(gMediaDir + "qtsymbian_qtsetup.wav"))
        \ .DelayAudio(-1.75)
        \ .Trim(10, 325)
        \ .QtorialsSubtitle("Alessandro Portale", "Nokia, Qt Development Frameworks", 30, 160)
}

function audioQtSymbian
{
    audioNoise(1)
\[*
    #n We visit qt.nokia.com
    #t qt.nokia.com
*]
        \ + audioClip(0.034, 2.144, 1.3)
\[*
    #n There, we click on "Download"...
    #n ...and on the LGPL / Free Tab
*]
        \ + audioClip(2.702, 6.730, 2)
\[*
    #n Now, we choose the Qt libraries for the Symbian Platform and download the installer.
*]
        \ + audioClip(7.415, 12.234, 3)
\[*
    #n The installer will detect our previously installed S60 SDK and install the Qt libraries into it.
*]
        \ + audioClip(12.361, 18.236, 2)
\[*
    #n We keep in mind that we need to install Qt on the same drive on which the S60 SDK was installed.
    #n I add dash 'symbian' to the installation directory in case I want to install Qt for other platforms, later on.
    #t -symbian
*]
        \ + audioClip(18.596, 30.705, 3.5)
\[*
    #n Qt for Symbian is now installed on the computer.
*]
        \ + audioClip(31.680, 34.443, 1)

        \ + audioNoise(10)
}

function videoQtSymbian_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbiandesktop.avi")
    footage.trim(90, 201)                                                [* Entering Url *]
        \ + footage.trim(235, 425)                                       [* clicking Download/Lgpl. Hover QtSymbian installer *]
        \ + footage.trim(425, 425).loop(80)                              [* Hover QtSymbian installer *]
        \ + footage.trim(425, 445)                                       [* Download QtSymbian installer *]
        \ + footage.trim(445, 6470).selectevery(100).assumefps(25)       [* Timelapse Installation until S60 SDK step *]
        \ + footage.trim(6470, 6500)                                     [* S60 SDK step *]
        \ + footage.trim(6500, 6500).loop(100)                           [* S60 SDK step *]
        \ + footage.trim(6500, 6560)                                     [* S60 SDK step. Destination Path step. *]
        \ + footage.trim(6560, 6560).loop(100)                           [* Destination Path step *]
            \ .QtorialsHighlight(267, 386, 22, 24, 20, 100)
        \ + footage.trim(6560, 6692)                                     [* Destination Path step *]
        \ + footage.trim(6692, 6692).loop(90)                            [* Destination Path step *]
        \ + footage.trim(6692, 12495).selectevery(110).assumefps(25)     [* Timelapse til End *]
        \ + footage.trim(12495, 12495).loop(115)                         [* End *]
}

function videoQtSymbian_640x360
{
    videoQtSymbian_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                   0,    0,       -1,   -1                      [* Entering Url *]
        \ ,   84,  -1,       -1,   -1,       -1,   -1                      [* Page loads *]
        \ ,  140,  -1,      150,   85,       -1,   -1                      [* Clicking Download/Lgpl *]
        \ ,  230,  -1,       -1,   -1,       -1,   -1                      [* Scrolling Down *]
        \ ,  310,  -1,      320,   88,       -1,   -1                      [* Clicking link *]
        \ ,  410,  -1,       -1,   -1,       -1,   -1                      [* Installation til SDK step *]
        \ ,  480,  -1,      164,  172,       -1,   -1                      [* SDK step, Destination step *]
        \ ,  940,  -1,       -1,   -1,       -1,   -1                      [* Finishing Installation *]
        \ , 1060,  -1,       43,   57,       -1,   -1                      [* End *]
        \ )
}

function qtSymbian
{
    AudioDub(videoWithClipSize("videoQtSymbian").urlSubTitle("qt.nokia.com"), audioQtSymbian).converttorgb32
}

function audioqtDemoSisPackage
{
    audioNoise(1)
\[*
    #n We also want to install Qt on our phone
    #t qt.nokia.com
*]
        \ + audioClip(35.720, 38.275, 1.3)
\[*
    #n In the folder where we installed Qt for symbian we find a file called 'qt_demos.sis'
*]
        \ + audioClip(39.111, 45.032, 1)
\[*
    #n That is a one-in all installer which will install...
*]
        \ + audioClip(45.404, 47.799, 1)

        \ + audioNoise(10)
}

function videoqtDemoSisPackage_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbianphone.avi")
    footage.trim(60, 60).loop(40)                                         [* Explorer open *]
        \ + footage.trim(60, 223)                                         [* Navigating to qt_demos.sis *]
        \ + footage.trim(223, 223).loop(157)                              [* Navigating to qt_demos.sis *]
            \ .QtorialsHighlight(346, 470, 84, 18, 0, 157)
}

function videoqtDemoSisPackage_640x360
{
    videoqtDemoSisPackage_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                 126,   12,      809,  455                      [* Explorer open *]
        \ ,   70,  -1,      304,   12,       -1,   -1                      [* Navigating to qt dir *]
        \ ,  170,  -1,      304,  268,       -1,   -1                      [* Pointer on qt_demos.sis *]
        \ )
}

function qtDemoSisPackage
{
    AudioDub(videoWithClipSize("videoqtDemoSisPackage"), audioqtDemoSisPackage).converttorgb32
}

function audioqtDemoSisContent
{
    audioNoise(0.7)
\[*
    #n The required
    #n POSIX on Symbian, ...
    #n ...Secure Sockets Layer...
    #n ...and the Standard C++ and Boost libraries
    #n The Qt libraries themselves
    #n And 'Fluidluncher', with a set of Qt examples, demonstrating different modules of Qt.
*]
        \ + audioClip(48.011, 62.238, 1)

        \ + audioNoise(10)
}

function videoqtDemoSisContent
{
    Dissolve(
        \   textClip("", 45)
        \ , textClip("pips.sis\n\n\n\n", 50)
        \ , textClip("pips.sis\nopenc_ssl.sis\n\n\n", 55)
        \ , textClip("pips.sis\nopenc_ssl.sis\nSTDCPP.sis\n\n", 70)
        \ , textClip("pips.sis\nopenc_ssl.sis\nSTDCPP.sis\nqt.sis\n", 55)
        \ , textClip("pips.sis\nopenc_ssl.sis\nSTDCPP.sis\nqt.sis\nfluidlauncher.sis", 150)
        \ , textClip("", 20)
        \ , gDissolveLength)
}

function qtDemoSisContent
{
    AudioDub(videoqtDemoSisContent, audioqtDemoSisContent).converttorgb32
}

function audioqtDemoSisExecution
{
    audioNoise(1)
\[*
    #n If you have previous versions of Qt or Fluidlauncher on your phone, they need to be uninstalled before proceeding.
    #n Now, we execute the installer, ...
*]
        \ + audioClip(62.854, 71.294, 1)

        \ + audioNoise(10)
}

function videoqtDemoSisExecution_960x720
{
    footage = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsymbianphone.avi")
    footage.trim(240, 240).loop(200)                                     [* On qt_demos.sis *]
        \ + footage.trim(240, 260)                                       [* Installing qt_demos.sis *]
        \ + footage.trim(320, 430)                                       [* Installing qt_demos.sis *]
}

function videoqtDemoSisExecution_640x360
{
    videoqtDemoSisExecution_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                 304,  268,       -1,   -1                      [* Zoomed on qt_demos.sis *]
        \ ,  150,  75,       -1,   -1,       -1,   -1                      [* Zoom out *]
        \ ,  250,  -1,      100,  170,       -1,   -1                      [* End *]
        \ )
}

function qtDemoSisExecution
{
    AudioDub(videoWithClipSize("videoqtDemoSisExecution"), audioqtDemoSisExecution).converttorgb32
}

function audioqtDemoSisInstallation
{
    audioNoise(3)
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

function videoqtDemoSisInstallation
{
    croppedWidth = 1080
    croppedHeight = 1280
    ratio = float(croppedWidth) / float(croppedHeight)
    scaledHeight = gClipHeight
    scaledWidth = int(scaledHeight * ratio) + 1
    bordersSide = (gClipWidth - scaledWidth) / 2

    qtInstall =
        \  DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qt.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .tweak(bright = 17)
        \ .turnright()
        \ .crop(0, 330, croppedWidth, croppedHeight)
        \ .Lanczos4Resize(scaledWidth, scaledHeight)
        \ .addborders(bordersSide, 0, bordersSide, 0, $000000)
        \ .converttorgb32
    qtInstall_cut =
        \   qtInstall.trim(100, 260)                                        [* Preparing, Confirming *]
        \ + qtInstall.trim(260, 1881).selectevery(20).assumefps(25)         [* Installing *]

    fluidLauncherInstall =
        \  DirectShowSource(gMediaDir + "qtsymbian_qtsetup_fluidlauncher.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .tweak(bright = 17)
        \ .turnright()
        \ .crop(0, 330, croppedWidth, croppedHeight)
        \ .Lanczos4Resize(scaledWidth, scaledHeight)
        \ .addborders(bordersSide, 0, bordersSide, 0, $000000)
        \ .converttorgb32
    fluidLauncherInstall_cut =
        \   fluidLauncherInstall.trim(1, 265).selectevery(10).assumefps(25) [* Installing Fluidlauncher *]
        \ + fluidLauncherInstall.trim(265, 370)                             [* Using Fluidlauncher *]
        \ + fluidLauncherInstall.trim(495, 700)                             [* Playing Raycasting *]
        \ + fluidLauncherInstall.trim(700, 700).loop(35)                    [* End *]

    Dissolve(qtInstall_cut, fluidLauncherInstall_cut, gDissolveLength)
}

function qtDemoSisInstallation
{
    AudioDub(videoqtDemoSisInstallation, audioqtDemoSisInstallation).converttorgb32
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
        \ + audioClip(95.443, 96.418, 3.5)
\[*
    #n After launching QtCreator, we check...
*]
        \ + audioClip(96.847, 99.331, 0.4)
\[*
    #n ...Tools...
*]
        \ + audioClip(99.354, 99.993, 0.7)
\[*
    #n ...Options...
*]
        \ + audioClip(100.167, 100.956, 0.6)
\[*
    #n ...Qt4...
*]
        \ + audioClip(101.165, 102.141, 0.5)
\[*
    #n ...Qt Versions...
*]
        \ + audioClip(102.245, 103.255, 0.8)
\[*
    #n ...to verify if QtCreator correctly detected the S60 SDK and Qt for Symbian.
*]
        \ + audioClip(103.545, 109.095, 1)

        \ + audioNoise(10)
}

function videoQtSdk_960x720
{
    install = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsdkinstall.avi")
    install_cut =
        \ + install.trim(150, 372)                                      [* Entering Url *]
        \ + install.trim(372, 372).loop(70)                             [* Hover download *]
        \ + install.trim(372, 17600).selectevery(260).assumefps(25)     [* Hover download *]
    check = DirectShowSource(gMediaDir + "qtsymbian_qtsetup_qtsdkcheckqtversions.avi")
    check_cut =
        \   check.trim(15, 15).loop(75)                                 [* Creator open *]
        \ + check.trim(15, 350)                                         [* Going to QtVersions preferences *]
        \ + check.trim(350, 350).loop(65)                               [* Qt version info tooltip *]
    Dissolve(install_cut, check_cut, gDissolveLength)
}

function videoQtSdk_640x360
{
    videoQtSdk_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1                      [* Page loads *]
        \ ,  100,  75,       22,  204,       -1,   -1                      [* Navigate to link *]
        \ ,  305,  -1,       -1,   -1,       -1,   -1                      [* Finish Installation, start Creator *]
        \ ,  460,  -1,        0,    0,       -1,   -1                      [* Going to QtVersions preferences *]
        \ ,  630,  -1,      195,   88,       -1,   -1                      [* End *]
        \ )
}

function qtSdk
{
    AudioDub(videoWithClipSize("videoQtSdk").urlSubTitle("qt.nokia.com"), audioQtSdk).converttorgb32
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
    BlankClipRGB(200)
        \ .QtorialsElements("qtlogobig")
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
            \ , qtSymbian
            \ , qtDemoSisPackage
            \ , qtDemoSisContent
            \ , qtDemoSisExecution
            \ , qtDemoSisInstallation
            \ , qtSdk
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
