Import("tests.avsi")

ScreenCast
\ .QtAviSynthZoomNPan(
        \ 320, 240, $ff000000, 40, "BlackmanResize"
        \ ,                  -1,   -1,       -1,   -1,
        \ [
        \         80,  -1,      160,    0,       -1,   -1           [* Zoom on top center *]
        \     ,  233,  -1,      320,  240,       -1,   -1           [* Lower right *]
        \     ,  370,  -1,       -1,   -1,       -1,   -1           [* Zoom out *]
        \ ]
        \ )
