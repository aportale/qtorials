Import("..\..\..\tools.avsi")

global gAudioClip = WAVSource("qts60garden_audio.wav")
global gAudioNoiseStart = 13216700 / 44100.0
global gAudioNoiseEnd = 13225219 / 44100.0

function audioWelcome()
{
    #n In the last Qtorials, we implemented a Qt Dialog by writing C++ code.
    #  Short flash back to last video
    a2 = audioClip(0.0, 2.0, 1)

    #n This Qtorial woill show how to create the dialog in a purely visual fashion with the Qt Designer.
    a1 = audioNoise(0.7) + audioClip(0.0, 2.0, 1)

    return a1 + a2 + audioNoise(10)
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
    #n In order to start a new Gui Application, we chose "File"->"New", chose "Qt4 Gui Application" and press "OK"
    a1 = audioClip(0.0, 2.0, 1)

    #n The wizard asks us for the name of our new Project. We simply call it "MyFirstGui" and click on "Next".
    
    #n On the following page we can choose additional Qt modules for our application. But to keep things simple, we continue without selecting additional modules.
    
    #n The wizard will create our Ui as a C++ class. We chose QDialog as base class and give our class the name "MyFirstDialog". Notice how the other fields in this page got updated accordingly.
    
    #n We leave the header file name "myfirstdialog.h" and Source file name "myfirstdialog.cpp" as they are. We will see them again, later in the generated sources.
    
    #n The wizard will create a form file for us and we leave its file name unchanged. The last page of the wizard shows us an overview of the generated files. We complete the Wizard by clicking "Finish".

    return a1 + a2 + a3 + a4 + audioNoise(10)
}

function videoApplicationWizard()
{
}

function audioFilesOverview()
{
    #n A couple of files have been created. Let's take a short look at them.
    a1 = audioClip(0.0, 2.0, 1)
    
    #n "myfirstguiproject.pro" is the project description file. "TARGET" defines the name of the executable that we compile. Setting "TEMPLATE" to "app" makes sure that the end product is an executable in instead of a library. "SOURCES" defines the cpp files and "HEADERS" the header files. "FORMS" defines the Qt designer files of our project.
    
    #n The main.cpp should already look familiar to us. It includes some QtGui headers and our own myfirstdialog.h. The main function instantiates a QApplication and executes it at the end. Inbetween, our dialog is instantiated and shown.
    
    #n The next files "myfirstdialog.cpp" and "myfirstdialog.h" declare and define our user interface class. We have a MyFirstDialog, derived from QDialog. Constructor and destructor are already there. And there is also a mysterious ui pointer which we will cover in the next Qtorial.
    
    #n MyFirstDialog.ui is the visual form file which is currently still empty. What we see here is Qt designer in action, waitin for us to add widgets. We will however do that in the next Qtorial.
    
    #n How does the application look, right now? - It is an empty dialog, as expected.

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + audioNoise(10)
}

function videoFilesOverview()
{
}

function audioOutro()
{
    #n Don't miss the next Qtorial where we will add widgets to our dialog via drag and drop.

    return audioNoise(1) + audioClip(312.704, 317.112, 0)
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