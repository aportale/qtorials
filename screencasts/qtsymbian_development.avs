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
    #n There is a lineEdit... and a pushButton.
    #n And there is a big listWidget.
    #n The user can enter text into the listWidget.
    #n And when the user presses the addButton, the text is added to the listWidget
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
    #n ...with the name 'MyFirstApp'...
    #t MyFirstApp
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n ...and proceed to the end of the project wizard.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In the form editor, we add the widgets to the mainWindow...
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
    #n Now, the button text is adjusted.
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
    #n ...and the IDE creates the slot for us.
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The actual code is a one liner.
    #n We add an item to the listWidget, and that item is a text string.
    #t ui->§lis§{ENTER}->§addI§{ENTER}§{DOWN}
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n The text comes from the lineEdit.
    #t ui->§li§{ENTER}->§te§{DOWN}§{DOWN}§{ENTER}
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n In order to see the debugger in action, we create a slot that is executed when the selection in the listWidget changes.
    #n As code we add some simple operations which we can follow in the debugger.
    #t int a = 2;§{ENTER}int b = 3;§{ENTER}int c = a + b;§{ENTER}c++;§{ENTER}c++;{ENTER}c++;{ENTER}c++;
 *]
        \ + audioClip(1.000, 2.000, 1)
\[*
    #n Now, let's test the application.
    #n QtCreator will create a desktop application, by default.
 *]
        \ + audioClip(1.000, 2.000, 1)

        \ + audioNoise(10)
}

function videoCoding
{
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