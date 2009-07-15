global gStillFrameLength = 30
global gDissolveLength = 6
global gClipWidth = 480
global gClipHeight = 360
global qTitleTextSize = 25

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
        \ .Subtitle(text, align = 5, text_color = textColor, halo_color = backgroundColor, size = qTitleTextSize, lsp = 100)
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

