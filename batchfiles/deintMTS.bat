ECHO OFF
ECHO #####################################################
ECHO ####  DEINTERLACING %1 
echo ####  THIS WILL TAKE A VERY, VERY LONG TIME
ECHO.
ECHO.

set file=%1
set noext=%file:~0,-4%
set q=%~2

echo ####              CREATING TEMP FILE             ####
echo #####################################################

ffmpeg -i %file% -vf yadif=3:1,mcdeint=2:1 -c:a copy -c:v libx264 -preset ultrafast %q% tmp_%noext%.mp4

echo ####            CONVERTING TEMP FILE             ####
echo #####################################################

rem ffmpeg -i tmp_%noext%.mp4 -c:v libx264 -g 30 -r 30 deint_%noext%.mp4
ffmpeg -i tmp_%noext%.mp4 -c:v libx264 -r 25 %q% deint_%noext%.mp4

echo ####              CLEANING UP FILES              ####
echo #####################################################
IF EXIST deint_%noext%.mp4. (
	del %1
	del tmp_%noext%.mp4
	ren deint_%noext%.mp4 %noext%.mp4
) ELSE (
	echo Conversion of %1 was not completed.
	PAUSE
	GOTO:EOF
)

echo ####                     DONE                    ####
echo #####################################################
