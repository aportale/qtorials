Import("tests.avsi")

function borderAndCaption(clip c, string title) {
	c.AddBorders(4, 4, 4, 24, color_white)
\	.Subtitle(title, align=2)
\   .AddBorders(0, 0, 0, 4, color_white)
}

background = ColorBars(width=400, height=300).trim(0, 200)

elements = background.QtAviSynthElements("rgbpatterns", "qtlogosmall", "vignette")
\ .borderAndCaption("QtAviSynthElements")

highlight = background
\ .QtAviSynthHighlight(30, 70, 100, 15, 20, 100)
\ .QtAviSynthHighlight(80, 120, 90, 50, 50, 150)
\ .QtAviSynthHighlight(160, 200, 50, 50, 100, 190)
\ .borderAndCaption("QtAviSynthHighlight")

svganimation = background
\ .QtAviSynthSvgAnimation("zoo.svg"
\ , "horse"   ,  30,  150, "fadeandscale", "fade"
\ , "giraffe" ,  50,  110, "fadeandscale", "fade"
\ , "pig"     ,  70,   90, "fadeandscale", "fade"
\ , "dog"     , 110,  170, "fadeandscale", "fade"
\ , "cat"     , 140,  190, "fadeandscale", "fade"
\ )
\ .borderAndCaption("QtAviSynthSvgAnimation")

zoomnpan = background.PointResize(background.width * 2, background.height * 2)
\ .QtAviSynthZoomNPan(
\ background.width, background.height, $ff000000, 20, "BlackmanResize"
\ ,                  -1,   -1,       -1,   -1
\ ,   40,  -1,      400,    0,       -1,   -1
\ ,  105,  -1,      200,  300,       -1,   -1
\ ,  170,  -1,       -1,   -1,       -1,   -1
\ )
\ .borderAndCaption("QtAviSynthZoomNPan")

title = Dissolve(
\   background.trim(0, 100).QtAviSynthTitle(text="Some text", fontface="Titillium Web")
\ , background.trim(0, 100).QtAviSynthTitle(text="Some\nother\nText", fontface="Titillium Web", color=color_red)
\ , 20)
\ .borderAndCaption("QtAviSynthTitle")

subtitle = background
\ .QtAviSynthSubtitle("Some text", "Foo Bar", 20, 90)
\ .QtAviSynthSubtitle("Some other Text", "Foo-bar", 120, 200)
\ .borderAndCaption("QtAviSynthSubtitle")

StackVertical(
\   StackHorizontal(elements, highlight, svganimation)
\ , StackHorizontal(zoomnpan, title, subtitle)
\ )
