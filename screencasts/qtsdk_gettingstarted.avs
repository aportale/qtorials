# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

//global gAudioClip = WAVSource(gMediaDir + "qtsdk_gettingstarted_narration.wav").Amplify(1.5)
global gAudioNoiseStart = 54.575987
global gAudioNoiseEnd = 55.449887
global gClipWidth = 960
global gClipHeight = 720
global gTextClipFramesPerCharacter = 2

function intro
{
    textClip("Getting started with\nthe Qt SDK", 75)
}

global gCameraFootage = 0
function cameraFootage
{
    global gCameraFootage = (gCameraFootage.IsClip ? gCameraFootage : DirectShowSource(gMediaDir + "androidqt_intro.m2ts", audio = false))
    AudioDub(gCameraFootage, WavSource(gMediaDir + "qtsdk_gettingstarted_intro.wav"))
    DelayAudio(3.91)
    TemporalSoften(4, 4, 8, mode = 2)
}

function cameraFootage_960x720
{
    cameraFootage
        \ .Lanczos4Resize(960, 480, 138.0, 120, 1514.0, 758.0)
        \ .AddBorders(0, 120, 0, 120, 0)
}

function exampleIntro
{
    videoWithClipSize("cameraFootage")
        \ .trim(250, 1315)
}

function audioExampleIntro
{
[*
    #n Hi, I am Alessandro. In this video I will demonstrate how to get started with the Qt SDK.
    #n Let's start by opening an example project in Qt Creator. We run the example as a Desktop application, then in the Qt Simulator and also on a mobile device.
*]
}

function audioExample
{
    audioNoise(2)
\[*
    #n The Qt SDK installer added a shortcut which launches Qt Creator.
*]
        \ + audioClip(, 1)
\[*
    #n The Welcome screen offers...
*]
        \ + audioClip(, 1)
\[*
    #n ...tutorials with step-by step instructions and screenshots...
*]
        \ + audioClip(, 1)
\[*
    #n ...tips which worth knowing...
*]
        \ + audioClip(, 1)
\[*
    #n ...and a big collection of Qt C++ and Qt Quick examples.
*]
        \ + audioClip(, 1)
\[*
    #n Let's open the Qt Quick example ... "Demos" ... "Samegame"
*]
        \ + audioClip(, 1)
\[*
    #n A project setup dialog appears where we can choose which platforms we want to target.
*]
        \ + audioClip(, 1)
\[*
    #n "Desktop" is preselected and we add "Qt Simulator" and "Symbian device.
*]
        \ + audioClip(, 1)
\[*
    #n It is possible to remove or add target platforms, afterwards.
*]
        \ + audioClip(, 1)
\[*
    #n The project is loaded and the main .qml file of Samegame is opened.
*]
        \ + audioClip(, 1)
\[*
    #n Let's run the application by pressing the "Run" button on the right.
*]
        \ + audioClip(, 1)
\[*
    #n The application is built and launches ... in the Qt Simulator
*]
        \ + audioClip(, 1)
\[*
    #n The application was launched in the Simulator because that is the currently selected target.
*]
        \ + audioClip(, 1)
\[*
    #n By opening the target chooser we can switch ... to the "Desktop" target. Let's run that one.
*]
        \ + audioClip(, 1)
\[*
    #n Samegame is now a native Desktop application.
*]
        \ + audioClip(, 1)
\[*
    #n Let's switch the target to "Symbian" and run the application on the connected Symbian device.
*]
        \ + audioNoise(10)
}

function videoExample_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_example.avi", audio = false)
        \ .converttorgb32
    cut =
        \   clip.trim(30, 127)                                          [*  *]
        \ + clip.trim(127, 250).selectevery(2).assumefps(25)            [*  *]
    cut
}

function qmlAppIntroIntro
{
    videoWithClipSize("cameraFootage")
        \ .trim(250, 1315)
}

function audioQmlAppIntro
{
[*
    #n So, opening an existing project and running it is pretty straight forward.
    #n We will now create our own Qt Quick application and run it.
*]
}

function audioQmlApp
{
    audioNoise(2)
\[*
    #n We select "File"...
*]
        \ + audioClip(, 1)
\[*
    #n ..."New File or Project"
*]
        \ + audioClip(, 1)
\[*
    #n And choose "Qt Quick Project"...
*]
        \ + audioClip(, 1)
\[*
    #n ..."Qt Quick Application"
*]
        \ + audioClip(, 1)
\[*
    #n Then we give our project a name...
*]
        \ + audioClip(, 1)
\[*
    #n ...and continue to the target selection which we already saw.
*]
        \ + audioClip(, 1)
\[*
    #n The wizard offers several options. The defaults are fine for now.
*]
        \ + audioClip(, 1)
\[*
    #n Our project has been created and we can see the main QML file.
*]
        \ + audioClip(, 1)
\[*
    #n It is a simple "Hello World" which quits when it is clicked.
*]
        \ + audioClip(, 1)
\[*
    #n We could start editing the QML source code, or we can work in the visual Design mode.
*]
        \ + audioClip(, 1)
\[*
    #n Let's change a few properties of the text...
*]
        \ + audioClip(, 1)
\[*
    #n ... and switch back to the Edit mode... where we can see the fresh changes in text form.
*]
        \ + audioClip(, 1)
\[*
    #n Let's run the application, again first in the Simulator.
*]
        \ + audioClip(, 1)
\[*
    #n And now on the Symbian device.
*]
        \ + audioNoise(10)
}

function videoQmlApp_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_qmlapp.avi", audio = false)
        \ .converttorgb32
    cut =
        \   clip.trim(30, 127)                                          [*  *]
        \ + clip.trim(127, 250).selectevery(2).assumefps(25)            [*  *]
    cut
}

function audioDesktopAppIntro
{
[*
    #n We ran two Qt Quick applications, which mostly targeted mobile devices.
    #n With the Qt SDK, we can of course also create powerful Qt C++ applications optimized for the Desktop.
*]
}

function audioDesktopApp
{
    audioNoise(2)
\[*
    #n We choose "Qt C++ Project"...
*]
        \ + audioClip(, 1)
\[*
    #n  ..."Qt Gui Application",
*]
        \ + audioClip(, 1)
\[*
    #n ...and finish the wizard.
*]
        \ + audioClip(, 1)
\[*
    #n The generated project contains a Form ...
*]
        \ + audioClip(, 1)
\[*
    #n ... which opens up in the visual UI Designer.
    #n Here, we can drag Qt Widgets on our form, lay them out, edit properties, define application menu entries, define signal/slot connectiosn, ... and much more.
*]
        \ + audioClip(, 1)
\[*
    #n A click on "Run" launches our Desktop Qt C++ application which looks and feels native.
*]
        \ + audioNoise(10)
}

function videoDesktopApp_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_desktopapp.avi", audio = false)
        \ .converttorgb32
    cut =
        \   clip.trim(30, 127)                                          [*  *]
        \ + clip.trim(127, 250).selectevery(2).assumefps(25)            [*  *]
    cut
}

function audioOutro
{
    audioNoise(2)
\[*
    #n That's it. You just got started with the Qt SDK.
    #n Thanks for watching.
*]
        \ + audioNoise(10)
}

function videoOutro
{
    Dissolve(
        \   textClip("Thank you for\nwatching", 280)
        \ , gDissolveLength)
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
            \ , necessitasComponents
            \ , androidSdk
            \ , necessitas
            \ , creatorAction
            \ , qmlOnDevice.converttorgb
            \ , debugger.converttorgb
            \ , whatAboutDeployment.converttorgb
            \ , ministro.converttorgb
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
flipvertical
