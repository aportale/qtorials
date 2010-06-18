# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "nqsinnutshell.wav")
global gAudioNoiseStart = 118.740
global gAudioNoiseEnd = 119.158
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
    #n The Nokia Qt SDK can be found on the Forum Nokia website.
*]
        \ + audioClip(0.197, 3.784, 1)
\[*
    #n Under 'Develop' -> 'Qt' -> 'Download',...
*]
        \ + audioClip(3.796, 5.816, 1)
\[*
    #n ...we can choose between the Online and Offline Installer variants for the Desktop platform on which we develop on.
*]
        \ + audioClip(5.909, 11.389, 1)
\[*
    #n The installer allows a Full or Custom installation.
*]
        \ + audioClip(11.586, 14.675, 1)
\[*
    #n The components page lets us select the...
    #n QtMobility Api, Documentation, Qt Creator, the Qt Simulator and the complete Maemo and Symbian toolchains.
*]
        \ + audioClip(15.325, 25.716, 1)
\[*
    #n The installation takes about 20 to 30 minutes. Afterwards, we have a complete Qt development environment for Maemo and Symbian.
*]
        \ + audioClip(26.911, 34.400, 1)

        \ + audioNoise(10)
}

function install
{
    AudioDub(videoInstall, audioInstall).converttorgb32
}

function videoCode
{
    DirectShowSource(gMediaDir + "nqsinnutshell_code.avi", audio = false)
}

function audioCode
{
    audioNoise(1)
\[*
    #n In QtCreator, we can directly create Create a new Mobile Project.
*]
        \ + audioClip(35.840, 39.729, 1)
\[*
    #n The Project Wizard lets us choose the target platforms for our project.
    #n We select Maemo, Qt Simulator and Symbian, whose toolchains came with the Installer.
*]
        \ + audioClip(40.112, 49.470, 1)
\[*
    #n The application Ui can be created with the classical Qt Widgets which originate from the desktop world.
    #n Future Nokia Qt SDK versions will offer more mobile optimized Ui technologies.
    #n This tiny test application has a list widget with items which can be cleared with the push button below.
*]
        \ + audioClip(49.923, 66.990, 1)
\[*
    #n The initially active target is the Qt Simulator. When we run the project, the Simulator with our application is launched.
    #n The Device to be simulated can be choosen...
    #n ...it can be rotated...
    #n ...and be scaled.
    #n Of course, our little test application is fully functional.
*]
        \ + audioClip(67.361, 84.103, 1)
\[*
    #n The simultaor allows to manipulate different mobile specific parameters of the simulated device.
    #n For example the Location and Contacts.
    #n A Qt application which uses the QtMobility API can handle these parameters,...
    #n ...in the Simulator, and as well on a real device.
*]
        \ + audioClip(84.567, 101.216, 1)
\[*
    #n We can now change the target to 'Symbian Device' and execute the program.
*]
        \ + audioClip(101.634, 106.255, 1)

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
    #n The application gets deployed to the mobile phone and is executed.
*]
        \ + audioClip(106.480, 109.986, 1)
\[*
    #n Qt Widgets on Symbian look and feel like native S60 Controls.
*]
        \ + audioClip(110.335, 114.143, 1)
\[*
    #n ...and also here, our application works like a charm.
*]
        \ + audioClip(114.178, 116.987, 1)
\[*
    #n Thanks for watching :)
*]
        \ + audioClip(117.301, 118.438, 1)

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

#completeclip
install