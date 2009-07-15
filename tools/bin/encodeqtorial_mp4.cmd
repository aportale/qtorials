@echo off
set SCRIPTDIR=%~d0%~p0
set SCREENCASTSDIR=%SCRIPTDIR%..\..\screencasts
set SCREENCASTAVS=%SCREENCASTSDIR%\%1.avs
set STAGEDIR=%SCRIPTDIR%..\..\..\qtorials_stage
set SCREENCASTMP4=%STAGEDIR%\%1.mp4

ffmpeg -threads 0 -y -i "%SCREENCASTAVS%" -vb 2500000 -vcodec libx264 "%SCREENCASTMP4%"
