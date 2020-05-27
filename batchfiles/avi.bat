ECHO OFF
ECHO #####################################################
ECHO ####  CONVERTING %1 to AVI
ECHO.
ECHO.
set file=%1
set noext=%file:~0,-4%

set q=%~2

ffmpeg -i %file% -f avi %q% tmp_%noext%.avi


IF EXIST tmp_%noext%.avi. (
	del %file%
	ren tmp_%noext%.avi %noext%.avi
) ELSE (
	echo Conversion of %1 was not completed.
)

