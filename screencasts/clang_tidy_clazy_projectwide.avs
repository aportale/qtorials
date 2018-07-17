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

raw_clip = DirectShowSource("clangtidy_complete.avi").converttorgb32.AssumeFps(30)

function fullscreenResize(clip sourceClip)
{
    sourceClip.BilinearResize(gClipWidth, gClipHeight)
}

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

clang_fullscreen = raw_clip.fullscreenResize

clang_title_screen = textClip("Improve your entire code base\nwith Clang-Tidy and Clazy", 100).KillAudio.AssumeFps(raw_clip.FrameRate)

clang_launch_tool =
\    (clang_fullscreen.trim(1, 1).loop(30) + clang_fullscreen.trim(1, 20) + raw_clip.trim(10, 140).detailCrop(0, 219)).caption("Find the 'Clang-Tidy and Clazy' tool in the Debug mode")
\    + clang_fullscreen.trim(140, 160)

clang_manage_presets_detail = raw_clip.detailCrop(282, 38)
clang_manage_presets =
\   (clang_fullscreen.trim(160, 200) + clang_manage_presets_detail.trim(190, 280)).caption("Chose a diagnostic configuration ...")
\   + (clang_manage_presets_detail.trim(280, 280).loop(20) + clang_manage_presets_detail.trim(280, 425)).caption("... or create your own one")

clang_edit_preset_detail = raw_clip.detailCrop(282, 250)
clang_edit_presettext_detail = raw_clip.detailCrop(282, 160)
clang_edit_preset =
\   (clang_manage_presets_detail.trim(425, 475) + clang_edit_preset_detail.trim(475, 490) + clang_edit_preset_detail.trim(515, 710)).caption("Select the checks to perform...")
\   + (clang_edit_preset_detail.trim(710, 750) + clang_edit_presettext_detail.trim(750, 750).loop(10) + clang_edit_presettext_detail.trim(750, 848)).caption("... or define the checks as string")
\   + (clang_edit_presettext_detail.trim(848, 944) + clang_fullscreen.trim(944, 969)).caption("Add some Qt checks by Clazy")
\   + clang_fullscreen.trim(969, 1000)

clang_select_sources_detail = raw_clip.detailCrop(282, 144)
clang_select_sources =
\     (clang_select_sources_detail.trim(1000, 1165) + clang_fullscreen.trim(1165, 1200)).caption("Select the source files to analyze")
\   + clang_fullscreen.trim(1240, 6550).SelectEvery(100).AssumeFps(raw_clip.FrameRate)

clang_browse_diagnostics_detail = raw_clip.crop(249, 181, 1031, 587).fullscreenResize
clang_browse_diagnostics =
\     (clang_browse_diagnostics_detail.trim(7865, 7879)
\   + clang_browse_diagnostics_detail.trim(7990, 8100) + clang_browse_diagnostics_detail.trim(8100, 8100).loop(40)).caption("Browse the reported issues")

clang_filter_report_detail = raw_clip.detailCrop(246, 376)
clang_filter_report =
\     clang_filter_report_detail.trim(9730, 9860).caption("Filter the reported issues")

clang_select_fixes_detail = raw_clip.detailCrop(592, 376)
clang_select_fixes =
\     clang_select_fixes_detail.trim(9850, 10000).caption("Select some or all fixits")
\   + (clang_select_fixes_detail.trim(10000, 10045) + clang_select_fixes_detail.trim(10045, 10045).loop(50)).caption("Apply the fixits")

clang_view_diff_menu_detail = raw_clip.detailCrop(198, 0)
clang_view_diff_detail = raw_clip.crop(264, 0, 1016, 579).fullscreenResize
clang_view_diff =
\     (clang_fullscreen.trim(10240, 10290) + clang_view_diff_menu_detail.trim(10330, 10420) + clang_view_diff_detail.trim(10515, 10515).loop(130)).caption("Celebrate your patch! :)")

clang_outro_screen = textClip("", 70).KillAudio.AssumeFps(raw_clip.FrameRate)

complete = clang_title_screen + clang_launch_tool + clang_manage_presets + clang_edit_preset + clang_select_sources + clang_browse_diagnostics + clang_filter_report + clang_select_fixes + clang_view_diff + clang_outro_screen

complete

# Generate an animated gif with ffmpeg
# from https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
# Generate a palette:
#   path c:\qt\online-installer\5.11.1\msvc2017_64\bin;%PATH%
#   C:\ProgramData\chocolatey\bin\ffmpeg -y -i clang_tidy_clazy_projectwide.avi -filter_complex "palettegen=reserve_transparent=false:max_colors=256" palette.png && C:\ProgramData\chocolatey\bin\ffmpeg -y -i clang_tidy_clazy_projectwide.avi -i palette.png -filter_complex "paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" clang_tidy_clazy_projectwide.avs.gif
