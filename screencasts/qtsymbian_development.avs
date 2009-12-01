# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

#global gAudioClip = WAVSource(gMediaDir + "sdkinstallation_windows.wav")
#global gAudioNoiseStart = 1829888 / 44100.0
#global gAudioNoiseEnd = 1912832 / 44100.0
global gClipWidth = 640
global gClipHeight = 360
global gTextClipFramesPerCharacter = 2

function intro
{
    Dissolve(
        \   textClip("Mobile development with\nQt for the Symbian Platform", 75)
        \ , textClip("3 of 3 - Developing with\nQt for Symbian", 75)
        \ , gDissolveLength)
}

function videoWelcome_960x720
{
    DirectShowSource(gMediaDir + "qtsymbian_development.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Crop(400, 0, 1280, 960)
        \ .Lanczos4Resize(gClipWidth, gClipHeight)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtsymbian_development.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Crop(200, 40, 1568, 880)
        \ .Lanczos4Resize(gClipWidth, gClipHeight)
}

function welcome
{
    AudioDub(videoWithClipSize("videoWelcome"), WAVSource(gMediaDir + "qtsymbian_development.wav"))
        \ .DelayAudio(0.26)
        \ .Trim(16, 350)
}

function svgSnippet(string elementsCsv, int frames)
{
    clip =
        \ QtorialsSvg("qtsymbian_development.svg", elementsCsv, gClipWidth, gClipHeight)
    overlayRgbClip(BlankClip(clip, color = gBackgroundColor), clip)
}

function audioMockup
{
    audioNoise(10)
\[*
    #n Let's say our application has a MainWindow.
    #n There is a lineEdit, ... a pushButton ... and a big listWidget.
    #n The user enters text into the lineEdit.
    #n And when the user presses the pushButton, the text gets added to the listWidget.
*]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoMockup
{
    Dissolve(
        \   svgSnippet("", 100)
        \ , svgSnippet("mainwindow", 100)
        \ , svgSnippet("mainwindow, lineedit", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit, finger, foolistwidget", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, foolineedit, foolistwidget", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, barlineedit, foolistwidget", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, barlineedit, foolistwidget, finger, barlistwidget", 100)
        \ , svgSnippet("mainwindow, lineedit, pushbutton, listwidget, barlineedit, foolistwidget, barlistwidget", 100)
        \ , gDissolveLength)
}

function audioCoding
{
    audioNoise(10)
\[*
    #n In QtCreator, we start a new project.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We want a 'Qt4 Gui Application'...
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...with the name 'MyFirstApp'.
    #t MyFirstApp
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We proceed to the end of the project wizard.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In the form editor, we add the widgets to the mainWindow...
    #t pu
    #t lin
    #t lis
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...we just drop them roughly on their final positions, ...
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n and afterwards, we lay the widgets out in a GridLayout.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n We edit the button text.
    #t Add
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n With a right click and 'Go To Slot...'
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...we tell QtCreator that we want to handle the button's 'clicked' signal...
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and the IDE creates the right slot for us.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Our code is just a one-liner.
    #n We add an item to the listWidget.
    #n That item is a text string...
    #t ui->§lis§{ENTER}->§addI§{ENTER}§{DOWN}
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and the text comes from the lineEdit.
    #t ui->§li§{ENTER}->§te§{DOWN}§{DOWN}§{ENTER}
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Now, let's test the application.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n QtCreator will build and run the project as a desktop application, by default.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n And as we can see, the application works.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In order to see the debugger in action, we create a slot that is executed when we select or deselect an item in the listWidget.
    #n As code we add a few simple operations which we can follow in the debugger.
    #n And we set the breakpoint.
    #t int a = 2;§{ENTER}int b = 3;§{ENTER}int c = a + b;§{ENTER}c++;§{ENTER}c++;{ENTER}c++;{ENTER}c++;
 *]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function audioOnDevice
{
    audioNoise(10)
\[*
    #n In order to build, run and debug the application on the phone, we change to the project mode.
    #n First of all: What we see here is the preliminary project manager gui.
    #n The QtCreator team is working on a simpler and more intuitive concept.
    #n Nevertheless, what what we are going to do now should be very easy to reproduce, later on.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In the 'Build Settings' section we add a new 'Build Configuration' using our previously installed Qt Version for Symbian.
    #n It asks for a name.... The default is fine for us.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n And at the bottom of the dialog is the 'Run Settings' section, where we add a new 'run configuration' for our application on the Symbian Device
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n As we can see, QtCreator autmatically detected our device...
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and we are done in the project mode.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n There are now two sets of build and run configurations. One set for the Desktop, which we already used. And one set for the Symbian Device, which we just added.
    #n We want to debug our application on the device, so we need to switch the build and run configurations, accordingly.
    #n With a long mouse press on the 'debug start' button, we get a context menu with the run configurations, where we chose the one for our device.
    #n Then a dialog appears which offers to automatically change the current build configuration to the correct one. We will accept that and continue.
    #n Btw.: Also this part of the user interface in QtCreator is preliminary. There will be a more intuitive and automated way of keeping these configurations in sync. So, stay tuned for the next versions of QtCreator :)
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Before accepting and continuing, we launch the Application TRK on our phone. If it is using Bluetooth, we need to switch to USB mode and connect.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n And now, we start.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The application gets built and deployed to the phone.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and there it is...
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...it works just like the Desktop version. It is Qt after all.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n When selecting an item in the list the breakpoint is hit and we are in our second slot.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Stepping forward we can see how the values of the variables change.
 *]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoCoding
{
}

function audioOutro
{
    audioNoise(10)
\[*
    #n That's it, now you know how to develop your Qt applications on the Desktop and on the Device. Changing back and forth. Isn't that Qt?
    #n Thanks for watching :)
\[*
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoOutro
{
    simpleQtorialsElements("qtlogobig", 100)
}

function completeclip
{
    return
        \ Dissolve(
            \   intro
            \ , welcome.converttorgb
            \ , gDissolveLength)
        \ .overlayQtorialsElements("qtlogosmall, oldstyle")
        \ .FadeIO(gDissolveLength)
#        \ .creativeCommons
}

#completeclip
#videoS60SdksVideo.overlayQtorialsElements("qtlogosmall, oldstyle")
#videoS60Sdks
#videoOverview

videoMockup.overlayQtorialsElements("qtlogosmall, oldstyle")
#converttoyv12