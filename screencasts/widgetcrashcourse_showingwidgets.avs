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
    #n Let's start by writing a few lines of code that generate and show some Qt widgets.
    #  Text: "Create & show Qt widgets"
    a1 = audioNoise(0.7) + audioClip(0.0, 2.0, 1)

    return a1 + audioNoise(10)
}

function videoWelcome()
{
    return Dissolve(
        \   ImageReader("..\..\..\qtlogobackground_480x360.png", 0, 0, 25).Loop(160).AssumeFPS(25, 1)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "Qt SDK Installation on Windows").trim(1,1).loop(155)
        \ , textClip(BlankClip(0, 480, 360, fps=25), "QtCreator, QtDemo, QtLinguist...").trim(1,1).loop(80)
        \ , 6).ConvertToRGB24
}

function audioPreparation()
{
}

function audioCoding()
{
    #n First, we launch Qt Creator...
    #  Launch Qt Creator
    a1 = audioNoise(1) + audioClip(51.653, 55.431, 2)

    #n We will now add code to the main function.
    #  Selection the "Our Gui code goes here" comment
    a4 = audioClip(0.0, 2.0, 1)

    #n Let's instantiate a QDialog...
    #t QDi^{SPACE}§{DOWN}§{ENTER} dialog;{ENTER}
    a5 = audioClip(0.0, 2.0, 1)

    #n ...and show it.
    #t di^{SPACE}§{ENTER}.sh§{ENTER}
    a6 = audioClip(0.0, 2.0, 1)

    #n Before adding more code, I want to see, if our program already works. That's why I simply press the shiny "play" button.
    #  Click on Play
    a7 = audioClip(0.0, 2.0, 1)

    #n There is our dialog! It is still too empty to be useful, so lets show some more widgets
    #  playing around with empty dialog and closing it
    a8 = audioClip(0.0, 2.0, 1)

    #n A QTextEdit is a very useful widget for editing texts
    #t {ENTER}{ENTER}§QTextE^{SPACE}§{ENTER} textEdit;{ENTER}§tex^{SPACE}.sh§{ENTER}
    a9 = audioClip(0.0, 2.0, 1)

    #n The omnipresent QPushButton...
    #t {ENTER}{ENTER}§QP^{SPACE}§u§{ENTER} pushButton({DOWN}{DOWN}§{ENTER}
    a10 = audioClip(0.0, 2.0, 1)

    #n ...can get its text as a contructor parameter...
    #t "Click me :)");{ENTER}§pushButton.show();
    a11 = audioClip(0.0, 2.0, 1)

    #n How does our program look now?
    #  Starting application
    a12 = audioClip(0.0, 2.0, 1)

    #n ...Ohhh Keyyy(!)... We see the new widgets and that they are functional. But each of it is in its own window.
    #  Moving windows around
    a13 = audioClip(0.0, 2.0, 1)

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + audioNoise(10)
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