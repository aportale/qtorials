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
    #n In the last Qtorial, we created multiple widgets which showed up as single windows.
    #  Short flash back to last video
    a2 = audioClip(0.0, 2.0, 1)

    #n We will now learn about parent-child relationships in Qt and how to apply them in order to place widgets _into_ dialogs
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

function audioBoringTheory()
{
    #n First the boring (but short) theory about parent-child relationships
    #  Text "parent-child relationships"
    a1 = audioClip(0.0, 2.0, 1)

    #n Lets say we have a QWidget (or any type of QObject)
    #  Whiteboard: Drawing one circle in the top
    a2 = audioClip(0.0, 2.0, 1)
    
    #n It can be the parent of other objects
    #  Whiteboard: Drawing two circles below, and connecting via lines
    a3 = audioClip(0.0, 2.0, 1)

    #n Those child objects can be parents of other objects.
    #  Whiteboard: Drawing two circles below the right child, and connecting via lines
    a4 = audioClip(0.0, 2.0, 1)

    #n Which usually leads to an object tree.
    #  Whiteboard: Blending over a Tree (?)
    a5 = audioClip(0.0, 2.0, 1)

    #n One big benefit of such trees in Qt is the managed object ownership.
    #  Whiteboard: Zoom/panning to root node 
    a6 = audioClip(0.0, 2.0, 1)
    
    #n When an object gets deleted, it will delete its own children first...
    #  Whiteboard: "Delete arrow" is drawn
    a7 = audioClip(0.0, 2.0, 1)

    #n ...and so on.
    #  Whiteboard: Propagated deletion
    a8 = audioClip(0.0, 2.0, 1)

    #n The parent-child relationships has an additional fundamental effect on QWidgets.
    #  Whiteboard: QDialog, QTextEdit and QPushButton are drawn
    a9 = audioClip(0.0, 2.0, 1)

    #n A QWidget which is the parent of other QWidgets...
    #  Whiteboard: Ownership lines are drawn
    a10 = audioClip(0.0, 2.0, 1)
    
    #n ...will contain its childs. In our case, the QDialog -which is also a QWidget, since it derives from QWidget- will contain the QTextEdit and the QPushButton.
    #  Whiteboard: Blend over to a QDialog with QTextEdit and QPushButton in it
    a11 = audioClip(0.0, 2.0, 1)

    return a1 + a2 + a3 + a4 + audioNoise(10)
}

function videoBoringTheory()
{
}

function audioCoding()
{
    #n Let's apply the theory on our code.
    #  Text "Enough theory."
    a1 = audioClip(0.0, 2.0, 1)

    #n Since the QDialog becomes the parent of our widgets and will have the ownership, we need to change the way the child widgets are instantiated.
    #  Moving cursor to line above QTextEdit instatiation, creating a new line above it
    a2 = audioClip(0.0, 2.0, 1)
    
    #n Instead of instantiating them on the stack, we will do that on the heap using the "new" command.
    #t QTextEdit *textEdit = new QTextEdit(
    a3 = audioClip(0.0, 2.0, 1)

    #n We specify the parent by passing the address of the dialog to the QTextEdit contructor.
    #t {DOWN}{DOWN}{DOWN}§{ENTER}&dialog);
    a4 = audioClip(0.0, 2.0, 1)

    #  We remove the old code...
    #t {DOWN}{HOME}{HOME}+{DOWN}§{DEL}{HOME}
    a5 = audioClip(0.0, 2.0, 1)

    #n ...and fix the call of the show() function
    #t ^{RIGHT}{DEL}§->§{ESC}
    a6 = audioClip(0.0, 2.0, 1)
    
    #n Let's do the same for the QPushButton
    #t {DOWN}{ENTER}§QPushButton *pushButton ={ENTER}new QPushButton({DOWN}{DOWN}§{ENTER}"Click me :)", &dialog);{DOWN}{HOME}{HOME}+{DOWN}§{DEL}{HOME}^{RIGHT}{DEL}§->§{ESC}
    a7 = audioClip(0.0, 2.0, 1)

    #n Now we press again the shiny "play" button...
    #  Staring application
    a8 = audioClip(0.0, 2.0, 1)

    #n Well... Text area and push button are now obviously inside the dialog... And they are functional.
    #  Playing around width widgets, zooming in.
    a9 = audioClip(0.0, 2.0, 1)

    #n But they are not nicely layed out. And they also do not adapt their size if the dialog gets resized.
    #  Resizing the dialog around
    a10 = audioClip(0.0, 2.0, 1)

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + audioNoise(10)
}

function videoCoding()
{
}

function audioOutro()
{
    #n The next Qtorial will introduce Qts layout managers and explain how to use on for our little example.

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