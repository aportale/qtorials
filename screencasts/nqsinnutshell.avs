# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

#global gAudioClip = WAVSource(gMediaDir + "nqsinnutshell.wav")
global gAudioNoiseStart = 1078334 / 44100.0
global gAudioNoiseEnd = 1094214 / 44100.0
global gClipWidth = 1024
global gClipHeight = 768
global gTextClipFramesPerCharacter = 4

function videoInstall
{
    DirectShowSource(gMediaDir + "nqsinnutshell_install.avi", audio = false)
}

function audioInstall
{
    audioNoise(1)
\[*
    #n The Nokia Qt SDK can be found on the forum nokia website.
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n Under 'Develop' -> 'Qt' -> 'Download',...
*]
        \ + audioClip(48.082, 49.604, 0.8)
\[*
    #n ...we can choose between the Online and Offline Installer variants for our Desktop platform.
*]
        \ + audioClip(49.627, 50.567, 2.6)
\[*
    #n The installer allows a Full or Custom installation.
*]
        \ + audioClip(51.235, 57.266, 1)
\[*
    #n The components page let's us select the...
    #n QtMobility Api, Documentation, Qt Creator, the Qt Simulator and the complete Maemo and Symbian toolchains.
*]
        \ + audioClip(51.235, 57.266, 1)
\[*
    #n The installation takes about 20 to 30 minutes. Afterwards, we have a complete Qt development environment for Maemo and Symbian.
*]
        \ + audioClip(49.627, 50.567, 2.6)

        \ + audioNoise(10)
}

function install
{
    AudioDub(videoInstall, audioInstall).converttorgb32
}

function videoCode
{
    DirectShowSource(gMediaDir + "nqsinnutshell_code.avi", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
}

function audioCode
{
    audioNoise(1)
\[*
    #n In QtCreator, we can directly create Create a new Mobile Project.
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n The Project Wizard lets us choose the target platforms for our project.
    #n We select Maemo, Qt Simulator and Symbian, whose toolchains came with the Installer.
*]
        \ + audioClip(48.082, 49.604, 0.8)
\[*
    #n The applicatino Ui can be created with the classical QtWidgets which originate from the desktop world.
    #n Future Nokia Qt SDK versions will offer more mobile optimized Ui technologies.
    #n This tiny test application has a list widget with items which can be cleared with the push button below.
*]
        \ + audioClip(49.627, 50.567, 2.6)
\[*
    #n The initially active target is the Qt Simulator. When we run the project, the Simulator with our application is launched.
    #n The Device that is simulated can be choosen...
    #n ...it can be rotated...
    #n ...and be scaled.
    #n Of course, our little test application is fully functional.
*]
        \ + audioClip(51.235, 57.266, 1)
\[*
    #n The simultaor allows to manipulate different mobile specific parameters of the simulated device.
    #n For example the Location and Contacts.
    #n A Qt application which uses the QtMobility API can handle these parameters,...
    #n ...in the Simulator, and as well in a real device.
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n We can now change the target to 'Symbian Device' and execute the program.
*]
        \ + audioClip(45.046, 48.018, 1.7)

        \ + audioNoise(10)
}

function code
{
    AudioDub(videoCode, audioCode).converttorgb32
}

function videoPhone
{
    DirectShowSource(gMediaDir + "nqsinnutshell_phone.m2ts", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
}

function audioPhone
{
    audioNoise(1)
\[*
    #n The application gets deployed to the mobile phone and executed.
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n QWidets on Symbian look and feel like native S60 Controls.
*]
        \ + audioClip(48.082, 49.604, 0.8)
\[*
    #n ...and also here, our application works like a charm,
*]
        \ + audioClip(49.627, 50.567, 2.6)
\[*
    #n Thanks for watching :)
*]
        \ + audioClip(51.235, 57.266, 1)

        \ + audioNoise(10)
}

function phone
{
    AudioDub(videoPhone, audioPhone).converttorgb32
}

function completeclip
{
    return
        \ Dissolve(
            \   textClip("Nokia Qt SDK", 75)
            \ , textClip("", 25)
            \ , textClip("Installation", 45)
            \ , install
            \ , textClip("Creating an application", 60)
            \ , code
            \ , phone
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength)
}

completeclip
