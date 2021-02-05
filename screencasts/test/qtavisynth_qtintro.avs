Import("tests.avsi")

multiplier = 3
qtintro = ColorBars(width = 640 * multiplier, height = 360 * multiplier).trim(1, 340).AssumeFps(60).QtAviSynthQtIntro("Qt for MCUs", "Ultimate performance. Tiny footprint.").killaudio
StackVertical (\
qtintro, \
FFVideoSource("orig_cut.mp4").BilinearResize(640 * multiplier, 360 * multiplier).ConvertToRGB32 \
)

qtintro
