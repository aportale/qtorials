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
    #n In the last Qtorial, we used parent-child relationships in order to put widgets inside a dialog.
    #  Short flash back to last video
    a2 = audioClip(0.0, 2.0, 1)

    #n We will now learn some basics about Qts layout management and how use it in our application
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
    #n First the boring (but short) theory about Qts layout management 
    #  Text "Qts layout management"
    a1 = audioNoise(2) + audioClip(0.0, 2.0, 1)

    #n We have our QDialog with child-QWidgets "A", "B", "C". As we saw, without layout management, the children are in the upper left.
    #  Whiteboard: QDialog with overlapping A, B, C children
    a2 = audioClip(0.0, 2.0, 1)

    #n The parent of the widgets...
    #  Whiteboard: Empty dialog
    a3 = audioClip(0.0, 2.0, 1)

    #n ...needs its layout manager...
    #  Whiteboard: Underneath dialog: Indicating horizontal boxlayout with strokes. Arrow from layout to dialog
    a4 = audioClip(0.0, 2.0, 1)

    #n ...which will layout the children.
    #  Whiteboard: Underneath dialog: Widgets A, B, C. Arrow from widgets to boxlayout
    a5 = audioClip(0.0, 2.0, 1)
    
    #n What we see here is the Horizontal Box Layout, arranging the children horizontally in a row.
    #  Whiteboard: Widgets A, B, C inside boxlayout, inside dialog. (Subtitle: HBoxLayout)
    a6 = audioClip(0.0, 2.0, 1)

    #n The Vertical Box Layout does domething similar...
    #  Whiteboard: Blending to: layout next to dialog, next to Widgets A, B, C. With arrows.
    a7 = audioClip(0.0, 2.0, 1)

    #n ...only in a vertical fashion.
    #  Whiteboard: Blending to: Widgets A, B, C inside boxlayout, inside dialog. (Subtitle: VBoxLayout)
    a8 = audioClip(0.0, 2.0, 1)

    #n Then there is the Gridlayout...
    #  Whiteboard: 2x2 gridlayout next to dialog, next to Widgets A, B, C. With arrows. Lower right cell is empty
    a9 = audioClip(0.0, 2.0, 1)

    #n ...which acts like a table as we know them from Html.
    #  Whiteboard: Blending to: Widgets A, B, C inside gridlayout, inside dialog. Lower right cell is empty. (Subtitle: QGridLayout)
    a10 = audioClip(0.0, 2.0, 1)

    #n A laid out widget can span mutiple cells, just like in Html.
    #  Whiteboard: Blending to: Widgets A, B, C inside gridlayout, inside dialog. C Widget spans over both lower cells. (Subtitle: QGridLayout)
    a11 = audioClip(0.0, 2.0, 1)

    #n It is possible to nest layout managers of different types one into the other...
    #  Whiteboard: main HorizontalLayout takes 1) VBoxLayout 2) Widget 3) QGridLayout. All sublayouts filled with widgtes. Many arrows.
    a12 = audioClip(0.0, 2.0, 1)

    #n ...so there are theoretically no limits for the complexity of Qt Guis.
    #  Whiteboard: Blending to: Same as before, only all laid out
    a13 = audioClip(0.0, 2.0, 1)

    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + audioNoise(10)
}

function videoBoringTheory()
{
}

function audioCoding()
{
    #n Let's apply the theory on our code.
    #  Text "Enough theory."
    a1 = audioClip(0.0, 2.0, 1)

    #n We create a layout manager for the QDialog... More precisely a "vertical box" layout...
    #  Open main.cpp, go to the end of dialog.show()
    #t {ENTER}§{ENTER}§{UP}§QVBoxLayout *layout = new QVBoxLayout(
    
    #n ...and what is the parameter that we pass to the constructor?? The address of the dialog. The dialog takes the ownership of the layout and the layout lays out child widgets of the dialog.
    #t &dialog);

    #n We have to tell the layout about the widgets which it is supposed to lay out. We do that by "adding" them to the layout.
    #t {DOWN}§{DOWN}§{DOWN}§{END}§{ENTER}§layout->addWidget(textEdit);§{DOWN}§{DOWN}§{DOWN}§{DOWN}§{END}§{ENTER}§layout->addWidget(pushButton);

    #n Btw., since now the widgets have a parent and are layed out, we do not need to show them individually. They are shown automatically when the parent is shown.
    #t {UP}{END}§+{HOME}§+{HOME}§{DEL}{DEL}§{UP}§{UP}§{UP}§{UP}§{UP}+{END}§{DEL}{DEL}

    #n Let's see what our current program looks like
    #  Cliack "Play"
    
    #n The widgets are now laid out nicely. Even if the dialog is resized.
    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + audioNoise(10)
}

function videoCoding()
{
}

function audioOutro()
{
    #n The next Qtorial will show how to create the same Gui in a vissual manner with Qts Designer.

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