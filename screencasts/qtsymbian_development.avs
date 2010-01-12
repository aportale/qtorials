# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "qtsymbian_development_narration.wav")
global gAudioNoiseStart = 5538927 / 44100.0
global gAudioNoiseEnd = 5559036 / 44100.0
global gClipWidth = 640
global gClipHeight = 360
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Mobile development with\nQt for the Symbian Platform", 75)
        \ , textClip("Developing with\nQt for Symbian", 75)
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

function welcome
{
    AudioDub(
        \  videoWithClipSize("videoWelcome")
            \ , WAVSource(gMediaDir + "qtsymbian_development.wav"))
        \ .DelayAudio(0.26)
        \ .Trim(16, 350)
        \ .QtorialsSubtitle("Alessandro Portale", "Nokia, Qt Development Frameworks", 30, 160)
}

function audioMockup
{
    audioNoise(2)
\[*
    #n Let's say our application has a MainWindow.
    #n There is a lineEdit, ... a pushButton ... and a big listWidget.
    #n The user enters text into the lineEdit.
    #n And when the user presses the pushButton, the text gets added to the listWidget.
*]
        \ + audioClip(1.155, 15.005, 1)

        \ + audioNoise(10)
}

function videoMockup
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

function mockup
{
    AudioDub(videoMockup, audioMockup)
}

function audioCreatorAppWizard
{
    audioNoise(0)
\[*
    #n In QtCreator, we start a new project.
 *]
        \ + audioClip(16.050, 18.697, 0)
\[*
    #n We want a 'Qt4 Gui Application'...
 *]
        \ + audioClip(18.964, 21.159, 1)
\[*
    #n ...with the name 'MyFirstApp'.
    #t MyFirstApp
    ##n The project has to be created on the same drive where the S60 SDK and Qt for Symbian were installed. That is a requirement by the tool chain.
 *]
        \ + audioClip(21.449, 23.632, 2.5)
\[*
    #n We proceed to the end of the project wizard.
 *]
        \ + audioClip(23.875, 26.604, 10)

        \ + audioNoise(10)
}

function videoCreatorAppWizard_960x720
{
    DirectShowSource(gMediaDir + "qtsymbian_development_appwizard.avi")
		\ .converttorgb32
}

function videoCreatorAppWizard_640x360
{
    videoCreatorAppWizard_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1
        \ ,   45,  -1,      160,  180,       -1,   -1
        \ ,  145,  -1,      174,  234,       -1,   -1
        \ ,  330,  -1,       -1,   -1,       -1,   -1			[* Finito *]
        \ )
}

function creatorAppWizard
{
    AudioDub(videoWithClipSize("videoCreatorAppWizard"), audioCreatorAppWizard)
}

function audioCreatorAction
{
    audioNoise(5)
\[*
    #n In the form editor, we add the widgets to the mainWindow...
    #t pu
    #t lin
    #t lis
 *]
        \ + audioClip(27.405, 30.923, 4)
\[*
    #n ...we just drop them roughly on their final positions, ...
 *]
        \ + audioClip(31.364, 34.243, 4)
\[*
    #n and afterwards, we lay the widgets out in a GridLayout.
 *]
        \ + audioClip(34.545, 37.668, 2.5)
\[*
    #n We edit the button text.
    #t Add{ENTER}
 *]
        \ + audioClip(38.225, 39.944, 0.5)
\[*
    #n With a right click and 'Go To Slot...'
 *]
        \ + audioClip(40.617, 42.730, 0)
\[*
    #n ...we tell QtCreator that we want to handle the button's 'clicked' signal...
 *]
        \ + audioClip(42.904, 46.956, 0)
\[*
    #n ...and the IDE creates the right slot for us.
 *]
        \ + audioClip(47.258, 50.347, 1)
\[*
    #n Our code is just a one-liner.
    #n We add an item to the listWidget.
    #n That item is a text string...
    #t ui->§lis§{ENTER}->§addI§{ENTER}§{DOWN}
 *]
        \ + audioClip(50.718, 57.475, 1)
\[*
    #n ...and the text comes from the lineEdit.
    #t ui->§li§{ENTER}->§te§{DOWN}§{DOWN}§{ENTER}
 *]
        \ + audioClip(57.522, 59.635, 1)
\[*
    #n Now, let's test the application.
 *]
        \ + audioClip(60.134, 62.351, 2)
\[*
    #n QtCreator will build and run the project as a desktop application, by default.
 *]
        \ + audioClip(62.943, 67.715, 3)
\[*
    #n And as we can see, the application works.
 *]
        \ + audioClip(67.831, 70.571, 4)
\[*
    #n In order to see the debugger in action, we create a slot that is executed when we select or deselect an item in the listWidget.
 *]
        \ + audioClip(71.047, 78.715, 4)
\[*
    #n As code we add a few simple operations which we can follow in the debugger.
    #n And we set the breakpoint.
    #t int a = 2;§{ENTER}int b = 3;§{ENTER}int c = a {+} b;§{ENTER}c{+}{+};§{ENTER}c{+}{+};{ENTER}c{+}{+};{ENTER}c{+}{+};
 *]
        \ + audioClip(78.715, 85.130, 1)
\[*
    #n In order to build, run and debug the application on the phone, we change to the project mode.
    #n First of all: What we see here is the preliminary project manager gui.
    #n The QtCreator team is working on a simpler and more intuitive concept.
    #n Nevertheless, what what we are going to do now should be very easy to reproduce, later on.
 *]
        \ + audioClip(85.664, 106.260, 1)
\[*
    #n In the 'Build Settings' section we add a new 'Build Configuration' using our previously installed Qt Version for Symbian.
    #n It asks for a name.... The default is fine for us.
 *]
        \ + audioClip(106.469, 116.988, 1)
\[*
    #n And at the bottom of the dialog is the 'Run Settings' section, where we add a new 'run configuration' for our application on the Symbian Device
 *]
        \ + audioClip(117.336, 125.626, 1)
\[*
    #n As we can see, QtCreator autmatically detected our device...
 *]
        \ + audioClip(126.044, 130.456, 1)
\[*
    #n ...and we are done in the project mode.
 *]
        \ + audioClip(130.525, 132.824, 1)
\[*
    #n There are now two sets of build and run configurations. One set for the Desktop, which we already used. And one set for the Symbian Device, which we just added.
    #n We want to debug our application on the device, so we need to switch the build and run configurations, accordingly.
    #n With a long mouse press on the 'debug start' button, we get a context menu with the run configurations, where we chose the one for our device.
    #n Then a dialog appears which offers to automatically change the current build configuration to the correct one. We will accept that and continue.
    #n Btw.: Also this part of the user interface in QtCreator is preliminary. There will be a more intuitive and automated way of keeping these configurations in sync. So, stay tuned for the next versions of QtCreator :)
 *]
        \ + audioClip(133.172, 179.751, 1)
\[*
    #n Before accepting and continuing, we launch the Application TRK on our phone.
 *]
        \ + audioClip(180.448, 185.306, 3)
\[*
    #n If it is using Bluetooth, we need to switch to USB mode and connect.
 *]
        \ + audioClip(185.434, 190.061, 6)
\[*
    #n And now, we start.
 *]
        \ + audioClip(190.827, 192.778, 2)
\[*
    #n The application gets built and deployed to the phone.
 *]
        \ + audioClip(193.358, 196.609, 3)
\[*
    #n ...and there it is...
 *]
        \ + audioClip(196.632, 198.188, 6)
\[*
    #n ...it works just like the Desktop version. It is Qt after all.
 *]
        \ + audioClip(198.606, 202.437, 1)
\[*
    #n When selecting an item in the list the breakpoint is hit and we are in our second slot.
 *]
        \ + audioClip(203.204, 208.939, 1)
\[*
    #n Stepping forward we can see how the values of the variables change.
 *]
        \ + audioClip(210.193, 214.814, 1)

        \ + audioNoise(10)
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

function audioOutro
{
    audioNoise(1)
\[*
    #n That's it, now you know how to develop your Qt applications on the Desktop and on the Device. Changing back and forth. Isn't that Qt?
 *]
        \ + audioClip(215.440, 223.718, 1)

        \ + audioNoise(10)
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
            \ , mockup
            \ , creatorAppWizard
            \ , creatorActionWithOverlay
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
