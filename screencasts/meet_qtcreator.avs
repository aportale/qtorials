# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "meet_qtcreator.wav")
global gAudioNoiseStart = 1829888 / 44100.0
global gAudioNoiseEnd = 1912832 / 44100.0
global gClipWidth = 640
global gClipHeight = 360

function audioIntro
{
    #n Qt Creator, the Integrated Development Environment is the one stop shop for all your application development needs
    #  Qt Creator is shown.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioCrossPlatform
{
    #n Qt Creator runs on the major desktop operating systems and you can build and run your application natively on the desktop.
    #  Split screen showing the application launching on: Windows, OSX, Linux.
    #n You can also target other platforms which are supported by Qt.
    #  Split screen showing the application launching on: Android, iOS, WinPhone, Embedded.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioCodeEditingAndNavigation
{
    #n The code editor in Qt Creator understands your source code.
    #  Editor is shown, while code is typed
    #n It helps you creating code faster,...
    #  Code completion is shown
    #n ...warns you about problems while you type,....
    #  A warning is shown (TODO: find a simple semantic check with warning and one with error)
    #n ...and helps you refactoring your code.
    #  Refactoring action is shown ()
    #n The IDE offers several powerful ways to have an overview of complex Projects
    #  Opening a class via Locator. Doing a "Find Usages" on something.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioVisualEditors
{
    #n You can create user interfaces in a visual manner, for traditional Desktop applications...
    #  Shows time lapse of Qt Widget Designer in action
    #n ...and for touch based applications.
    #  Shows time lapse of Qt Quick Designer in action
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioDebuggerProfilerAnalyzers
{
    #n The debugger helps you fixing issues in your C++ or QML code...
    #  Debugger in action
    #n ...the Profiler shows you where to optimize the performance of your application...
    #  Profile action is shown
    #n ...and additional, integrated third-party tools help improving your application further
    #  clang static analyzer complaining about errors
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioVersionControlSystems
{
    #n Qt Creator allows allows you to manage your code without leaving the IDE.
    #  Debugger in action
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
    #n This was just a selection of what Qt Creator can do. Try it out to find out more. And thank you for watching.
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