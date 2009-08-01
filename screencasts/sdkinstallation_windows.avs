# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

SetMemoryMax(64)

global gAudioClip = WAVSource(gMediaDir + "sdkinstallation_windows.wav")
global gAudioNoiseStart = 1829888 / 44100.0
global gAudioNoiseEnd = 1912832 / 44100.0
global gClipWidth = 960
global gClipHeight = 720

function audioWelcome
{
    #n Let's download and install the Qt SDK for Windows...
    #n ...and afterwards take a look at the installed components.
    a1 = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a1 + audioNoise(10)
}

function videoWelcome
{
    return Dissolve(
        \   titleTextClip("Qt SDK installation on Windows", 175)
        \ , titleTextClip("QtDemo, QtCreator, QtLinguist ...", 100)
        \ , gDissolveLength)
}

function welcome
{
    return AudioDub(videoWelcome, audioWelcome)
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

function videoDownload
{
    footage = DirectShowSource(gMediaDir + "sdkinstallation_windows_download_installation.avi")

    return
        \   footage.trim(   85,   217)                  [* Entering Url + go *]
        \ + footage.trim(  257,   520)                  [* Navigating to download *]
        \ + footage.trim(  520,   520).loop(35)         [* Clicking download *]
        \ + footage.trim(  520,   547)                  [* Clicked download *]
        \ + footage.trim(  627,   755)                  [* Save file *]
}

function download
{
    return AudioDub(videoDownload, audioDownload)
}

function audioInstallation
{
    return
\[*
    #n We launch the installer...
    #  Starting installer from downloaded files
*]
        \ + audioNoise(2) + audioClip(27.184, 28.496, 1)
\[*
    #n ...and go through the installation wizard.
    #  Next, yes, next...
*]
        \ + audioClip(28.757, 30.841, 1.5)
\[*
    #n It will take a minute or two before the Qt SDK is installed.
    #  installation progress / cut / Click finish
*]
        \ + audioClip(31.306, 34.487, 1)

        \ + audioNoise(10)
}

function videoInstallation
{
    footage = DirectShowSource(gMediaDir + "sdkinstallation_windows_download_installation.avi")

    startingInstaller =
        \  footage.trim( 1160,   1240)                  [* Launching installer *]
    wizard =
        \ (footage.trim( 2950, 3400)                    [* Going through wizard (2x time lapse) *]
            \ . SelectEvery(2, 1)
            \ . AssumeFps(25))
    finishingInstaller =
        \ (footage.trim( 3555, 3860)                    [* Finishing installer (2x time lapse) *]
            \ . SelectEvery(2, 1)
            \ . AssumeFps(25))

    return Dissolve(startingInstaller, wizard, finishingInstaller, gDissolveLength)
}

function installation
{
    return AudioDub(videoInstallation, audioInstallation)
}

function audioComponentsIntro
{
    return
\[*
    #n And now let's look at the components that have been installed
    #  "
*]
        \ audioNoise(1) + audioClip(36.861, 40.559, 1)

        \ + audioNoise(10)

}

function videoComponentsIntro
{
    return textClip("QtDemo, QtCreator, QtLinguist ...", 150)
}

function audioComponentQtdemo
{
    return
\[*
    #n The Qt Demo consists of examples which demonstrate different parts of the Qt framework.
*]
        \ audioNoise(2.5) + audioClip(61.324, 68.522, 3.5)
\[*
    #n Some of these examples are really fancy. And of course, their complete source code is included in the Qt SDK.
    #  Clicking around some demos, browsing through sources.
*]
        \ + audioClip(69.637, 76.115, 1)

        \ + audioNoise(10)
}

function videoComponentQtdemo
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtdemo.avi")

    vectorTransformation =
        \   footage.Trim(50, 150).SelectEvery(2).AssumeFps(25)          [* Going to QtDemo shortcut *]
        \ + footage.Trim(151, 175)                                      [* Launching QtDemo *]
        \ + footage.Trim(215, 390)                                      [* Opening Vector Transformation *]
        \ + footage.Trim(436, 630)                                      [* Playing with Vector Transformation *]

    spreadSheet =
        \   footage.Trim(850, 990)                                      [* Playing with SpreadSheet *]

    closingQtDemo =
        \   footage.Trim(1165, 1230)                                    [* Closing QtDemo *]

    return Dissolve(vectorTransformation, spreadSheet, closingQtDemo, gDissolveLength)
}

function audioComponentQtcreator
{
    return
\[*
    #n Qt Creator is the integrated development environment, that comes with...
    #  Starting Qt Creator
*]
        \ + audioNoise(1.5) + audioClip(79.006, 84.358, 0.5)
\[*
    #n ...an advanced C++ code editor with smart code completion...
    #  Quick impressions of code completion based on Gui App made with the wizard
    #t {ENTER}§w.res§{DOWN}§{ENTER}§{DOWN}§640, §480);
*]
        \ + audioClip(84.463, 88.677, 5)
\[*
    #n ...a Drag'n'Drop-based Gui designer...
    #  Quick impressions of designer
*]
        \ + audioClip(93.042, 95.283, 5.5)
\[*
    #n ...a debugger that displays Qt datatypes,...
    #  Quick impressions of the debugger
*]
        \ + audioClip(95.771, 99.219, 6)
\[*
    #n ...and an integrated help system.
    #  Quick impressions of help
*]
        \ + audioClip(100.229, 102.354, 1)
\[*
    #n We will do most of the application development in Qt Creator.
*]
        \ + audioClip(106.452, 110.330, 1)

        \ + audioNoise(10)
}

function videoComponentQtcreator
{
    footageEditor =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtcreator_editor.avi")
    footageDesigner =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtcreator_designer.avi")
    footageDebugger =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtcreator_debugger.avi")
    footageHelp =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtcreator_help.avi")

    editor =
        \   footageEditor.Trim(185, 261).SelectEvery(2).AssumeFps(25)   [* Going to QtCreator shortcut *]
        \ + footageEditor.Trim(261, 290)                                [* Clicking QtCreator shortcut *]
        \ + footageEditor.Trim(690, 975)                                [* Qt Creator shows up, completion example *]

    debugger =
        \   footageDebugger.Trim(100, 172)                              [* Adding breakpoint and start debugging *]
        \ + footageDebugger.Trim(260, 460)                              [* Adding breakpoint and start debugging *]

    return Dissolve(
        \   editor
        \ , footageDesigner.Trim(40, 400).SelectEvery(2).AssumeFps(25)  [* Adding radiobuttons to form *]
        \ , debugger
        \ , footageHelp.Trim(60, 320)                                   [* Jumping to QList::takeLast *]
        \ , gDissolveLength)
}

function audioComponentQtlinguist
{
    return
\[*
    #n Qt Linguist is the language translation tool.
    #  Launching Qt Linguist
*]
        \ audioNoise(2) + audioClip(111.839, 115.182, 3)
\[*
    #n It is used by translators to create or maintain multiple languages for applications made with Qt.
    #  Some clicks through Linguist
*]
        \ + audioClip(115.397, 122.079, 1)

        \ + audioNoise(10)
}

function videoComponentQtlinguist
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtlinguist.avi")

    return
        \   footage.Trim(120, 210).SelectEvery(2).AssumeFps(25)     [* Going to QtLinguist shortcut *]
        \ + footage.Trim(210, 210).loop(15)                         [* Mouse on QtLinguist shortcut *]
        \ + footage.Trim(210, 565)                                  [* Playing with Linguist *]
        \ + footage.Trim(605, 685).SelectEvery(2).AssumeFps(25)     [* Closing QtLinguist *]
}

function audioComponentCommandprompt
{
    return
\[*
    #n The Qt Command prompt has a fully set up environment for advanced operations.
    #t qmake --version{ENTER}
*]
        \ audioNoise(3) + audioClip(129.196, 134.455, 1)

        \ + audioNoise(10)
}

function videoComponentCommandprompt
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_commandprompt.avi")

    return
        \   footage.Trim(75, 175).SelectEvery(2).AssumeFps(25)      [* Going to Commandprompt shortcut *]
        \ + footage.Trim(175, 175).loop(15)                         [* Mouse on Commandprompt shortcut *]
        \ + footage.Trim(175, 289)                                  [* Typing in qmake --version *]
        \ + footage.Trim(316, 430)                                  [* Cout out a cursor bink. *]
}

function videoComponents_960x720
{
    return Dissolve(
        \   AudioDub(videoComponentQtdemo, audioComponentQtdemo)
        \ , AudioDub(videoComponentQtcreator, audioComponentQtcreator)
        \ , AudioDub(videoComponentQtlinguist, audioComponentQtlinguist)
        \ , AudioDub(videoComponentCommandprompt, audioComponentCommandprompt)
        \ , gDissolveLength)
}

function videoComponents_640x360
{
    fullscreen = videoComponents_960x720
    setFullScreen(fullscreen)
    return
        \   showFullScreen(fullscreen,   70 -    0)
        \ + showDetail(fullscreen,      205 -   70, 0, 188)                 [* Open Start Menu, with group *]
        \ + showFullScreen(fullscreen,  410 -  205)                         [* Launching QtDemo *]
        \ + showDetail(fullscreen,      660 -  410, 0, 37, 948, 533)        [* Vector Transformation, Spreadsheet *]
        \ + showDetail(fullscreen,      715 -  660, 0, 188)                 [* Open Start Menu, with group *]
        \ + showFullScreen(fullscreen,  805 -  715)                         [* Launching QtCreator *]
        \ + showDetail(fullscreen,      900 -  805, 0, 0)                   [* Code Completion *]
        \ + showFullScreen(fullscreen,  960 -  900)                         [* Designer overview *]
        \ + showDetail(fullscreen,     1015 -  960, 30, 73)                 [* Designer action *]
        \ + showFullScreen(fullscreen, 1080 - 1015)                         [* Debugger overview *]
        \ + showDetail(fullscreen,     1150 - 1080, 190, 104)               [* Debugger action *]
        \ + showFullScreen(fullscreen, 1220 - 1150)                         [* Help overview *]
        \ + showDetail(fullscreen,     1280 - 1220, 0, 122)                 [* Help action1 *]
        \ + showDetail(fullscreen,     1340 - 1280, 320, 0)                 [* Help action1 *]
        \ + showFullScreen(fullscreen, 1370 - 1340)                         [* Help zoom out *]
        \ + showDetail(fullscreen,     1420 - 1370, 0, 188)                 [* Open Start Menu, with group *]
        \ + showFullScreen(fullscreen, 1490 - 1420)                         [* Linguist overview *]
        \ + showDetail(fullscreen,     1610 - 1490, 0, 53, 960, 540)        [* Linguist open translations *]
        \ + showDetail(fullscreen,     1720 - 1610, 207, 73)                [* Linguist action *]
        \ + showDetail(fullscreen,     1770 - 1720, 0, 188)                 [* Open Start Menu, with group *]
        \ + showDetail(fullscreen,     1800 - 1770, 0, 33, 896, 504)        [* Commandprompt action *]
        \ + showDetail(fullscreen,     1940 - 1800, 30, 35)                 [* Commandprompt action *]
}

function audioComponents
{
    return videoComponents_960x720.killAudio
}

function components
{
    return Dissolve(
        \   AudioDub(videoComponentsIntro, audioComponentsIntro)
        \ , AudioDub(videoWithClipSize("videoComponents"), audioComponents)
        \ , gDissolveLength)
}

function audioOutro
{
    #n Now, that the Qt SDK is installed, we should continue with the other Qtorials :)

    return audioNoise(1) + audioClip(144.382, 149.653, 1)
}

function videoOutro
{
    return titleTextClip("...thanks for watching...", 175)
}

function outro
{
    return AudioDub(videoOutro, audioOutro)
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

completeclip
