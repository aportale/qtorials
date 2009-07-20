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
global gTitleTextSize = 25
global gDetailsTransitionDeafultFrameCount = 15

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
    noiseSampleReverse = noiseSample.reverse()
    noiseSample = noiseSample + noiseSample.reverse()
    noiseSampleLength = (gAudioNoiseEnd - gAudioNoiseStart) * 2 # '* 2' because it has the reversed noise appended
    noiseAudio = noiseSample.loop(ceil(lengthSeconds / noiseSampleLength))
    return noiseAudio.trimAudio(0, lengthSeconds)
}

function audioClip(float startSecond, float endSecond, float appendedSilenceSeconds)
{
    return gAudioClip.trimAudio(startSecond, endSecond) + audioNoise(appendedSilenceSeconds)
}

function textClip(clip templateClip, string text)
{
    backgroundColor = $eeeeee
    textColor = $333333
    return
        \  BlankClip(clip = templateClip, length = StrLen(text) * 2, color = backgroundColor)
        \ .Subtitle(text, align = 5, text_color = textColor, halo_color = backgroundColor, size = gTitleTextSize, lsp = 100)
}

function frame(clip sourceClip, int frame)
{
    return sourceClip.trim(frame, frame).loop(gStillFrameLength)
}

function clipSizeString()
{
    return String(gClipWidth) + "x" + String(gClipHeight)
}

function fittedClipWidth(int outerClipWidth, int outerClipHeight, int fittedClipOriginalWidth, int fittedClipOriginalHeight)
{
    innerOuterWidthRatio = float(outerClipWidth) / fittedClipOriginalWidth
    innerOuterHeightRatio = float(outerClipHeight) / fittedClipOriginalHeight
    return int(fittedClipOriginalWidth * (innerOuterWidthRatio > innerOuterHeightRatio ? innerOuterHeightRatio : innerOuterWidthRatio))
}

function fittedClipHeight(int outerClipWidth, int outerClipHeight, int fittedClipOriginalWidth, int fittedClipOriginalHeight)
{
    innerOuterWidthRatio = float(outerClipWidth) / fittedClipOriginalWidth
    innerOuterHeightRatio = float(outerClipHeight) / fittedClipOriginalHeight
    return int(fittedClipOriginalHeight * (innerOuterWidthRatio > innerOuterHeightRatio ? innerOuterHeightRatio : innerOuterWidthRatio))
}

function fittedClip(clip theClip, int outerClipWidth, int outerClipHeight)
{
    fittedClipWidth = fittedClipWidth(outerClipWidth, outerClipHeight, theClip.Width, theClip.Height)
    fittedClipWidth = (fittedClipWidth % 2 == 1) ? fittedClipWidth - 1 : fittedClipWidth
    fittedClipHeight = fittedClipHeight(outerClipWidth, outerClipHeight, theClip.Width, theClip.Height)
    fittedClipHeight = (fittedClipHeight % 2 == 1) ? fittedClipHeight - 1 : fittedClipHeight
    borderLeft = (outerClipWidth - fittedClipWidth) / 2
    borderTop = (outerClipHeight - fittedClipHeight) / 2
    borderRight = outerClipWidth - borderLeft - fittedClipWidth
    borderBottom = outerClipHeight - borderTop - fittedClipHeight
    theClip.LanczosResize(fittedClipWidth, fittedClipHeight).addBorders(borderLeft, borderTop, borderRight, borderBottom)
}

function CroppedFittedClip(clip theClip, int left, int top, int width, int height)
{
    theClip.Crop(left, top, width, height).fittedClip(gClipWidth, gClipHeight)
}

function qtLogoSmall(clip)
{
    clipSizeString = String(clip.Width) + "x" + String(clip.Height)
    qtLogo = ImageReader("..\artwork\qt_small_" + clipSizeString + ".png", 0, 0, 25, pixel_type="rgb32")
    qtLogoMask = qtLogo.showalpha
    return clip.Overlay(qtlogo, 0, 0, qtlogomask, 0.6)
}

function oldStyle(clip)
{
    clipSizeString = String(clip.Width) + "x" + String(clip.Height)
    oldStyle = ImageReader("..\artwork\oldstyle_" + clipSizeString + ".png", 0, 0, 25, pixel_type="rgb32")
    oldStyleAlpha = oldStyle.showalpha()
    return clip.Overlay(oldStyle, 0, 0, oldStyleAlpha, 0.6)
}

global gDetailClip = BlankClip

function resetCurrentDetail()
{
    global gDetailClip = BlankClip
    global gDetailLastFrame = 1

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

function showDetailStartAndEndSameSize()
{
    return (gDetailStartWidth == gDetailEndWidth) && (gDetailStartHeight == gDetailEndHeight)
}

function showDetailFrame()
{
    interpolatedLeft = sCurveInterpolation(float(gDetailStartLeft), float(gDetailEndLeft), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedLeft = showDetailStartAndEndSameSize ? Round(interpolatedLeft) : interpolatedLeft
    interpolatedTop = sCurveInterpolation(float(gDetailStartTop), float(gDetailEndTop), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedTop = showDetailStartAndEndSameSize ? Round(interpolatedTop) : interpolatedTop
    interpolatedWidth = sCurveInterpolation(float(gDetailStartWidth), float(gDetailEndWidth), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    interpolatedHeight = sCurveInterpolation(float(gDetailStartHeight), float(gDetailEndHeight), gDetailCurrentTransitionFrame, gDetailsTransitionFrameCount)
    result = gDetailClip
        \ .Trim(gDetailLastFrame + gDetailCurrentTransitionFrame, gDetailLastFrame + gDetailCurrentTransitionFrame)
        \ .LanczosResize(gClipWidth, gClipHeight, interpolatedLeft, interpolatedTop, interpolatedWidth, interpolatedHeight)
    global gDetailCurrentTransitionFrame = gDetailCurrentTransitionFrame + 1
    return (gDetailCurrentTransitionFrame <= gDetailsTransitionFrameCount) ? (result + showDetailFrame) : result  # recursion = poor man's loop in AviSynth
}

function showDetail(clip, int totalFrames, int left, int top, int "width", int "height", int "transitionFrames")
{
    (gDetailClip != clip) ? resetCurrentDetail : NOP

    global gDetailClip = clip
    global gDetailEndLeft = left
    global gDetailEndTop = top
    global gDetailEndWidth = Default(width, gClipWidth)
    global gDetailEndHeight = Default(height, gClipHeight)
    global gDetailsTransitionFrameCount = Default(transitionFrames, gDetailsTransitionDeafultFrameCount)
    global gDetailCurrentTransitionFrame = 1

    transition = showDetailFrame
    detail = clip
        \ .trim(gDetailLastFrame + gDetailsTransitionFrameCount , gDetailLastFrame + totalFrames)
        \ .LanczosResize(gClipWidth, gClipHeight, gDetailEndLeft, gDetailEndTop, gDetailEndWidth, gDetailEndHeight)

    global gDetailStartLeft = gDetailEndLeft
    global gDetailStartTop = gDetailEndTop
    global gDetailStartWidth = gDetailEndWidth
    global gDetailStartHeight = gDetailEndHeight
    global gDetailLastFrame = gDetailLastFrame + totalFrames

    return transition + detail
}
