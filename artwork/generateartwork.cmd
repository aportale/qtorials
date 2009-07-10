@Echo off
for %%i in (qt_small qt_big cc-by-nc-sa_small cc-by-nc-sa_big cc-by-nc-nd_small cc-by-nc-nd_big oldstyle) do call :exportidtopng %%i
goto :eof

:exportidtopng
for %%j in (1280x720 640x480 480x360 424x320) do call :exportidwithsizetopng %1 %%j
goto :eof

:exportidwithsizetopng
SET EXPORT_ID=%1
SET EXPORT_ID=%EXPORT_ID%_%2
inkscape.exe --file=artwork.svg --export-id=%EXPORT_ID% --export-id-only --export-png=%EXPORT_ID%.png --export-background-opacity=0
pngout %EXPORT_ID%.png /c6
optipng -quiet -o7 -zw32k %EXPORT_ID%.png
goto :eof
