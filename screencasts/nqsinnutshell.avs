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
    #n We visit the Nokia Ovi Suite download page.
    #t bit.ly/ovisuite
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n There, we click "Download"...
*]
        \ + audioClip(48.082, 49.604, 0.8)
\[*
    #n ...and and install it.
*]
        \ + audioClip(49.627, 50.567, 2.6)
\[*
    #n If after the installation, we see such an icon, the Nokia Ovi Suite is connected to our device.
*]
        \ + audioClip(51.235, 57.266, 1)

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
    #n We visit the Nokia Ovi Suite download page.
    #t bit.ly/ovisuite
*]
        \ + audioClip(45.046, 48.018, 1.7)
\[*
    #n There, we click "Download"...
*]
        \ + audioClip(48.082, 49.604, 0.8)
\[*
    #n ...and and install it.
*]
        \ + audioClip(49.627, 50.567, 2.6)
\[*
    #n If after the installation, we see such an icon, the Nokia Ovi Suite is connected to our device.
*]
        \ + audioClip(51.235, 57.266, 1)

        \ + audioNoise(10)
}

function code
{
    AudioDub(videoCode, audioCode).converttorgb32
}

function phone
{
    DirectShowSource(gMediaDir + "nqsinnutshell_phone.m2ts", audio = false)
        \ .TemporalSoften(4, 4, 8, mode = 2)
        \ .Lanczos4Resize(gClipWidth, 544, 98, 0, 1706, 968)
        \ .AddBorders(0, 88, 0, 88, 0)
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
