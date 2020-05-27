ECHO OFF
ECHO #####################################################
ECHO ####  CONVERTING %1 to H264
ECHO.
ECHO.

set file=%1
set noext=%file:~0,-4%

ffmpeg -i %1 -c:v libx264 -g 30 tmp_%noext%.mp4

IF EXIST tmp_%noext%.mp4. (
	del %1
	ren tmp_%noext%.mp4 %noext%.mp4
) ELSE (
	echo Conversion of %1 was not completed.
)