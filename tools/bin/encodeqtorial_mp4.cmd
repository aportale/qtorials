@echo off
rem This work is licensed under the Creative Commons
rem Attribution-Noncommercial-Share Alike 3.0 Unported
rem License. To view a copy of this license, visit
rem http://creativecommons.org/licenses/by-nc-sa/3.0/
rem or send a letter to Creative Commons,
rem 171 Second Street, Suite 300, San Francisco,
rem California, 94105, USA.

set SCRIPTDIR=%~d0%~p0
set SCREENCASTSDIR=%SCRIPTDIR%..\..\screencasts
set SCREENCASTAVS=%SCREENCASTSDIR%\%1.avs
set STAGEDIR=%SCRIPTDIR%..\..\..\qtorials_stage
set SCREENCASTMP4=%STAGEDIR%\%1.mp4
set SCREENCASTMP4TEMP=%STAGEDIR%\%1_temp.mp4

x264 -o "%SCREENCASTMP4TEMP%" --threads 1 --crf 15 "%SCREENCASTAVS%"
ffmpeg -y -i "%SCREENCASTMP4TEMP%" -vcodec copy -i "%SCREENCASTAVS%" -acodec libfaac -ac 1 -ar 44100 -ab 64k "%SCREENCASTMP4%"
del "%SCREENCASTMP4TEMP%"