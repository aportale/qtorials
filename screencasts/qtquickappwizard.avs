# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

#global gAudioClip = WAVSource(gMediaDir + "qtquickappwizard_narration.wav")
#global gAudioNoiseStart = 5538927 / 44100.0
#global gAudioNoiseEnd = 5559036 / 44100.0
global gClipWidth = 640
global gClipHeight = 360

function intro
{
    Dissolve(
        \   textClip("Qt Quick Applications\non mobile devices", 90)
        \   textClip("...with Qt Creator 2.1", 60)
        \ , gDissolveLength)
}

function videoWelcome_960x720
{
    DirectShowSource(gMediaDir + "qtquickappwizard.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
}

function videoWelcome_640x360
{
    DirectShowSource(gMediaDir + "qtquickappwizard.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, gClipHeight, 200, 40, 1568, 880)
}

function welcome
{
    AudioDub(
        \  videoWithClipSize("videoWelcome")
            \ , WAVSource(gMediaDir + "qtquickappwizard.wav"))
        \ .DelayAudio(0.26)
        \ .Trim(16, 350)
        \ .QtorialsSubtitle("Alessandro Portale", "Nokia, Qt Development Frameworks", 30, 160)
}

function audioPackage
{
    audioNoise(2)
\[*
    #n This is how the package is structured on Symbian
*]
        \ + audioClip(0, 1, 1)

        \ + audioNoise(10)
}

function videoPackage
{
    BlankClipRGB(455)
    \.QtorialsSvgAnimation("qtquickappwizard.svg"
        \ , "mainwindow"          ,   80,  455,     "fade"        , "immediate"
    \ )
}

function package
{
    AudioDub(videoPackage, audioPackage)
}

function audioWizardNew
{
    audioNoise(0)
\[*
    #n In QtCreator, we start a new project.
 *]
        \ + audioClip(0, 1, 1)

        \ + audioNoise(10)
}

function videoWizardNew_960x720
{
    appwizard = DirectShowSource(gMediaDir + "qtquickappwizard.avi")
        \ .converttorgb32
    appwizard_cut =
        \   appwizard.trim(0, 100)                          [* We start Creator's project wizard *]
    appwizard_cut
}

function videoWizardNew_640x360
{
    videoWizardNew_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1
        \ ,   45,  -1,      160,  180,       -1,   -1
        \ ,  420,  -1,       -1,   -1,       -1,   -1           [* Finito *]
        \ )
}

function wizardNew
{
    AudioDub(videoWithClipSize("videoWizardNew"), audioWizardNew)
}

function audioHybrid
{
    audioNoise(5)
\[*
    #n ...
 *]
        \ + audioClip(0, 1, 1)

        \ + audioNoise(10)
}

function videoHybrid_960x720
{
    hybrid = DirectShowSource(gMediaDir + "qtquickappwizard.avi")
    hybrid_cut =
        \   hybrid.trim(1, 833)                             [* Start *]
        \ + hybrid.trim(836, 860).loop(4)                   [* Cursorblink *]
    hybrid_cut
}

function videoHybrid_640x360
{
    videoCreatorAction_960x720.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, gZoomNPanTransitionFrames, gZoomNPanResizeFilter
        \ ,                  -1,   -1,       -1,   -1
        \ , 6020,  -1,       -1,   -1,       -1,   -1                     [* Finito *]
        \ ) 
}

function hybridWithOverlay
{
    modelInQml =
        \  DirectShowSource(gMediaDir + "qtquickappwizard_phoneaction.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    modelInCpp =
        \  DirectShowSource(gMediaDir + "qtquickappwizard_phoneaction.MTS", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .turnright()
        \ .crop(70, 128, 934, 1662)
        \ .Lanczos4Resize(204, 360)
        \ .converttorgb32
    overlay = Dissolve(
        \   Blankclip(trkRgb, 4624)
        \ , modelInQml
        \ , Blankclip(debugRgb, 185)
        \ , modelInCpp
        \ , Blankclip(debugRgb, 185)
        \ , gDissolveLength)

    AudioDub(videoWithClipSize("videoHybrid"), audioHybrid)
        \ .layer(overlay, x = gClipWidth - overlay.Width, y = (gClipHeight - overlay.height) / 2)
}

function audioOutro
{
    audioNoise(1)
\[*
    #n That's it, now you know how to develop your Qt Quick applications on the phone, and how to leverage the benefits of hybrid applications.
 *]
        \ + audioClip(0, 1, 1)

        \ + audioNoise(10)
}

function videoOutro
{
    BlankClipRGB(250)
        \ .QtorialsElements("qtlogobig")
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
            \ , package
            \ , wizardNew
            \ , hybridWithOverlay
            \ , outro
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
