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
global gDetailsExpansionColor = $eeeeee
global gMediaDir = "..\..\qtorials_media\"

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
        \  BlankClip(Default(frames, StrLen(text) * 2), gClipWidth, gClipHeight, fps = 25, color = backgroundColor, pixel_type = "RGB24")
        \ .Subtitle(text, align = 5, text_color = textColor, halo_color = backgroundColor, size = titleTextSize, lsp = 100)
}

function titleTextClip(string text, int "frames")
{
    backgroundColor = $eeeeee
    textColor = $333333
    result =
        \  BlankClip(Default(frames, StrLen(text) * 2), gClipWidth, gClipHeight, fps = 25, color = backgroundColor, pixel_type = "RGB24")
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

function videoWithClipSize(string videoBaseName, int "width", int "height")
{
    sizeString = String(Default(width, gClipWidth)) + "x" + String(Default(height, gClipHeight))
    return Eval(videoBaseName + "_" + sizeString)
}

function overlayQtorialImage(clip, string baseName, float "opacity")
{
    clipSizeString = String(clip.Width) + "x" + String(clip.Height)
    image = ImageReader("..\artwork\" + baseName + "_" + clipSizeString + ".png", 0, 0, 25, pixel_type="rgb32")
    imageMask = image.showalpha
    return clip.Overlay(image, 0, 0, imageMask, Default(opacity, 1.0))
}

function qtLogoSmall(clip)
{
    clip.overlayQtorialImage("qt_small", 0.6)
}

function oldStyle(clip)
{
    clip.overlayQtorialImage("oldstyle")
}

global gDetailClip = BlankClip

function resetCurrentDetail
{
    global gDetailClip = BlankClip
    global gDetailExpandedClip = gDetailClip
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

# Adds borders to the clip in order to make it the same aspect ratio as gClipWidth/gClipHeight
# Either Top/Bottom or Left/Right or no Borders are added.
function expandedClipForDetails(clip)
{
    clipWithToHeight = Float(clip.Width) / Float(clip.Height)
    globalClipWithToHeight = Float(gClipWidth) / Float(gClipHeight)
    global gDetailWidthExpand = (globalClipWithToHeight > clipWithToHeight) ? Round(clip.Width * globalClipWithToHeight / clipWithToHeight - clip.Width) / 2: 0
    global gDetailHeightExpand = (globalClipWithToHeight < clipWithToHeight) ? Round(clip.Height * clipWithToHeight / globalClipWithToHeight - clip.Height) / 2: 0
    return clip.addBorders(gDetailWidthExpand, gDetailHeightExpand, gDetailWidthExpand, gDetailHeightExpand, gDetailsExpansionColor)
}

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
    result = gDetailExpandedClip
        \ .Trim(gDetailLastFrame + gDetailCurrentTransitionFrame + 1, gDetailLastFrame + gDetailCurrentTransitionFrame + 1)
        \ .LanczosResize(gClipWidth, gClipHeight, interpolatedLeft, interpolatedTop, interpolatedWidth, interpolatedHeight)
    global gDetailCurrentTransitionFrame = gDetailCurrentTransitionFrame + 1
    return (gDetailCurrentTransitionFrame < gDetailsTransitionFrameCount) ? (result + showDetailFrame) : result  # recursion = poor man's loop in AviSynth
}

function setFullScreen(clip)
{
    global gDetailClip = clip
    expandedClip = expandedClipForDetails(clip)
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
    global gDetailStartLeft = left + gDetailWidthExpand
    global gDetailStartTop = top + gDetailHeightExpand
    global gDetailStartWidth = Default(width, gClipWidth)
    global gDetailStartHeight = Default(height, gClipHeight)
}

function creativeCommons(clip)
{
    backgroundColor = $eeeeee
    textColor = $333333
    return Dissolve(
        \   clip
        \ , Audiodub(BlankClip(clip, 75, color = backgroundColor).overlayQtorialImage("cc-by-sa_big"), audioNoise(10))
        \ , gDissolveLength)
}

function showDetail(clip, int untilFrame, int left, int top, int "width", int "height", int "transitionFrames")
{
    (gDetailClip != clip) ? resetCurrentDetail : NOP

    global gDetailClip = clip
    global gDetailExpandedClip = expandedClipForDetails(gDetailClip)
    global gDetailEndLeft = left + gDetailWidthExpand
    global gDetailEndTop = top + gDetailHeightExpand
    global gDetailEndWidth = Default(width, gClipWidth)
    global gDetailEndHeight = Default(height, gClipHeight)
    totalFrames = untilFrame - gDetailLastFrame
    global gDetailsTransitionFrameCount = Min(Default(transitionFrames, gDetailsTransitionDefaultFrameCount), totalFrames)
    global gDetailCurrentTransitionFrame = 0

    detail = gDetailExpandedClip
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
