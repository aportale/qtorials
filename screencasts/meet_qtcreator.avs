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
global gClipWidth = 640
global gClipHeight = 360

function deinterlace(clip sourceClip)
{
    sourceClip.ffdshow(options="isDeinterlace=1,deinterlaceMethod=14")
}

function audioIntro
{
    #n Qt Creator is the IDE for all your C++ and Qt Quick application development needs
    #  Qt Creator is shown.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioCrossPlatform
{
    #n It is available on all major desktop operating systems and can build and run your application on the desktop.
    #  Split screen showing the application launching on: Windows, OSX, Linux.
    #n And you can also target several other platforms.
    #  Split screen showing the application launching on: Android, iOS, WinPhone, Embedded, BareMetal (if I manage to get it running)
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
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

    stacked = StackHorizontal(android_cropped, ios_cropped, winrt_cropped, board_cropped)
    stacked.info
}

function audioCodeEditingAndNavigation
{
    #n The code editor in Qt Creator understands your source code.
    #  Editor is shown, while code is typed
    #n It helps you to create code faster,...
    #  Snippet action is shown, code completion is used to fill place holders.
    #n ...warns you about problems while you type,....
    #  A warning is shown (TODO: find a simple semantic check with warning and one with error)
    #n ...and helps you to refactor your code.
    #  Refactoring action is shown ()
    #n The IDE offers several powerful ways to have an overview of complex Projects
    #  Opening a class via Locator. Open a Type hierarchy, jump to code, do a "Find Usages" on something.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
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

videoCrossPlatform