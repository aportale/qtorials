Import("tests.avsi")

ScreenCast
\ .QtAviSynthZoomNPan(
        \ 640, 480, $ff000000, 40, "BlackmanResize"
        \ ,                  -1,   -1,       -1,   -1
        \ ,   80,  -1,      380,    0,       -1,   -1           [* Zoom on Pop up *]
        \ ,  233,  -1,      640,    0,       -1,   -1           [* Upper right *]
        \ ,  370,  -1,      320,    0,      960,  720           [* Right side *]
        \ )
