ECHO OFF
ECHO #####################################################
ECHO ####  CONVERTING %1 FRAMES to MP4
ECHO.
ECHO.

set file=%1
set framerate=%2
set q=%~2

ffmpeg -framerate %framerate% -i %1_%%04d.png -f avi -r 24 %q% %file%.avi