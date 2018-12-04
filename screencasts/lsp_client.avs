# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

Import("tools.avsi")
LoadPlugin("qtavisynth.dll")

# Qt Creator window has 1280*728 pixels in the raw footage (ratio 17.6:10)
global gClipWidth = 688
global gClipHeight = 392
global gTextFontFace = "Titillium Web"
global gBackgroundColor = $f0f0f0

pip_install_source = DirectShowSource("lsp_client_pip_install_cut.avi").converttorgb32.AssumeFps(25).crop(358, 240, gClipWidth, gClipHeight)
openoptions_source = DirectShowSource("lsp_client_openoptions_cut.avi").converttorgb32.AssumeFps(25).crop(358, 173, gClipWidth, gClipHeight)
addserver_source = DirectShowSource("lsp_client_addserver_cut.avi").converttorgb32.AssumeFps(25).crop(357, 112, gClipWidth, 609)
code_source = DirectShowSource("lsp_client_code_cut.avi").converttorgb32.AssumeFps(25).crop(672, 154, gClipWidth, gClipHeight)

function detailCrop(clip sourceClip, int x, int y)
{
    sourceClip.crop(x, y, gClipWidth, gClipHeight)
}

function caption(clip sourceClip, string captionText)
{
	height = 30
	stackvertical(sourceClip.CropBottom(height),
	\ BlankClip(sourceClip.FrameCount, sourceClip.Width, height, fps = sourceClip.FrameRate, color = gBackgroundColor, pixel_type = sourceClip.PixelType)
	\   .QtAviSynthTitle(captionText, gTextFontFace, gTextColor))
}

title_screen = textClip("Language Client Protocol\nsupport in Qt Creator", 100).KillAudio.AssumeFps(pip_install_source.FrameRate)

pip_install =
\    pip_install_source.trim(1, 200)

openoptions =
\    openoptions_source.trim(1, 200)

addserver =
\    addserver_source.detailCrop(0, 0).trim(1, 200)

code =
\    code_source.trim(1, 200)

complete = title_screen + pip_install + openoptions + addserver + code

#complete
code

