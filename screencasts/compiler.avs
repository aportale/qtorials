# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720

global qRobertoClipPath = "e:\PRIVATE\AVCHD\BDMV\STREAM\"
global qScreenRecordingClipPath = "c:\temp\"

function RobertoA()
{
    SegmentedDirectShowSource(qRobertoClipPath + "clipA.MTS")
    trim(800, 0)
}

function RobertoB()
{
    SegmentedDirectShowSource(qRobertoClipPath + "clipB.MTS")
#    DirectShowSource(qScreenRecordingClipPath + "clipB.01.MTS")
    trim(800, 110950 + 800)
}

function TweakedFootage(clip)
{
    clip
    crop(410, 0, 600, 980)
    TemporalSoften(2, 4, 4, mode = 2)
    Lanczos4Resize(180, 220)
#    PointResize(180, 220)
}

function ScreenRecordingA()
{
    DirectShowSource(qScreenRecordingClipPath + "ScreenRecordingA.avi", audio = false)
    trim(5550, 118560 + 5550)
}

function ScreenRecordingB()
{
    DirectShowSource(qScreenRecordingClipPath + "ScreenRecordingB.avi", audio = false)
    trim(1265, 0)
}

function ScreenWithRoberto(screen, roberto)
{
    screen.overlay(roberto, screen.width - roberto.width, screen.height - roberto.height)
    audiodub(roberto.Amplify(1.8).ConvertToMono)
}

function completeclip
{
    Dissolve(
        \   ScreenWithRoberto(ScreenRecordingA, TweakedFootage(RobertoA))
        \ , ScreenWithRoberto(ScreenRecordingB, TweakedFootage(RobertoB))
        \ , gDissolveLength
    \)
    FadeIO(gDissolveLength)
}

#TweakedFootage(RobertoB)
#ScreenWithRoberto(ScreenRecordingB, TweakedFootage(RobertoB)).trim(0, 3000)
#TweakedFootage(RobertoB)
completeclip