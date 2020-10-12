@ECHO OFF

TITLE Please wait ...

setlocal

IF NOT EXIST bin\ffmpeg.exe (
  CLS
  ECHO bin\ffmpeg.exe could not be found.
  GOTO:error
)

CD bin || GOTO:error
CLS
SET PATH=%CD%;%PATH%
cd ..

IF NOT EXIST _inout (
  mkdir _inout
)

cd _inout
SET "INPUTOUTPUT=%CD%"
REM ECHO Current working directory is: "%INPUTOUTPUT%"
REM ECHO The ffmpeg\bin directory has been added to PATH
ECHO.

rem Set Default Quality:
set "quality=-b:v 20000K"
set userframerate=24
set userheight=0
set usernumdigits=4

goto STARTMENU


rem #####################################################
:STARTMENU

    setlocal enableextensions enabledelayedexpansion
    TITLE ffmpeg Batch Converter

    set nfiles=0
    for %%a in (*.*) do set /a nfiles+=1
    
    set "choices= 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    ECHO.
    ECHO ***********************************************************
    ECHO *               FFMPEG simple converter                   *
    ECHO ***********************************************************
    ECHO *   Press number or letter in [] to select your task      *
    ECHO *       WARNING: Orginal files will be REPLACED           *
    ECHO ***********************************************************
    ECHO.
    ECHO  [1]  Convert to AVI
    ECHO.  
    ECHO  [3]  Movie to Frames (filename.mp4 to filename_0000.png)
    ECHO  [4]  Frames to Movie (filename_0000.png to filename.mp4)
    ECHO  [5]  Convert to h264 (MP4) (set quality [q] first)
    ECHO.
    ECHO  [7]  MTS Deinterlace (loosless; yadif; mcdeint;
    ECHO        = very long process but best.)
    ECHO  [8]  MP4 Deinterlace (loosless; yadif;  OK.)
    ECHO  [9]  MP4 Deinterlace (-deinterlace;     Not Recommended.)
    ECHO.
    ECHO  [a]  Deinterlace to frames (filename.mp4 to filename_0000.png)
    ECHO  [b]  Convert MP4 to MP3
    ECHO.
    ECHO  [g]  Convert to GIF ... yes, gif.
    ECHO  [h]  Frames to GIF (direct conversion; set framerate [r])
    ECHO.
    ECHO.
    ECHO  [v]  ffmpeg version
    ECHO  [x]  EXIT
    ECHO ---------------------------------------------------------
    ECHO  Found !nfiles! file(s) in directory !INPUTOUTPUT!
    ECHO.
    ECHO  Options:

    IF not !userheight! == 0 (
        ECHO   [e] Set output height                      : !userheight! pixels
        set outputscale=-vf "scale=-1:!userheight!, scale=trunc(iw/2)*2:!userheight!"
    ) ELSE (
        ECHO   [e] Set output height                      : default
        set "outputscale="
    )
    
    set prefix=%%0!usernumdigits!d
    if not "!usernumdigits!" EQU 0 ECHO   [f] Set number of digits 'movie to frames' : !usernumdigits!
    
    IF not "!quality!" == "" (
        ECHO   [q] Set compression quality                : !quality!
    ) ELSE (
        ECHO   [q] Set compression quality                : ignored
    )
    ECHO   [r] Set framerate                          : !userframerate!
    ECHO.

    CHOICE /T 3600 /D 2 /C:%choices:~1% /N /M:"READY: "
    set "choice=!choices:~%errorlevel%,1!"
    
    IF "!choice!"=="0" (
        REM unused
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="1" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="2" (
        REM needed for timer
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="3" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="4" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="5" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="6" (
        REM unused
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="7" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="8" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="9" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="A" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="B" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="E" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="F" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="G" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="H" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="Q" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="R" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="V" (
        GOTO sub_!choice!
    ) ELSE IF "!choice!"=="X" (
        GOTO sub_!choice!
    ) ELSE (
        REM not in list - instead of "crash"
        cls
        GOTO STARTMENU
    )

    cls
    goto sub_!choice!


rem #####################################################
:sub_1

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
        ECHO.
        ECHO ####  CONVERTING !filename! to AVI
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" -f avi !quality! !outputscale! "tmp_!noext!.avi"

        IF EXIST tmp_!noext!.avi. (
            del !filename!
            ren tmp_!noext!.avi !noext!.avi
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART
    

rem #####################################################
:sub_2
    REM This does just a restart ...
    REM Do not re-use this as this is the default value for the timer
    GOTO RESTART
    

rem #####################################################
:sub_3

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
    
        ECHO.
        ECHO ####  CONVERTING !filename! to frames (.png)
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" !outputscale! "!noext!_!prefix!.png"

    )
    GOTO RESTART


rem #####################################################
:sub_4
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
:sub_5

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
        ECHO.
        ECHO ####  CONVERTING !filename! to MP4
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" -c:v libx264 !quality! !outputscale! "tmp_!noext!.mp4"

        IF EXIST "tmp_!noext!.mp4" (
            del "!filename!"
            ren "tmp_!noext!.mp4" "!noext!.mp4"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART


rem #####################################################
:sub_6
    REM Removed ... nid nötig!
    GOTO RESTART


rem #####################################################
:sub_7

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"

        ECHO ***********************************************************
        ECHO ****  DEINTERLACING !filename! 
        ECHO ****  THIS WILL TAKE A LONG TIME
        ECHO.

        ECHO ****               CREATING TEMP FILE
        ECHO ***********************************************************

        ffmpeg -i "!filename!" -vf yadif=3:1,mcdeint=2:1 -c:a copy -c:v libx264 -preset veryfast !quality! "tmp_!noext!.mp4" -loglevel 24

        ECHO ****            CONVERTING TEMP FILE
        ECHO ***********************************************************

        ffmpeg -i "tmp_!noext!.mp4" -c:v libx264 !quality! "deint_!noext!.mp4"

        ECHO ****              CLEANING UP FILES
        ECHO ***********************************************************
        IF EXIST "deint_!noext!.mp4" (
            del "!filename!"
            del "tmp_!noext!.mp4"
            ren "deint_!noext!.mp4" "!noext!.mp4"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
            PAUSE
            GOTO:EOF
        )
        
        goto exitsub7
        
    )
    
    :exitsub7
    GOTO RESTART

    
rem #####################################################
:sub_8

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
       
        ECHO.
        ECHO  DEINTERLACING !filename!
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" -vcodec libx264 -acodec aac -strict experimental -vf "yadif=2:-1, scale=trunc(iw/2)*2:trunc(ih/2)*2" !quality! "tmp_!noext!.mp4"

        IF EXIST "tmp_!noext!.mp4" (
            del "!filename!"
            ren "tmp_!noext!.mp4" "!noext!.mp4"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART


REM #####################################################
:sub_9

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
       
        ECHO.
        ECHO  DEINTERLACING !filename!
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" -deinterlace !quality! "tmp_!noext!.mp4"

        IF EXIST "tmp_!noext!.mp4" (
            del "!filename!"
            ren "tmp_!noext!.mp4" "!noext!.mp4"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART


REM #####################################################
:sub_X
    GOTO EXIT


REM #####################################################
:sub_A
    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
       
        ECHO.
        ECHO  DEINTERLACING !filename! to Images
        ECHO  THIS WILL TAKE A LONG TIME!
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" -vf yadif=3:1,mcdeint=2:1 -c:a copy -c:v libx264 -preset medium !quality! "tmp_!noext!.mp4"
        ffmpeg -i "tmp_!noext!.mp4" !outputscale! "!noext!_!prefix!.png"

        IF EXIST "tmp_!noext!.mp4" (
            del "!filename!"
            ren "tmp_!noext!.mp4" "!noext!.mp4"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART


REM #####################################################
:sub_B

    for %%f in (*.*) do (
        set "filename=%%~nf%%~xf"
        set "noext=%%~nf"
        
        ECHO.
        ECHO  CONVERTING !filename! to MP3
        ECHO.
        ECHO.

        ffmpeg -i "!filename!" "tmp_!noext!.mp3"

        IF EXIST "tmp_!noext!.mp3" (
            del "!filename!"
            ren "tmp_!noext!.mp3" "!noext!.mp3"
        ) ELSE (
            ECHO Conversion of !filename! was not completed.
        )
    )
    GOTO RESTART

REM #####################################################
:sub_C
    GOTO RESTART


REM #####################################################
:sub_D
    GOTO RESTART


rem #####################################################
:sub_G

    for %%f in (*.*) do (
        ECHO.
        TITLE Converting: %%~nf%%~xf
        
        set "filename=%%~nf%%~xf"
        set "filename=!filename:~0,-4!"
        
        SET SCALE=!userheight!
        SET "palette=!INPUTOUTPUT!\palette.png"
        ffmpeg -v warning -i "%%~nf%%~xf" -vf "scale=256:-1, palettegen" -y "!palette!"
        
        SET filters="fps=!userframerate!,scale=-1:!SCALE!:flags=lanczos"
        ffmpeg -v warning -i "%%~nf%%~xf" -i "!palette!" -lavfi "!filters! [x]; [x][1:v] paletteuse" -y "!filename!.gif"
    
        del "!palette!" /q /f
    )
    
    goto STARTMENU


rem #####################################################
:sub_H

    SET filename=test
    SET fileext=ext
    
    for %%q in (*.png) do ( 
        ECHO.
        SET "framename=%%~nq%%~xq"
        SET "fileext=%%~xq"
    
        SET "data=%%~nq"
        FOR /f "tokens=1 delims=_" %%a IN ("%data%") do SET filename=%%a
    )
    
    TITLE Converting: !filename! ...
    
    FOR /f "tokens=1 delims=_" %%a IN ("!framename!") do (
        SET "filename=%%a"
    )
    
    ffmpeg -v warning -i "!framename!" -vf "scale=256:-1, palettegen" -y "palette.png"
            
    set "framesname=!filename!_%%0!usernumdigits!d!fileext!"
    ffmpeg.exe -framerate !userframerate! -i "!framesname!" !outputscale! !quality! "!filename!.flv"
    
    ffmpeg.exe -i "!filename!.flv" -i palette.png -filter_complex "fps=1.2,scale=-1:!userheight!:flags=lanczos[x];[x][1:v]paletteuse" "!filename!.gif"
    
    del "palette.png" /q /f
    del "!filename!.flv" /q/f

    goto STARTMENU


rem #####################################################
:sub_E
cls
    SET /A "MinValue=0","MaxValue=10000"
    
    TITLE Set Frame Rate
    ECHO ***********************************************************
    ECHO * ENTER OUTPUT HEIGHT IN PIXELS                           *
    ECHO ***********************************************************
    ECHO.
    ECHO  Standard Values: 200, 480, 720, 1080, 2160, ...
    ECHO  Enter 0 (zero) to disable scaling.
    ECHO.
    ECHO ---------------------------------------------------------
    set /P inputuserheight=Please input height in pixels (range: !MinValue! to !MaxValue!): 
    set "userheight=!inputuserheight!" 

    IF NOT DEFINED inputuserheight (
        ECHO Input out of range.
        pause
        GOTO :sub_E
    )
    
    SET /A "myNumber=inputuserheight" 2>nul
    
    IF not "!myNumber!"=="!inputuserheight!" (
        GOTO :sub_E
    )
    IF !myNumber! GTR !MaxValue! (
        ECHO Input out of range.
        pause
        GOTO :sub_E
    )
    IF !myNumber! LSS !MinValue! (
        ECHO Input out of range.
        pause
        GOTO :sub_E
    ) 

    cls
    goto STARTMENU


rem #####################################################
:sub_F
cls

    SET /A "MinValue=0","MaxValue=10"
  
    TITLE Set Number of Digits
    ECHO ***********************************************************
    ECHO * NUMBER OF DIGITS FOR MOVIE TO FRAMES                    *
    ECHO ***********************************************************
    ECHO.
    ECHO  The number of digits controls the output.
    ECHO  Input: 5 = filename_00000.png
    ECHO.
    ECHO ---------------------------------------------------------
    set /P inputusernumdigits=Please input number of Digits (range: !MinValue! to !MaxValue!): 
    set "usernumdigits=!inputusernumdigits!"
    
    IF NOT DEFINED inputusernumdigits (
        ECHO VAR is undefined.
        pause
        GOTO :sub_F
    )
    
    SET /A "myNumber=inputusernumdigits" 2>nul
    
    IF not "!myNumber!"=="!inputusernumdigits!" (
        GOTO :sub_F
    ) ELSE IF !myNumber! GTR !MaxValue! (
        ECHO Value out of range
        pause
        GOTO :sub_F
    ) ELSE IF !myNumber! LSS !MinValue! (
        ECHO Value out of range
        pause
        GOTO :sub_F
    ) 
    
    cls
    goto STARTMENU


rem #####################################################
:sub_R
cls
    SET /A "MinValue=1","MaxValue=10000"
    
    TITLE Set Frame Rate
    ECHO ***********************************************************
    ECHO * FRAME RATE FOR IMAGES TO MP4                            *
    ECHO ***********************************************************
    ECHO.
    ECHO  Enter frames per second for output MP4
    ECHO.
    ECHO ---------------------------------------------------------
    set /P inputuserframerate=Please input frame rate (range: !MinValue! to !MaxValue!): 
    set "userframerate=!inputuserframerate!"
    
    IF NOT DEFINED inputuserframerate (
        ECHO VAR is undefined.
        pause
        GOTO :sub_R
    )

    SET /A "myNumber=inputuserframerate" 2>nul
    
    IF not "!myNumber!"=="!inputuserframerate!" (
        GOTO :sub_R
    ) ELSE IF !myNumber! GTR !MaxValue! (
        ECHO Value out of range
        pause
        GOTO :sub_R
    ) ELSE IF !myNumber! LSS !MinValue! (
        ECHO Value out of range
        pause
        GOTO :sub_R
    )

    cls
    goto STARTMENU


rem #####################################################
:sub_Q
cls
    TITLE Set Compression Quality
    ECHO ***********************************************************
    ECHO * SELECT COMPRESSION QUALITY                              *
    ECHO * or x to abort                                           *
    ECHO ***********************************************************
    ECHO.
    ECHO  [1] - loosless (not for AVI)
    ECHO  [2] - Enter custom quality in bits/s
    ECHO.
    ECHO  [3] - Preset  2'000 Kbits/s
    ECHO  [4] - Preset  5'000 kbits/s
    ECHO  [5] - Preset 10'000 Kbits/s
    ECHO  [6] - Preset 15'000 Kbits/s
    ECHO  [7] - Preset 20'000 Kbits/s
    ECHO  [8] - Preset 40'000 Kbits/s
    ECHO.
    ECHO  [i] - Quality ignored (set to blank)
    ECHO.
    ECHO  [x] - ABORT (no changes)
    ECHO ---------------------------------------------------------
    CHOICE /T 30 /D 0 /C:%choices:~1% /N /M:"Select or type quality: "
    set "choice=!choices:~%errorlevel%,1!"

    IF "!choice!"=="0" (
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="1" (
        set quality=-qp 0
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="2" (
        set quality=0
        set /p quality="Enter quality in bits/s: "
        set "quality=-b:v !quality!"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="3" (
        set "quality=-b:v 2000K"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="4" (
        set "quality=-b:v 5000K"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="5" (
        set "quality=-b:v 10000K"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="6" (
        set "quality=-b:v 15000K"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="7" (
        set "quality=-b:v 20000K"
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!"=="8" (
        set "quality=-b:v 40000K"
        cls
        GOTO STARTMENU    
    ) ELSE IF "!choice!" == "I" (
        set "quality="
        cls
        GOTO STARTMENU
    ) ELSE IF "!choice!" == "X" (
        cls
        GOTO STARTMENU
    ) ELSE (
        GOTO sub_Q
    )


rem #####################################################
:sub_V
    cls
    ffmpeg -version
    ECHO.
    pause
    cls
    GOTO STARTMENU


rem #####################################################
:RESTART

    ECHO ####  ALL DONE.
    ECHO.
    GOTO:STARTMENU

rem #####################################################
:error
    ECHO.
    ECHO Press any key to exit.
    PAUSE >nul
    GOTO:EXIT

rem #####################################################
:EXIT
    endlocal
    REM setlocal disableextensions disabledelayedexpansion
    TITLE Command Prompt
    cd ..
    exit /B 0
    
