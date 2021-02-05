Import("tests.avsi")

multiplier = 3
qtintro = ColorBars(width = 640 * multiplier, height = 360 * multiplier).trim(1, 340).QtAviSynthQtLowerThird("Adapts to various screen sizes and aspect ratios.").killaudio
StackVertical (\
qtintro, \
FFVideoSource("lowerthird_orig_cut.mp4").BilinearResize(640 * multiplier, 360 * multiplier).ConvertToRGB32 \
)

#qtintro
