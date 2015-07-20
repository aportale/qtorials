# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")
Import(gFFDShowImport)

#global gAudioClip = WAVSource(gMediaDir + "meet_qtcreator.wav")
global gAudioNoiseStart = 1829888 / 44100.0
global gAudioNoiseEnd = 1912832 / 44100.0
global gClipWidth = 640
global gClipHeight = 360

function deinterlace(clip sourceClip)
{
    sourceClip.ffdshow(options="isDeinterlace=1,deinterlaceMethod=3")
}

function srceencastSource(string fileName)
{
    DirectShowSource(gMediaDir + fileName, audio = false).AddBorders(320, 180, 320, 180, $ffffff)
}

function warp(clip sourceClip, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
{
    # return sourceClip
    scaledX3 = String(Round(100.0 / sourceClip.width * x1))
    scaledY3 = String(Round(100.0 - (100.0 / sourceClip.height * y1)))
    scaledX4 = String(Round(100.0 / sourceClip.width * x2))
    scaledY4 = String(Round(100.0 - (100.0 / sourceClip.height * y2)))
    scaledX1 = String(Round(100.0 / sourceClip.width * x3))
    scaledY1 = String(Round(100.0 - (100.0 / sourceClip.height * y3)))
    scaledX2 = String(Round(100.0 / sourceClip.width * x4))
    scaledY2 = String(Round(100.0 - (100.0 / sourceClip.height * y4)))
    coordinates = ("perspectiveX1=" + scaledX1 + ",perspectiveY1=" + scaledY1 + ",perspectiveX2=" + scaledX2 + ",perspectiveY2=" + scaledY2 + ",perspectiveX3=" + scaledX3 + ",perspectiveY3=" + scaledY3 + ",perspectiveX4=" + scaledX4 + ",perspectiveY4=" + scaledY4)
    return sourceClip.ffdshow(options="isPerspective=1,perspectiveIsSrc=1,perspectiveInterpolation=2," + coordinates)
}

function videoIntro
{
    intro = ImageSource(gMediaDir + "meet_boot2qt_intro.png", pixel_type = "RGB32", fps = 50).trim(1, 100)
    intro
}

function audioIntro
{
    audioNoise(10)
}

function intro
{
    AudioDub(videoIntro, audioIntro)
}

function audioUnboxing
{
    #n Creating your own device with a great Qt based user interface has never been easier.
    #  A board is shown, attached to a screen showing black.
    #n When using Qt for device creation, you get everything you need to let your embedded Linux based device boot to your first Qt application in no time.
    #  Screen shows Qt demo logo with particles, and "Boot to Qt" text blends in.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoUnboxing
{
    intro = directshowsource(gMediaDir + "meet_boot2qt_unboxing_.avi", audio = false)
    outofbox = intro.trim(0, 146).ChangeFPS(50)
    attachdisplay = (intro.trim(146, 430) + intro.trim(498, 542)).SelectEvery(2).AssumeFps(50)
    grabcard = intro.trim(542, 580).ChangeFPS(50)
    insertcard = intro.trim(580, 666).AssumeFps(50)
    connectpower = intro.trim(666, 752).SelectEvery(2).AssumeFps(50)
    boot = intro.trim(844, 880).ChangeFPS(50)
    boot2qtlogo = intro.trim(1290, 1424).ChangeFPS(50)
    intro = outofbox + attachdisplay + grabcard + insertcard + connectpower + boot + boot2qtlogo
    return intro
}

function audioInstaller
{
    #n The easy-to-use online installer will install the SDK components.
    #  2-3 installer pages are quickly shown. A list of bullet points appears on the side.
}

function videoInstaller
{
    installer = srceencastSource("meet_boot2qt_installer.avi")
    installer_components = installer.trim(800, 1180).SelectEvery(2).AssumeFps(50)
    installer_clicknext = installer.trim(1180, 1200)
    installer_progress = installer.trim(1448, 16390).SelectEvery(80).AssumeFps(50)    [* Components tree *]
    installer_components + installer_clicknext + installer_progress
    warp(710, 300,  1690, 280,  710, 820,  1690, 840)
}

function audioDeviceImage
{
    #n The cross compiling toolchain and a pre-built image can be flashed to your board using the flashing wizard.
    #  Wizard is shown. SD card in reader is shown. SD card gets inserted into device
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoDeviceImageSDCard
{
    clip = directShowSource(gMediaDir + "meet_boot2qt_insertflashedsdcard.avi", audio = false)
    grabcard = clip.trim(30, 88).ChangeFPS(50)
    insertcard = clip.trim(88, 220).SelectEvery(2).AssumeFps(50)
    pushin = clip.trim(220, 242).ChangeFPS(50)
    return grabcard + insertcard + pushin
}

function videoDeviceImage
{
    wizard = srceencastSource("meet_boot2qt_flashingwizard.avi")
    wizard_imageselection = wizard.trim(130, 270)
    wizard_diskselection = wizard.trim(320, 374).SelectEvery(2).AssumeFps(wizard.Framerate)
    wizard_confirmaction = wizard.trim(1100, 1161).SelectEvery(2).AssumeFps(wizard.Framerate)
    wizard_flashing = wizard.trim(1336, 6000).SelectEvery(100).AssumeFps(wizard.Framerate)
    wizard_cut = wizard_imageselection + wizard_diskselection + wizard_confirmaction + wizard_flashing
    return Dissolve(wizard_cut.warp(320, 250,  1230, 220,  320, 730,  1230, 770), videoDeviceImageSDCard.ConvertToRGB32, gDissolveLength)
}

function audioYoctoRecipies
{
    #n The included the Yocto project recipies -which the boot to Qt stack is built on- can be used to easily customize the stack into your production needs.
    #  Time lapse of console yocto action
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoYoctoRecipies
{
    clip = srceencastSource("meet_boot2qt_yoctobitbake.avi")
    launchingbitbake = clip.trim(800, 870)
    parsing = clip.trim(870, 3476).SelectEvery(20).AssumeFps(clip.Framerate)
    runningtasks = clip.trim(3476, 6060).SelectEvery(30).AssumeFps(clip.Framerate)
    return launchingbitbake + parsing + runningtasks
}

function audioVirtualKeyboard
{
    #n The Qt Virtual Keyboard can be used for text input on your device.
    #n It supports several languages, ...
    #n ...and can be styled individually.
    #  Device with virtual keyboard demo is shown. Normal theme, some languages, theh typewriter theme.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoVirtualKeyboard
{
    virtualkeyboard_languages = DirectShowSource(gMediaDir + "meet_boot2qt_virtualkeyboardlanguages_.avi", audio = false)
    virtualkeyboard_themes = DirectShowSource(gMediaDir + "meet_boot2qt_virtualkeyboardthemes_.avi", audio = false).trim(32, 140)

    virtualkeyboard_cut = Dissolve(virtualkeyboard_languages, virtualkeyboard_themes, gDissolveLength)
    return virtualkeyboard_cut.ChangeFPS(50)
}

function audioQtCreatorIDE
{
    #n The Qt Creator IDE for all your application development needs...
    #  Time lapse of Qt Quick Designer creating a hello world application
    #n ...is fully configured to deploy applications to your board...
    #  Press on play. Time lapse of deployment and start of the application on the device.
    #n ...and includes the debugging and profiling tools which help you to create great devices.
    #  Debugger is shown. Profiler is shown.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoQtCreatorIDE
{
    create = srceencastSource("meet_boot2qt_helloworldcreate.avi")
    create_dragtextfield = create.trim(162, 220).SelectEvery(2).AssumeFps(create.Framerate)
    create_editextfield = create.trim(220, 1420).SelectEvery(20).AssumeFps(create.Framerate)
    create_draglabel = create.trim(1678, 1714).SelectEvery(2).AssumeFps(create.Framerate)
    create_editlabel = create.trim(1714, 3062).SelectEvery(20).AssumeFps(create.Framerate)
    pressplay_1 = create.trim(3230, 3270).SelectEvery(2).AssumeFps(create.Framerate)
    pressplay_2 = create.trim(3270, 3320)
    create_cut = create_dragtextfield + create_editextfield + create_draglabel + create_editlabel + pressplay_1
    create_and_launch = create_cut + pressplay_2
    create_and_launch = create_cut.warp(380, 250,  1600, 230,  380, 880,  1600, 900) + pressplay_2.warp(380, 580,  960, 570,  380, 880,  960, 900)
    debugger = srceencastSource("meet_boot2qt_debugger.avi")
    debugger_step1 = debugger.trim(12, 66)
    debugger_step2 = debugger.trim(148, 266)
    debugger_cut = (debugger_step1 + debugger_step2).warp(690, 220,  1600, 190,  690, 690,  1600, 700)
    profiler = srceencastSource("meet_boot2qt_profiler.avi").trim(10, 240).warp(480, 280,  1600, 270,  480, 880,  1600, 900)
    return Dissolve(create_and_launch + videoLaunchOnBoard.ConvertToRGB32, debugger_cut, profiler, gDissolveLength)
}

function videoLaunchOnBoard
{
    DirectShowSource(gMediaDir + "meet_boot2qt_launchapponboard_.avi", audio = false).trim(20, 180).ChangeFPS(50)
}

function audioEmulator
{
    #n The emulator allows you to test your application without the actual hardware...
    #  Press on play. Start of the application on the device.
    #n ...under special conditions, ...
    #n ...and with editable sensor data.
    #  Switching through the control panels in the emulator
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoEmulator
{
    emulator = srceencastSource("meet_boot2qt_helloworldonemulator.avi")
    emulator_launch = emulator.trim(84, 364)
    emulator_options = emulator.trim(364, 418) + emulator.trim(460, 484) + emulator.trim(534, 696)
    return emulator_launch.warp(320, 200,  1600, 180,  320, 880,  1600, 900) + emulator_options.warp(820, 220,  1610, 200,  820, 680,  1610, 690)
}

function audioDocs
{
    #n The comprehensive documentation is well integrated in the tools.
    #  Help mode in Qt Creator
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoDocs
{
    docs = srceencastSource("meet_boot2qt_documentation.avi").trim(100, 500)
    return docs.warp(380, 240,  1600, 220,  380, 880,  1600, 900)
}

function audioQtSupport
{
    #n With Qt, you are not alone with your problems.
    #n In case you get stuck, the Qt support team will quickly help you finding solutions.
    #  logging into account page -> Support Center.
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoQtSupport
{
    support = srceencastSource("meet_boot2qt_support.avi").trim(0, 550)
    return support.warp(380, 230,  1600, 220,  380, 890,  1600, 900)
}

function audioOutro
{
    #n Visit our website to get started. And thank you for watching.
    #  showing qt.io url
    a = audioNoise(2) + audioClip(4.075, 11.563, 1)

    return a + audioNoise(10)
}

function videoOutro
{
    outro = ImageSource(gMediaDir + "meet_boot2qt_outro.png", pixel_type = "RGB32", fps = 50).trim(1, 500)
    outro
}

function completeClip
{
    return
        \ Dissolve(
            \   welcome
            \ , download
            \ , installation
            \ , components
            \ , outro
            \ , gDissolveLength)
        \ .oldStyle
        \ .qtLogoSmall
        \ .FadeIO(gDissolveLength)
}

#completeclip

videoIntro