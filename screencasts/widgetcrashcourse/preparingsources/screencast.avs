Import("..\..\..\tools.avsi")

global gAudioClip = WAVSource("qts60garden_audio.wav")
global gAudioNoiseStart = 13216700 / 44100.0
global gAudioNoiseEnd = 13225219 / 44100.0

function audioWelcome()
{
    #n We will now create two very basic files which will constitute a minimalistic Qt Gui program.
    #n It is a 'main.cpp' source file and a Qt project file called 'myfirstapp.pro'.
    a1 = audioNoise(0.7) + audioClip(0.0, 2.0, 1)

    #n These two files will be the basis for the following Qtorials.
    a2 = audioNoise(0.7) + audioClip(0.0, 2.0, 1)

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

function audioMainCpp()
{
    #n Let's launch our favourite text editor with an empty document
    #  Starting Notepad++
    a1 = audioNoise(1) + audioClip(0.0, 2.0, 1)

    #n The main.cpp file includes the Qt Gui header
    #t {#}include <QtGui>
    a2 = audioClip(0.0, 2.0, 1)

    #n In the main function...
    #t {ENTER}{ENTER}§int main(int argc, char *argv[]){ENTER}{{}{ENTER}{ENTER}{ASC 125}{ENTER}§{UP}{UP}
    a3 = audioClip(0.0, 2.0, 1)

    #n ...we have a QApplication object...
    #t {TAB}QApplication app(
    a4 = audioClip(0.0, 2.0, 1)

    #n ...which takes the command line arguments of our program as constructor parameters.
    #t argc, argv);
    a5 = audioClip(0.0, 2.0, 1)
    
    #n Then, we execute the application and let the main function return the result.
    #t {ENTER}§return app.exec();
    a6 = audioClip(0.0, 2.0, 1)

    #n The execution call is usually at the end of the main function. So the code of our gui program will be before that line.
    #t {HOME}{ENTER}{UP}{ENTER}§// Our Gui code goes here{ENTER}
    a7 = audioClip(0.0, 2.0, 1)

    #n We save that file as 'main.cpp'
    #  Save as: main.cpp
    a8 = audioClip(0.0, 2.0, 1)

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + audioNoise(10)
}

function videoMainCpp()
{
}

function audioProFile()
{
    #n Let's create a new document for our Qt project file.
    #  Click "New"
    a1 = audioNoise(4) + audioClip(0.0, 2.0, 1)

    #n Here we will list all the pieces which our program consist of. And since our program is so minimalistic, we only have to specify main.cpp as a source.
    #t SOURCES += main.cpp
    a2 = audioClip(0.0, 2.0, 1)

    #n We save that file as 'myfirstapp.pro'
    #  Save as: myfirstapp.pro

    return a1 + a2 + audioNoise(10)
}

function videoProFile()
{
}

function audioOutro()
{
    #n The next Qtorial will use these two files and fill the main function with code. We will learn how to create and show different widgets.

    return audioNoise(1) + audioClip(0.0, 2.0, 1)
}

function videoOutro()
{
    return ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1).ConvertToRGB24
}

function clip_2d()
{
    return Dissolve(
        \   AudioDub(videoMainCpp(), audioMainCpp())
        \ , AudioDub(videoProFile(), videoProFile())
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