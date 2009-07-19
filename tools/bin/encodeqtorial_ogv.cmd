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
set SCREENCASTOGV=%STAGEDIR%\%1.ogv

ffmpeg -i "%SCREENCASTAVS%" -f yuv4mpegpipe -pix_fmt yuv420p - | ffmpeg2theora -f yuv4mpegpipe -x 480 -y 360 -o "%SCREENCASTOGV%" --optimize -
