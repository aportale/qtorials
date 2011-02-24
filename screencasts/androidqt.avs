# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "androidqt_narration.wav")
global gAudioNoiseStart = 54.575987
global gAudioNoiseEnd = 55.449887
global gClipWidth = 960
global gClipHeight = 720
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Getting started with\nQt on Android", 75)
        \ , gDissolveLength)
}

function videoWelcome_960x720
{
    DirectShowSource(gMediaDir + "qtsymbian_development.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtsymbian_development.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 200, 40, 1568, 880)
}

function audioAboutAndroidPort
{
    audioNoise(2)
\[*
    #n Hi, my name is Alessandro. I want to talk about the community port of Qt to Android, and show how to get our first Qt application running on Android.
    #n It all began when Qt announced the "Lighthouse", project which makes Qt easy to port to nearly any operating system.
    #n Bogdan Vatra, a Romanian software engineer with a strong passion for Qt and for Android, read about Lighthouse and decided to port Qt to Android... as a spare time project.
    #n Not even a year later, Bodgan announced the test version of a complete Qt for Android development suite.
*]
        \ + audioClip(1.155, 15.005, 1)

        \ + audioNoise(10)
}

function audioNecessitasComponents
{
    audioNoise(2)
\[*
    #n The suite is called "Necessitas". It consists of:
    #n The Lighthouse based Qt port to Android
    #n A complete Qt Creator integration. With packaging and debugging support. And much more.
    #n The Necessitas suite installer, which sets up the Android Qt development libraries and Qt Creator on top of a standard Android development environment.
    #n And "Ministro". The deployment service for Qt libraries to the end-consumer.
*]
        \ + audioClip(0.101, 25.475, 1)

        \ + audioNoise(10)
}

function videoNecessitasComponents
{
    Dissolve(
        \   textClip("Necessitas:\n\n\n\n", 135)
        \ , textClip("Necessitas:\nQt for Android\n\n\n", 100)
        \ , textClip("Necessitas:\nQt for Android\nQt Creator for Android\n\n", 130)
        \ , textClip("Necessitas:\nQt for Android\nQt Creator for Android\nNecessitas installer\n", 220)
        \ , textClip("Necessitas:\nQt for Android\nQt Creator for Android\nNecessitas installer\nMinistro", 145)
        \ , gDissolveLength)
}

function necessitasComponents
{
    AudioDub(videoNecessitasComponents, audioNecessitasComponents)
}

function audioAndroidSdk
{
    audioNoise(0.5)
\[*
    #n Let's start by downloading and setting up the Android Software development kit, as well as the Android native development kit.
*]
        \ + audioClip(28.606, 35.131, 0.5)
\[*
    #n From the android developer site, we download the linux version of the Android sdk.
*]
        \ + audioClip(35.758, 40.472, 2)
\[*
    #n And from another page on that site we get the Android ndk.
*]
        \ + audioClip(43.699, 47.252, 2.5)
\[*
    #n Then, we extract both downloaded archives.
*]
        \ + audioClip(48.065, 50.736, 1)
\[*
    #n For Android development, we need a Java Development Kit aswell as "Ant", the Java Build Tool.
*]
        \ + audioClip(56.146, 62.206, 1)
\[*
    #n The Android SDK is not yet completely set up. We need to do some things in the Android SDK Manager.
*]
        \ + audioClip(64.598, 70.240, 4)
\[*
    #n We get the Platform tools and the SDK Platform for at least one Android version.
*]
        \ + audioClip(73.700, 78.414, 3.5)
\[*
    #n Then we create a new virtual device for the Android emulator...
*]
        \ + audioClip(79.273, 82.663, 0.5)
\[*
    #n With enough space on the SD Card and with our screen resolution of choice.
*]
        \ + audioClip(82.965, 87.191, 1)

        \ + audioNoise(10)
}

function videoAndroidSdk_960x720
{
    clip = DirectShowSource(gMediaDir + "androidqt_androidsdkndk.avi")
        \ .converttorgb32
    download_cut =
        \   clip.trim(30, 127)                                          [* Focussing input field *]
        \ + clip.trim(127, 250).selectevery(2).assumefps(25)            [* Googling "Android SDK" *]
        \ + clip.trim(250, 370)                                         [* Start Downloading SDK *]
        \ + clip.trim(370, 1012).selectevery(15).assumefps(25)          [* Downloading SDK *]
        \ + clip.trim(1065, 1210)                                       [* Goto NDK Page *]
        \ + clip.trim(1210, 1558).selectevery(15).assumefps(25)         [* Downloading NDK *]
    setup_cut =
        \   clip.trim(1620, 1775).selectevery(4).assumefps(25)          [* Extracting SDK *]
        \ + clip.trim(1775, 1775).loop(20)                              [* Extracting SDK *]
        \ + clip.trim(1820, 1964).selectevery(4).assumefps(25)          [* Extracting NDK *]
        \ + clip.trim(2300, 2428).selectevery(4).assumefps(25)          [* apt-get*]
        \ + clip.trim(2428, 2575).selectevery(2).assumefps(25)          [* jdk ant *]
        \ + clip.trim(2575, 3050).selectevery(4).assumefps(25)          [* installing jdk ant *]
        \ + clip.trim(3050, 3270).selectevery(2).assumefps(25)          [* launching sdk manager *]
        \ + clip.trim(3270, 3400).selectevery(4).assumefps(25)          [* sdk manager opens *]
        \ + clip.trim(3400, 3472).selectevery(2).assumefps(25)          [* Click Available versions *]
        \ + clip.trim(3472, 3620).selectevery(4).assumefps(25)          [* List updates *]
        \ + clip.trim(3620, 3700)                                       [* Selecting tool and froyo *]
        \ + clip.trim(3700, 3768).selectevery(2).assumefps(25)          [* Click: Yes, Ok *]
        \ + clip.trim(3768, 4644).selectevery(80).assumefps(25)         [* installing tools *]
        \ + clip.trim(4644, 4678)                                       [* Agree adb update *]
        \ + clip.trim(4678, 4795).selectevery(15).assumefps(25)         [* adb restarts *]
        \ + clip.trim(4795, 4926).selectevery(2).assumefps(25)          [* Click avd *]
        \ + clip.trim(5200, 5515).selectevery(2).assumefps(25)          [* Creating device *]
        \ + clip.trim(5725, 5925).selectevery(3).assumefps(25)          [* Creating device *]

    Dissolve(download_cut, setup_cut, gDissolveLength)
}

function androidSdk
{
    AudioDub(videoWithClipSize("videoAndroidSdk"), audioAndroidSdk)
}

function audioNecessitas
{
    audioNoise(1)
\[*
    #n Having the standard Android SDK installed, we can now continue with the Qt part.
*]
        \ + audioClip(88.840, 93.832, 2)
\[*
    #n Necessitas is hosted on source forge.
*]
        \ + audioClip(95.840, 98.397, 4)
\[*
    #n We just need to download one installer...
*]
        \ + audioClip(98.647, 100.589, 3)
\[*
    #n ...and run it.
*]
        \ + audioClip(100.624, 101.364, 4)
\[*
    #n The installer creates a start menu entry which we use to launch Qt Creator.
*]
        \ + audioClip(102.623, 107.186, 1)
\[*
    #n Under Tools -> ...
*]
        \ + audioClip(111.427, 112.347, 0.5)
\[*
    #n ... -> Options -> ...
*]
        \ + audioClip(112.437, 112.942, 1.5)
\[*
    #n ... Android, ...
*]
        \ + audioClip(112.945, 113.586, 1)
\[*
    #n ... we specify the Android SDK and NDK locations, aswell as the toolchain and Ant location.
*]
        \ + audioClip(113.847, 120.126, 1)
\[*
    #n Our virtual device which we created moments ago has been detected and there is even the possibility to add and remove devices and launch the emulator from within Creator!
*]
        \ + audioClip(121.571, 131.532, 1)
\[*
    #n In the Qt4 options we add a new Qt version, by specifying the location of the qmake binary that came with Necessitas.
*]
        \ + audioClip(133.216, 140.820, 1)

        \ + audioNoise(10)
}

function videoNecessitas_960x720
{
    clip = DirectShowSource(gMediaDir + "androidqt_necessitas.avi")
        \ .converttorgb32
    download_cut =
        \   clip.trim(94, 94).loop(135)                                 [* Google *]
        \ + clip.trim(94, 444).selectevery(2).assumefps(25)             [* Googling "necessitas" *]
        \ + clip.trim(444, 660).selectevery(6).assumefps(25)            [* Start Downloading *]
        \ + clip.trim(660, 685)                                         [* Save As... *]
        \ + clip.trim(660, 4360).selectevery(100).assumefps(25)         [* downloading... *]

    installation_cut = 
        \   clip.trim(4575, 4850).selectevery(4).assumefps(25)          [* Launching *]
        \ + clip.trim(5245, 5280)                                       [* Starting installation *]
        \ + clip.trim(5280, 5320).selectevery(2).assumefps(25)          [* Starting installation *]
        \ + clip.trim(5320, 9120).selectevery(200).assumefps(25)        [* Installing *]
        \ + clip.trim(9120, 9210).selectevery(2).assumefps(25)          [* Finished *]

    setup_cut = 
        \   clip.trim(9340, 9340).loop(20)                              [* Desktop *]
        \ + clip.trim(9340, 9430)                                       [* Launching Creator *]
        \ + clip.trim(9462, 9604)                                       [* Opening options *]
        \ + clip.trim(9604, 10155).selectevery(3).assumefps(25)         [* Setting paths *]

    Dissolve(download_cut, installation_cut, setup_cut, gDissolveLength)
}

function necessitas
{
    AudioDub(videoWithClipSize("videoNecessitas"), audioNecessitas)
}

function audioCreatorAction
{
    audioNoise(2)
\[*
    #n Let's finally get our first Qt application running on Android.
*]
        \ + audioClip(141.981, 145.279, 1)
\[*
    #n I am opening a Qt Quick Application called "Samegame"
*]
        \ + audioClip(145.894, 149.272, 1)
\[*
    #n ...and select a Qt version.
*]
        \ + audioClip(150.062, 151.641, 1)
\[*
    #n Creator generated a few Java files for us which are the shell for our C++ based Qt application.
*]
        \ + audioClip(152.790, 158.676, 1)
\[*
    #n The file "libs.xml" lists which Qt modules are needed to launch our application. Samegame also needs "QtDeclarative".
*]
        \ + audioClip(159.269, 167.674, 1)
\[*
    #n Now we can press play, and see how our application gets first built as shared library...
*]
        \ + audioClip(168.533, 173.305, 1)
\[*
    #n ...then the java code gets built and package gets created.
*]
        \ + audioClip(173.642, 177.078, 1)
\[*
    #n Samegame gets deployed to my attached device, and gets launched.
*]
        \ + audioClip(177.984, 182.198, 1)

        \ + audioNoise(10)
}

function audioQmlOnDevice
{
    audioNoise(2)
\[*
    #n Finally, we see our first Qt/QML application running on Android.
*]
        \ + audioClip(183.766, 188.653, 1)
\[*
    #n While, we are here, let's look at a few more QML applications.
*]
        \ + audioClip(189.780, 193.309, 1)
\[*
    #n An initial input methods implementation has already been done.
*]
        \ + audioClip(195.596, 199.253, 1)
\[*
    #n OpenGL support is still missing in the first version of Qt for Android, because of technical issues. But the software rendering is pretty performant.
*]
        \ + audioClip(199.854, 207.586, 1)

        \ + audioNoise(10)
}

function audioCreatorDebugging
{
    audioNoise(2)
\[*
    #n What if our application has bugs?
*]
        \ + audioClip(209.583, 212.602, 1)
\[*
    #n No reason to worry, BogDan already implemented Android debugging in Creator. For emulator and device.
    #n You can see the debugger in action on his YouTube channel.
*]
        \ + audioClip(212.590, 221.936, 1)

        \ + audioNoise(10)
}

function audioWhatAboutDeployment
{
    audioNoise(2)
\[*
    #n We have everything we need to create, develop, test and package Qt applications for Android.
    #n But... what about deployment? The Qt libraries need to be present on the end users' device, in order to make our Qt application work.
    #n That's why BogDan also implemented a pretty smart deployment service for Qt libraries... called Ministro.
*]
        \ + audioClip(0, 1, 1)

        \ + audioNoise(10)
}

function audioMinistro
{
    audioNoise(2)
\[*
    #n The very first time any necessitas based Qt application is started on a device, the user is asked to install the "Ministro" application.
*]
        \ + audioClip(224.340, 232.618, 1)
\[*
    #n Then, the Marked app launches and offers Ministro to be installed with a few clicks.
*]
        \ + audioClip(233.094, 238.086, 1)
\[*
    #n Please note, this only happens once on a device, if Ministro was not yet installed.
*]
        \ + audioClip(239.804, 245.203, 1)
\[*
    #n Now, Ministro will download the missing Qt libraries that are required for our application.
*]
        \ + audioClip(245.934, 251.101, 1)
\[*
    #n Remember the "libs.xml" where we added QtDeclarative? Ministro uses that data to determine which Qt libraries need to be downloaded.
*]
        \ + audioClip(253.121, 261.584, 1)
\[*
    #n The libraries are stored in a central location on the system and are now shared among Qt applications.
    #n Therefore, the next launch of a Qt application may not trigger any library download.
*]
        \ + audioClip(263.245, 273.705, 1)
\[*
    #n Another very crucial point of Ministro is that it downloads a version of Qt libraries that is compatible with the Android version running on the end users' device.
*]
        \ + audioClip(274.588, 284.317, 1)

        \ + audioNoise(10)
}

function audioOutro
{
    audioNoise(1)
\[*
    #n Thanks for watching. Enjoy migrating your Qt app to Android.
 *]
        \ + audioClip(285.682, 289.665, 1)

        \ + audioNoise(10)
}

function videoQtPorts
{
    BlankClipRGB(455)
    \.QtorialsSvgAnimation("qtsymbian_development.svg"
        \ , "mainwindow"          ,   80,  455,     "fade"        , "immediate"
        \ , "lineedit"            ,  140,  455,     "fadeandscale", "immediate"
        \ , "pushbutton"          ,  160,  455,     "fadeandscale", "immediate"
        \ , "listwidget"          ,  195,  455,     "fadeandscale", "fade"
        \ , "foolineedit"         ,  250,  455,     "fade"        , "fadeandscale"
        \ , "finger"              ,  305,  365,     "immediate"   , "immediate"
        \ , "foolistwidget"       ,  365,  455,     "fadeandscale", "fade"
    \ )
}

function QtPorts
{
    AudioDub(videoQtPorts, audioQtPorts)
}

function videoCreatorAppWizard_960x720
{
    appwizard = DirectShowSource(gMediaDir + "qtsymbian_development_appwizard.avi")
        \ .converttorgb32
    appwizard_createin_blink =
        \   appwizard.trim(198, 198).loop(13)               [* blinking cursor *]
        \ + appwizard.trim(197, 197).loop(13)
    appwizard_cut =
        \   appwizard.trim(0, 197)                          [* Until Class name entered *]
        \ + appwizard_createin_blink.loop(7)                [* Project on same drive as S60 SDK and Qt for Symbian *]
            \ .QtorialsHighlight(314, 410, 22, 24, 0, 180)
        \ + appwizard.trim(197, 371)

    appwizard_cut
}

function videoCreatorAppWizard_640x360
{
    videoCreatorAppWizard_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1
        \ ,   45,  -1,      160,  180,       -1,   -1
        \ ,  145,  -1,      174,  234,       -1,   -1
        \ ,  420,  -1,       -1,   -1,       -1,   -1           [* Finito *]
        \ )
}

function creatorAppWizard
{
    AudioDub(videoWithClipSize("videoCreatorAppWizard"), audioCreatorAppWizard)
}

function videoCreatorAction_960x720
{
    desktopapp = DirectShowSource(gMediaDir + "qtsymbian_development_desktopapp.avi")
    desktopapp_cut =
        \   desktopapp.trim(1, 833)                             [* Start until first goto slot *]
        \ + desktopapp.trim(836, 860).loop(4)                   [* Cursorblink *]
        \ + desktopapp.trim(860, 1329)                          [* first goto slot until app launch *]
        \ + desktopapp.trim(1329, 1329).loop(3)                 [* app launch delay *]
        \ + desktopapp.trim(1390, 1437)                         [* app launch until type hello *]
        \ + desktopapp.trim(1464, 1629)                         [* type hello until *]
    projectmode = DirectShowSource(gMediaDir + "qtsymbian_development_projectmode.avi")
    projectmode_cut =
        \   projectmode.trim(70, 720)                           [* changed to project mode *]
        \ + projectmode.trim(720, 720).loop(440)                [* wait for that guy to finish talking *]
        \ + projectmode.trim(720, 1230)                         [* talking guy until device detected *]
        \ + projectmode.trim(1230, 1230).loop(120)              [* device detected *]
            \ .QtorialsHighlight(159, 489, 220, 14, 0, 120)
        \ + projectmode.trim(1230, 1262)                        [* projectmode left *]
    devicedebugging = DirectShowSource(gMediaDir + "qtsymbian_development_devicedebugging.avi")
    devicedebugging_cut =
        \   devicedebugging.trim(1, 1).loop(480)                [* changed to project mode *]
        \ + devicedebugging.trim(1, 50)                         [* changed to project mode *]
        \ + devicedebugging.trim(50, 50).loop(110)              [* context menu from debug button *]
        \ + devicedebugging.trim(50, 150)                       [* *]
        \ + devicedebugging.trim(150, 150).loop(1000)           [* configuration helper dialog *]
        \ + devicedebugging.trim(150, 225)                      [* start of debugger launch *]
        \ + devicedebugging.trim(381, 600)                      [* app starts up *]
        \ + devicedebugging.trim(600, 600).loop(237)            [* app runs *]
        \ + devicedebugging.trim(680, 1115)                     [* app hits breakpoint *]
            \ .QtorialsHighlight(424, 431, 238, 89, 160, 320)
    Dissolve(
        \   desktopapp_cut
        \ , projectmode_cut
        \ , devicedebugging_cut
        \ , gDissolveLength).converttorgb32
}

function videoCreatorAction_640x360
{
    videoCreatorAction_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1
        \ ,  115,  -1,      160,    0,       -1,   -1
        \ ,  490,  -1,      320,  360,       -1,   -1
        \ ,  585,  -1,      320,   48,       -1,   -1
        \ ,  850,  -1,      186,  330,       -1,   -1
        \ , 1230,  -1,        0,  148,      960,  540
        \ , 1450,  -1,       72,  144,       -1,   -1
        \ , 1600,  -1,       -1,   -1,       -1,   -1
        \ , 1720,  -1,      320,  192,       -1,   -1
        \ , 1770,  -1,      320,    0,       -1,   -1
        \ , 1865,  -1,       -1,   -1,       -1,   -1
        \ , 1925,  -1,      180,  360,       -1,   -1
        \ , 2180,  -1,       -1,   -1,       -1,   -1
        \ , 2310, 120,        0,  182,       -1,   -1
        \ , 2810,  -1,      236,  190,       -1,   -1                     [* Selecting new build configuration from popup *]
        \ , 2880,  -1,      288,  106,       -1,   -1                     [* accepting runconfiguration name *]
        \ , 2940,  -1,       -1,   -1,       -1,   -1                     [* Scrolling down *]
        \ , 3070,  -1,        0,  360,       -1,   -1                     [* Adding new run configuration *]
        \ , 3330,  -1,       -1,   -1,       -1,   -1                     [* Exiting rpoject mode *]
        \ , 3890,  -1,        0,  360,       -1,   -1                     [* Selection run configuration grom debug button popup *]
        \ , 4060,  -1,      164,  164,       -1,   -1                     [* configuration helper dialog *]
        \ , 5130,  -1,       -1,   -1,       -1,   -1                     [* Qreator is active *]
        \ , 5270,  -1,        0,    0,     1240,  720                     [* Phone blends in *]
        \ , 5590, 120,      260,  194,       -1,   -1                     [* App runs on phone *]
        \ , 6020,  -1,       -1,   -1,       -1,   -1                     [* Finito *]
        \ ) 
}

function creatorActionWithOverlay
{
    trkRgb =
        \  DirectShowSource(gMediaDir + "qtsymbian_development_launchapptrk.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    debugRgb =
        \  DirectShowSource(gMediaDir + "qtsymbian_development_debugapplication.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    overlay = Dissolve(
        \   Blankclip(trkRgb, 4624)
        \ , trkRgb
        \ , Blankclip(debugRgb, 185)
        \ , debugRgb + debugRgb.trim(debugRgb.Framecount, debugRgb.Framecount).loop(140)
        \ , Blankclip(debugRgb, 185)
        \ , gDissolveLength)

    AudioDub(videoWithClipSize("videoCreatorAction"), audioCreatorAction)
        \ .layer(overlay, x = gClipWidth - overlay.Width, y = (gClipHeight - overlay.height) / 2)
}

function videoOutro
{
    BlankClipRGB(250)
        \ .QtorialsElements("qtlogobig")
}

function outro
{
    AudioDub(audioOutro, videoOutro)
}

function completeclip
{
    return
        \ Dissolve(
            \   intro
            \ , welcome.converttorgb
            \ , QtPorts
            \ , creatorAppWizard
            \ , creatorActionWithOverlay
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength)
}

#completeclip
necessitas
