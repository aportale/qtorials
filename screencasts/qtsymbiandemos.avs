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
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\ footage_portrait.trim(95, 235)
    resetCurrentDetail
 	camera_portrait =
        \   showDetail(cut_portrait,        1, -460, 318, 2000, 1500)
        \ + showDetail(cut_portrait,       70, -460, 318, 2000, 1500)
        \ + showDetail(cut_portrait,      140, -100, 306, 1280, 960)

    footage_landscape =
        \  DirectShowSource(gMediaDir + "raycasting.02.MTS")
        \ .TemporalSoften(2, 4, 8)
	cut_landscape =
		\ footage_landscape.trim(100, 240)
    resetCurrentDetail
	camera_landscape =
        \   showDetail(cut_landscape,       1, 316, 188, 932, 700)
        \ + showDetail(cut_landscape,      70, 316, 188, 932, 700)
        \ + showDetail(cut_landscape,     140, 322, -16, 1488, 1116)
	
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
    resetCurrentDetail
	camera_slide =
		\   showDetail(cut_slide,  	     1, -640, 68, 2370, 1778)
		\ + showDetail(cut_slide,  	    40, -640, 68, 2370, 1778)
	    \ + showDetail(cut_slide,       68, 64, 776)
	    \ + showDetail(cut_slide,      128, 64, 542)

	footage_flip =
        \  DirectShowSource(gMediaDir + "digiflip.02.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_flip =
		\ footage_flip.trim(70, 115) + footage_flip.trim(320, 370)
    resetCurrentDetail
	camera_flip =
	    \ + showDetail(cut_flip,         1, 64, 776)
	    \ + showDetail(cut_flip,        37, 64, 776)
	    \ + showDetail(cut_flip,        96, 64, 542)

	all = Dissolve(camera_slide, camera_flip, gDissolveLength)
		
	all
}

function flickabe
{
    footage_portrait =
        \  DirectShowSource(gMediaDir + "flickable.01.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .TurnRight
	cut_portrait =
		\ footage_portrait.trim(80, 140) + footage_portrait.trim(160, 250)
    resetCurrentDetail
	camera_portrait =
		\   showDetail(cut_portrait,  	     1, -640, 68, 2370, 1778)
		\ + showDetail(cut_portrait,  	    25, -640, 68, 2370, 1778)
	    \ + showDetail(cut_portrait,       150, -60, 534, 1190, 894)

	footage_landscape =
        \  DirectShowSource(gMediaDir + "flickable.02.MTS")
        \ .TemporalSoften(2, 4, 8)
        \ .Turn180
	cut_landscape =
		\ footage_landscape.trim(245, 310) + footage_landscape.trim(310, 310).loop(25)
    resetCurrentDetail
	camera_landscape =
	    \ + showDetail(cut_landscape,         1, 364, 182)
	    \ + showDetail(cut_landscape,        55, 364, 182)
	    \ + showDetail(cut_landscape,        90, 64, -140, 1800, 1350)

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
    resetCurrentDetail
	camera =
		\   showDetail(cut,  	      1, -640, 68, 2370, 1778)
		\ + showDetail(cut,  	     30, -640, 68, 2370, 1778)
	    \ + showDetail(cut,         115, 60, 536)
		\ + showDetail(cut,  	    140, -640, 68, 2370, 1778)
	    \ + showDetail(cut,         180, 60, 800)
	    \ + showDetail(cut,         239, 60, 536)

	camera
}

flightinfo
