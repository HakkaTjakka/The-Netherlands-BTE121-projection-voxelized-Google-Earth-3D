@ECHO OFF
setlocal EnableDelayedExpansion

:AGAIN

robocopy f:\saves\test\region\done0 f:\saves\Test.copy\region /MIR

if exist files2.txt del files2.txt
dir F:\SAVES\TEST.COPY\REGION\*.mca /b >> files2.txt 2>NUL
echo NO_NEW_FILES > NO_NEW_FILES.TXT

for %%a in (files2.txt) do (
	if not %%~za == 0 (
		for /F "tokens=*" %%A in (files2.txt) do (
			CALL :GET_REGION_X F:\SAVES\TEST.COPY\REGION\%%~nA
			if not exist !REGION_X! MKDIR !REGION_X!
 			if not exist !REGION_X!\%%A (
				echo NEW FILE: %%A - COPYING FROM F:\SAVES\TEST.COPY\REGION TO !REGION_X!/%%A
				copy F:\SAVES\TEST.COPY\REGION\%%A !REGION_X! >NUL
				if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
 			) else (
				FOR %%X IN ("!REGION_X!\%%A") DO (
					set /a date_modified_destination=%%~zX
				)
				FOR %%X IN ("F:\SAVES\TEST.COPY\REGION\%%A") DO (
					set /a date_modified_source=%%~zX
				)
				if not "!date_modified_source!" == "!date_modified_destination!" (
					ECHO NEW SIZE: %%A - COPYING FROM F:\SAVES\TEST.COPY\REGION TO !REGION_X!/%%A  SRC: !date_modified_source! DEST: !date_modified_destination!
					copy F:\SAVES\TEST.COPY\REGION\%%A !REGION_X! >NUL
					if exist NO_NEW_FILES.TXT del NO_NEW_FILES.TXT
				) else (
					REM echo EXISTING: !REGION_X!/%%A
				)
			
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
