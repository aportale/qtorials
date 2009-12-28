@echo off
rem This work is licensed under the Creative Commons
rem Attribution-Noncommercial-Share Alike 3.0 Unported
rem License. To view a copy of this license, visit
rem http://creativecommons.org/licenses/by-nc-sa/3.0/
rem or send a letter to Creative Commons,
rem 171 Second Street, Suite 300, San Francisco,
rem California, 94105, USA.

set SCRIPTDIR=%~d0%~p0
set OUTPUTDIR=%SCRIPTDIR%html\

for %%i in (bgtop bgmiddle bgbottom bgwatch bgcomment bglength) do call :exportidtopng %%i
goto :eof

:exportidtopng
SET EXPORT_ID=%1
SET PNGFILE=%OUTPUTDIR%%EXPORT_ID%.png
inkscape.exe --file=%SCRIPTDIR%artwork.svg --export-id=%EXPORT_ID% --export-png=%PNGFILE%
pngout %PNGFILE% /c6
optipng -quiet -o7 -zw32k %PNGFILE%
goto :eof
