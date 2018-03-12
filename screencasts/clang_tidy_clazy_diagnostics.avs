# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("C:\\Users\\aportale\\ownprojects\\ffms2-2.23.1-msvc\\x64\\ffms2.dll")
Import("tools.avsi")

global gClipWidth = 660
global gClipHeight = 392

function fullscreenResize(clip sourceClip)
{
    sourceClip.BilinearResize(gClipWidth, gClipHeight)
}

function detailCrop(clip sourceClip, int x, int y)
{
    sourceClip.crop(x, y, gClipWidth, gClipHeight)
}

raw_clip = FFVideoSource(gMediaDir + "ClangTidyClazyDiagnostics_cropped.mov", colorspace = "RGB24").AssumeFps(30)

tidy_caption = ImageSource("clang_tidy_clazy_diagnostics_tidy_caption.png", fps = 30, end = 100)

tidy_opening_options_raw = raw_clip.trim(64, 138).fullscreenResize
tidy_opening_options = tidy_opening_options_raw.trim(0, -1).loop(45) + tidy_opening_options_raw

tidy_setting_options_raw = raw_clip.trim(320, 447).detailCrop(272, 212)
tidy_setting_options = tidy_setting_options_raw.trim(0, -1).loop(25) + tidy_setting_options_raw

tidy_diagnostics_appearing = raw_clip.trim(444, 526).fullscreenResize

tidy_applying_fixits_raw = raw_clip.detailCrop(364, 0)
tidy_applying_fixits = tidy_applying_fixits_raw.trim(540, 570) + tidy_applying_fixits_raw.trim(618, 1060)

clazy_caption = ImageSource("clang_tidy_clazy_diagnostics_clazy_caption.png", fps = 30, end = 100)

clazy_setting_options = raw_clip.trim(1430, 1546).detailCrop(272, 212)
clazy_diagnostics = raw_clip.trim(1590, 2150).detailCrop(364, 52)

complete = tidy_caption + tidy_opening_options + tidy_setting_options + tidy_diagnostics_appearing + tidy_applying_fixits + clazy_caption + clazy_setting_options + clazy_diagnostics

complete

# Generate an animated gif with ffmpeg
# from https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
# Generate a palette:
#   ffmpeg -y -i clang_tidy_clazy_diagnostics.avs -filter_complex "palettegen=reserve_transparent=false:max_colors=256" palette.png
# Output the GIF using the palette:
#   ffmpeg -y -i clang_tidy_clazy_diagnostics.avs -i palette.png -filter_complex "paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" clang_tidy_clazy_diagnostics.gif

