ECHO OFF
ECHO #####################################################
ECHO ####  DEINTERLACING %1 to Images
echo ####  THIS WILL TAKE FOREVER
ECHO.
ECHO.


set file=%1
set noext=%file:~0,-4%
set q=%~2

echo ####              CREATING TEMP FILE             ####
echo #####################################################

ffmpeg -i %file% -vf yadif=3:1,mcdeint=2:1 -c:a copy -c:v libx264 -preset medium %q% tmp_%noext%.mp4
ffmpeg -i tmp_%noext%.mp4 %noext%_%%04d.png

IF EXIST tmp_%noext%.mp4. (
	del %1
	del tmp_%noext%.mp4
) ELSE (
	echo Conversion of %1 was not completed.
	PAUSE
	GOTO:EOF
)