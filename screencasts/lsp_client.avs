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
    captionHeight = 30
	captionAppearance = 15
	captionDuration = 80
	clipBefore = sourceClip.trim(0, captionAppearance - 1)
	clipWithCaption = sourceClip.trim(captionAppearance, captionAppearance + captionDuration - 1)
	clipRemainder = sourceClip.trim(captionAppearance + captionDuration - 1, sourceClip.FrameCount)
	clipBefore
	\ +	stackvertical(
	\       clipWithCaption.CropBottom(captionHeight),
    \       BlankClip(captionDuration, sourceClip.Width, captionHeight, fps = sourceClip.FrameRate, color = gBackgroundColor, pixel_type = sourceClip.PixelType)
    \   .QtAviSynthTitle(captionText, gTextFontFace, gTextColor))
	\ + clipRemainder
}

function doubleSpeed(clip sourceClip)
{
	sourceClip.selectEvery(2).AssumeFps(25)
}

function highSpeed(clip sourceClip)
{
	sourceClip.selectEvery(4).AssumeFps(25)
}

title_screen = textClip("Language Server Protocol\nin Qt Creator", 80).KillAudio.AssumeFps(pip_install_source.FrameRate)

pip_install =
\    pip_install_source.trim(30, 110)
\ +  pip_install_source.trim(110, 168).doubleSpeed
\ +  pip_install_source.trim(220, 265)

addserver =
\    openoptions_source.trim(50, 200)
\ +  addserver_source.detailCrop(0, 0).trim(80, 130).doubleSpeed
\ +  addserver_source.detailCrop(0, 0).trim(130, 170).highSpeed
\ +  addserver_source.detailCrop(0, 100).trim(160, 310).highSpeed
\ +  addserver_source.detailCrop(0, 100).trim(310, 460).doubleSpeed
\ +  addserver_source.detailCrop(0, addserver_source.height - gClipHeight).trim(460, 588).highSpeed

code =
\    code_source.trim(10, 40)
\ +  code_source.trim(48, 90).doubleSpeed        [* completing PySide2 *]
\ +  code_source.trim(90, 90).loop(15)
\ +  code_source.trim(90, 175).highSpeed         [* completing .QtWidget *]
\ +  code_source.trim(175, 175).loop(15)
\ +  code_source.trim(175, 400).highSpeed        [* completing QLabel *]
\ +  code_source.trim(400, 400).loop(15)
\ +  code_source.trim(1930, 2010).doubleSpeed    [* completing show *]
\ +  code_source.trim(2010, 2010).loop(15)
\ +  code_source.trim(2635, 2668).doubleSpeed
\ +  code_source.trim(2668, 2750)

end_screen = textClip("", 75).KillAudio.AssumeFps(pip_install_source.FrameRate)

complete =
\    title_screen
\ +  pip_install.caption("Install a language server.")
\ +  addserver.caption("Register the language server.")
\ +  code.caption("Enjoy the language support.")
\ +  end_screen

complete
