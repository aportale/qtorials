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
    #n In the last Qtorials, we implemented a Qt Dialog by writing C++ code.
    #  Short flash back to last video
*]
        \ + audioClip(0, 1, 2)
\[*
    #n This Qtorial woill show how to create the dialog in a purely visual fashion with the Qt Designer.
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

function audioApplicationWizard()
{
    return
        \ audioNoise(1.5)
\[*
    #n In order to start a new Gui Application, we chose "File"->"New", chose "Qt4 Gui Application" and press "OK"
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The wizard asks us for the name of our new Project. We simply call it "MyFirstGui" and click on "Next".
*]
        \ + audioClip(0, 1, 2)
\[*
    #n On the following page we can choose additional Qt modules for our application. But to keep things simple, we continue without selecting additional modules.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The wizard will create our Ui as a C++ class. We chose QDialog as base class and give our class the name "MyFirstDialog". Notice how the other fields in this page got updated accordingly.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n We leave the header file name "myfirstdialog.h" and Source file name "myfirstdialog.cpp" as they are. We will see them again, later in the generated sources.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The wizard will create a form file for us and we leave its file name unchanged. The last page of the wizard shows us an overview of the generated files. We complete the Wizard by clicking "Finish".
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoApplicationWizard()
{
}

function audioFilesOverview()
{
    return
        \ audioNoise(1.5)
\[*
    #n A couple of files have been created. Let's take a short look at them.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n "myfirstguiproject.pro" is the project description file. "TARGET" defines the name of the executable that we compile. Setting "TEMPLATE" to "app" makes sure that the end product is an executable in instead of a library. "SOURCES" defines the cpp files and "HEADERS" the header files. "FORMS" defines the Qt designer files of our project.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The main.cpp should already look familiar to us. It includes some QtGui headers and our own myfirstdialog.h. The main function instantiates a QApplication and executes it at the end. Inbetween, our dialog is instantiated and shown.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n The next files "myfirstdialog.cpp" and "myfirstdialog.h" declare and define our user interface class. We have a MyFirstDialog, derived from QDialog. Constructor and destructor are already there. And there is also a mysterious ui pointer which we will cover in the next Qtorial.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n MyFirstDialog.ui is the visual form file which is currently still empty. What we see here is Qt designer in action, waitin for us to add widgets. We will however do that in the next Qtorial.
*]
        \ + audioClip(0, 1, 2)
\[*
    #n How does the application look, right now? - It is an empty dialog, as expected.
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoFilesOverview()
{
}

function audioOutro()
{
    return
        \ audioNoise(1.5)
\[*
    #n Don't miss the next Qtorial where we will add widgets to our dialog via drag and drop.
*]
        \ + audioClip(0, 1, 2)

        \ + audioNoise(10)
}

function videoOutro()
{
    return ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1).ConvertToRGB24
}

function clip_2d()
{
    return Dissolve(
        \   AudioDub(videoBoringTheory(), audioBoringTheory())
        \ , AudioDub(videoCoding(), audioCoding())
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