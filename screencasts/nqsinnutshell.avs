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
    install = DirectShowSource(gMediaDir + "nqsinnutshell_install.avi", audio = false)
    install_cut =
        \   install.trim(250, 460).selectevery(2).assumefps(25)                 [* Start until page loaded *]
        \ + install.trim(460, 810)               	                    [* Installer variants popup *]
        \ + install.trim(900, 990).selectevery(2).assumefps(25)         [* Downloading start *]
        \ + install.trim(990, 8000).selectevery(250).assumefps(25)      [* Downloading progress *]
        \ + install.trim(10650, 10735).selectevery(2).assumefps(25)     [* Launching Installer *]
        \ + install.trim(10790, 10810).selectevery(2).assumefps(25)     [* Installer launched *]
        \ + install.trim(10875, 10905).selectevery(2).assumefps(25)     [* Goto page 2 *]
        \ + install.trim(10910, 10965).selectevery(2).assumefps(25)     [* Agree License & Goto page 3 *]
        \ + install.trim(10995, 11070).selectevery(2).assumefps(25)     [* Chose 'Custom' & Goto page 4 *]
        \ + install.trim(11070, 11350)                                  [* Expand components *]
        \ + install.trim(11350, 11425).selectevery(2).assumefps(25)     [* Goto page 5 *]
        \ + install.trim(11425, 17530).selectevery(250).assumefps(25)   [* Install progress till Windows Logo Warning *]
        \ + install.trim(20130, 20170).selectevery(2).assumefps(25)     [* Accept Windows Logo Warning *]
        \ + install.trim(20170, 30510).selectevery(100).assumefps(25)   [* Install progress till Finish *]
        \ + install.trim(30510, 30510).loop(50)                         [* Finish *]
    greendot = install_cut.trim(3, 3).crop(908, 744, 20, 20).converttorgb32
    install_cut.converttorgb32.Layer(greendot, x = 908, y = 744)
}

function audioInstall
{
    audioNoise(2)
\[*
    #n The Nokia Qt SDK can be found on the Forum Nokia website.
*]
        \ + audioClip(0.197, 3.784, 1)
\[*
    #n Under 'Develop'...
*]
        \ + audioClip(3.857, 4.716, 0.5)
\[*
    #n ...'Qt'...
*]
        \ + audioClip(4.771, 5.105, 1.5)
\[*
    #n ...'Download',...
*]
        \ + audioClip(5.151, 5.825, 1)
\[*
    #n ...we can choose between the Online and Offline Installer variants for the Desktop platform on which we develop on.
*]
        \ + audioClip(5.909, 11.389, 7)
\[*
    #n The installer allows a Full or Custom installation.
*]
        \ + audioClip(11.586, 14.675, 0)
\[*
    #n The components page lets us select the...
    #n QtMobility Api, Documentation, Qt Creator, the Qt Simulator and the complete Maemo and Symbian toolchains.
*]
        \ + audioClip(15.325, 25.716, 2)
\[*
    #n The installation takes about 20 to 30 minutes. Afterwards, we have a complete Qt development environment for Maemo and Symbian.
*]
        \ + audioClip(26.911, 34.400, 1)

        \ + audioNoise(10)
}

function install
{
    AudioDub(videoInstall, audioInstall)
}

function videoCode
{
    code = DirectShowSource(gMediaDir + "nqsinnutshell_code.avi", audio = false)
    code_cut =
        \   code.trim(1, 180)                                                   [* Start until Targets step *]
        \ + code.trim(180, 180).loop(220)                               [* Targets step *]
        \ + code.trim(180, 253).selectevery(2).assumefps(25)            [* Targets step till end of wizard *]
        \ + code.trim(430, 1070).selectevery(3, 1, 2).assumefps(25)     [* Creating app *]
        \ + code.trim(1070, 1070).loop(60)                              [* App Created *]
        \ + code.trim(1070, 1170)                                       [* Launching app in Simulator *]
        \ + code.trim(1270, 2100)                                       [* Switching, Rotating, scaling, testing app, expanding parameters *]
        \ + code.trim(2100, 2100).loop(60)                              [* pause on contacts list *]
        \ + code.trim(2100, 2400)                                       [* Close Simulator and launch on Symbian device *]
    greendot = code_cut.trim(3, 3).crop(1000, 744, 20, 20).converttorgb32
    code_cut.converttorgb32.Layer(greendot, x = 1000, y = 744)
}

function audioCode
{
    audioNoise(1)
\[*
    #n In QtCreator, we can directly create Create a new Mobile Project.
*]
        \ + audioClip(35.840, 39.729, 1.5)
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
*] 
        \ + audioClip(67.942, 75.302, 1.5)
\[*
    #n The Device to be simulated can be choosen...
*] 
        \ + audioClip(75.627, 78.019, 4.5)
\[*
    #n ...it can be rotated...
*] 
        \ + audioClip(78.251, 79.621, 3)
\[*
    #n ...and be scaled.
*] 
        \ + audioClip(79.668, 80.759, 1)
\[*
    #n Of course, our little test application is fully functional.
*] 
        \ + audioClip(80.805, 84.103, 1)
\[*
    #n The simultaor allows to manipulate different mobile specific parameters of the simulated device.
    #n For example the Location and Contacts.
    #n A Qt application which uses the QtMobility API can handle these parameters,...
    #n ...in the Simulator, and as well on a real device.
*]
        \ + audioClip(84.567, 101.216, 2)
\[*
    #n We can now change the target to 'Symbian Device' and execute the program.
*]
        \ + audioClip(101.634, 106.255, 1)

        \ + audioNoise(10)
}

function code
{
    AudioDub(videoCode, audioCode)
}

function videoPhone
{
    phone = DirectShowSource(gMediaDir + "nqsinnutshell_phone.m2ts", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .trim(5, 380)
    phone.animate(0, phone.FrameCount, "Lanczos4Resize",
        \   gClipWidth, gClipHeight, float(256), float(0), float(1382), float(1036),
        \   gClipWidth, gClipHeight, float(410), float(110), float(1080), float(810))
}

function audioPhone
{
    audioNoise(1)
\[*
    #n The application gets deployed to the mobile phone and is executed.
*]
        \ + audioClip(106.480, 109.986, 0.5)
\[*
    #n Qt Widgets on Symbian look and feel like native S60 Controls.
*]
        \ + audioClip(110.335, 114.143, 0.5)
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
    AudioDub(videoPhone, audioPhone)
}

function completeclip
{
    return
        \ Dissolve(
            \   textClip("Nokia Qt SDK", 50).converttoyv12
            \ , textClip("", 10).converttoyv12
            \ , textClip("Installation", 45).converttoyv12
            \ , install.converttoyv12
            \ , textClip("Creating an application", 60).converttoyv12
            \ , code.converttoyv12
            \ , phone
            \ , gDissolveLength)
        \ .QtorialsElements("qtlogosmall", "oldstyle")
        \ .FadeIO(gDissolveLength * 3)
}

completeclip