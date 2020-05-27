ECHO OFF
ECHO #####################################################
ECHO ####  DEINTERLACING %1
ECHO.
ECHO.


set file=%1
set noext=%file:~0,-4%
set q=%~2


ffmpeg -i %file% -vcodec libx264 -acodec aac -strict experimental -vf "yadif=2:-1, scale=trunc(iw/2)*2:trunc(ih/2)*2" %q% tmp_%noext%.mp4

IF EXIST tmp_%noext%.mp4. (
	del %1
	ren tmp_%noext%.mp4 %noext%.mp4
) ELSE (
	echo Conversion of %1 was not completed.
)