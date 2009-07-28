@echo off
rem This work is licensed under the Creative Commons
rem Attribution-Noncommercial-Share Alike 3.0 Unported
rem License. To view a copy of this license, visit
rem http://creativecommons.org/licenses/by-nc-sa/3.0/
rem or send a letter to Creative Commons,
rem 171 Second Street, Suite 300, San Francisco,
rem California, 94105, USA.

for %%i in (qt_small qt_big qt_orials cc-by-sa_small cc-by-sa_big cc-by-nc-sa_small cc-by-nc-sa_big cc-by-nc-nd_small cc-by-nc-nd_big oldstyle) do call :exportidtopng %%i
goto :eof

:exportidtopng
for %%j in (1280x720 960x720 640x480 640x360 480x360 424x320) do call :exportidwithsizetopng %1 %%j
goto :eof

:exportidwithsizetopng
SET EXPORT_ID=%1
SET EXPORT_ID=%EXPORT_ID%_%2
inkscape.exe --file=artwork.svg --export-id=%EXPORT_ID% --export-id-only --export-png=%EXPORT_ID%.png --export-background-opacity=0
pngout %EXPORT_ID%.png /c6
optipng -quiet -o7 -zw32k %EXPORT_ID%.png
goto :eof
