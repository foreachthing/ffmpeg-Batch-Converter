ECHO OFF
ECHO #####################################################
ECHO ####  CONVERTING %1 TO FRAMES
ECHO.
ECHO.

set file=%1
set noext=%file:~0,-4%

ffmpeg -i %1 %noext%_%%04d.png

rem del %1
