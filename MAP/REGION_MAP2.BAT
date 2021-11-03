@echo off
setlocal EnableDelayedExpansion

if not exist DOAGAIN mkdir DOAGAIN

if exist OBJECT_ARRAY.TXT del OBJECT_ARRAY.TXT

set date_mark=21-07-2021 22:00
set YEAR=!date_mark:~6,4!
set MONTH=!date_mark:~3,2!
set DAY=!date_mark:~0,2!
set HOUR=!date_mark:~11,2!
set MINUTE=!date_mark:~14,2!
SET /A TODO=0
SET /A FIXED=0
echo !date_mark! TO: !YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!
set date_mark2=!YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!
IF "2021-07-19 22:00" GTR "!date_mark2!" (
	echo "2021-07-19 22:00" GTR "!date_mark2!" SMALLER
) else (
	echo "2021-07-19 22:00" GTR "!date_mark2!" NOT SMALLER
)
IF "2021-07-22 22:00" GTR "!date_mark2!" (
	echo "2021-07-22 22:00" GTR "!date_mark2!" SMALLER
) else (
	echo "2021-07-22 22:00" GTR "!date_mark2!" NOT SMALLER
)


set /A number_x = 6240
echo|set /p="!number_x! "
echo -                                                                                                       1         1         1
echo|set /p="!number_x! "
echo -             1         2         3         4         5         6         7         8         9         0         1         2
echo|set /p="!number_x! "
echo -   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

:DOE_MAAR

SET /A TODO=0
SET /A FIXED=0

set /A number_y = -10500

:X_IS_0

echo|set /p="!number_y!   "

set /A number_x = 6240

:NEXT_X

set filename=r.!number_x!.!number_y!

if exist !filename!.mca (
	echo|set /p="1"
) else (
	if exist E:\SAVES\TEST\REGION\DONE0\!filename!.mca (
		echo|set /p="*"
		SET /A FIXED=!FIXED! + 1
	) else (
		if exist f:\cut\!filename!.vox (
			FOR %%X IN ("f:/cut/!filename!.vox") DO (
				set date_modified=%%~tX
				set YEAR=!date_modified:~6,4!
				set MONTH=!date_modified:~3,2!
				set DAY=!date_modified:~0,2!
				set T=!date_modified:~11,5!
				set HOUR=!date_modified:~11,2!
				set MINUTE=!date_modified:~14,2!
				REM echo !date_modified! TO: !YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!
				
				set date_modified2=!YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!
				rem echo !date_modified!
			)
			
			IF "!date_mark2!" GTR "!date_modified2!" (
				echo|set /p="E"
				SET /A TODO=!TODO! + 1
				if not exist DOAGAIN\!filename!.info copy f:\cut\!filename!.* DOAGAIN>NUL

				for /f "tokens=*" %%R in (DOAGAIN\!filename!.info) do (
					REM echo %%R
					for /f "tokens=2,3 delims==[]" %%a in ("%%R") do (
						set "l=%%a"
						set var_x=!l: =!
						set "l=%%b"
						set "var_y=!l: =!
						ECHO X=!var_x! Y=!var_y!>> OBJECT_ARRAY.TXT
						REM ECHO X=!var_x! Y=!var_y! OCTANT=%1
					)
				)

			) else (
				echo|set /p="Q"
			)
		) else (
			if exist f:\cut\done\!filename!.vox (
				echo|set /p="e"
				SET /A TODO=!TODO! + 1

				if not exist DOAGAIN\!filename!.info  copy f:\cut\done\!filename!.* DOAGAIN>NUL
				for /f "tokens=*" %%R in (DOAGAIN\!filename!.info) do (
					REM echo %%R
					for /f "tokens=2,3 delims==[]" %%a in ("%%R") do (
						set "l=%%a"
						set var_x=!l: =!
						set "l=%%b"
						set "var_y=!l: =!
						ECHO X=!var_x! Y=!var_y!>> OBJECT_ARRAY.TXT
						REM ECHO X=!var_x! Y=!var_y! OCTANT=%1
					)
				)
				
			) else (
				echo|set /p="0"
			)
		)
	)
)

set /a number_x = !number_x! + 1

if !number_x! GTR 6371 (
	set /a number_y = !number_y! + 1
	if !number_y! equ -10380 goto END
	SET /A TOTAL=!TODO! + !FIXED!
	SET /A PERCENT=100 * !FIXED!
	IF NOT !TOTAL! EQU 0 (
		SET /A PERCENT=!PERCENT! / !TOTAL!
	)
	ECHO  TODO=!TODO! FIXED=!FIXED! TOTAL=!TOTAL! PCT: !PERCENT!
	REM echo .
	goto X_IS_0
)

goto NEXT_X
:END
echo .

SET /A TOTAL=!TODO! + !FIXED!
ECHO TODO=!TODO! FIXED=!FIXED!  TOTAL=!TOTAL!


timeout 30
goto :DOE_MAAR

rem FOR %%? IN ("C:\somefile\path\file.txt") DO (
rem     ECHO File Name Only       : %%~n?
rem     ECHO File Extension       : %%~x?
rem     ECHO Name in 8.3 notation : %%~sn?
rem     ECHO File Attributes      : %%~a?
rem     ECHO Located on Drive     : %%~d?
rem     ECHO File Size            : %%~z?
rem     ECHO Last-Modified Date   : %%~t?
rem     ECHO Drive and Path       : %%~dp?
rem     ECHO Drive                : %%~d?
rem     ECHO Fully Qualified Path : %%~f?
rem     ECHO FQP in 8.3 notation  : %%~sf?
rem     ECHO Location in the PATH : %%~dp$PATH:?
rem )

for %%X in (F:\PACMAN\EARTH\NEW_OCTANT.TXT) do (
	REM echo %%X
	if not %%~zX == 0 (
		for /f "tokens=*" %%R in (%%X) do (
			REM echo %%R
			for /f "tokens=2,3 delims==[]" %%a in ("%%R") do (
				set "l=%%a"
				set var_x=!l: =!
				set "l=%%b"
				set "var_y=!l: =!
				ECHO X=!var_x! Y=!var_y!>> F:\PACMAN\EARTH\OBJECT_ARRAY.TXT
				ECHO X=!var_x! Y=!var_y! OCTANT=%1
			)
		)
	)
)
