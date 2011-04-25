# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "qtsdk_gettingstarted_narration.wav").Amplify(1.5)
global gAudioNoiseStart = 190.0
global gAudioNoiseEnd = 193.0
global gClipWidth = 480
global gClipHeight = 360
global gTextClipFramesPerCharacter = 2

function intro
{
    textClip("Getting started with\nthe Qt SDK", 75)
}

global gTalkingHeadFootage = 0
function talkingHeadFootage
{
    global gTalkingHeadFootage = (gTalkingHeadFootage.IsClip ? gTalkingHeadFootage : DirectShowSource(gMediaDir + "androidqt_intro.m2ts", audio = false))
    AudioDub(gTalkingHeadFootage, WavSource(gMediaDir + "qtsdk_gettingstarted_intro.wav"))
    DelayAudio(3.91)
    TemporalSoften(4, 4, 8, mode = 2)
}

function talkingHeadFootage_960x720
{
    talkingHeadFootage
        \ .Lanczos4Resize(960, 480, 138.0, 120, 1514.0, 758.0)
        \ .AddBorders(0, 120, 0, 120, 0)
}

global gPhoneActionFootage = 0
function phoneActionFootage
{
    global gPhoneActionFootage = (gPhoneActionFootage.IsClip ? gPhoneActionFootage : DirectShowSource(gMediaDir + "qtsdk_gettingstarted_phoneaction.m2ts", audio = false))
    AudioDub(gPhoneActionFootage, audioNoise(30))
    TemporalSoften(4, 4, 8, mode = 2)
    TurnRight
}

function phoneActionFootage_960x720
{
    phoneActionFootage
        \ .Lanczos4Resize(524, 720, 0.0, 260.0, 1080.0, 1480.0)
        \ .AddBorders(218, 0, 218, 0, 0)
}

function phoneActionFootage_480x360
{
    phoneActionFootage
        \ .Lanczos4Resize(384, 360, 0.0, 498.0, 1080.0, 1008.0)
        \ .AddBorders(48, 0, 48, 0, 0)
}

function exampleIntro
{
    videoWithClipSize("talkingHeadFootage")
        \ .trim(250, 1315)
}

function audioExampleIntro
{
[*
    #n Hi, I am Alessandro. In this video I will demonstrate how to get started with the Qt SDK.
    #n We begin by opening an example project in Qt Creator. We run the example as a Desktop application, then in the Qt Simulator and also on a mobile device.
*]
}

function audioExample
{
    audioNoise(1)
\[*
    #n The Qt SDK installer added a shortcut which launches Qt Creator.
*]
        \ + audioClip(0.278, 4.481, 1)
\[*
    #n The Welcome screen offers: Tutorials with step-by step instructions and screenshots...
*]
        \ + audioClip(5.363, 11.029, 1)
\[*
    #n ...useful tips about Qt Creator...
*]
        \ + audioClip(11.888, 14.326, 1)
\[*
    #n ...and many Qt C++ and Qt Quick examples.
*]
        \ + audioClip(15.325, 18.552, 1)
\[*
    #n Let's open the Qt Quick example ... "Demos" ... "Samegame"
*]
        \ + audioClip(20.062, 23.614, 1)
\[*
    #n A dialog appears where we can choose the platforms which we want to target.
*]
        \ + audioClip(25.100, 29.698, 1)
\[*
    #n "Desktop" is preselected and we add "Qt Simulator" and "Symbian device".
*]
        \ + audioClip(31.555, 36.664, 1.5)
\[*
    #n The project is loaded and the main .qml file of Samegame is opened.
*]
        \ + audioClip(36.873, 41.261, 1)
\[*
    #n We launch the application by pressing the "Run" button.
*]
        \ + audioClip(42.167, 45.209, 2)
\[*
    #n The application is built and launches ... in the Qt Simulator
*]
        \ + audioClip(46.277, 50.271, 2.5)
\[*
    #n It was launched in the Simulator because that is the currently selected target.
*]
        \ + audioClip(51.455, 56.053, 1)
\[*
    #n By opening the target chooser we can switch ... to the "Desktop" target. Let's run that one.
*]
        \ + audioClip(57.284, 62.833, 3)
\[*
    #n Samegame is now a native Desktop application.
*]
        \ + audioClip(64.203, 67.082, 2.5)
\[*
    #n Let's switch the target to "Symbian",
*]
        \ + audioClip(71.471, 73.329, 0)
\[*
    #n and run Samegame on a connected Symbian device.
*]
        \ + audioClip(73.747, 76.394, 1)
        \ + audioNoise(10)
}

function videoExample_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_example.avi", audio = false)
        \ .converttorgb32
        \ .applyrange(2712, 2742, "overlay", ImageSource(gMediaDir + "qtsdk_gettingstarted_devicefound_pressed.png", fps = 25).loop(1000), 0, 504)
        \ .applyrange(2742, 9999, "overlay", ImageSource(gMediaDir + "qtsdk_gettingstarted_devicefound_normal.png", fps = 25).loop(1000), 0, 504)
    cut =
        \   clip.trim(70, 200)                                          [* Click on shortcut *]
        \ + clip.trim(210, 238)                                         [* Creator opens *]
        \ + clip.trim(238, 238).loop(40)                                [* Welcome Screen *]
        \ + clip.trim(238, 290)                                         [* Tutorials *]
        \ + clip.trim(290, 290).loop(60)                                [* Tutorials *]
        \ + clip.trim(290, 355)                                         [* Tips *]
        \ + clip.trim(355, 355).loop(140)                               [* Qt C++/Quick Examples *]
        \ + clip.trim(355, 438)                                         [* opening Examples -> Demos -> SameGame *]
        \ + clip.trim(482, 500)                                         [* Targets dialog appears *]
        \ + clip.trim(500, 500).loop(120)                               [* Targets dialog *]
        \ + clip.trim(500, 650)                                         [* Targets dialog explained *]
        \ + clip.trim(680, 688)                                         [* Targets dialog appears *]
        \ + clip.trim(984, 1059)                                        [* Samegame is opened *]
        \ + clip.trim(1059, 1086).loop(4)                               [* Samegame is opened, cursor blinks *]
        \ + clip.trim(1087, 1165)                                       [* Pressed "Run" *]
        \ + clip.trim(1324, 1560).selectevery(2).assumefps(25)          [* Builds, launches in Simulator *]
        \ + clip.trim(1580, 1930)                                       [* Switching to Desktop Target *]
        \ + clip.trim(1930, 2450).selectevery(30).assumefps(25)         [* Pressed "Run" , build, launch *]
        \ + clip.trim(2450, 2638)                                       [* Playing Desktop Samegame *]
        \ + clip.trim(2655, 2736)                                       [* Switching to Symbian Target *]
        \ + clip.trim(2765, 2765).loop(40)                              [* Pressed "Run"  *]
    cut
}

function example
{
    AudioDub(videoWithClipSize("videoExample"), audioExample)
}

function examplePhoneAction
{
    clip = videoWithClipSize("phoneActionFootage")
    clip.trim(30, 80) + clip.trim(115, 360)
}

function qmlAppIntroIntro
{
    videoWithClipSize("cameraFootage")
        \ .trim(250, 1315)
}

function audioQmlAppIntro
{
[*
    #n Opening an existing project and running it is pretty straight forward.
    #n Now, we will create our own Qt Quick application and run it.
*]
}

function audioQmlApp
{
    audioNoise(2)
\[*
    #n We select "File"...
*]
        \ + audioClip(77.949, 79.343, 0)
\[*
    #n ..."New File or Project"
*]
        \ + audioClip(79.552, 80.875, 0.5)
\[*
    #n And choose "Qt Quick Project", ...
*]
        \ + audioClip(81.386, 83.197, 0)
\[*
    #n ..."Qt Quick Application"
*]
        \ + audioClip(83.244, 84.614, 1)
\[*
    #n Then we give our project a name...
*]
        \ + audioClip(85.705, 87.795, 0.75)
\[*
    #n ...and continue to the target selection step which we already know.
*]
        \ + audioClip(89.954, 93.576, 0.5)
\[*
    #n The wizard offers further options for our Qt Quick Application. The defaults are fine for now.
*]
        \ + audioClip(95.597, 100.705, 3)
\[*
    #n Our project has been created and we see the main QML file.
*]
        \ + audioClip(101.262, 105.465, 1)
\[*
    #n It is a simple "Hello World" app which quits when the user taps on it.
*]
        \ + audioClip(105.953, 110.016, 1)
\[*
    #n We could start editing the QML source code, ... or we can work in the visual QML Design mode.
*]
        \ + audioClip(111.154, 116.680, 1.5)
\[*
    #n Let's change a few properties of the text, like color, size and style.
*]
        \ + audioClip(118.724, 123.135, 2)
\[*
    #n When we switch back to the "Edit" mode, we can see the fresh changes in the QML source.
*]
        \ + audioClip(126.618, 131.471, 1)
\[*
    #n By the way... the help system is always at our finger tip.
    #n By moving the mouse pointer on a QML element, we get a brief description of it. And by pressing F1 we get to the full help page of the element.
*]
        \ + audioClip(132.307, 143.987, 2)
\[* 
    #n Let's run the application. Again, first in the Simulator.
*]
        \ + audioClip(145.961, 148.863, 6)
\[*
    #n And now on the Symbian device.
*]
        \ + audioClip(149.908, 151.673, 1)
        \ + audioNoise(10)
}

function videoQmlApp_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_qmlapp.avi", audio = false)
        \ .converttorgb32
        \ .applyrange(2703, 2721, "overlay", ImageSource(gMediaDir + "qtsdk_gettingstarted_devicefound_pressed.png", fps = 25).loop(1000), 0, 504)
        \ .applyrange(2722, 9999, "overlay", ImageSource(gMediaDir + "qtsdk_gettingstarted_devicefound_normal.png", fps = 25).loop(1000), 0, 504)
    cut =
        \   clip.trim(0, 70)                                            [* Click on "File" *]
        \ + clip.trim(70, 70).loop(10)                                  [* Click on "File" *]
        \ + clip.trim(70, 90)                                           [* Click on "New File or Project" *]
        \ + clip.trim(90, 90).loop(20)                                  [* Click on "New File or Project" *]
        \ + clip.trim(90, 220)                                          [* Click on "Qt Quick Project" *]
        \ + clip.trim(240, 460)                                         [* Entering name *]
        \ + clip.trim(460, 460).loop(60)                                [* Finishing Wizard *]
        \ + clip.trim(460, 530)                                         [* Project opens *]
        \ + clip.trim(530, 530).loop(100)                               [* Qml file visible *]
        \ + clip.trim(530, 631)                                         [* Explaining app *]
        \ + (clip.trim(632, 632).loop(14) + clip.trim(631, 631).loop(14)).loop(5) [* Explaining app *]
        \ + clip.trim(632, 660)                                         [* Choose Design mode *]
        \ + clip.trim(780, 900)                                         [* Switched to Design mode *]
        \ + clip.trim(900, 1690).selectevery(8).assumefps(25)           [* Changing properties *]
        \ + clip.trim(1690, 1789)                                       [* Switched to Edit mode *]
        \ + (clip.trim(1790, 1790).loop(14) + clip.trim(1789, 1789).loop(14)).loop(4) [* Chenged source *]
        \ + clip.trim(1790, 1868)                                       [* Switched to Edit mode *]
        \ + (clip.trim(1869, 1869).loop(14) + clip.trim(1868, 1868).loop(14)).loop(2) [* Tooltip help *]
        \ + clip.trim(1869, 1922)                                       [* Pressed F1 *]
        \ + clip.trim(2000, 2128)                                       [* Pressed "Run" *]
        \ + clip.trim(2143, 2165).selectevery(2).assumefps(25)          [* Go to "Save All" *]
        \ + clip.trim(2165, 2170)                                       [* Pressed "Save All" *]
        \ + clip.trim(2360, 2399)                                       [* Starting *]
        \ + clip.trim(2522, 2736)                                       [* Simulator action, switching to Symbian *]
        \ + clip.trim(2736, 2736).loop(40)                              [* Pressed "Run" *]
    cut
}

function qmlApp
{
    AudioDub(videoWithClipSize("videoQmlApp"), audioQmlApp)
}

function qmlAppPhoneAction
{
    videoWithClipSize("phoneActionFootage")
        \ .trim(530, 660)
}

function audioDesktopAppIntro
{
[*
    #n We ran two Qt Quick applications, which mostly targeted mobile devices.
    #n With the Qt SDK, we can of course also create powerful Qt C++ applications, optimized for the Desktop.
*]
}

function audioDesktopApp
{
    audioNoise(2.5)
\[*
    #n We choose "Qt C++ Project"...
*]
        \ + audioClip(153.182, 155.504, 0)
\[*
    #n  ..."Qt Gui Application",
*]
        \ + audioClip(155.643, 157.153, 1)
\[*
    #n ...and finish the wizard.
*]
        \ + audioClip(157.315, 158.592, 1)
\[*
    #n The generated project contains a Form ...
*]
        \ + audioClip(160.403, 163.120, 1)
\[*
    #n ... which opens up in the visual UI Designer.
*]
        \ + audioClip(164.435, 166.821, 2)
\[*
    #n Here, we can drag Qt Widgets on our form, lay them out, edit properties, define application menu entries, ... and much more.
*]
        \ + audioClip(167.065, 174.710, 4)
\[*
    #n The launched Desktop Qt C++ application looks and feels native.
*]
        \ + audioClip(176.100, 180.071, 1)
        \ + audioNoise(10)
}

function videoDesktopApp_960x720
{
    clip = DirectShowSource(gMediaDir + "qtsdk_gettingstarted_desktopapp.avi", audio = false)
        \ .converttorgb32
    cut =
        \   clip.trim(0, 83)                                            [* New Project *]
        \ + clip.trim(83, 83).loop(20)                                  [* Qt C++ Project *]
        \ + clip.trim(83, 110)                                          [* Qt Gui Application *]
        \ + clip.trim(110, 110).loop(30)                                [* Qt Gui Application *]
        \ + clip.trim(110, 270).selectevery(2).assumefps(25)            [* Finishing Wizard *]
        \ + clip.trim(270, 415)                                         [* Qt Gui Application *]
        \ + clip.trim(415, 2650).selectevery(10).assumefps(25)          [* Editing Form *]
        \ + clip.trim(2650, 2672)                                       [* Resizing form *]
        \ + clip.trim(2695, 2770).selectevery(2).assumefps(25)          [* Pressing "Run" *]
        \ + clip.trim(2950, 2975)                                       [* Application started *]
        \ + clip.trim(3013, 3300)                                       [* Using application *]
    cut
}

function desktopApp
{
    AudioDub(videoWithClipSize("videoDesktopApp"), audioDesktopApp)
}

function audioOutro
{
    audioNoise(2)
\[*
    #n That's it. You just got started with the Qt SDK.
    #n Thanks for watching.
*]
        \ + audioClip(181.487, 185.551, 1)
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
            \   exampleIntro
            \ , example
            \ , examplePhoneAction
            \ , qmlAppIntro
            \ , qmlApp
            \ , qmlAppPhoneAction
            \ , desktopAppIntro
            \ , desktopApp
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("oldstyle")
        \ .FadeIO(gDissolveLength)
}

#completeclip
#flipvertical

examplePhoneAction