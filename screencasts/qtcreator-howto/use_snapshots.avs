# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("..\\qtavisynth.dll")
Import("..\\tools.avsi")

global gAudioClip = WAVSource(gMediaDir + "scxml_tooling.wav")
global gAudioNoiseStart = 3259511 / 44100.0
global gAudioNoiseEnd = 3315898 / 44100.0
global gFastPreview = false
global gClipWidth = gFastPreview ? 640 : 1920
global gClipHeight = gFastPreview ? 360 : 1080
global gTextColor = $ffffff
global gBackgroundColor = $09102b

function screenCastClip(string fileBaseName)
{
    FFVideoSource(gMediaDir + fileBaseName + (gFastPreview ? "_small" : "") + ".mov", colorspace = "RGB32").AssumeFps(60)
}

function scaleToMovieSize(clip sourceClip)
{
    gFastPreview ? sourceClip : sourceClip.BicubicResize(gClipWidth, gClipHeight)
}

function videoIntro
{
}

function audioIntro
{
    audioNoise(1)
\[*
    #  Introduction
    #n This video shows how to install an older release or a development snapshot of Qt Creator ...
*]
        \ + audioClip(0, 0, 0)
\[*
    #n ... and how to use it alongside an installed Qt SDK.
*]
        \ + audioClip(0, 0, 0)

        \ + audioNoise(10)
}

function videoSdk
{
}

function audioSdk
{
    audioNoise(1)
\[*
    #  SDK installer is shown. Qt > Developer and Designer Tools > Qt Creator x.y gets highlighted.
    #n The Qt Creator team works hard to ensure that the IDE version which is available via the SDK installer is the best version for you.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Preview > Qt Creator x.y beta/rc gets highlighted.
    #n The available beta version or release candidate should provide a adequate preview for the upcoming Qt Creator release.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Closing installer.
    #n However...
*]
        \ + audioClip(0, 0, 0)

        \ + audioNoise(10)
}

function videoDownload
{
}

function audioDownload
{
    audioNoise(1)
\[*
    #  Browser: Google search for Qt downloads.
    #n ... there might be reasons for you to additionally install other Qt Creator versions than the ones offered by the installer:
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Navigate to older, archived version
    #n For example, You want to use an older Qt Creator release with a feature which got removed (or wich broke)
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Browser back button > Select root > Navigate to Snapshopts
    #n ...Or you want to test the fresh nightly snapshot ... to verify the latest code submissions.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Start of download, and fast-forwarded download progress
    #n So, you download the Qt Creator installer for your operating system...
*]
        \ + audioClip(0, 0, 0)

        \ + audioNoise(10)
}

function videoInstallation
{
}

function audioInstallation
{
    audioNoise(1)
\[*
    #  The downloaded installer is launched from Browser downloads
    #n ... and click through the steps of the installer.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Qt Creator is launched
    #n After the installation, Qt Creator is launched ...
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Browser back button > Select root > Navigate to Snapshopts
    #n ... and offers to *Link with an existing Qt Installation*.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Qt Creator offers restart, and we accept
    #n After a quick restart of Qt Creator ...
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Opening Tools -> Options -> Kits -> Qt Versions
    #n ... the components of the linked Qt SDK installation are available for this Qt Creator installation.
    #n We have now access to Qt Versions with examples and documentation and various tools.
*]
        \ + audioClip(0, 0, 0)
\[*
    #  Click on "Link with Qt...". Open path choser. Cancel. Mouse over "Remove link" button. Cancel dialog.
    #n The button "Link with Qt..." allows to change the link to another Qt SDK installation... or to remove the current link.
*]
        \ + audioClip(0, 0, 0)

        \ + audioNoise(10)
}

function completeClip
{
    clip = Dissolve(
        \   intro
        \ , outro
        \ , 10
    \)
    clip
}

