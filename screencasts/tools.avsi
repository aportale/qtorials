# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

global gStillFrameLength = 30
global gDissolveLength = 6
global gClipWidth = 480
global gClipHeight = 360
global gZoomNPanExpansionColor = $eeeeee
global gZoomNPanTransitionFrames = 20
global gZoomNPanResizeFilter = "Lanczos4Resize"
global gArtworkDir = "..\artwork\"
global gMediaDir = "..\..\qtorials_media\"
global gAudioClip = BlankClip
global gAudioNoiseStart = 0
global gAudioNoiseEnd = 1
global gTextClipFramesPerCharacter = 3
global gBackgroundColor = $ffffff

function titleTextSize
{
    return gClipHeight / 14
}

function trimAudio(clip audioClip, float startSecond, float endSecond)
{
    fps = 1000
    dummyVideoFrames = Round((endSecond - startSecond) * fps)
    dummyVideo = BlankClip(Round(endSecond * fps), width = 1, height = 1, fps = fps)
    dummyClip = AudioDub(dummyVideo, audioClip)
    trimmedClip = dummyClip.trim(Round(startSecond * dummyClip.Framerate), 0)
    trimmedAudio = GetChannel(trimmedClip, 1).killvideo
    return trimmedAudio
}

function audioNoise(float lengthSeconds)
{
    noiseSample = trimAudio(gAudioClip, gAudioNoiseStart, gAudioNoiseEnd)
    noiseSampleReverse = noiseSample.reverse
    noiseSample = noiseSample + noiseSample.reverse
    noiseSampleLength = (gAudioNoiseEnd - gAudioNoiseStart) * 2 # '* 2' because it has the reversed noise appended
    noiseAudio = noiseSample.loop(ceil(lengthSeconds / noiseSampleLength))
    return noiseAudio.trimAudio(0, lengthSeconds)
}

function audioClip(float startSecond, float endSecond, float appendedSilenceSeconds)
{
    return gAudioClip.trimAudio(startSecond, endSecond) + audioNoise(appendedSilenceSeconds)
}

function textClip(String text, int "frames", int "align", int "x", int "y", string "backgroundimage")
{
    textColor = $333333
    framesCount = Default(frames, StrLen(text) * gTextClipFramesPerCharacter)
    background = Defined(backgroundimage) ?
        \ ImageSource(backgroundimage, fps = 25, end = framesCount)
        \ : BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
    background.overlayRgbClip(
        \ QtorialsTitle(text, textColor, gClipWidth, gClipHeight, framesCount))
}

function frame(clip sourceClip, int frame)
{
    return sourceClip.trim(frame, frame).loop(gStillFrameLength)
}

function clipSizeString
{
    return String(gClipWidth) + "x" + String(gClipHeight)
}

function videoWithClipSize(string videoBaseName, int "width", int "height")
{
    sizeString = String(Default(width, gClipWidth)) + "x" + String(Default(height, gClipHeight))
    return Eval(videoBaseName + "_" + sizeString)
}

function overlayRgbClipOnRgb(clip background, clip overlay)
{
    return background.layer(overlay, "add")
}

function overlayRgbClipOnNonRgb(clip background, clip overlay)
{
    return background.Overlay(overlay, 0, 0, overlay.showAlpha)
}

function overlayRgbClip(clip background, clip overlay)
{
    return background.IsRGB ?
        \ overlayRgbClipOnRgb(background, overlay)
        \ : overlayRgbClipOnNonRgb(background, overlay)
}

function overlayQtorialsElements(clip background, string overlayElements)
{
    return background.overlayRgbClip(
        \ QtorialsElements(overlayElements, background.Width, background.Height, background.FrameCount))
}

function simpleQtorialsElements(string overlayElements, int framesCount)
{
    overlayRgbClip(
        \   BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
        \ , QtorialsElements(overlayElements, gClipWidth, gClipHeight, framesCount))
}

function urlSubTitle(clip, string url)
{
    overlayRgbClip(clip.converttorgb32, QtorialsSubtitle(gClipWidth, gClipHeight, url, "", 30, 175))
}

function BlankClipRGB(framesCount)
{
    BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
}
