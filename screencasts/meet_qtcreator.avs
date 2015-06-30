# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")
Import(gFFDShowImport)

#global gAudioClip = WAVSource(gMediaDir + "meet_qtcreator.wav")
global gAudioNoiseStart = 1829888 / 44100.0
global gAudioNoiseEnd = 1912832 / 44100.0

function warp(clip sourceClip, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
{
    scaledX3 = String(Round(100.0 / sourceClip.width * x1))
    scaledY3 = String(Round(100.0 - (100.0 / sourceClip.height * y1)))
    scaledX4 = String(Round(100.0 / sourceClip.width * x2))
    scaledY4 = String(Round(100.0 - (100.0 / sourceClip.height * y2)))
    scaledX1 = String(Round(100.0 / sourceClip.width * x3))
    scaledY1 = String(Round(100.0 - (100.0 / sourceClip.height * y3)))
    scaledX2 = String(Round(100.0 / sourceClip.width * x4))
    scaledY2 = String(Round(100.0 - (100.0 / sourceClip.height * y4)))
    coordinates = ("perspectiveX1=" + scaledX1 + ",perspectiveY1=" + scaledY1 + ",perspectiveX2=" + scaledX2 + ",perspectiveY2=" + scaledY2 + ",perspectiveX3=" + scaledX3 + ",perspectiveY3=" + scaledY3 + ",perspectiveX4=" + scaledX4 + ",perspectiveY4=" + scaledY4)
    return sourceClip.ffdshow(options="isPerspective=1,perspectiveIsSrc=2,perspectiveInterpolation=2," + coordinates).subtitle(coordinates)
}

function deinterlace(clip sourceClip)
{
    sourceClip.ffdshow(options="isDeinterlace=1,deinterlaceMethod=14")
}

function audioCrossPlatform
{
    #n Qt Creator is the IDE for all your C++ and Qt Quick application development needs.
    #n It is available on the major desktop operating systems and can build and run your application there.
    #  Split screen showing the application launching on: Windows, OSX, Linux.
    #n You can also target several other platforms.
    #  Split screen showing the application launching on: Android, iOS, WinPhone, Embedded, BareMetal (if I manage to get it running)
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoCrossPlatform_desktop
{
    windows = DirectShowSource(gMediaDir + "meet_qtcreator_crossplatformwindows.avi", audio = false)
    windows_cut =
        \   windows.trim(50, 330)            [* App launching *]
    osx = ImageSource(gMediaDir + "meet_qtcreator_crossplatformosx.png", pixel_type = "RGB32").AssumeFps(50).trim(1, 120)
    linux = ImageSource(gMediaDir + "meet_qtcreator_crossplatformlinux.png", pixel_type = "RGB32").AssumeFps(50).trim(1, 120)
    return Dissolve(windows_cut, osx, linux, gDissolveLength)
}

function videoCrossPlatform
{
    android = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponandroid.MTS", audio = false).deinterlace
    android_cut = android.trim(92, 160) + android.trim(220, 240)
    android_cropped = android_cut.crop(786, 0, 438, 1080)

    ios = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponios.MTS", audio = false).deinterlace.Levels(0, 1.3, 180, 0, 255)
    ios_cut = ios.trim(130, 190) + ios.trim(360, 400)
    ios_cropped = ios_cut.crop(766, 0, 394, 1080)

    winrt = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponwinrt.MTS", audio = false).deinterlace
    winrt_cut = winrt.trim(380, 520)
    winrt_cropped = winrt_cut.crop(716, 0, 488, 1080)

    board = DirectShowSource(gMediaDir + "meet_qtcreator_launchapponboard.MTS", audio = false).deinterlace.Levels(0, 1.1, 255, 0, 255)
    board_cut = board.trim(125, 210)
    board_cropped = board_cut.crop(582, 0, 600, 1080)

    devices_stacked = StackHorizontal(android_cropped, ios_cropped, winrt_cropped, board_cropped).LanczosResize(1280, 720).Converttorgb32
    return Dissolve(videoCrossPlatform_desktop, devices_stacked, gDissolveLength)
}

function audioCodeEditingAndNavigation
{
    #n The code editor in Qt Creator helps you to create code faster,...
    #  Snippet action is shown, code completion is used to fill place holders.
    #t {CTRLDOWN}{SHIFTDOWN}{ENTER}{ENTER}{SHIFTUP}{CTRLUP}{#}§in{ENTER} <ios§{DOWN}{DOWN}{ENTER}{DOWN}{DOWN}{DOWN}{ENTER}for{CTRLDOWN}{SPACE}{CTRLUP}§§{ENTER}i{TAB}{TAB}ar{CTRLDOWN}{SPACE}{CTRLUP}§{ENTER}{TAB}{TAB}{ENTER}std::cou{ENTER} << ar{CTRLDOWN}{SPACE}{CTRLUP}{DOWN}§{ENTER}[i] << std::e§{ENTER};
    #n ...and helps you to refactor it.
    #  Extract function of the loop
    #t myExtractedFunction§{ENTER}
    #n The IDE understands your source code and offers several powerful ways to have an overview of complex projects
    #  Opening a class via Locator. Open a Type hierarchy, jump to code, do a "Find Usages" on something.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
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
        \ + navigate.trim(700, 950)                                [* Find usages *]
    return Dissolve(edit_cut, refactor_cut, navigate_cut, gDissolveLength)
}

function audioVisualEditors
{
    #n You can create user interfaces in a visual manner, for traditional Desktop applications...
    #  Shows time lapse of Qt Widget Designer in action
    #n ...and for Qt Quick based applications.
    #  Shows time lapse of Qt Quick Designer in action
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoVisualEditors
{
    widgets = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingwidgets.avi", audio = false)
    widgets_pushButtons = widgets.trim(1350, 1550)
    widgets_checkBoxes = (widgets.trim(1800, 1862) + widgets.trim(1900, 2000)).warp(20, 20,  850, 10,  10, 420,  850, 440)
    qtquick = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingqtquick.avi", audio = false)
    qtquick_cut =
        \   qtquick.trim(2280, 2600).warp(0, 100,  1100, 5,  0, 620,  1100, 715)          [* Open Locator *]
    return Dissolve(widgets_pushButtons, widgets_checkBoxes, qtquick_cut, gDissolveLength)
}

function audioDebuggerProfilerAnalyzers
{
    #n The debugger helps you to fix issues in your C++ or QML code...
    #  Debugger in action
    #n ...and the Profiler shows you where to optimize the performance of your application.
    #  Profile action is shown
    #n Additional tools help improving your application further
    #  clang static analyzer complaining about errors
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoDebuggerProfilerAnalyzers
{
    widgets = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingwidgets.avi", audio = false)
    widgets_pushButtons = widgets.trim(1350, 1550)
    widgets_checkBoxes = widgets.trim(1800, 1862) + widgets.trim(1900, 2000)
    qtquick = DirectShowSource(gMediaDir + "meet_qtcreator_visualeditingqtquick.avi", audio = false)
    qtquick_cut =
        \   qtquick.trim(2280, 2600).warp(0, 0,  1200, 20,  0, 620,  1200, 700)         [* Open Locator *]
    return Dissolve(widgets_pushButtons, widgets_checkBoxes, qtquick_cut, gDissolveLength)
}

function audioVersionControlSystems
{
    #n Qt Creator allows you to manage your code without leaving the IDE.
    #  Git commit in action. Git log with diff in action.
    #n Several version control systems are supported
    #  "About Plugins..." -> version control systems
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioDocumentation
{
    #n The Qt documentation is context sensitive and with a press of 'F1' always available at your finger tips.
    #  Showing some source code in the edit mode, with mouse pointer hovering above it. Tooltip shows F1, jump to function documentation.
    #n The example browser gives you a searchable overview of the Qt example collection.
    #  Example browser is shown. Filter is used. One Example is opened.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioOutro
{
    #n This was just a selection of what Qt Creator can do for you. Try it out to find out more. And thank you for watching.
    #  showing qt.io url
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function completeClip
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
        \ .FadeIO(gDissolveLength)
}

#completeclip

videoVisualEditors