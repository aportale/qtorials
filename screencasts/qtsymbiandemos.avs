# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

# Webcasting Ariya's demos

Import("tools.avsi")

global gClipWidth = 960
global gClipHeight = 720
global gDetailsExpansionColor = $000000
global gDetailsTransitionDefaultFrameCount = 15

function raycasting
{
    footage_portrait =
        \  DirectShowSource(gMediaDir + "raycasting.01.MTS")
		\ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\ footage_portrait.trim(95, 235)
	setDetailClip(cut_portrait)
	setDetail(-460, 318, 2000, 1500)
 	camera_portrait =
        \   showDetail( 70, -460, 318, 2000, 1500)
        \ + showDetail(140, -100, 306, 1280, 960)

    footage_landscape =
        \  DirectShowSource(gMediaDir + "raycasting.02.MTS")
		\ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
	cut_landscape =
		\ footage_landscape.trim(100, 240)
	setDetailClip(cut_landscape)
	setDetail(316, 188, 932, 700)
	camera_landscape =
        \   showDetail( 70, 316, 188, 932, 700)
        \ + showDetail(140, 322, -16, 1488, 1116)
	
	all = Dissolve(camera_portrait, camera_landscape, gDissolveLength)
		
	all
}

function digiflip
{
    footage_slide =
        \  DirectShowSource(gMediaDir + "digiflip.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_slide =
		\ footage_slide.trim(10, 45) + footage_slide.trim(55, 90) + footage_slide.trim(265, 320)	
	setDetailClip(cut_slide)
	setDetail(-640, 68, 2370, 1778)
	camera_slide =
		\   showDetail( 40, -640, 68, 2370, 1778)
	    \ + showDetail( 68, 64, 776)
	    \ + showDetail(128, 64, 542)

	footage_flip =
        \  DirectShowSource(gMediaDir + "digiflip.02.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_flip =
		\ footage_flip.trim(70, 115) + footage_flip.trim(320, 370)
	setDetailClip(cut_flip)
	setDetail(64, 776)
	camera_flip =
	    \ + showDetail(  1, 64, 776)
	    \ + showDetail( 37, 64, 776)
	    \ + showDetail( 96, 64, 542)

	all = Dissolve(camera_slide, camera_flip, gDissolveLength)

	all
}

function flickable
{
    footage_portrait =
        \  DirectShowSource(gMediaDir + "flickable.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\ footage_portrait.trim(80, 140) + footage_portrait.trim(160, 250)
	setDetailClip(cut_portrait)
	setDetail(-640, 68, 2370, 1778)
	camera_portrait =
		\   showDetail( 25, -640, 68, 2370, 1778)
	    \ + showDetail(150, -60, 534, 1190, 894)

	footage_landscape =
        \  DirectShowSource(gMediaDir + "flickable.02.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
	cut_landscape =
		\ footage_landscape.trim(245, 310) + footage_landscape.trim(310, 310).loop(25)
    setDetailClip(cut_landscape)
	setDetail(364, 182)
	camera_landscape =
	    \   showDetail( 55, 364, 182)
	    \ + showDetail( 90, 64, -140, 1800, 1350)

	all = Dissolve(camera_portrait, camera_landscape, gDissolveLength)
		
	all
}

function flightinfo
{
    footage =
        \  DirectShowSource(gMediaDir + "flightinfo.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut =
		\ footage.trim(170, 310) + footage.trim(378, 475)
	setDetailClip(cut)
	setDetail(-640, 68, 2370, 1778)
	camera =
		\   showDetail( 30, -640, 68, 2370, 1778)
	    \ + showDetail(115, 60, 536)
		\ + showDetail(140, -640, 68, 2370, 1778)
	    \ + showDetail(180, 60, 800)
	    \ + showDetail(239, 60, 536)

	camera
}

function lightmaps
{
    footage_portrait =
        \  DirectShowSource(gMediaDir + "lightmaps.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\   footage_portrait.trim(215, 252)
		\ + footage_portrait.trim(253, 290).SelectEvery(2).AssumeFps(25)
		\ + footage_portrait.trim(291, 390)
	setDetailClip(cut_portrait)
	setDetail(-640, 68, 2370, 1778)
	camera_portrait =
		\   showDetail( 15, -640, 68, 2370, 1778)
	    \ + showDetail( 80, -108, 540, 1300, 976)
	    \ + showDetail(157, 60, 536)

	footage_landscape =
        \  DirectShowSource(gMediaDir + "lightmaps.02.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
	cut_landscape =
		\   footage_landscape.trim(220, 295)
	setDetailClip(cut_landscape)
	setDetail(64, -140, 1800, 1350)
	camera_landscape =
	    \ showDetail( 76, 64, -140, 1800, 1350)

	all = Dissolve(camera_portrait, camera_landscape, gDissolveLength)
		
	all
}

function weatherinfo
{
    footage_portrait =
        \  DirectShowSource(gMediaDir + "weatherinfo.01.MTS")
		\ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\   footage_portrait.trim(80, 128)
		\ + footage_portrait.trim(129, 192).SelectEvery(3).AssumeFps(25)
		\ + footage_portrait.trim(193, 260)
	setDetailClip(cut_portrait)
	setDetail(-640, 68, 2370, 1778)
	camera_portrait =
		\   showDetail( 15, -640, 68, 2370, 1778)
	    \ + showDetail( 40, -128, 616, 1332, 1000)
	    \ + showDetail(139, -128, 366, 1332, 1000)

	footage_landscape =
        \  DirectShowSource(gMediaDir + "weatherinfo.02.MTS")
		\ .Tweak(bright = 5)
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
	cut_landscape =
		\   footage_landscape.trim(240, 280)
		\ + footage_landscape.trim(281, 295).SelectEvery(3).AssumeFps(25)
		\ + footage_landscape.trim(296, 360)
	setDetailClip(cut_landscape)
	setDetail(358, 172)
	camera_landscape =
	    \   showDetail( 85, 358, 172)
	    \ + showDetail(111, 64, -140, 1800, 1350)

	all = Dissolve(camera_portrait, camera_landscape, gDissolveLength)
		
	all
}


function medley
{
	return Dissolve (
		\   textClip("Qt demos for Symbian/S60").killaudio.converttoyv12
		\ , textClip("Digital clock", 50).killaudio.converttoyv12
		\ , digiflip.killaudio
		\ , textClip("Kinetic scrolling\non any Qt widget").killaudio.converttoyv12
		\ , flickable.killaudio
		\ , textClip("Weather info with Qt").killaudio.converttoyv12
		\ , weatherinfo.killaudio
		\ , textClip("Track your flight with Qt").killaudio.converttoyv12
		\ , flightinfo.killaudio
		\ , textClip("OpenStreetMap and Qt").killaudio.converttoyv12
		\ , lightmaps.killaudio
		\ , textClip("Ray casting with Qt").killaudio.converttoyv12
		\ , raycasting.killaudio
		\ , textClip("Get them from\nhttp://labs.qt.nokia.com").killaudio.converttoyv12
		\ , gDissolveLength).creativeCommons.qtlogosmall.oldStyle.FadeIO(10)
}

medley
