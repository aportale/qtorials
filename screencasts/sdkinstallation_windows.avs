# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "sdkinstallation_windows.wav")
global gAudioNoiseStart = 4501384 / 44100.0
global gAudioNoiseEnd = 4513940 / 44100.0
global gClipWidth = 640
global gClipHeight = 360

function audioWelcome
{
    #n Let's download and install the Qt SDK for Windows...
    #n ...and afterwards take a short look at the installed components.
    a1 = audioNoise(2) + audioClip(00.533, 07.247, 1)

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
    #n We visit the Qt website...
    #  In browser address bar, typing in "qtsoftware.com" -> click "Go"
    #t qtsoftware.com
*]
        \   audioNoise(2.5)
        \ + audioClip(07.671, 09.654, 1)
\[*
    #n ...and go straight to the "Downloads"...
    #  Clicking on "Downloads"
*]
        \ + audioClip(10.151, 12.184, 0.3)
\[*
    #n ...there, we choose the "LGPL / Free" tab,
    #  Clicking on "LGPL / Free"...
*]
        \ + audioClip(12.797, 15.615, 0.4)
\[*
    #n ...click on "Download Qt SDK for Windows",...
    #  Click on "Download Qt SDK for Windows"
*]
        \ + audioClip(16.209, 18.965, 1)
\[*
    #n ...and save the installer to the disk.
    #  Save 
*]
        \ + audioClip(19.360, 21.371, 1)

        \ + audioNoise(10)
}

function videoDownload
{
    footage = DirectShowSource(gMediaDir + "sdkinstallation_windows_download.avi")
    
    return
        \   footage.trim(   25,   167)                  [* Entering Url + go *]
        \ + footage.trim(  225,   272)                  [* Click on 'Download' *]
        \ + footage.trim(  300,   397)                  [* Click on installer *]
        \ + footage.trim(  397,   397).loop(40)         [* still clicking on installer *]
        \ + footage.trim(  397,   420)                  [* Download redirect *]
        \ + footage.trim(  490,   625)                  [* Save file *]
}

function download
{
    return AudioDub(videoDownload, audioDownload)
}

function audioInstallation
{
    return
\[*
    #n We execute the installer...
    #  Starting installer from downloaded files
*]
        \ + audioNoise(2) + audioClip(21.856, 23.893, 1)
\[*
    #n ...and go through the installation wizard.
    #  Next, yes, next...
*]
        \ + audioClip(27.200, 29.176, 2)
\[*
    #n Now, it will take a minute or two before the Qt SDK is installed.
    #  installation progress / cut / Click finish
*]
        \ + audioClip(29.463, 33.442, 1)

        \ + audioNoise(10)
}

function videoInstallation
{
    footage = DirectShowSource(gMediaDir + "sdkinstallation_windows_installation.avi")

    startingInstaller =
        \   footage.trim(  230,   330)                  [* Starting installer *]
    wizard =
        \ (footage.trim( 2860, 3360)                    [* Going through wizard (2x time lapse) *]
            \ . SelectEvery(2, 1)
            \ . AssumeFps(25))
    finishingInstaller =
        \ (footage.trim( 5915, 6035)                    [* Finishing installer (2x time lapse) *]
            \ . SelectEvery(2, 1)
            \ . AssumeFps(25))

    return Dissolve(startingInstaller, wizard, finishingInstaller, gDissolveLength)
}

function installation
{
    return AudioDub(videoInstallation, audioInstallation)
}

function audioComponentQtdemo
{
    return
\[*
    #n The installer created a program group called "Qt SDK by Nokia".
    #  Start->All Programs->Mouse on program group
*]
        \ + audioNoise(1) + audioClip(34.132, 38.480, 2)
\[*
    #n The Qt Demo is a collection of examples which showcase different parts of the Qt application framework.
*]
        \ + audioClip(67.697, 74.696, 2)
\[*
    #n Some of these examples are really fancy. And of course we can study all their source codes.
    #  Clicking around some demos, browsing through sources.
*]
        \ + audioClip(74.696, 80.283, 1)

        \ + audioNoise(10)
}

function videoComponentQtdemo
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_qtdemo.avi")

    vectorTransformation =
        \   footage.Trim(    0,   86)                   [* Opening start menu *]
        \ + footage.Trim(   86,   86).loop(40)          [* Resting on 'Qt SDK by Nokia' group *]
        \ + footage.Trim(   86,  125)                   [* Opening and playing with Vector Transformation *]
        \ + footage.Trim(  125,  125).loop(25)          [* Resting on QtDemo *]
        \ + footage.Trim(  125,  415)                   [* Opening and playing with Vector Transformation *]

    spreadSheet =
        \   footage.Trim( 1275, 1450)                   [* Playing with SpreadSheet *]

    return Dissolve(vectorTransformation, spreadSheet, gDissolveLength)
}

function audioComponentQtcreator
{
    return
\[*
    #n Qt Creator is the integrated development environment...
    #n ...that comes with...
    #  Starting Qt Creator
*]
        \ + audioNoise(1) + audioClip(44.967, 50.006, 0)
\[*
    #n ...an advanced C++ code editor...
    #  Quick impressions of code completion based on Gui App made with the wizard
    #t {ENTER}§w.res§{DOWN}§{ENTER}§{DOWN}§640, §480);
*]
        \ + audioClip(50.211, 52.761, 3)
\[*
    #n ...a Drag'n'Drop Gui editor...
    #  Quick impressions of designer
*]
        \ + audioClip(56.363, 58.674, 3)
\[*
    #n ...a debugger...
    #  Quick impressions of the debugger
*]
        \ + audioClip(59.063, 60.301, 3)
\[*
    #n ...and a help system.
    #  Quick impressions of help
*]
        \ + audioClip(61.148, 62.536, 0.5)
\[*
    #n We will do most of the application development in Qt Creator.
*]
        \ + audioClip(63.697, 67.280, 1)

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
        \   footageEditor.Trim(   85,   134)            [* Starting Qt Creator *]
        \ + footageEditor.Trim(  180,   400)            [* Qt Creator shows up, completion example *]

    return Dissolve(
        \   editor
        \ , footageDesigner.Trim(25, 150)               [* Adding textedit and rediobuttons to form *]
        \ , footageDebugger.Trim(75, 175)               [* Adding breakpoints and start debugging *]
        \ , footageDebugger.Trim(510, 580)              [* Showing contents of QStringList *]
        \ , footageHelp.Trim(60, 225)                   [* Jumping to aboutToActivate *]
        \ , gDissolveLength)
}

function audioComponentLinguist
{
    return
\[*
    #n Qt Linguist is the language translation tool.
    #n It can be used by translation specialists to create or maintain multiple languages for our applications.
    #  Some clicks through Linguist
*]
        \ audioNoise(1.5) + audioClip(84.918, 95.720, 1)

        \ + audioNoise(10)
}

function videoComponentLinguist
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_linguist.avi")

    return footage.Trim(62, 425)
}

function audioComponentCommandprompt
{
    return
\[*
    #n The Qt Command prompt has a fully set up environment for advanced tasks in the command line.
    #t qmake --version{ENTER}
*]
        \ audioNoise(1) + audioClip(38.787, 44.489, 1)

        \ + audioNoise(10)
}

function videoComponentCommandprompt
{
    footage =
        \   DirectShowSource(gMediaDir + "sdkinstallation_windows_components_commandprompt.avi")

    return
        \   footage.Trim(86, 243)                       [* Typing in qmake --v *]
        \ + footage.Trim(244, 244).Loop(24)             [* Cursor blink white *]
        \ + footage.Trim(243, 243).Loop(24)             [* Cursor blink black *]
        \ + footage.Trim(244, 244).Loop(24)             [* Cursor blink white *]
}

function videoComponents_960x720
{
    return Dissolve(
        \   AudioDub(videoComponentQtdemo, audioComponentQtdemo)
        \ , AudioDub(videoComponentQtcreator, audioComponentQtcreator)
        \ , AudioDub(videoComponentLinguist, audioComponentLinguist)
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
        \ + showDetail(fullscreen,     1690 - 1610, 207, 73)                [* Linguist action *]
}

function audioComponents
{
    return videoComponents.killAudio
}

function components
{
    return AudioDub(videoWithClipSize("videoComponents"), audioComponentQtdemo)
}

function audioOutro
{
    #n Now, that the Qt SDK is installed, we should continue with the other Qtorials :)

    return audioNoise(1) + audioClip(96.123, 141.674, 1)
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
        \ .oldStyle
        \ .qtLogoSmall
        \ .creativeCommons
        \ .FadeIO(gDissolveLength)
}

videoComponents_640x360
#videoComponents_960x720
#titleTextClip("Qt SDK installation on Windows").oldStyle.FadeIO(gDissolveLength)
