ECHO OFF

TITLE Please wait ...

IF NOT EXIST bin\ffmpeg.exe (
  CLS
  ECHO bin\ffmpeg.exe could not be found.
  GOTO:error
)

CD bin || GOTO:error
PROMPT $G
CLS
ffmpeg -version
SET PATH=%CD%;%PATH%
cd ..
cd _inout
SET "INPUTOUTPUT=%CD%"
ECHO Current directory is: "%CD%"
ECHO The ffmpeg\bin directory has been added to PATH
ECHO.

rem Set Default Quality:
set "quality=-b:v 20000K"
set userframerate=24
set userheight=0
set usernumdigits=4

goto STARTMENU


rem #####################################################

cls

:STARTMENU
	setlocal enableextensions enabledelayedexpansion
	rem SETLOCAL ENABLEDELAYEDEXPANSION
	
	TITLE ffmpeg Batch Converter

	set nfiles=0
	for %%a in (*.*) do set /a nfiles+=1
	
	set "choices= 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	ECHO บ Press 1, 2, 3, etc. to select your task,                บ
	ECHO บ or 0 to EXIT.                                           บ
	ECHO ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออออออน
	ECHO บ       WARNING: Orginal files will be REPLACED           บ
	ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
	ECHO  Convert files to:
	ECHO.
	ECHO  1 - AVI
	ECHO  2 - 
	ECHO  3 - Movie to Frames (filename.mp4 ฏ filename_0000.png)
	ECHO  4 - Frames to MP4 (filename_0000.png ฏ filename.mp4)
	ECHO  5 - h264 (MP4) (set quality first)
	ECHO  6 - h264 (MP4) (quality ignored)
    ECHO.
	ECHO  7 - MTS Deinterlace (loosless; yadif; mcdeint;
	ECHO      = very, very loooooong process but best.)
	ECHO  8 - MP4 Deinterlace (loosless; yadif;  OK.)
	ECHO  9 - MP4 Deinterlace (-deinterlace;     Not Recommended.)
    ECHO.
	ECHO  g - Make GIF ... I KNOW, right^^!^^!??
    ECHO  h - Frames to GIF (direct conversion; set framerate [r])
	ECHO.
	ECHO  a - Deinterlace to frames (filename.mp4 ฏ filename_0000.png)
rem	ECHO  b - 
rem	ECHO  c - 
rem ECHO  d - 
	ECHO  e - Set output HEIGHT in pixels (Width x ?)
    ECHO  f - Set number of digits for 'movie to frames'
	ECHO.
	ECHO  q - Set compression quality
	ECHO  r - Set Frame Rate for #4
	ECHO.
	ECHO  0 - EXIT
	ECHO ---------------------------------------------------------
	ECHO  Status:
    ECHO   Found !nfiles! file(s) in directory !CD!
	
    set "outputscale="
    
    IF not "!quality!" == ""       ECHO   (q) Quality set to        : !quality!
	IF not "!userframerate!" EQU 0 ECHO   (r) Framerate set to      : !userframerate!
	IF not !userheight! == 0 (
                                   ECHO   Output height set to      : !userheight!p
        set outputscale=-vf "scale=-1:!userheight!, scale=trunc(iw/2)*2:!userheight!"
    ) ELSE (
                                   ECHO   Output height set to      : default
    )    

    set prefix=%%0!usernumdigits!d
    if not "!usernumdigits!" EQU 0 ECHO   (f) Number of digits      : !usernumdigits!
	ECHO.
    
	CHOICE /T 9999 /D 0 /C:%choices:~1% /N /M:"Press key to start task: "
	set "choice=!choices:~%errorlevel%,1!"
	
    cls
	goto sub_!choice!
	



rem #####################################################
:sub_1
    ECHO OFF
    ECHO #####################################################
    
	for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
		ECHO.
		ECHO ####  CONVERTING !filename! to AVI
        ECHO.
        ECHO.

        ffmpeg -i !filename! -f avi !quality! !outputscale! tmp_!noext!.avi

        IF EXIST tmp_!noext!.avi. (
            del !filename!
            ren tmp_!noext!.avi !noext!.avi
        ) ELSE (
            echo Conversion of !filename! was not completed.
        )
	)
	GOTO RESTART
    

rem #####################################################
:sub_2
    GOTO RESTART
    

rem #####################################################
:sub_3
    ECHO OFF
    ECHO #####################################################
    
	for %%f in (*.*) do (

        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"

        rem ffmpeg -i !filename! !noext!_%%04d.png
        ffmpeg -i !filename! !outputscale! !noext!_!prefix!.png

	)
	GOTO RESTART


rem #####################################################
:sub_4
    GOTO FRAMES2mpeg


rem #####################################################
:sub_5
    ECHO OFF
    ECHO #####################################################
    
	for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
		ECHO.
		ECHO ####  CONVERTING !filename! to MP4
        ECHO.
        ECHO.

        ffmpeg -i !filename! -c:v libx264 !quality! !outputscale! tmp_!noext!.mp4

        IF EXIST tmp_!noext!.mp4. (
            del !filename!
            ren tmp_!noext!.mp4 !noext!.mp4
        ) ELSE (
            echo Conversion of !filename! was not completed.
        )
	)
	GOTO RESTART


rem #####################################################
:sub_6
    ECHO OFF
    ECHO #####################################################
    
	for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
		ECHO.
		ECHO ####  CONVERTING !filename! to MP4
        ECHO.
        ECHO.

        ffmpeg -i !filename! -c:v libx264 -g 30 !outputscale! tmp_!noext!.mp4

        IF EXIST tmp_!noext!.mp4. (
            del !filename!
            ren tmp_!noext!.mp4 !noext!.mp4
        ) ELSE (
            echo Conversion of !filename! was not completed.
        )
	)
	GOTO RESTART



:sub_7
	set decode=deintmts
	GOTO CONVERT

:sub_8
	set decode=mp4deint
	GOTO CONVERT

:sub_9
	set decode=mp4deint2
	GOTO CONVERT


:sub_0
	PROMPT $p$g
	GOTO EXIT



rem A	
:sub_A
	set decode=deint2images
	GOTO CONVERT	

rem #####################################################
:sub_B
	set decode=resize720p
	GOTO CONVERT
:sub_C
	set decode=resize1080p
	GOTO CONVERT
:sub_D
	set decode=resizeUHD
	GOTO CONVERT
rem #####################################################



rem #####################################################
:sub_G

	for %%f in (*.*) do (
		ECHO.		
		TITLE Converting: %%~nf%%~xf
		
        set "filename=%%~nf%%~xf"
        set "filename=!filename:~0,-4!"
        
		SET SCALE=!userheight!
		SET "palette=!INPUTOUTPUT!\palette.png"
		ffmpeg -v warning -i %%~nf%%~xf -vf "scale=256:-1, palettegen" -y !palette!
		
		SET filters="fps=!userframerate!,scale=-1:!SCALE!:flags=lanczos"
		ffmpeg -v warning -i %%~nf%%~xf -i !palette! -lavfi "!filters! [x]; [x][1:v] paletteuse" -y !filename!.gif
	
		del !palette! /q /f
	)
	
	goto STARTMENU


rem #####################################################
:sub_H

    SET filename=test
    SET fileext=ext
    
	for %%q in (*.png) do (	
        ECHO.
        SET "framename=%%~nq%%~xq"
        SET fileext=%%~xq
    
        SET "data=%%~nq"
        FOR /f "tokens=1 delims=_" %%a IN ("%data%") do SET filename=%%a
    )
    
    TITLE Converting: !filename! ...
    
    FOR /f "tokens=1 delims=_" %%a IN ("!framename!") do (
        SET filename=%%a
    )
    
    ffmpeg -v warning -i !framename! -vf "scale=256:-1, palettegen" -y palette.png
            
    set framesname=!filename!_%%0!usernumdigits!d!fileext!    
    ffmpeg.exe -framerate !userframerate! -i !framesname! !outputscale! !filename!.flv
    
    ffmpeg.exe -i !filename!.flv -i palette.png -filter_complex "fps=1.2,scale=-1:!userheight!:flags=lanczos[x];[x][1:v]paletteuse" !filename!.gif
    
    del palette.png /q /f
    del !filename!.flv /q/f

	goto STARTMENU
    
    

rem #####################################################
:sub_E
cls
	TITLE Set Frame Rate
	ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	ECHO บ ENTER OUTPUT HEIGHT IN PIXELS                           บ
	ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
	ECHO.
    ECHO  Standard Values: 200, 480, 720, 1080, 2160, ...
    ECHO  Enter 0 (zero) to disable scaling.
	ECHO.
	ECHO ---------------------------------------------------------
	set /P inputuserheight=Please input height in pixels: 
	IF NOT inputuserheight == "0" set "userheight=!inputuserheight!" 
	
	cls
	goto STARTMENU
    
rem #####################################################
:sub_F
cls
	TITLE Set Number of Digits
	ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	ECHO บ ENTER NUMBER OF DIGITS FOR MOVIE TO FRAMES              บ
	ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
	ECHO.
    ECHO  The number of digits controls the output.
    ECHO  Input: 5 = filename_00000.png
	ECHO.
	ECHO ---------------------------------------------------------
	set /P inputusernumdigits=Please input number of Digits: 
	IF NOT inputusernumdigits == "0" set "usernumdigits=!inputusernumdigits!" 
	
	cls
	goto STARTMENU    

	
rem #####################################################
:sub_R
cls
	TITLE Set Frame Rate
	ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	ECHO บ ENTER FRAME RATE FOR IMAGES TO MP4                      บ
	ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
	ECHO.
	ECHO.
	ECHO ---------------------------------------------------------
	set /P inputuserframerate=Please input frame rate: 
	IF NOT inputuserframerate == "0" set "userframerate=!inputuserframerate!" 
	
	cls
	goto STARTMENU


rem #####################################################
:CONVERT
	for %%f in (*.*) do (
		ECHO.
		TITLE Converting: %%~nf%%~xf
		call ..\batchfiles\%decode%.bat %%~nf%%~xf "!quality!"
	)
	GOTO RESTART

rem #####################################################


rem #####################################################
:FRAMES2mpeg

    SET filename=test
    SET fileext=ext
    
	for %%q in (*.png) do (	
        ECHO.
        SET "framename=%%~nq%%~xq"
        SET fileext=%%~xq
    
        SET "data=%%~nq"
        FOR /f "tokens=1 delims=_" %%a IN ("%data%") do SET filename=%%a
        goto frames2mpgcontinue
    )

:frames2mpgcontinue    
    
        TITLE Converting: !filename! ...
        
        FOR /f "tokens=1 delims=_" %%a IN ("!framename!") do (
            SET filename=%%a
        )
                
        set framesname=!filename!_%%0!usernumdigits!d!fileext!
        ffmpeg -i !framesname! -c:v libx264 -r !userframerate! !quality! !outputscale! !filename!.mp4

        GOTO RESTART
	REM )

rem #####################################################
:sub_Q
cls
	TITLE Set Compression Quality
	ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	ECHO บ CHOOSE QUALITY FOR COMPRESSION                          บ
	ECHO บ or 0 to EXIT.                                           บ
	ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
	ECHO.
	ECHO  1 - loosless (not for AVI)
	ECHO  2 - Enter custom quality in bits/s
	ECHO.
	ECHO  3 - Preset 2'000 Kbits/s
	ECHO  4 - Preset 5'000 kbits/s
	ECHO  5 - Preset 10'000 Kbits/s
	ECHO  6 - Preset 15'000 Kbits/s
	ECHO  7 - Preset 20'000 Kbits/s
	ECHO  8 - Preset 40'000 Kbits/s
	ECHO.
	ECHO  0 - EXIT (no changes)
	ECHO ---------------------------------------------------------
	CHOICE /T 9999 /D 0 /C:1234567890 /N /M:"Select or type quality: "

	goto quali_!ERRORLEVEL!
	
:quali_0
	set "quality=-b:v 2000K"
	cls
	GOTO STARTMENU
	
:quali_1
	set quality=-qp 0
	cls
	GOTO STARTMENU
	
:quali_2
	set quality=0
	set /p quality="Enter quality in bits/s: "
	set "quality=-b:v !quality!"
	
	rem -b:v 3500K
	cls
	GOTO STARTMENU

:quali_3
	set "quality=-b:v 2000K"
	cls
	GOTO STARTMENU

:quali_4
	set "quality=-b:v 5000K"
	cls
	GOTO STARTMENU

:quali_5
	set "quality=-b:v 10000K"
	cls
	GOTO STARTMENU
:quali_6
	set "quality=-b:v 15000K"
	cls
	GOTO STARTMENU
:quali_7
	set "quality=-b:v 20000K"
	cls
	GOTO STARTMENU
:quali_8
	set "quality=-b:v 40000K"
	cls
	GOTO STARTMENU
	
:quali_10
	cls
	GOTO STARTMENU
	
rem #####################################################


:RESTART

	ECHO ####  ALL DONE.
	ECHO.
	GOTO:STARTMENU


:error
	ECHO.
	ECHO Press any key to exit.
	PAUSE >nul
	GOTO:EXIT

  
:EXIT
	TITLE Command Prompt	
	cd ..
	PROMPT $p$g
	cmd /Q
	


	
	