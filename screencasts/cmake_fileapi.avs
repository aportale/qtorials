# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
LoadPlugin("C:\\Users\\alportal\\ownprojects\\ffms2-2.23.1-msvc\\x64\\ffms2.dll")
Import("tools.avsi")

global gClipWidth = 720
global gClipHeight = 502

function detailCrop(clip sourceClip, int x, int y)
{
    sourceClip.crop(x, y, gClipWidth, gClipHeight)
}

function caption(String text)
{
    (textClip("", 20) + textClip(text, 55)).killaudio.converttorgb24
}

raw_clip = FFVideoSource(gMediaDir + "cmake_fileapi_cropped.mov", colorspace = "RGB24").AssumeFps(25)

maincaption = \
	  caption("Support for CMake's fileapi\nin Qt Creator 4.11") \

options = \
	  caption("Detection of CMake features") \
	+ raw_clip.detailCrop(0, 0).trim(0, 70) \
	+ raw_clip.detailCrop(0, 0).trim(100, 270)

targetcontextmenu = \
	  caption("Improved target context menu") \
	+ raw_clip.detailCrop(0, 0).trim(310, 390) \
	+ raw_clip.detailCrop(0, 0).trim(408, 470) \
	+ raw_clip.detailCrop(21, 157).trim(471, 540) \
	+ raw_clip.detailCrop(0, 0).trim(541, 620)

locatorbuild = \
	  caption("Trigger build of CMake targets\nvia the locator") \
	+ raw_clip.detailCrop(0, 0).trim(1140, 1350)

locatoropen = \
	  caption("Open CMake target definitions\nvia the locator") \
	+ raw_clip.detailCrop(0, 0).trim(1740, 2000)

complete = maincaption + options + locatorbuild + locatoropen + targetcontextmenu

complete

# Generate an animated gif with ffmpeg
# %ProgramData%\chocolatey\bin\ffmpeg.exe -y -i cmake_fileapi.avs -filter_complex "palettegen=reserve_transparent=false:max_colors=256" cmake_fileapi_palette.png && %ProgramData%\chocolatey\bin\ffmpeg.exe -y -i cmake_fileapi.avs -i cmake_fileapi_palette.png -filter_complex "paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" cmake_fileapi.gif

