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
global gDetailsTransitionDefaultFrameCount = 20
global gDetailsExpansionWidth = 2
global gDetailsExpansionColor = $eeeeee
global gArtworkDir = "..\artwork\"
global gMediaDir = "..\..\qtorials_media\"
global gAudioClip = BlankClip
global gAudioNoiseStart = 0
global gAudioNoiseEnd = 1
global gTextClipFramesPerCharacter = 3

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

function textClip(String text, int "frames")
{
    backgroundColor = $eeeeee
    textColor = $333333
    return
        \  BlankClip(Default(frames, StrLen(text) * gTextClipFramesPerCharacter), gClipWidth, gClipHeight, fps = 25, color = backgroundColor, pixel_type = "RGB32")
        \ .Subtitle(text, align = 5, text_color = textColor, halo_color = backgroundColor, size = titleTextSize, lsp = 100)
}

function titleTextClip(string text, int "frames")
{
    backgroundColor = $eeeeee
    textColor = $333333
    result =
        \  BlankClip(Default(frames, StrLen(text) * gTextClipFramesPerCharacter), gClipWidth, gClipHeight, fps = 25, color = backgroundColor, pixel_type = "RGB32")
        \ .Subtitle(text, y = gClipHeight - int(titleTextSize * 2), align = 2, text_color = textColor, halo_color = backgroundColor, size = titleTextSize, lsp = 100)
    return result.overlayQtorialImage("qt_orials")
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

function overlayQtorialImage(clip, string baseName, float "opacity")
{
    clipSizeString = String(clip.Width) + "x" + String(clip.Height)
    image = ImageReader(gArtworkDir + baseName + "_" + clipSizeString + ".png", 0, 0, 25, pixel_type="rgb32")
    imageMask = image.showalpha
    return clip.Overlay(image, 0, 0, imageMask, Default(opacity, 1.0), output = "YV12")
}

function qtLogoSmall(clip)
{
    clip.overlayQtorialImage("qt_small", 0.6)
}

function oldStyle(clip)
{
    clip.overlayQtorialImage("oldstyle")
}

function resetCurrentDetail
{
    global gDetailLastFrame = 0

    global gDetailCurrentTransitionFrame = 1

    global gDetailStartLeft = 0
    global gDetailStartTop = 0
    global gDetailStartWidth = gClipWidth
    global gDetailStartHeight = gClipHeight

    global gDetailEndLeft = 0
    global gDetailEndTop = 0
    global gDetailEndWidth = gClipWidth
    global gDetailEndHeight = gClipHeight
}
resetCurrentDetail

function sCurveInterpolation(float sourceValue, float targetValue, int frame, int framesCount)
{
    x = float(frame) / float(framesCount)
    y = Spline(x, 0.0, 0.0,  1.0/3.0, 1.0/6.0,  2.0/3.0, 5.0/6.0,  1.0, 1.0,  true)
    return sourceValue + y * (targetValue - sourceValue)
}

function showDetailStartAndEndSameSize
{
    return (gDetailStartWidth == gDetailEndWidth) && (gDetailStartHeight == gDetailEndHeight)
}

function showDetailFrame
{
    interpolatedLeft = sCurveInterpolation(float(gDetailStartLeft), float(gDetailEndLeft), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedLeft = showDetailStartAndEndSameSize ? Round(interpolatedLeft) : interpolatedLeft
    interpolatedTop = sCurveInterpolation(float(gDetailStartTop), float(gDetailEndTop), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedTop = showDetailStartAndEndSameSize ? Round(interpolatedTop) : interpolatedTop
    interpolatedWidth = sCurveInterpolation(float(gDetailStartWidth), float(gDetailEndWidth), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedHeight = sCurveInterpolation(float(gDetailStartHeight), float(gDetailEndHeight), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    result = gDetailClip
        \ .Trim(gDetailLastFrame + gDetailCurrentTransitionFrame + 1, gDetailLastFrame + gDetailCurrentTransitionFrame + 1)
        \ .LanczosResize(gClipWidth, gClipHeight, interpolatedLeft, interpolatedTop, interpolatedWidth, interpolatedHeight)
    global gDetailCurrentTransitionFrame = gDetailCurrentTransitionFrame + 1
    return (gDetailCurrentTransitionFrame < gDetailsTransitionFrameCount) ? (result + showDetailFrame) : result  # recursion = poor man's loop in AviSynth
}

function setDetailClip(clip)
{
    resetCurrentDetail
    global gDetailClip = clip.addBorders(gDetailsExpansionWidth, gDetailsExpansionWidth, gDetailsExpansionWidth, gDetailsExpansionWidth, gDetailsExpansionColor)
}

function setFullScreen()
{
    setDetail(-gDetailWidthExpand, -gDetailHeightExpand, expandedClip.Width, expandedClip.Height)
}

function showFullScreen(clip, int untilFrame, int "transitionFrames")
{
    expandedClip = expandedClipForDetails(clip)
    transitionFrameCount = Default(transitionFrames, gDetailsTransitionDefaultFrameCount)
    return showDetail(clip, untilFrame, -gDetailWidthExpand, -gDetailHeightExpand, expandedClip.Width, expandedClip.Height)
}

function setDetail(int left, int top, int "width", int "height")
{
    global gDetailStartLeft = left + gDetailsExpansionWidth
    global gDetailStartTop = top + gDetailsExpansionWidth
    global gDetailStartWidth = Default(width, gClipWidth)
    global gDetailStartHeight = Default(height, gClipHeight)
}

function creativeCommons(clip, string "cclicense")
{
    backgroundColor = $eeeeee
    textColor = $333333
    theLogo = BlankClip(clip, 75, color = backgroundColor).overlayQtorialImage("cc-" + Default(cclicense, "by-sa") + "_big")
    return Dissolve(
        \   clip
        \ , clip.hasAudio ? Audiodub(theLogo, audioNoise(10)) : theLogo
        \ , gDissolveLength)
}

function showDetail(int untilFrame, int left, int top, int "width", int "height", int "transitionFrames")
{
    global gDetailEndLeft = left + gDetailsExpansionWidth
    global gDetailEndTop = top + gDetailsExpansionWidth
    global gDetailEndWidth = Default(width, gClipWidth)
    global gDetailEndHeight = Default(height, gClipHeight)
    totalFrames = untilFrame - gDetailLastFrame
    global gDetailsTransitionFrameCount = Min(Default(transitionFrames, gDetailsTransitionDefaultFrameCount), totalFrames)
    global gDetailCurrentTransitionFrame = 0

    detail = gDetailClip
        \ .trim(gDetailLastFrame + gDetailsTransitionFrameCount + 1, gDetailLastFrame + totalFrames)
        \ .LanczosResize(gClipWidth, gClipHeight, gDetailEndLeft, gDetailEndTop, gDetailEndWidth, gDetailEndHeight)
    detail = (gDetailsTransitionFrameCount > 0) ? (showDetailFrame + detail) : detail

    global gDetailStartLeft = gDetailEndLeft
    global gDetailStartTop = gDetailEndTop
    global gDetailStartWidth = gDetailEndWidth
    global gDetailStartHeight = gDetailEndHeight
    global gDetailLastFrame = gDetailLastFrame + totalFrames

    return detail
}
