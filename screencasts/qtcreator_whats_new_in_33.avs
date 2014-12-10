LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioNoiseStart = 6034486. / 44100
global gAudioNoiseEnd = 6043035. / 44100
global gClipWidth = 1280
global gClipHeight = 720
global gMediaPrefix = gMediaDir + "WhatsNewInQtCreator33_"
global gAudioClip = WAVSource(gMediaDir + "WhatsNewInQtCreator33.wav")

function titleAndClip(String titleText, clip theClip)
{
    Dissolve(textClip(titleText).convertToRgb24.killAudio.FadeIn(8, color = $ffffff), theClip, gDissolveLength)
}

function videoIntro
{
    textClip("What's new in\nQt Creator 3.3", 175).convertToRgb24.killAudio
}

function audioIntro
{
    audioNoise(4)
[*
    #n Hi, this video will show some of the new features in Qt Creator 3.3
*]
        \ + audioClip(0, 0, 1)
        \ + audioClip(0.267, 4.922, 1)
        \ + audioNoise(10)
}

function intro
{
    AudioDub(videoIntro, audioIntro)
}

function audioProjectLoading
{
    audioNoise(2.5)
\[*
    #n Loading of big projects is now faster and does not block the user interface as much as previous versions of Qt Creator did.
*]
        \ + audioClip(5.282, 12.329, 2)
\[*
    #n This has been achieved by moving much of the loading from the Gui thread into separate threads.
*]
        \ + audioClip(13.653, 18.425, 1)
        \ + audioNoise(10)
}

function videoProjectLoading
{
    subtitleFontSize = 55
    slow = DirectShowSource(gMediaPrefix + "ProjectLoadingSlow.avi", audio = false).trim(20, 0).crop(0, 0, 640, 0).Subtitle("Qt Creator 3.2", size = subtitleFontSize, align = 2)
    fast = DirectShowSource(gMediaPrefix + "ProjectLoadingFast.avi", audio = false).crop(0, 0, 640, 0).Subtitle("Qt Creator 3.3", size = subtitleFontSize, align = 2)
    fast_cut =
        \   fast.trim(0, 180)              [* Project loaded, cursor in locator *]
        \ + fast.trim(220, 0)              [* locating appmain.cpp *]
    combined = StackHorizontal(slow, fast_cut)
    cut =
        \   combined.trim(10, 76)          [* File -> Recent Projects -> qtcreator.pro *]
        \ + combined.trim(76, 76).loop(10) [* Resting on qtcreator.pro *]
        \ + combined.trim(76, 430)         [* Project gets loaded, source is edited *]
    titleAndClip("Faster project loading", cut)
}

function projectLoading
{
    AudioDub(videoProjectLoading, audioProjectLoading)
}

function audioEditorDragAndDrop
{
    audioNoise(1.5)
\[*
    #n Documents can now be dragged between splits and editor windows...
*]
        \ + audioClip(19.853, 23.312, 3.5)
\[*
    #n ...and from navigation views to splits or windows.
*]
        \ + audioClip(24.021, 26.633, 1)
        \ + audioNoise(10)
}

function videoEditorDragAndDrop
{
    clip = DirectShowSource(gMediaPrefix + "EditorDragAndDrop.avi", audio = false).trim(0, 300)
    titleAndClip("Drag and Drop\nof documents", clip)
}

function editorDragAndDrop
{
    AudioDub(videoEditorDragAndDrop, audioEditorDragAndDrop)
}

function audioDesignerTabView
{
    audioNoise(4)
\[*
    #n The Qt Quick Designer has support for the TabView QtQuick control.
*]
        \ + audioClip(27.782, 31.683, 3)
\[*
    #n Users of the professional or enterprise version can now manage tabs directly in the form editor.
*]
        \ + audioClip(33.738, 38.893, 1)
        \ + audioNoise(10)
}

function videoDesignerTabView
{
    clip = DirectShowSource(gMediaPrefix + "DesignerTabView.avi", audio = false)
    cut =
        \   clip.trim(80, 350)                                   [* Adding tab view and two tabs, entering into tab1 *]
        \ + clip.trim(350, 680).SelectEvery(12, 0).AssumeFPS(25) [* Adding content to Tab1 and Tab2, go to play *]
        \ + clip.trim(680, 780)                                  [* Pressing play, hovering button *]
        \ + clip.trim(797, 910)                                  [* Pressing button, switching tab, etc. *]
    titleAndClip("Tab View support\nin Qt Quick Designer", cut)
}

function designerTabView
{
    AudioDub(videoDesignerTabView, audioDesignerTabView)
}

function audioDesignerUiSplit
{
    audioNoise(1)
\[*
    #n This release introduces the file extension ".ui.qml".
*]
        \ + audioClip(41.331, 44.791, 0.5)
\[*
    #n Forms with that extension are .qml files which are meant to be edited with the professional or enterprise version of the Qt Quick Designer.
*]
        \ + audioClip(47.879, 55.496, 3.5)
\[*
    #n Other code can be placed inside implementation files of the forms.
*]
        \ + audioClip(56.959, 60.627, 1)
\[*
    #n This ensures that a very complex .ui.qml file can at any later time be edited in the Qt Quick Designer.
*]
        \ + audioClip(61.835, 67.976, 1)
        \ + audioNoise(10)
}

function videoDesignerUiSplit
{
    clip = DirectShowSource(gMediaPrefix + "DesignerUiSplit.avi", audio = false)
    cut =
        \   clip.trim(10, 90)                                        [* Clicking on MainForm.ui.qml *]
        \ + clip.trim(90, 90).loop(80)                               [* Mouse on MainForm.ui.qml *]
        \ + clip.trim(90, 95)                                        [* Designer is opening *]
        \ + clip.trim(95, 13490).SelectEvery(80, 0).AssumeFPS(25)    [* Creating print dialog *]
        \ + clip.trim(13795, 13795)                                  [* Clicking on Edit *]
        \ + clip.trim(13795, 14500).SelectEvery(4, 0).AssumeFPS(25)  [* Clicking on MainForm Item *]
        \ + clip.trim(14500, 14700)                                  [* Clicking on Edit *]
    titleAndClip(".ui.qml file format", cut)
}

function designerUiSplit
{
    AudioDub(videoDesignerUiSplit, audioDesignerUiSplit)
}

function audioTheme
{
    audioNoise(1)
\[*
    #n Qt Creator now supports theming of the user interface.
*]
        \ + audioClip(69.010, 72.284, 1.5)
\[*
    #n The "dark" theme comes with Qt Creator.
*]
        \ + audioClip(72.818, 74.873, 4.5)
\[*
    #n Custom themes can be added.
*]
        \ + audioClip(75.964, 77.578, 11)
\[*
    #n The theming feature is a contribution by members of the Qt Community.
*]
        \ + audioClip(78.472, 82.129, 1)
        \ + audioNoise(10)
}

function videoTheme
{
    clip = DirectShowSource(gMediaPrefix + "Theme.avi", audio = false)
    darkTheme = clip.trim(25, 295)                              [* Selecting dark theme *]
    ownTheme =
        \   clip.trim(330, 370)                                 [* Positioning cursor on "ThemeName" *]
        \ + clip.trim(370, 576).SelectEvery(4, 0).AssumeFPS(25) [* Editing MyTheme *]
        \ + clip.trim(606, 685).SelectEvery(2, 0).AssumeFPS(25) [* Go to options dialog *]
        \ + clip.trim(685, 840)                                 [* Selecting MyTheme *]
    contribution =
        \   clip.trim(841, 841).loop(50)                        [* Codereview website with 93717 *]
        \ + clip.trim(841, 862)                                 [* Scrolling down *]
        \ + clip.trim(862, 862).loop(110)                        [* Bottom of the page *]
    cut = Dissolve(darkTheme, ownTheme, contribution, gDissolveLength)
    titleAndClip("Theming support", cut)
}

function theme
{
    AudioDub(videoTheme, audioTheme)
}

function audioHighDPI
{
    audioNoise(0.5)
\[*
    #n High-DPI support in Qt was so far a speciality on OSX and iOS.
*]
        \ + audioClip(83.534, 88.178, 0.5)
\[*
    #n Qt 5.4 now adds experimental High-DPI support for Windows and Linux.
*]
        \ + audioClip(88.990, 93.843, 0.5)
\[*
    #n To honor that, Qt Creator improves its appearance on High-DPI screens and looks more crisp than ever.
*]
        \ + audioClip(94.656, 101.088, 1)
        \ + audioNoise(10)
}

function videoHighDPI
{
    clip = DirectShowSource(gMediaPrefix + "HighDPI.avi", audio = false)
    cut =
    \   clip.trim(0, 156)            [* Welcome screen action, click on "Edit" *]
    \ + clip.trim(156, 156).loop(25) [* Stay on Edit mode for a second *]
    \ + clip.trim(156, 415)          [* Click on "Build" and got along bottom bar *]
    cutAndZoomed = cut.QtorialsZoomNPan(
        \ gClipWidth, gClipHeight, gZoomNPanExpansionColor, 40, "BlackmanResize"
        \ ,                  -1,   -1,       -1,   -1
        \ ,   80,  -1,        0,    0,       -1,   -1           [* Upper left *]
        \ ,  233,  -1,        0,  900,       -1,   -1           [* Lower left *]
        \ ,  370,  -1,     1600,  900,       -1,   -1           [* Lower right *]
        \ )
    titleAndClip("Improved\nHighDPI support", cutAndZoomed)
}

function highDPI
{
    AudioDub(videoHighDPI, audioHighDPI)
}

function audioProfiler
{
    audioNoise(1)
\[*
    #n The QML Profiler now offers the possibility to select which types of events to record, which can reduce profiling overhead.
*]
        \ + audioClip(102.621, 110.051, 1.5)
\[*
    #n Categories can be reordered.
*]
        \ + audioClip(110.933, 112.489, 9)
\[*
    #n Annotations can be created which are stored with the QML trace for exchange with other developers.
*]
        \ + audioClip(113.650, 119.281, 1.5)
\[*
    #n The professional and enterprise versions allow profiling of memory usage and of the scene graph.
*]
        \ + audioClip(120.686, 125.481, 1)
        \ + audioNoise(10)
}

function videoProfiler
{
    clip = DirectShowSource(gMediaPrefix + "Profiler.avi", audio = false)
    clickingMemoryUsageEvents =
    \ + clip.trim(1125, 1145)
    \ + clip.trim(1155, 1159)
    \ + clip.trim(1180, 1189)
    \ + clip.trim(1200, 1220)
    cut =
    \   clip.trim(10, 260)                                    [* Filtering channels, reordering categories, start profiling *]
    \ + clip.trim(260, 617).SelectEvery(3, 0).AssumeFPS(25)   [* Profiling *]
    \ + clip.trim(617, 691)                                   [* Clicking "Adding annotation" *]
    \ + clip.trim(691, 730)                                   [* Typing in "too slow!" *]
    \ + clip.trim(730, 883).SelectEvery(2, 0).AssumeFPS(25)   [* Clicking Save QML Trace, Typing in "MyTrace"  *]
    \ + clip.trim(883, 895)                                   [* Finishing saving *]
    \ + clip.trim(895, 895).loop(20)                          [* Finishing saving *]
    \ + clip.trim(930, 1044).SelectEvery(2, 0).AssumeFPS(25)  [* Scrolling to commercial categories *]
    \ + clip.trim(1063, 1125)                                 [* Clicking 3 memory usage events *]
    \ + clickingMemoryUsageEvents.SelectEvery(2, 0).AssumeFPS(25)
    \ + clip.trim(1218, 1310)                                 [* Clicking Scene graph events *]
    titleAndClip("QML Profiler\nimprovements", cut)
}

function profiler
{
    AudioDub(videoProfiler, audioProfiler)
}

function audioWizards
{
    audioNoise(3)
\[*
    #n Wizards are now implemented with a new wizard engine.
*]
        \ + audioClip(127.164, 130.020, 3.5)
\[*
    #n Custom wizards can be added by anyone with a new, simple but powerful json based description.
*]
        \ + audioClip(131.402, 136.649, 1)
        \ + audioNoise(10)
}

function videoWizards
{
    clip = DirectShowSource(gMediaPrefix + "Wizards.avi", audio = false)
    cut =
    \   clip.trim(20, 257)                                  [* Showing "New File Or Project" dialog, switching to editor with own wizard *]
    \ + clip.trim(257, 383).SelectEvery(3, 0).AssumeFPS(25) [* Editing the wizard *]
    \ + clip.trim(383, 490)                                 [* Showing "New File Or Project" dialog with own wizard *]
    \ + clip.trim(490, 490).loop(50)                        [*  *]
    titleAndClip("New wizard engine", cut)
}

function wizards
{
    AudioDub(videoWizards, audioWizards)
}

function audioOutro
{
    audioNoise(1)
\[*
    #n We hope you like the new Qt Creator.
    #n Thank You for watching.
*]
        \ + audioClip(137.797, 140.908, 1)
        \ + audioNoise(10)
}

function videoOutro
{
    Dissolve(
        \   textClip("Thank you for\nwatching", 140)
        \ , textClip("2014, The Qt Company.\nAll rights reserved.", 70)
        \ , gDissolveLength
    \ ).convertToRgb24.killAudio
}

function outro
{
    AudioDub(videoOutro, audioOutro)
}

function completeclip
{
    sequence = Dissolve(
        \   intro
        \ , projectLoading
        \ , editorDragAndDrop
        \ , designerTabView
        \ , designerUiSplit
        \ , profiler
        \ , theme
        \ , highDPI
        \ , wizards
        \ , outro
        \ , gDissolveLength)

    qtlogo = ImageSource("qt_logo_small_1280x720.png", pixel_type = "RGB32")

    return sequence.Overlay(qtlogo, opacity = 0.65, mask = qtlogo.ShowAlpha).FadeIO(gDissolveLength)
}

completeclip

#intro
#projectLoading
#editorDragAndDrop
#designerTabView
#designerUiSplit
#theme
#highDPI
#profiler
#wizards
#outro
