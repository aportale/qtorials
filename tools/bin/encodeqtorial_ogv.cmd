@echo off
set SCRIPTDIR=%~d0%~p0
set SCREENCASTSDIR=%SCRIPTDIR%..\..\screencasts
set SCREENCASTAVS=%SCREENCASTSDIR%\%1.avs
set STAGEDIR=%SCRIPTDIR%..\..\..\qtorials_stage
set SCREENCASTOGV=%STAGEDIR%\%1.ogv

ffmpeg -i "%SCREENCASTAVS%" -f yuv4mpegpipe -pix_fmt yuv420p - | ffmpeg2theora -f yuv4mpegpipe -x 480 -y 360 -o "%SCREENCASTOGV%" --optimize -
