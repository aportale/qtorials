Import("tests.avsi")

multiplier = 2
ColorBars(width = 640 * multiplier, height = 360 * multiplier).trim(1, 2000).QtAviSynthQtIntro("Qt Creator", "Documentation")
