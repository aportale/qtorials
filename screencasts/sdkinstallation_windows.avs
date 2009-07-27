# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "sdkinstallation_windows.wav")
global gAudioNoiseStart = 13216700 / 44100.0
global gAudioNoiseEnd = 13225219 / 44100.0

function audioWelcome
{
    #n Let's download and install the Qt SDK for Windows...
    #n ...and afterwards take a short look at the installed components.
    a1 = audioNoise(0.7) + audioClip(00.533, 07.247, 1)

    return a1 + audioNoise(10)
}

function videoWelcome
{
    return Dissolve(
        \   ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "Qt SDK Installation on Windows").trim(1,1).loop(155)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "QtCreator, QtDemo, QtLinguist...").trim(1,1).loop(80)
        \ , 6).ConvertToRGB24
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

function audioComponents
{
    #n The installer created a program group called "Qt SDK by Nokia".
    #  Start->All Programs->Mouse on program group
    a1 = audioNoise(1) + audioClip(34.132, 38.480, 1)

    #n The Qt Command prompt has a fully set up environment for advanced tasks in the command line.
    #t qmake --version{ENTER}
    a2 = audioClip(3.,787, 44.489, 1)

    #n Qt Creator is the integrated development environment...
    #n ...that comes with...
    #  Starting Qt Creator
    a3 = audioClip(44.967, 50.006, 1)

    #n ...an advanced C++ code editor...
    #  Quick impressions of code completion based on Gui App made with the wizard
    #t {ENTER}§w.res§{DOWN}§{ENTER}§{DOWN}§640, §480);
    a4 = audioClip(50.211, 52.761, 1)

    #n ...a Drag'n'Drop Gui editor...
    #  Quick impressions of designer
    a5 = audioClip(56.363, 58.674, 1)

    #n ...a debugger...
    #  Quick impressions of the debugger
    a6 = audioClip(59.063, 60.301, 1)

    #n ...and a help system.
    #  Quick impressions of help
    a7 = audioClip(61.148, 62.536, 1)

    #n We will do most of the application development in Qt Creator.
    a8 = audioClip(63.697, 67.280, 1)

    #n The Qt Demo is a collection of examples which showcase different parts of the Qt application framework.
    #n Some of these examples are really fancy. And of course we can study all their source codes.
    #  Clicking around some demos, browsing through sources.
    a9 = audioClip(67.697, 80.283, 1)

    #n Qt Linguist is the language translation tool.
    #n It can be used by translation specialists to create or maintain multiple languages for our applications.
    #  Some clicks through Linguist
    a10 = audioClip(84.918, 95.720, 1)

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + audioNoise(10)
}

function videoComponents
{
    return Dissolve(textClip(carbide, "Our first Qt for S60 application"), carbide, emulator, 6)
}

function audioOutro
{
    #n Now, that the Qt SDK is installed, we should continue with the other Qtorials :)

    return audioNoise(1) + audioClip(96.123, 141.674, 1)
}

function videoOutro
{
    return ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1).ConvertToRGB24
}

function clip_2d
{
    return Dissolve(
        \   AudioDub(videoDownload, audioDownload)
        \ , AudioDub(videoInstallation, audioInstallation)
        \ , AudioDub(videoComponents, audioComponents)
        \ , 6)
}

function clip_3d
{
    audio = clip_2d.killvideo
    video = ImageSource("screencast_3D_480x360/%04d.png", start = 1, end = 5517, fps = 25)
    return AudioDub(video, audio)
}

function completeclip
{
    return Dissolve(
        \   AudioDub(videoWelcome, audioWelcome).ConvertToYUY2
        \ , clip_3d.ConvertToYUY2
        \ , AudioDub(videoOutro, audioOutro).ConvertToYUY2
        \ , 6).oldGradient.qtLogoSmall
}

#clip_2d
AudioDub(videoInstallation, audioInstallation)
#completeclip