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
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 400, 0, 1280, 960)
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
        \ .overlayRgbClip(
            \   QtorialsSubtitle(gClipWidth, gClipHeight, "Alessandro Portale", "Nokia, Qt Development Frameworks", 30, 160))
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg("qtsymbian_development.svg", elementsCsv, gClipWidth, gClipHeight, frames)
    overlayRgbClip(BlankClip(clip, color = gBackgroundColor), clip)
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
    Dissolve(
        \   svgSnippet("", 80)
        \ , svgSnippet("mainwindow", 60)
        \ , svgSnippet("mainwindow, lineedit", 30)
        \ , svgSnippet("mainwindow, lineedit, pushbutton", 35)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget", 50)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit", 70)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit, finger, foolistwidget", 30)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit, foolistwidget", 100)
        \ , gDissolveLength)
}

function mockup
{
    AudioDub(videoMockup, audioMockup)
}

function audioCreatorAction
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
 *]
        \ + audioClip(21.449, 23.632, 2.5)
\[*
    #n We proceed to the end of the project wizard.
 *]
        \ + audioClip(23.875, 26.604, 6)
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

function deviceOverlay
{
    trkRrb =
        \  DirectShowSource(gMediaDir + "qtsymbian_development_launchapptrk.MTS")
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    debugRrb =
        \  DirectShowSource(gMediaDir + "qtsymbian_development_debugapplication.MTS")
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    Dissolve(
        \   Blankclip(trkRrb, 4990)
        \ , trkRrb
        \ , Blankclip(debugRrb, 185)
        \ , debugRrb + debugRrb.trim(debugRrb.Framecount, debugRrb.Framecount).loop(140)
        \ , Blankclip(debugRrb, 185)
        \ , gDissolveLength)
}

function videoCreatorAction_960x720
{
    appwizard = DirectShowSource(gMediaDir + "qtsymbian_development_appwizard.avi")
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
        \   appwizard
        \ , desktopapp_cut
        \ , projectmode_cut
        \ , devicedebugging_cut
        \ , gDissolveLength).converttorgb32
}

function videoCreatorAction_640x360
{
    setDetailClip(videoCreatorAction_960x720)
    setDetail(-140, 0, 1240, 720)
    showDetail(25, -140, 0, 1240, 720)
        \ + showDetail( 125, 160, 180)
        \ + showDetail( 335, 174, 234)
        \ + showDetail( 465, -140, 0, 1240, 720)
        \ + showDetail( 840, 160, 0)
        \ + showDetail( 935, 960 - 640, 720 - 360)
        \ + showDetail(1200, 960 - 640, 48)
        \ + showDetail(1580, 186, 330)
        \ + showDetail(1800, 0, 148, 960, 540)
        \ + showDetail(1950, 72, 144)
        \ + showDetail(2070, -140, 0, 1240, 720)
        \ + showDetail(2120, 320, 192)
        \ + showDetail(2215, 960 - 640, 0)
        \ + showDetail(2275, -140, 0, 1240, 720)
        \ + showDetail(2530, 180, 360)
        \ + showDetail(2660, -140, 0, 1240, 720)
        \ + showDetail(3160, 0, 182, gClipWidth, gClipHeight, 120)
        \ + showDetail(3230, 236, 190)                          [* Selecting new build configuration from popup *]
        \ + showDetail(3290, 288, 106)                          [* accepting runconfiguration name *]
        \ + showDetail(3420, -140, 0, 1240, 720)                [* Scrolling down *]
        \ + showDetail(3680, 0, 360)                            [* Adding new run configuration *]
        \ + showDetail(4240, -140, 0, 1240, 720)                [* Exiting rpoject mode *]
        \ + showDetail(4410, 0, 360)                            [* Selection run configuration grom debug button popup *]
        \ + showDetail(5560, 164, 164)                          [* configuration helper dialog *]
        \ + showDetail(6010, 0, 0, 1240, 720)                   [* Qreator is active *]
        \ + showDetail(6370, 260, 194)                          [* App runs on phone *]
        \ + showDetail(6437, -140, 0, 1240, 720)                [* Finito *]
    layer(deviceOverlay, x = gClipWidth - 204)
}

function creatorAction
{
    AudioDub(videoWithClipSize("videoCreatorAction"), audioCreatorAction)
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
    simpleQtorialsElements("qtlogobig", 250)
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
            \ , creatorAction
            \ , outro
            \ , gDissolveLength)
        \ .overlayQtorialsElements("qtlogosmall, oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip

#converttoyv12