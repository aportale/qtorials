# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")
Import(gFFDShowImport)

global gAudioClip = WAVSource(gMediaDir + "meet_qtcreator_audio.wav")
global gAudioNoiseStart = 3901479 / 44100.0
global gAudioNoiseEnd = 3920494 / 44100.0

function warp(clip sourceClip, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
{
    return sourceClip
    scaledX3 = String(Round(100.0 / sourceClip.width * x1))
    scaledY3 = String(Round(100.0 - (100.0 / sourceClip.height * y1)))
    scaledX4 = String(Round(100.0 / sourceClip.width * x2))
    scaledY4 = String(Round(100.0 - (100.0 / sourceClip.height * y2)))
    scaledX1 = String(Round(100.0 / sourceClip.width * x3))
    scaledY1 = String(Round(100.0 - (100.0 / sourceClip.height * y3)))
    scaledX2 = String(Round(100.0 / sourceClip.width * x4))
    scaledY2 = String(Round(100.0 - (100.0 / sourceClip.height * y4)))
    coordinates = ("perspectiveX1=" + scaledX1 + ",perspectiveY1=" + scaledY1 + ",perspectiveX2=" + scaledX2 + ",perspectiveY2=" + scaledY2 + ",perspectiveX3=" + scaledX3 + ",perspectiveY3=" + scaledY3 + ",perspectiveX4=" + scaledX4 + ",perspectiveY4=" + scaledY4)
    return sourceClip.ffdshow(options="isPerspective=1,perspectiveIsSrc=1,perspectiveInterpolation=2," + coordinates)
}

function deinterlace(clip sourceClip)
{
    sourceClip.ffdshow(options="isDeinterlace=1,deinterlaceMethod=14")
}

function videoIntro
{
    intro = ImageSource(gMediaDir + "meet_qtcreator_intro.png", pixel_type = "RGB32", fps = 50).trim(1, 100)
    intro
}

function audioIntro
{
    audioNoise(10)
}

function intro
{
    AudioDub(videoIntro, audioIntro)
}

function audioCrossPlatform
{
    audioNoise(1)
\[*
    #n Qt Creator is the IDE for all your C++ and Qt Quick application development needs.
*]
        \ + audioClip(8.939, 16.323, 0.5)
\[*
    #n It is available on the major desktop operating systems and can build and run your application there.
    #  Split screen showing the application launching on: Windows, OSX, Linux.
*]
        \ + audioClip(16.857, 22.221, 0.5)
\[*
    #n You can also target several other platforms.
    #  Split screen showing the application launching on: Android, iOS, WinPhone, Embedded, BareMetal (if I manage to get it running)
*]
        \ + audioClip(26.284, 28.955, 0.5)

        \ + audioNoise(10)
}

function videoCrossPlatform_desktop
{
    windows = DirectShowSource(gMediaDir + "meet_qtcreator_crossplatformwindows.avi", audio = false)
    blinking_cursor = windows.trim(109, 109).loop(28) + windows.trim(108, 108).loop(28)
    windows_cut =
        \   blinking_cursor.loop(7)          [* Waiting *]
        \ + windows.trim(109, 330)           [* App launching *]
    osx = ImageSource(gMediaDir + "meet_qtcreator_crossplatformosx.png", pixel_type = "RGB32", fps = 50).trim(1, 90)
    linux = ImageSource(gMediaDir + "meet_qtcreator_crossplatformlinux.png", pixel_type = "RGB32", fps = 50).trim(1, 90)
    return Dissolve(
        \   windows_cut
        \ , osx
        \ , linux
        \ , gDissolveLength).warp(10, 30,  1280, 10,  10, 680,  1280, 700)
}

function videoCrossPlatform
{
    android = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponandroid.MTS", audio = false).deinterlace
    android_cut = android.trim(92, 160) + android.trim(220, 290)
    android_cropped = android_cut.crop(786, 0, 438, 1080)

    ios = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponios.MTS", audio = false).deinterlace.Levels(0, 1.3, 180, 0, 255)
    ios_cut = ios.trim(130, 190) + ios.trim(360, 450)
    ios_cropped = ios_cut.crop(766, 0, 394, 1080)

    winrt = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponwinrt.MTS", audio = false).deinterlace
    winrt_cut = winrt.trim(380, 570)
    winrt_cropped = winrt_cut.crop(716, 0, 488, 1080)

    board = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponboard.MTS", audio = false).deinterlace.Levels(0, 1.1, 255, 0, 255)
    board_cut = board.trim(125, 260)
    board_cropped = board_cut.crop(582, 0, 600, 1080)

    devices_stacked = StackHorizontal(android_cropped, ios_cropped, winrt_cropped, board_cropped).LanczosResize(1280, 720).Converttorgb32
    return Dissolve(videoCrossPlatform_desktop, devices_stacked, gDissolveLength)
}

function crossPlatform
{
    AudioDub(videoCrossPlatform, audioCrossPlatform)
}

function audioCodeEditingAndNavigation
{
    audioNoise(1)
\[*
    #n The code editor in Qt Creator helps you to create code faster,...
    #  Snippet action is shown, code completion is used to fill place holders.
    #t {CTRLDOWN}{SHIFTDOWN}{ENTER}{ENTER}{SHIFTUP}{CTRLUP}{#}§in{ENTER} <ios§{DOWN}{DOWN}{ENTER}{DOWN}{DOWN}{DOWN}{ENTER}for{CTRLDOWN}{SPACE}{CTRLUP}§§{ENTER}i{TAB}{TAB}ar{CTRLDOWN}{SPACE}{CTRLUP}§{ENTER}{TAB}{TAB}{ENTER}std::cou{ENTER} << ar{CTRLDOWN}{SPACE}{CTRLUP}{DOWN}§{ENTER}[i] << std::e§{ENTER};
*]
        \ + audioClip(29.884, 33.947, 2)
\[*
    #n ...and helps you to refactor it.
    #  Extract function of the loop
    #t myExtractedFunction§{ENTER}
*]
        \ + audioClip(34.969, 36.664, 4)
\[*
    #n The IDE understands your source code and offers several powerful ways to have an overview of complex projects
    #  Opening a class via Locator. Open a Type hierarchy, jump to code, do a "Find Usages" on something.
*]
        \ + audioClip(37.685, 44.814, 0.5)

        \ + audioNoise(10)
}

function videoCodeEditingAndNavigation
{
    edit = DirectShowSource(gMediaDir + "meet_qtcreator_codeediting.avi", audio = false)
    edit_cut =
        \   edit.trim(50, 300)             [* Editing *]
    refactor_cut =
        \   edit.trim(550, 870)            [* Refactor *]
        \ + edit.trim(870, 870).loop(50)   [* Refactored *]
    navigate = DirectShowSource(gMediaDir + "meet_qtcreator_codenavigation.avi", audio = false)
    navigate_cut =
        \   navigate.trim(25, 100)                                 [* Open Locator *]
        \ + navigate.trim(100, 200).SelectEvery(3).AssumeFps(50)   [* Selecting class *]
        \ + navigate.trim(200, 350)                                [* Open Type Hierarchy. Wait. *]
        \ + navigate.trim(530, 700)                                [* Jump to class *]
        \ + navigate.trim(700, 850)                                [* Find usages *]
    return Dissolve(
        \   edit_cut.warp(250, 30,  800, 10,  250, 300,  800, 320)
        \ , refactor_cut.warp(200, 30,  1100, 10,  200, 530,  1100, 560)
        \ , navigate_cut.warp(10, 30,  1280, 10,  10, 680,  1280, 700)
        \ , gDissolveLength)
}

function codeEditingAndNavigation
{
    AudioDub(videoCodeEditingAndNavigation, audioCodeEditingAndNavigation)
}

function audioVisualEditors
{
    audioNoise(1)
\[*
    #n You can create user interfaces in a visual manner, for traditional Desktop applications...
    #  Shows time lapse of Qt Widget Designer in action
*]
        \ + audioClip(46.091, 51.250, 2)
\[*
    #n ...and for Qt Quick based applications.
    #  Shows time lapse of Qt Quick Designer in action
*]
        \ + audioClip(51.502, 53.870, 0.5)

        \ + audioNoise(10)
}

function videoVisualEditors
{
    widgets = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingwidgets.avi", audio = false)
    widgets_pushButtons = widgets.trim(1350, 1550)
    widgets_checkBoxes = widgets.trim(1800, 1862) + widgets.trim(1900, 2000)
    qtquick = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingqtquick.avi", audio = false)
    qtquick_cut =
        \   qtquick.trim(2280, 2600)          [* Open Locator *]
    return Dissolve(
        \   widgets_pushButtons.warp(10, 20,  1280, 10,  10, 660,  1280, 680)
        \ , widgets_checkBoxes.warp(20, 20,  820, 10,  20, 440,  820, 450)
        \ , qtquick_cut.warp(60, 40,  1280, 5,  60, 680,  1280, 715)
        \ , gDissolveLength)
}

function visualEditors
{
    AudioDub(videoVisualEditors, audioVisualEditors)
}

function audioDebuggerProfilerAnalyzers
{
    audioNoise(2.5)
\[*
    #n The debugger helps you to fix issues in your C++ or QML code...
    #  Debugger in action
*]
        \ + audioClip(60.651, 65.086, 3)
\[*
    #n ...and the Profiler shows you where to optimize the performance of your application.
    #  Profile action is shown
*]
        \ + audioClip(65.666, 70.264, 3.5)
\[*
    #n Additional tools help improving your application further
    #  clang static analyzer complaining about errors
*]
        \ + audioClip(78.762, 82.361, 0.5)

        \ + audioNoise(10)
}

function videoDebuggerProfilerAnalyzers
{
    debugger = DirectShowSource(gMediaDir + "meet_qtcreator_debugger.avi", audio = false)
    debugger_cut =
        \    debugger.trim(15, 145)             [* Setting Breakpoint. Pressing play *]
        \  + debugger.trim(2720, 2745)          [* Application launching *]
        \  + debugger.trim(2910, 3055)          [* Breakpoint hit *]
        \  + debugger.trim(3225, 3270)          [* Debugger views populated *]
        \  + debugger.trim(3370, 3445)          [* Tree expanded *]
    profiler = DirectShowSource(gMediaDir + "meet_qtcreator_profiler.avi", audio = false)
    profiler_cut =
        \    profiler.trim(0, 38)                                  [* Launching App *]
        \  + profiler.trim(90, 180)                                [* App appears *]
        \  + profiler.trim(180, 280).SelectEvery(3).AssumeFps(50)  [* Loading Data *]
        \  + profiler.trim(400, 740)                               [* Browsing Data, jumping to code location *]
    staticanalyzer = DirectShowSource(gMediaDir + "meet_qtcreator_clangstaticanalyzer.avi", audio = false)
    staticanalyzer_cut =
        \  + staticanalyzer.trim(8695, 8970).SelectEvery(2).AssumeFps(50)  [* Clicking through results *]
        \  + staticanalyzer.trim(8989, 9145)                               [* Jumping to location *]
    return Dissolve(
        \    debugger_cut.warp(10, 30,  1280, 10,  10, 680,  1280, 700)
        \  , profiler_cut.warp(230, 100,  1280, 30,  230, 640,  1280, 700)
        \  , staticanalyzer_cut.warp(290, 110,  1150, 60,  290, 550,  1150, 560)
        \  , gDissolveLength)
}

function debuggerProfilerAnalyzers
{
    AudioDub(videoDebuggerProfilerAnalyzers, audioDebuggerProfilerAnalyzers)
}

function audioVersionControlSystems
{
    audioNoise(2)
\[*
    #n Qt Creator allows you to manage your code without leaving the IDE.
    #  Git commit in action. Git log with diff in action.
*]
        \ + audioClip(101.262, 105.628, 3)
\[*
    #n Several version control systems are supported
    #  "About Plugins..." -> version control systems
*]
        \ + audioClip(106.022, 108.994, 0.5)

        \ + audioNoise(10)
}

function videoVersionControlSystems
{
    versioncontrol = DirectShowSource(gMediaDir + "meet_qtcreator_versioncontrol.avi", audio = false)
    launch_commit_editor = versioncontrol.trim(50, 265)
    commit_editor_action =
        \    versioncontrol.trim(290, 340)                              [* Commit message pasted *]
        \  + versioncontrol.trim(340, 480).SelectEvery(2).AssumeFps(50) [* Selecting file and Pressing Diff *]
        \  + versioncontrol.trim(510, 652)                              [* Viewing diff and opening plugin dialog *]
        \  + versioncontrol.trim(652, 720).SelectEvery(2).AssumeFps(50) [* Scrolling to VCS plugins *]
    plugin_list =
        \    versioncontrol.trim(720, 825)                              [* Watching list of plugins *]
        \  + versioncontrol.trim(825, 825).loop(100)                     [* Watching list of plugins *]
    return Dissolve(
        \    launch_commit_editor.warp(80, 10,  1040, 5,  80, 510,  1040, 560)
        \  , commit_editor_action.warp(100, 30,  1280, 20,  100, 680,  1280, 700)
        \  , plugin_list.warp(280, 280,  1000, 260,  280, 680,  1000, 700)
        \  , gDissolveLength)
}

function versionControlSystems
{
    AudioDub(videoVersionControlSystems, audioVersionControlSystems)
}

function audioDocumentationAndExamples
{
    audioNoise(1)
\[*
    #n The Qt documentation is context sensitive and with a press of 'F1' always available at your finger tips.
    #  Showing some source code in the edit mode, with mouse pointer hovering above it. Tooltip shows F1, jump to function documentation.
*]
        \ + audioClip(109.575, 116.634, 2)
\[*
    #n The example browser gives you a searchable overview of the Qt example collection.
    #  Example browser is shown. Filter is used. One Example is opened.
*]
        \ + audioClip(117.470, 122.532, 0.5)

        \ + audioNoise(10)
}

function videoDocumentationAndExamples
{
    documentation = DirectShowSource(gMediaDir + "meet_qtcreator_documentation.avi", audio = false)
    documentation_beforepopup = documentation.trim(0, 100)
    documentation_popup = documentation.trim(100, 100).loop(100) + documentation.trim(100, 190)
    documentation_afterpopup = documentation.trim(190, 335)
    examples = DirectShowSource(gMediaDir + "meet_qtcreator_examples.avi", audio = false)
    examples_beforefiltering = examples.trim(0, 155)
    examples_filtering = examples.trim(155, 300)
    examples_afterfiltering = examples.trim(300, 520)
    return Dissolve(
        \   documentation_beforepopup.warp(60, 40,  1160, 20,  60, 600,  1160, 620)
        \ , documentation_popup.warp(510, 250,  1020, 230,  510, 510,  1020, 530)
        \ , documentation_afterpopup.warp(10, 20,  1280, 10,  10, 660,  1280, 680)
        \ , examples_beforefiltering.warp(10, 20,  1100, 10,  10, 680,  1100, 700)
        \ , examples_filtering.warp(20, 115,  880, 80,  20, 560,  880, 580)
        \ , examples_afterfiltering.warp(80, 30,  1280, 10,  80, 680,  1280, 700)
        \ , gDissolveLength)
}

function documentationAndExamples
{
    AudioDub(videoDocumentationAndExamples, audioDocumentationAndExamples)
}

function videoOutro
{
    outro = ImageSource(gMediaDir + "meet_qtcreator_outro.png", pixel_type = "RGB32", fps = 50).trim(1, 500)
    outro
}

function audioOutro
{
    audioNoise(1)
\[*
    #n This was just a selection of what Qt Creator can do for you. Try it out to find out more. And thank you for watching.
    #  showing qt.io url
*]
        \ + audioClip(123.231, 130.917, 0.5)

        \ + audioNoise(10)
}

function outro
{
    AudioDub(videoOutro, audioOutro)
}

function completeClip
{
    return
        \ Dissolve(
            \   intro
            \ , crossPlatform.FadeIO(color = $ffffff, 35)
            \ , codeEditingAndNavigation.converttorgb32
            \ , visualEditors.converttorgb32
            \ , debuggerProfilerAnalyzers.converttorgb32
            \ , versionControlSystems.converttorgb32
            \ , documentationAndExamples.converttorgb32
            \ , outro
            \ , gDissolveLength)
        \ .FadeIO(color = $ffffff, 35)
}
#        \ .QtorialsElements("oldstyle")

completeClip