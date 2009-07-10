for %%i in (640x480 512x384 480x360 425x320 424x320 1280x720) do call :exportsozetopng %%i
goto :eof

:exportsozetopng
inkscape.exe --file=qtlogosmall.svg --export-id=backgroundgroupsmall_%1 --export-id-only --export-png=qtlogosmall_%1.png --export-background-opacity=0
pngout qtlogosmall_%1.png
inkscape.exe --file=cclogo.svg --export-id=backgroundgroupsmall_%1 --export-id-only --export-png=cclogosmall_%1.png --export-background-opacity=0
pngout cclogosmall_%1.png
inkscape.exe --file=cclogo.svg --export-id=backgroundgroupbig_%1 --export-id-only --export-png=cclogobig_%1.png --export-background-opacity=0
pngout cclogobig_%1.png
inkscape.exe --file=oldstylegradient.svg --export-id=gradient_%1 --export-id-only --export-png=oldstylegradient_%1.png --export-background-opacity=0
pngout oldstylegradient_%1.png
goto :eof
