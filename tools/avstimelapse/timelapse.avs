LoadPlugin("timelapse.dll")

ColorBars(pixel_type = "YUY2").Info.TimeLapse(20, 4).trim(0, 200)
