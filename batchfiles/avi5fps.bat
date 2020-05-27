ECHO OFF
ECHO #####################################################
ECHO ####  CONVERTING %1 to AVI
ECHO.
ECHO.

set file=%1
set noext=%file:~0,-4%
set q=%~2

rem ffmpeg -i %1 -f avi -framerate 5 -vb 8000k tmp_%noext%.avi
ffmpeg -i %1 -f avi -r 5 -framerate 5 %q% tmp_%noext%.avi


IF EXIST tmp_%noext%.avi. (
	del %1
	ren tmp_%noext%.avi %noext%.avi
) ELSE (
	echo Conversion of %1 was not completed.
)