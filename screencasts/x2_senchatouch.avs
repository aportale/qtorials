# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

LoadPlugin("qtavisynth.dll")
Import("tools.avsi")

global gClipWidth = 640
global gClipHeight = 360
global gDissolveLength = 12

function phoneaction
{
    clip = DirectShowSource(gMediaDir + "senchatouchN8.ts", audio = false).TemporalSoften(2, 4, 4)
    FadeIO(clip.trim(540, 1163) + clip.trim(1230, 1470) + clip.trim(1545, 1610) + clip.trim(1950, 2015) + clip.trim(2060, 2095) + clip.trim(2226, 2410), gDissolveLength)
        \ + FadeIO(clip.trim(2850, 2994) + clip.trim(3096, 3230) + clip.trim(3278, 3405) + clip.trim(3495, 3575) + clip.trim(3640, 3866) + clip.trim(3990, 4040) + clip.trim(4140, 4240) + clip.trim(4240, 4240).loop(25), gDissolveLength)
        \ + FadeIO(clip.trim(4425, 4425).loop(25) + clip.trim(4425, 4485) + clip.trim(4745, 4790) + clip.trim(4860, 5140), gDissolveLength)
        \ + FadeIO(clip.trim(5410, 5410).loop(25) + clip.trim(5410, 5645), gDissolveLength)
}

function completeclip
{
    phoneactionClip = phoneaction()
    clip =
        \ Dissolve(
            \   BlankClipRGB(15)
            \ , textClip("Sencha Touch\n\n", 40)
            \ , textClip("Sencha Touch\non QtWebKit\n", 40)
            \ , textClip("Sencha Touch\non QtWebKit\non Nokia N8", 40)
            \ , gDissolveLength).killaudio
        \ + phoneactionClip.animate(0, phoneactionClip.FrameCount, "Lanczos4Resize",     gClipWidth, gClipHeight, 0.0, 0.0, 1920.0, 1080.0,     gClipWidth, gClipHeight, 248.0, 128.0, 1390.0, 781.0).ConvertToRgb
    return clip.QtorialsElements("oldstyle").FadeIO(gDissolveLength)
}

completeclip
