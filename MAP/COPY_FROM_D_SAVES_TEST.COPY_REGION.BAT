@ECHO OFF
setlocal EnableDelayedExpansion

:AGAIN

rem robocopy d:\saves\test\region\done0 d:\saves\Test.copy\region /MIR
rem echo robocopy ready, make list of D:\SAVES\TEST.COPY\REGION\*.mca

if exist files2.txt del files2.txt
dir D:\SAVES\TEST\REGION\done0\*.mca /b >> files2.txt 2>NUL
echo NO_NEW_FILES > NO_NEW_FILES.TXT
echo NO_NEW_FILES3 > NO_NEW_FILES3.TXT

for %%a in (files2.txt) do (
	if not %%~za == 0 (
		for /F "tokens=*" %%A in (files2.txt) do (
			CALL :GET_REGION_X D:\SAVES\TEST\REGION\done0\%%~nA
			
			if not exist !REGION_X! MKDIR !REGION_X!
 			if not exist !REGION_X!\%%A (
				echo NEW FILE: %%A - COPYING FROM D:\SAVES\TEST\REGION\done0 TO !REGION_X!/%%A
				copy D:\SAVES\TEST\REGION\done0\%%A !REGION_X!>NUL
				if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
				if exist NO_NEW_FILES3.TXT del NO_NEW_FILES3.TXT
 			) else (
				FOR %%X IN ("!REGION_X!\%%A") DO (
					set /a date_modified_destination=%%~zX
				)
				FOR %%X IN ("D:\SAVES\TEST\REGION\done0\%%A") DO (
					set /a date_modified_source=%%~zX
				)
				if not "!date_modified_source!" == "!date_modified_destination!" (
					ECHO NEW SIZE: %%A - COPYING FROM D:\SAVES\TEST\REGION\done0 TO !REGION_X!/%%A  SRC: !date_modified_source! DEST: !date_modified_destination!
					copy D:\SAVES\TEST\REGION\done0\%%A !REGION_X!>NUL
					if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
					if exist NO_NEW_FILES3.TXT del NO_NEW_FILES3.TXT
				) else (
					echo EXISTING: !REGION_X!/%%A
				)
			)
			if exist F:\CUT\%%~nA.png (
				set REGION_X=!REGION_X!.png
				if not exist !REGION_X! MKDIR !REGION_X!
				if not exist !REGION_X!\%%~nA.png (
					echo NEW FILE: %%~nA.png - COPYING FROM F:\CUT TO !REGION_X!/%%~nA.png
					REM ECHO copy F:\CUT\%%~nA.png !REGION_X! REM
					copy F:\CUT\%%~nA.png !REGION_X! >NUL
					if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
					if exist NO_NEW_FILES3.TXT del NO_NEW_FILES3.TXT
				) else (
					FOR %%X IN ("!REGION_X!\%%~nA.png") DO (
						set /a date_modified_destination=%%~zX
					)
					FOR %%X IN ("F:\CUT\%%~nA.png") DO (
						set /a date_modified_source=%%~zX
					)
					if not "!date_modified_source!" == "!date_modified_destination!" (
						ECHO NEW SIZE: %%~nA.png - COPYING FROM F:\CUT TO !REGION_X!/%%~nA.png  SRC: !date_modified_source! DEST: !date_modified_destination!
						copy F:\CUT\%%~nA.png !REGION_X!>NUL
						if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
						if exist NO_NEW_FILES3.TXT del NO_NEW_FILES3.TXT
					) else (
						REM echo EXISTING: !REGION_X!/%%A
					)
				)
			) else (
				echo ERR: F:\CUT\%%~nA.png DOES NOT EXIST!!!
			)
		)
	)
)

TIMEOUT 5
exit /b

GOTO :AGAIN

:GET_REGION_X
	set NAME=%~n1
	set REGION_X=!NAME:~2,17!
	REM echo !REGION_X!
	exit /b
