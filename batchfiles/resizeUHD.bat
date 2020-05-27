ECHO OFF
ECHO #####################################################
ECHO ####  RESIZING %1 to ?x2160 & H264
ECHO.
ECHO.

set file=%1
set noext=%file:~0,-4%
set quality=%~2

ffmpeg -i %1 -vf "scale=-1:2160, scale=trunc(iw/2)*2:2160" -c:v libx264 %quality% tmp_%noext%.mp4

IF EXIST tmp_%noext%.mp4. (
	del %1
	ren tmp_%noext%.mp4 %noext%.mp4
) ELSE (
	echo Conversion of %1 was not completed.
)