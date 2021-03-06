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
global gTextFontFace = "Titillium Web"
global gTextColor = $333333
global gBackgroundColor = $ffffff
global gFFDShowImport = "c:\Program Files (x86)\ffdshow\ffavisynth.avsi"

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

function textClip(String text, int "frames", string "backgroundimage")
{
    framesCount = Default(frames, StrLen(text) * gTextClipFramesPerCharacter)
    background = Defined(backgroundimage) ?
        \ ImageSource(backgroundimage, fps = 25, end = framesCount)
        \ : BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
    background.QtAviSynthTitle(text, gTextFontFace, gTextColor)
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

function urlSubTitle(clip, string url)
{
    clip.converttorgb32.QtorialsSubtitle(url, "", 30, 175)
}

function BlankClipRGB(framesCount)
{
    BlankClip(framesCount, gClipWidth, gClipHeight, fps = 25, color = gBackgroundColor, pixel_type = "RGB32")
}

function warp(clip sourceClip, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)
{
    # return sourceClip
    scaledX3 = String(Round(100.0 / sourceClip.width * x1))
    scaledY3 = String(Round(100.0 - (100.0 / sourceClip.height * y1)))
    scaledX4 = String(Round(100.0 / sourceClip.width * x2))
    scaledY4 = String(Round(100.0 - (100.0 / sourceClip.height * y2)))
    scaledX1 = String(Round(100.0 / sourceClip.width * x3))
    scaledY1 = String(Round(100.0 - (100.0 / sourceClip.height * y3)))
    scaledX2 = String(Round(100.0 / sourceClip.width * x4))
    scaledY2 = String(Round(100.0 - (100.0 / sourceClip.height * y4)))
    coordinates = ("perspectiveX1=" + scaledX1 + ",perspectiveY1=" + scaledY1 + ",perspectiveX2=" + scaledX2 + ",perspectiveY2=" + scaledY2 + ",perspectiveX3=" + scaledX3 + ",perspectiveY3=" + scaledY3 + ",perspectiveX4=" + scaledX4 + ",perspectiveY4=" + scaledY4)
    return sourceClip.ffdshow(options="dithering=0,isPerspective=1,perspectiveIsSrc=1,perspectiveInterpolation=2," + coordinates)
}
