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
    #n Creating your own device with a great Qt based user interface has never been easier.
    #  A board is shown, attached to a screen showing black.
    #n When using Qt for device creation, you get everything you need to let your embedded Linux based device boot to your first Qt application in no time.
    #  Screen shows Qt demo logo with particles, and "Boot to Qt" text blends in.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioInstaller
{
    #n The easy-to-use online installer will install a set of components.
    #  2-3 installer pages are quickly shown. A list of bullet points appears on the side.
}

function audioDeviceImage
{
    #n A cross compiling toolchain and a pre-built image which you can flash to your device using the flashing wizard
    #  Wizard is shown. SD card in reader is shown. SD card gets inserted into device
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioYoctoRecipies
{
    #n The Yocto project recipies which the boot to Qt stack is built on, so you can easily customize the stack into your production needs.
    #  Time lapse of console yocto action
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioQtCreatorIDE
{
    #n The Qt Creator IDE for all your application development needs...
    #  Time lapse of Qt Quick Designer creating a hello world application
    #n ...which is fully configured to deploy applications to your board...
    #  Press on play. Time lapse of deployment and start of the application on the device.
    #n ...and which has the debugging and profiling tools helping you in creating a great application.
    #  Debugger is shown. Profiler is shown.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioEmulator
{
    #n An emulator which allows you to test your application without the actual board...
    #  Press on play. Start of the application on the device.
    #n ...and under special conditions or with editable sensor data.
    #  Switching through the control panels in the emulator
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioDocs
{
    #n And the comprehensive documentation which is well integrated in the tools.
    #  Help mode in Qt Creator
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioQtSupport
{
    #n With Qt, you are not alone with your problems. In case you get stuck, the Qt support team will quickly help you finding solutions.
    #  logging into account page -> Support Center.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function audioOutro
{
    #n Visit our website to get started. And thank you for watching.
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