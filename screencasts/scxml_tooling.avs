# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
LoadPlugin("ffms2.dll")
Import("tools.avsi")
Import(gFFDShowImport)

global gAudioClip = WAVSource(gMediaDir + "scxml_tooling.wav")
global gAudioNoiseStart = 3259511 / 44100.0
global gAudioNoiseEnd = 3315898 / 44100.0
global gFastPreview = false
global gClipWidth = gFastPreview ? 640 : 1920
global gClipHeight = gFastPreview ? 360 : 1080
global gTextColor = $ffffff
global gBackgroundColor = $09102b

function myWarp(clip sourceClip, float x, float y, float size)
{
    gFastPreview ? sourceClip : myWarp_impl(sourceClip, x, y, size)
}

function myWarp_impl(clip sourceClip, float x, float y, float size)
{
    borderX = 640
    borderY = 360

    newX = borderX + x
    newY = borderY + y

    warpWidth = sourceClip.width * size
    warpHeight = sourceClip.height * size

    warpSkewTop = 40.0 * size
    warpSkewBottom = 40.0 * size

    return sourceClip
        \ .AddBorders(borderX, borderY, borderX, borderY, color=$ffffff)
        \ .Warp(newX, newY + warpSkewTop,
            \ newX + warpWidth, newY,
            \ newX, newY + warpHeight - warpSkewBottom,
            \ newX + warpWidth, newY + warpHeight)
}

function screenCastClip(string fileBaseName)
{
    #DirectShowSource(gMediaDir + fileBaseName + ".avi", audio = false).AssumeFps(60)

    # for %i in (*.avi) do ffmpeg -i %i -y -an -vf scale=640:-1 -vcodec qtrle %~ni_small.mov
    # for %i in (*.avi) do ffmpeg -i %i -y -an -vcodec qtrle %~ni.mov

    FFVideoSource(gMediaDir + fileBaseName + (gFastPreview ? "_small" : "") + ".mov", colorspace = "RGB32").AssumeFps(60)
}

function nTimesSpeed(clip sourceClip, int n)
{
    sourceClip.SelectEvery(n).AssumeFps(sourceClip.FrameRate)
}

function doubleSpeed(clip sourceClip)
{
    sourceClip.nTimesSpeed(2).AssumeFps(sourceClip.FrameRate)
}

function threeHalvesSpeed(clip sourceClip)
{
    sourceClip.SelectEvery(3, 1, 2).AssumeFps(sourceClip.FrameRate)
}

function fourThirdsSpeed(clip sourceClip)
{
    sourceClip.SelectEvery(4, 1, 2, 3).AssumeFps(sourceClip.FrameRate)
}

function scaleToMovieSize(clip sourceClip)
{
    gFastPreview ? sourceClip : sourceClip.BicubicResize(gClipWidth, gClipHeight)
}

function withTitle(clip sourceClip, string title)
{
    blank = BlankClipRGB(30).assumefps(sourceClip.FrameRate).killAudio
    titleClip = textClip(title, frames = 240).assumefps(sourceClip.FrameRate).killAudio
    Dissolve(blank, titleClip, blank, sourceClip, blank, 15).killAudio
}

function intro
{
    FFmpegSource2(gMediaDir + "Qt_IntroLogo_v03_60fps" + (gFastPreview ? "_small" : "") + ".mov", colorspace = "RGB32").AssumeFps(60).trim(0, 280).audioDub(WAVSource(gMediaDir + "qtintrosound_mono.wav"))
}

function outro
{
    FFmpegSource2(gMediaDir + "Qt_OutroLogo_v03_60fps" + (gFastPreview ? "_small" : "") + ".mov", colorspace = "RGB32").AssumeFps(60).audioDub(WAVSource(gMediaDir + "qtintrosound_mono.wav"))
}

function videoNewProject
{
    new_project = screenCastClip("scxml_tooling_new_project")
    fullscreen =
        \   new_project.trim(35, 100)                      [* File *]
        \   new_project.trim(100, 100).loop(100)           [* File *]
    wizardAction =
        \   new_project.trim(100, 354)                     [* New Project -> Qt Quick Application -> Next *]
        \ + new_project.trim(354, 471).threeHalvesSpeed    [* Type "trafficlight" *]
        \ + new_project.trim(472, 786)                     [* Finishing Wizard *]
        \ + new_project.trim(756, 817).loop(4)             [* Finishing Wizard, cursor blinks *]
    newProject =
        \   fullscreen
        \ + wizardAction

    newProject.myWarp(0, 0, 1).scaleToMovieSize
}

function audioNewProject
{
    #  Introduction

    audioNoise(1)
\[*
    #n This video demonstrates the usage of the Qt SCXML module..
*]
        \ + audioClip(1.776, 5.572, 0.4)
\[*
    #n and how Qt Creator supports us when using the module.
*]
        \ + audioClip(6.037, 8.777, 0.8)
\[*
    #n For that purpose, we will reimplement the "Traffic light" example from scratch. It a simple State Machine driven, Qt Quick example which is included in the Qt documentation.
*]
        \ + audioClip(12.631, 22.267, 0.6)

        \ + audioNoise(10)
}

function videoEditingStateChart
{
    new_scxmlfile = screenCastClip("scxml_tooling_new_scxmlfile")
    clip = screenCastClip("scxml_tooling_modelling_scxml")
    setname = screenCastClip("scxml_tooling_set_statemachine_name")
    new_scxmlfile_cut =
        \   new_scxmlfile.trim(80, 223).doubleSpeed        [* Go to "Add New..." *]
        \ + new_scxmlfile.trim(223, 223).Loop(45)          [* on "Add New..." *]
        \ + new_scxmlfile.trim(223, 446)                   [* Selecting New State Chart *]
        \ + new_scxmlfile.trim(494, 604).doubleSpeed       [* Typing "statemachine" *]
        \ + new_scxmlfile.trim(625, 760).nTimesSpeed(3)    [* Finishing Wizard *]
    fullscreen =
        \   clip.trim(420, 420).Loop(120)                  [* Empty state chart *]
        \ + clip.trim(420, 700)                            [* Positioning "Initial" *]
    green_state =
        \   clip.trim(773, 815)                            [* Hovering to "new" state context menu *]
        \ + clip.trim(840, 885)                            [* Dragging "Transition to new State" *]
        \ + clip.trim(930, 995)                            [* Dropping "Transition to new State" *]
        \ + clip.trim(1035, 1080).doubleSpeed              [* Typing "green" *]
    yellow_state =
        \   clip.trim(1190, 1330)                          [* Creating yellow state *]
        \ + clip.trim(1380, 1470).doubleSpeed              [* Typing "yellow" *]
        \ + clip.trim(1550, 1640).doubleSpeed              [* Resizing yellow state *]
    red_state =
        \   clip.trim(1640, 1860).threeHalvesSpeed         [* Creating red state *]
        \ + clip.trim(1890, 1920).doubleSpeed              [* Typing "red" *]
        \ + clip.trim(1955, 2003).threeHalvesSpeed         [* Moving red state *]
        \ + clip.trim(2104, 2200).threeHalvesSpeed         [* Fit to screen *]
    greenGoingRed_state =
        \   clip.trim(2755, 2790)                          [* Move mouse to green state *]
        \ + clip.trim(2810, 2875).threeHalvesSpeed         [* Hovering to "new" state context menu *]
        \ + clip.trim(2875, 2875).Loop(20)                 [* over "Transition to new State" *]
        \ + clip.trim(2875, 2934)                          [* Dropping "Transition to new State" *]
        \ + clip.trim(3000, 3020)                          [* Move mouse to name label *]
        \ + clip.trim(3166, 3375).doubleSpeed              [* Typing "greenGoingRed" *]
        \ + clip.trim(3410, 3590).nTimesSpeed(4)           [* resize greenGoingRed state *]
        \ + clip.trim(3590, 3645).threeHalvesSpeed         [* center greenGoingRed state *]
    startGoingRed_event =
        \   clip.trim(3840, 3890).threeHalvesSpeed         [* Selecting startGoingRed label *]
        \ + clip.trim(3965, 4125).doubleSpeed              [* Typing "startGoingRed" *]
        \ + clip.trim(4373, 4402)                          [* Move mouse to green state *]
        \ + clip.trim(4440, 4470)                          [* Context menu opens *]
        \ + clip.trim(4508, 4612)                          [* Select "send" *]
        \ + clip.trim(4612, 4677)                          [* Move mouse to event name *]
    startGoingRed_event_properties =
        \   clip.trim(4739, 4960).doubleSpeed              [* Typing "startGoingRed" *]
        \ + clip.trim(4970, 4987)                          [* Move mouse to event delay #1 *]
        \ + clip.trim(4998, 5056)                          [* Move mouse to event delay #2 *]
        \ + clip.trim(5094, 5111)                          [* Move mouse to event delay #3 *]
        \ + clip.trim(5411, 5480).doubleSpeed              [* Typing "3s" *]
        \ + clip.trim(5488, 5488).Loop(120)                [* Delay entered *]
    remaining_chart =
        \   clip.trim(5816, 6020)                          [* Create goRed transition *]
        \ + clip.trim(6170, 6200)                          [* Select goRed transition label *]
        \ + clip.trim(7276, 7460).doubleSpeed              [* Drag redGoingGreen state *]
        \ + clip.trim(7564, 7614)                          [* Drop redGoingGreen state, edit name *]
        \ + clip.trim(8020, 8300)                          [* selecting startGoingGreenTrasitionLabel *]
        \ + clip.trim(10036, 10290)                        [* Create goGreen transition *]
        \ + clip.trim(10408, 10490)                        [* Typing "goGreen" *]
        \ + clip.trim(11910, 11910).Loop(20)               [* Done. *]
    settingChartName =
        \   setname.trim(10, 60)                           [* Select chart name field *]
        \ + setname.trim(110, 450).doubleSpeed             [* Typing "TrafficLightStateMachine" *]
    inspecting_scxml =
        \   clip.trim(11885, 12400)                        [* Switching to Edit mode *]
        \ + clip.trim(12400, 12400).Loop(360)              [* Wait a bit *]
    editingStateChart =
        \   (new_scxmlfile_cut + fullscreen).myWarp(0, 0, 1)
        \ + (green_state + yellow_state + red_state + greenGoingRed_state + startGoingRed_event).myWarp(476, 83, 1117 / 1440.0)
        \ + startGoingRed_event_properties.myWarp(1139, 560, 799 / 1440.0)
        \ + remaining_chart.nTimesSpeed(3).myWarp(0, 0, 1)
        \ + settingChartName.myWarp(1139, 560, 799 / 1440.0)
        \ + inspecting_scxml.myWarp(0, 0, 1100 / 1440.0)

    editingStateChart.scaleToMovieSize
}

function audioEditingStateChart
{
    #  Editing the state chart

    audioNoise(5)
\[*
    #n We launch the file wizard and add a new state chart file to our project.
*]
        \ + audioClip(23.916, 28.305, 2)
\[*
    #n ...The file opens in the visual state chart editor.
*]
        \ + audioClip(29.257, 32.275, 0.2)
\[*
    #n We start modelling our chart by placing the initial state.
*]
        \ + audioClip(32.949, 36.664, 0.2)
\[*
    #n Then we create the "Green" state...
*]
        \ + audioClip(37.360, 39.427, 2.5)
\[*
    #n ...the "Yellow" state...
*]
        \ + audioClip(40.205, 41.238, 3)
\[*
    #n ...and "Red".
*]
        \ + audioClip(43.049, 43.827, 0.5)
\[*
    #n The event "startGoingRed" triggers the transition from "Green" to a sub-state of "Yellow" called "GreenGoingRed".
*]
        \ + audioClip(44.895, 52.674, 1.2)
\[*
    #n The "Green" state has an "OnEntry" handler, which schedules the event "startGoingRed" to be sent after a delay of three seconds
*]
        \ + audioClip(53.476, 62.148, 1.5)
\[*
    #n The rest of the chart is modelled following the same pattern...
*]
        \ + audioClip(62.822, 66.026, 2.5)
\[*
    #n Let's not forget to define the state machine name
*]
        \ + audioClip(71.007, 73.828, 1.5)
\[*
    #n A short glance on the text mode shows the scxml code...
*]
        \ + audioClip(76.231, 80.144, 0.01)
\[*
    #n ...which was generated by the visual chart editor.
*]
        \ + audioClip(80.515, 83.139, 0.5)
\[*
    #n This chart can be read or written by any software which supports scxml.
*]
        \ + audioClip(84.045, 88.863, 1)

        \ + audioNoise(10)
}

function videoRegisterStateMachine
{
    clip = screenCastClip("scxml_tooling_register_statemachine")
    clip_cut =
        \   clip.trim(61, 344)                             [* Open trafficlight.pro, add scxml to QT *]
        \ + clip.trim(345, 440)                            [* Open main.cpp *]
        \ + clip.trim(501, 815).threeHalvesSpeed           [* type 'include "statemachine.h"' *]
    watchCode =
        \   clip.trim(882, 931)                            [* switch to statemachine.h *]
        \ + clip.trim(985, 985).Loop(260)                  [* looking at statemachine.h *]
        \ + clip.trim(985, 1026)                           [* looking at statemachine.h *]
        \ + clip.trim(1050, 1080)                          [* scrolling down *]
        \ + clip.trim(1106, 1166)                          [* Moving mouse away from scrollbar *]
        \ + clip.trim(1166, 1245)                          [* Switching to statemachine.cpp *]
        \ + clip.trim(1267, 1380)                          [* Scrolling down *]
        \ + clip.trim(1380, 1380).Loop(260)                [* Looking at code *]
        \ + clip.trim(1476, 1735)                          [* Move mouse away from scrollbar *]
        \ + clip.trim(2011, 2124)                          [* Move mouse to close button, and close both editors *]
    qmlRegisterType =
        \   clip.trim(2225, 2268)                          [* Put cursor int main function *]
        \ + clip.trim(2267, 2434).doubleSpeed              [* Type "qmlRe"... *]
        \ + clip.trim(2635, 2767).threeHalvesSpeed         [* Type "egisterType"... *]
        \ + clip.trim(2840, 2860)                          [* Type "<"... *]
        \ + clip.trim(2900, 3026).doubleSpeed              [* Type "TrafficLightStateMachine"... *]
        \ + clip.trim(3037, 3060)                          [* Type ">"... *]
        \ + clip.trim(3156, 3180)                          [* Type "("... *]
        \ + clip.trim(3200, 3250)                          [* Type '"'... *]
        \ + clip.trim(3295, 3340)                          [* Select TrafficLightStateMachine *]
        \ + clip.trim(3380, 3470).threeHalvesSpeed         [* Paste TrafficLightStateMachine *]
        \ + clip.trim(3556, 3738).threeHalvesSpeed         [* Type ", 1, 0, " + Paste TrafficLightStateMachine *]
        \ + clip.trim(3834, 3855)                          [* Type ")" *]
        \ + clip.trim(3906, 4040)                          [* Type ";"... looking at code *]
    registerStateMachine =
        \   clip_cut.myWarp(0, 0, 929 / 1440.0)
        \ + watchCode.myWarp(769, 66, 1007 / 1440.0)
        \ + qmlRegisterType.myWarp(778, 36, 813 / 1440.0)

    registerStateMachine.scaleToMovieSize
}

function audioRegisterStateMachine
{
    #  Including the state chart into the build process, and registering the state machine

    audioNoise(5.5)
\[*
    #n We tell the build system to include the Qt SCXML module
*]
        \ + audioClip(92.172, 96.096, 0.6)
\[*
    #n In the main cpp file, we include the "statemachine" header file.
*]
        \ + audioClip(96.374, 100.333, 1)
\[*
    #n The Qt SCXML Compiler produces this c++ code on the basis of our SCXML document.
*]
        \ + audioClip(101.274, 108.124, 0.5)
\[*
    #n This provides us with optimal startup time and performance of our state machine driven application.
*]
        \ + audioClip(110.550, 116.378, 0.5)
\[*
    #n The code generation happens automatically behind the scenes, we do not have to take care about it.
*]
        \ + audioClip(117.272, 122.253, 1.5)
\[*
    #n Back in our application code, we register the state machine type in the QML system.
*]
        \ + audioClip(126.200, 131.738, 3)
\[*
    #n QML can now work with the state machine.
*]
        \ + audioClip(132.412, 135.082, 1)

        \ + audioNoise(10)
}

function videoCreatingTrafficLightQml
{
    populate = screenCastClip("scxml_tooling_qml_populate_form")
    states = screenCastClip("scxml_tooling_qml_create_states")
    background =
        \   populate.trim(510, 596)                        [* Open "Library -> Resources" *]
        \ + populate.trim(649, 755)                        [* Scroll to background image and drag to from *]
        \ + populate.trim(825, 853)                        [* Drop image to form *]
    redSignal =
        \   populate.trim(890, 976)                        [* Scroll to red signal image *]
        \ + populate.trim(977, 1123)                       [* Drag & Drop red signal to form *]
    redSignalOpacity =
        \   populate.trim(1124, 1200).threeHalvesSpeed     [* Move mouse to opacity field *]
        \ + populate.trim(1240, 1290).threeHalvesSpeed     [* Move mouse to away from opacity field *]
        \ + populate.trim(1300, 1420).threeHalvesSpeed     [* type "0.20" *]
    remainingSignals =
        \   populate.trim(1460, 1628)                      [* Drag & Drop yellow signal to form *]
        \ + populate.trim(1690, 1734)                      [* Move mouse to opacity field *]
        \ + populate.trim(1870, 1955)                      [* type "0.20" *]
        \ + populate.trim(2000, 2045)                      [* Move mouse to "Library -> Resources" *]
        \ + populate.trim(2079, 2160)                      [* Scroll to green signal image *]
        \ + populate.trim(2161, 2270)                      [* Drag & Drop green signal to form *]
        \ + populate.trim(2287, 2322)                      [* Move mouse to opacity field *]
        \ + populate.trim(2450, 2580)                      [* type "0.20" *]
        \ + populate.trim(2580, 2580).Loop(160)            [* Done. *]
    editingQml =
        \   (background + redSignal).myWarp(0, 0, 1)
        \ + redSignalOpacity.myWarp(1048, 55, 851 / 1440.0)
        \ + remainingSignals.doubleSpeed.myWarp(0, 0, 1)

    editingQml.scaleToMovieSize
}

function audioCreatingTrafficLightQml
{
    #  Creating the Traffic Light Qt Quick UI

    audioNoise(5.5)
\[*
    #n The background image comes first
*]
        \ + audioClip(145.473, 147.365, 1)
\[*
    #n Now, we position the red light,...
*]
        \ + audioClip(148.108, 150.210, 1)
\[*
    #n ...we reduce its initial opacity...
*]
        \ + audioClip(151.394, 153.623, 1.5)
\[*
    #n ...and we do the same for the yellow and green lights.
*]
        \ + audioClip(154.366, 156.944, 1)

        \ + audioNoise(10)
}

function videoCreatingTrafficLightUIStates
{
    clip = screenCastClip("scxml_tooling_qml_create_states")
    createRedState =
        \   clip.trim(0, 135)                              [* Press "Add State" *]
        \ + clip.trim(134, 135)                            [* Press "Add State" *]
        \ + clip.trim(135, 135).loop(80)                   [* Press "Add State" *]
    editRedState =
        \   clip.trim(136, 190)                            [* Select Red state name label *]
        \ + clip.trim(230, 420)                            [* Type "Red", select red light, set opacity value *]
        \ + clip.trim(600, 700)                            [* Type "1" *]
        \ + clip.trim(700, 700).loop(60)                   [* Red state done *]
    remainingStates =
        \   clip.trim(744, 855)                            [* Press "Add State" *]
        \ + clip.trim(880, 904)                            [* Select state name label *]
        \ + clip.trim(961, 1106)                           [* Type "RedGoingGreen" *]
        \ + clip.trim(1160, 1199)                          [* Select yellow light *]
        \ + clip.trim(1220, 1248)                          [* Select opacity value *]
        \ + clip.trim(1642, 1670)                          [* Type "1" *]
        \ + clip.trim(1888, 1912)                          [* Press "Add State" #1 *]
        \ + clip.trim(1956, 1990)                          [* Press "Add State" #2 *]
        \ + clip.trim(2020, 2058)                          [* Mouse to scrollbar *]
        \ + clip.trim(2099, 2125)                          [* Select state name label *]
        \ + clip.trim(2200, 2292)                          [* Type "Yello" *]
        \ + clip.trim(2369, 2446)                          [* Select red light and opacity *]
        \ + clip.trim(2478, 2550)                          [* Reset opacity *]
        \ + clip.trim(2576, 2599)                          [* Press "Add State" *]
        \ + clip.trim(2615, 2626)                          [* Mouse to scrollbar #1 *]
        \ + clip.trim(2648, 2668)                          [* Mouse to scrollbar #2, and scroll *]
        \ + clip.trim(2680, 2705)                          [* Select state name label *]
        \ + clip.trim(2874, 2946)                          [* Type "Green" *]
        \ + clip.trim(2998, 3028)                          [* Select yellow light *]
        \ + clip.trim(3040, 3060)                          [* Select opacity value *]
        \ + clip.trim(3116, 3156)                          [* Reset opacity *]
        \ + clip.trim(3158, 3192)                          [* Select green light *]
        \ + clip.trim(3206, 3244)                          [* Select opacity value *]
        \ + clip.trim(3500, 3552)                          [* Type "1" *]
        \ + clip.trim(3552, 3552).loop(370)                [* Done. *]
    creatingTrafficLightUIStates =
        \   createRedState.myWarp(0, 0, 1)
        \ + editRedState.myWarp(904, 71, 810 / 1440.0)
        \ + remainingStates.nTimesSpeed(4).myWarp(700, 71, 1046 / 1440.0)

    creatingTrafficLightUIStates.scaleToMovieSize
}

function audioCreatingTrafficLightUIStates
{
    #  Creating the Qt Quick UI states

    audioNoise(6)
\[*
    #n Now we use the Qt Quick State pane to create the "Red" user interface state...
*]
        \ + audioClip(158.453, 163.387, 0.5)
\[*
    #n ...which has a glowing red light.
*]
        \ + audioClip(165.338, 167.393, 1.5)
\[*
    #n We do the same for the other user interface states.
*]
        \ + audioClip(168.751, 171.514, 1)

        \ + audioNoise(10)
}

function videoInstantiatingStateMachine
{
    instantiating = screenCastClip("scxml_tooling_qml_create_statemachine_instance")
    setRunning = screenCastClip("scxml_tooling_qml_set_statemachine_running")
    addingInstanceFullscreen =
        \   instantiating.trim(0, 85)                      [* Move mouse to '+' *]
        \ + instantiating.trim(108, 150)                   [* Dialog pops up *]
        \ + instantiating.trim(150, 150).loop(150)         [* Add new backend object *]
    addingInstance =
        \   instantiating.trim(150, 150).loop(150)         [* Add new backend object *]
        \ + instantiating.trim(166, 238)                   [* Add new backend object *]
        \ + instantiating.trim(238, 238).loop(150)         [* Add new backend object *]
        \ + instantiating.trim(238, 406)                   [* Add new backend object *]
    switchingToMainQml =
        \   setRunning.trim(0, 120)                        [* Chose 'main.qml' in ComboBox *]
    editMainQmlFullscreen =
        \   setRunning.trim(226, 316)                      [* Insert new line *]
    editMainQml =
        \   setRunning.trim(316, 516)                      [* "trafficLightStateMachine.running:" *]
        \ + setRunning.trim(543, 700)                      [* Type "true" *]
    instantiatingStateMachine =
        \   addingInstanceFullscreen.myWarp(0, 0, 1)
        \ + addingInstance.myWarp(495, 385, 745 / 1440.0)
        \ + (switchingToMainQml + editMainQmlFullscreen).myWarp(0, 0, 1)
        \ + editMainQml.myWarp(759, 75, 680 / 1440.0)

    instantiatingStateMachine.scaleToMovieSize
}

function audioInstantiatingStateMachine
{
    #  Instantiating the state machine

    audioNoise(4.5)
\[*
    #n We "Add a new Backend"
*]
        \ + audioClip(172.304, 174.126, 1)
\[*
    #n There are several ways to connect to a state machine
*]
        \ + audioClip(174.475, 177.493, 0.5)
\[*
    #n For this example, we define the state machine as local backend object
*]
        \ + audioClip(177.935, 182.137, 4)
\[*
    #n In the QML file that uses our form...
*]
        \ + audioClip(182.753, 185.458, 1)
\[*
    #n ...we make our state machine run at application start.
*]
        \ + audioClip(186.538, 189.939, 1)

        \ + audioNoise(10)
}

function videoConnectingStates
{
    connecting = screenCastClip("scxml_tooling_qml_create_statemachine_instance")
    fullscreen =
        \   connecting.trim(490, 490).loop(350)            [* Wait... *]
        \ + connecting.trim(490, 568)                      [* Open state context menu *]
    connectingRedState =
        \   connecting.trim(558, 566)                      [* Select "Set when Condition" *]
        \ + connecting.trim(566, 566).loop(250)            [* Move mouse away *]
        \ + connecting.trim(566, 662)                      [* Move mouse away *]
        \ + connecting.trim(679, 804).doubleSpeed          [* Type "traff" *]
        \ + connecting.trim(1042, 1130).doubleSpeed        [* Complete "trafficLightStateMachine" *]
        \ + connecting.trim(1131, 1402).doubleSpeed        [* Type ".red" *]
        \ + connecting.trim(1410, 1512)                    [* Close Editor *]
    remainingStates =
        \   connecting.trim(2122, 2141)                    [* Move mouse to state options *]
        \ + connecting.trim(2172, 2240)                    [* Open state context menu *]
        \ + connecting.trim(2326, 2664)                    [* Type "trafficLightStateMachine.redGoingGreen" *]
        \ + connecting.trim(2700, 3070)                    [* Proceed to Yellow when condition *]
        \ + connecting.trim(3117, 3190)                    [* Type "traff" *]
        \ + connecting.trim(3230, 3264)                    [* Move to completion *]
        \ + connecting.trim(3778, 3932)                    [* Proceed to Green when condition *]
        \ + connecting.trim(3978, 4308)                    [* Type Green when condition *]
    done =
        \   connecting.trim(3762, 3762).loop(100)
    connectingStates =
        \   fullscreen.myWarp(0, 0, 1)
        \ + connectingRedState.myWarp(717, 17, 701 / 1440.0)
        \ + (remainingStates.nTimesSpeed(5) + done).myWarp(0, 0, 1)

    connectingStates.scaleToMovieSize
}

function audioConnectingStates
{
    #  Connecting the states of the state machine with the respective UI states 

    audioNoise(1)
\[*
    #n Now is a good time to connect the user interface to the state machine.
*]
        \ + audioClip(191.286, 195.152, 0.5)
\[*
    #n We bind the Qt Quick UI states to the respective states of the state machine.
*]
        \ + audioClip(197.451, 203.604, 0.5)
\[*
    #n We do that by definig the "when conditions" of our user interface states.
*]
        \ + audioClip(204.289, 208.933, 0.5)
\[*
    #n The editor helps us by providing code completion.
*]
        \ + audioClip(209.885, 212.973, 3)
\[*
    #n As usual, we repeat this for the remaining states
*]
        \ + audioClip(214.181, 217.199, 1)

        \ + audioNoise(10)
}

function videoRunningApplication
{
    running = screenCastClip("scxml_tooling_run_application")
    pressingRun =
        \   running.trim(120, 120).loop(70)                [* Wait *]
        \ + running.trim(120, 150)                         [* Press Run Button *]
        \ + running.trim(185, 202)                         [* Move mouse a bit *]
        \ + running.trim(242, 330)                         [* Application launches *]
    applicationRunning =
        \   running.trim(370, 799).threeHalvesSpeed        [* Application runs *]
        \ + running.trim(800, 910)                         [* close application *]
        \ + running.trim(910, 910).loop(80)                [* Application closed *]
    runningApplication =
        \   pressingRun.myWarp(0, 592, 848 / 1440.0)
        \ + applicationRunning.myWarp(688, 320, 662 / 1440.0)

    runningApplication.scaleToMovieSize
}

function audioRunningApplication
{
    #  Running the application

    audioNoise(3)
\[*
    #n Let's run the application
*]
        \ + audioClip(218.581, 219.916, 4)
\[*
    #n This is our state machine driven Qt Quick application
*]
        \ + audioClip(220.810, 224.235, 1)

        \ + audioNoise(10)
}

function videoCheckoutExamples
{
    examples = screenCastClip("scxml_tooling_run_application")
    examples_cut =
        \   examples.trim(920, 1060)                       [* Switch to Welcome screen, focus search field *]
        \ + examples.trim(1103, 1179).threeHalvesSpeed     [* Type "scxml" *]
        \ + examples.trim(1242, 2000)                      [* Chose Traffic Light. Browse QtScxml examples *]
        \ + examples.trim(2000, 2000).loop(270)            [* Chose Traffic Light. Browse QtScxml examples *]
    checkoutExamples =
        \   examples_cut.myWarp(0, 0, 1)

    checkoutExamples.scaleToMovieSize
}

function audioCheckoutExamples
{
    #  Browsing the examples and outro

    audioNoise(5.5)
\[*
    #n Source code and documentation of the "Traffic Light" example come with the Qt SDK
*]
        \ + audioClip(225.524, 230.667, 1)
\[*
    #n There are also more advanced Qt SCXML examples...
*]
        \ + audioClip(232.304, 235.276, 0.5)
\[*
    #n Make sure to check them out as-well.
*]
        \ + audioClip(236.251, 237.935, 0.5)
\[*
    #n Thank you for watching...
*]
        \ + audioClip(238.434, 239.665, 0.5)
\[*
    #n We wish you success with state machines in your Qt applications
*]
        \ + audioClip(240.697, 244.017, 1)

        \ + audioNoise(10)
}

function newProject()
{
    videoNewProject.withTitle("Qt SCXML and state machine tooling\nin Qt Creator").audioDub(audioNewProject)
}

function editingStateChart()
{
    videoEditingStateChart.withTitle("Creating the state chart").audioDub(audioEditingStateChart)
}

function registerStateMachine()
{
    videoRegisterStateMachine.withTitle("Registering the state machine").audioDub(audioRegisterStateMachine)
}

function creatingTrafficLightQml()
{
    videoCreatingTrafficLightQml.withTitle("Creating the Qt Quick user interface").audioDub(audioCreatingTrafficLightQml)
}

function creatingTrafficLightUIStates()
{
    videoCreatingTrafficLightUIStates.withTitle("Creating the user interface states").audioDub(audioCreatingTrafficLightUIStates)
}

function instantiatingStateMachine()
{
    videoInstantiatingStateMachine.withTitle("Instantiating the state machine").audioDub(audioInstantiatingStateMachine)
}

function connectingStates()
{
    videoConnectingStates.withTitle("Connecting the user interface\nto the state machine").audioDub(audioConnectingStates)
}

function runningApplication()
{
    videoRunningApplication.withTitle("The result: A working traffic light").audioDub(audioRunningApplication)
}

function checkoutExamples()
{
    videoCheckoutExamples.withTitle("More Qt SCXML examples").audioDub(audioCheckoutExamples)
}

function clipForScriptFileName()
{
    baseNameLength = StrLen("scxml_tooling_")
    extensionLength = StrLen(".avs")
    clipName = MidStr(ScriptFile(), baseNameLength + 1, StrLen(ScriptFile()) - extensionLength - baseNameLength)
    Eval(clipName)
}

# for %i in (intro, newProject, editingStateChart, registerStateMachine, creatingTrafficLightQml, creatingTrafficLightUIStates, instantiatingStateMachine, connectingStates, runningApplication, checkoutExamples, outro, completeClip completeCachedClip) do copy scxml_tooling__dummy.avs scxml_tooling_%i.avs

# for %i in (intro, newProject, editingStateChart, registerStateMachine, creatingTrafficLightQml, creatingTrafficLightUIStates, instantiatingStateMachine, connectingStates, runningApplication, checkoutExamples, outro) do echo start ffmpeg -i scxml_tooling_%i.avs -y -an -vcodec qtrle scxml_tooling_%i.mov>> scxml_tooling_create_cache.cmd
# start ffmpeg -i scxml_tooling_completeClip.avs -y -acodec pcm_s16le scxml_tooling_completeClip.wav

function completeClip
{
    clip = Dissolve(
        \   intro
        \ , newProject
        \ , editingStateChart
        \ , registerStateMachine
        \ , creatingTrafficLightQml
        \ , creatingTrafficLightUIStates
        \ , instantiatingStateMachine
        \ , connectingStates
        \ , runningApplication
        \ , checkoutExamples
        \ , outro
        \ , 10
    \)
    clip
}

function cachedClip(string clipName)
{
    prefix = "scxml_tooling_"
    FFmpegSource2(prefix + clipName + ".mov")
}

function completeCachedClip
{
    prefix = "scxml_tooling_"
    clip =
        \   cachedClip("intro")
        \ + cachedClip("newProject")
        \ + cachedClip("editingStateChart")
        \ + cachedClip("registerStateMachine")
        \ + cachedClip("creatingTrafficLightQml")
        \ + cachedClip("creatingTrafficLightUIStates")
        \ + cachedClip("instantiatingStateMachine")
        \ + cachedClip("connectingStates")
        \ + cachedClip("runningApplication")
        \ + cachedClip("checkoutExamples")
        \ + cachedClip("outro")
    clip.QtAviSynthElements("vignette").audioDub(WAVSource("scxml_tooling_completeClip.wav"))
}
