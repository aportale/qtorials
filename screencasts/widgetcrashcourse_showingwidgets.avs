# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("..\..\..\tools.avsi")

global gAudioClip = WAVSource("qts60garden_audio.wav")
global gAudioNoiseStart = 13216700 / 44100.0
global gAudioNoiseEnd = 13225219 / 44100.0

function audioWelcome()
{
    return
        \ audioNoise(1.5)
\[*
    #n Let's start by writing a few lines of code that will show some Qt widgets.
    #  Text: "Create & show Qt widgets"
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoWelcome()
{
    return Dissolve(
        \   ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "Qt SDK Installation on Windows").trim(1,1).loop(155)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "QtCreator, QtDemo, QtLinguist...").trim(1,1).loop(80)
        \ , 6).ConvertToRGB24
}

function audioCreateProject()
{
    return
        \ audioNoise(1.5)
\[*
    #n First we launch our IDE, Qt Creator.
    #  Launching QtCreator
*]
        \ + audioClip(0, 1, 2)
\[*
    #n From the File menu we select "New..." ... "Empty Qt4 Project".
    #  File->New...->Empty Qt4 Project
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The wizard asks us for a project name and we call it "widgetCrashCourse".
    #t widgetCrashCourse
*]
        \ + audioClip(0, 1, 2)
\[*
    #n After finishing the Wizard we get a project which consists of a file with the extension ".pro".
    #n This is the actual project file, and it is currently empty.
    #  clicking on "widgetCrashCourse.pro"
*]
        \ + audioClip(0, 1, 2)
\[*
    #n A right click on the project folder let's us add a new...
    #  Click on "Add New..."
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...C++ Source file.
    #  Click on "C++ Source File"
*]
        \ + audioClip(0, 1, 2)
\[*
    #n We call it main.cpp...
    #t main.cpp
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...and finish the wizard.
    #n click "OK" and "Finish"...
*]
        \ + audioClip(0, 1, 2)
\[*
    #n Our project, now contains a .cpp file. And the project file now has a "SOURCE" entry...
    #n ...the new main.cpp file
    #  opening .pro file. Selectring "SOURCES" and then "main.cpp"
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoCreateProject()
{
}

function audioCoding()
{
    return
        \ audioNoise(1.5)
\[*
    #n Now, lets write some code.
    #  opening "main.cpp"
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The main.cpp file includes the Qt Gui header
    #t {#}include <QtGui>
    #  first, silently remove te bogus include.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n In the main function...
    #t {ENTER}{ENTER}§int main(int argc, char *argv[]){ENTER}{{}{ENTER}{ENTER}{ASC 125}{ENTER}§{UP}{UP}
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...we have a QApplication object...
    #t {TAB}QApplication app(
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...which takes the command line arguments of our program as constructor parameters.
    #t argc, argv);
*]
        \ + audioClip(0, 1, 2)
\[*
    #n Then, we execute the application and let the main function return the result.
    #t {ENTER}§return app.exec();
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The execution call is usually at the end of the main function...
    #n ...so, the code of our gui program will be before that line.
    #t {HOME}{ENTER}{UP}{ENTER}§
*]
        \ + audioClip(0, 1, 2)
\[*
    #n Let's instantiate a QDialog...
    #t QDi^{SPACE}§{DOWN}§{ENTER} dialog;{ENTER}
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...and show it.
    #t di^{SPACE}§{ENTER}.sh§{ENTER}
*]
        \ + audioClip(0, 1, 2)
\[*
    #n Before adding more code, I want to see, if our program already works. That's why I simply press the shiny "play" button.
    #  Click on Play
*]
        \ + audioClip(0, 1, 2)
\[*
    #n There is our dialog! It is still too empty to be useful, so lets show some more widgets.
    #  playing around with empty dialog and closing it
*]
        \ + audioClip(0, 1, 2)
\[*
    #n A QTextEdit is a very useful widget for editing texts.
    #t {ENTER}{ENTER}§QTextE^{SPACE}§{ENTER} textEdit;{ENTER}§tex^{SPACE}.sh§{ENTER}
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The omnipresent QPushButton...
    #t {ENTER}{ENTER}§QP^{SPACE}§u§{ENTER} pushButton({DOWN}{DOWN}§{ENTER}
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...can get its text as a contructor parameter...
    #t "Click me :)");{ENTER}§pushButton.show();
*]
        \ + audioClip(0, 1, 2)
\[*
    #n How does our program look now?
    #  Starting application
*]
        \ + audioClip(0, 1, 2)
\[*
    #n ...Ohhh Keyyy(!)... We see the new widgets and that they are functional. But each of it is in its own window.
    #  Moving windows around
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoCoding()
{
}

function audioOutro()
{
    #n The next Qtorial will explain the reason for this behavior and demonstrate how to put widgets inside a dialog.

    return audioNoise(1) + audioClip(312.704, 317.112, 0)
}

function videoOutro()
{
    return ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1).ConvertToRGB24
}

function clip_2d()
{
    return Dissolve(
        \   AudioDub(videoCoding(), audioCoding())
        \ , 6)
}

function clip_3d()
{
    audio = clip_2d().killvideo()
    video = ImageSource("screencast_3D_480x360/%04d.png", start = 1, end = 5517, fps = 25)
    return AudioDub(video, audio)
}

function completeclip()
{
    qtLogo = ImageReader("..\..\..\qtlogosmall_480x360.png", 0, 0, 25, pixel_type="rgb32")
    qtLogoMask = qtLogo.showalpha()
    oldStyleGradient = ImageReader("..\..\..\oldstylegradient_480x360.png", 0, 0, 25, pixel_type="rgb32")
    oldStyleGradientAlpha = oldStyleGradient.showalpha()

    return Dissolve(
        \   AudioDub(videoWelcome(), audioWelcome()).ConvertToYUY2()
        \ , clip_3d().ConvertToYUY2().Overlay(qtlogo, 0, 0, qtlogomask, 0.7)
        \ , AudioDub(videoOutro(), audioOutro()).ConvertToYUY2()
        \ , 6).Overlay(oldStyleGradient, mask = oldStyleGradientAlpha)
}

#clip_2d()
#AudioDub(videoCarbide(), audioCarbide())
completeclip()