@ECHO OFF
setlocal EnableDelayedExpansion

:AGAIN

for /f "tokens=*" %%G in (date_mark.txt) do (
	set date_mark2=%%G
)

for /f "tokens=1" %%G in ('time /t') do (
	set time=%%G
)
for /f "tokens=2" %%G in ('date /t') do (
	set date=%%G
)
echo !date! !time!
rem set date_mark=21-07-2021 22:00

set YEAR=!date:~6,4!
set MONTH=!date:~0,2!
set DAY=!date:~3,2!
set HOUR=!time:~0,2!
set MINUTE=!time:~3,2!


rem echo !date_mark! TO: !YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!
set date_mark=!YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!

ECHO !date_mark!>date_mark.txt
ECHO !date_mark2!  to  !date_mark!

rem pause
rem exit /b

for /f "tokens=*" %%G in ('dir /b /a:d ".\*"') do (
	if exist files3.txt del files3.txt
	dir %%G\*.* /b >> files3.txt 2>NUL
	for %%A in (files3.txt) do (
		if not %%~za == 0 (
			for /F "tokens=*" %%A in (files3.txt) do (
				for %%P in ("%%G\%%A") do (
					REM ECHO HOP %%~nP %%~fP
					set date_modified=%%~tP
					set YEAR=!date_modified:~6,4!
					set MONTH=!date_modified:~0,2!
					set DAY=!date_modified:~3,2!
					set T=!date_modified:~11,5!
					set HOUR=!date_modified:~11,2!
					set MINUTE=!date_modified:~14,2!
				)

				set date_modified=!YEAR!-!MONTH!-!DAY! !HOUR!:!MINUTE!

				IF  "!date_modified!" GTR "!date_mark2!" (
					echo YES "!date_modified!" GTR "!date_mark2!"
 					if exist "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G\%%A" (
 						FOR %%X IN ("Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G\%%A") DO (
 							set /a date_modified_destination=%%~zX
 						)
 						FOR %%X IN ("%%G\%%A") DO (
 							set /a date_modified_source=%%~zX 
 						)
 						if not "!date_modified_source!" == "!date_modified_destination!" (
 							ECHO Test.copy\region\%%G\%%A on Google Drive Does exist.
 							ECHO.   Filesize changed - deleting destination file on Google Drive: Test.copy\region\%%G\%%A
 							del "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G\%%A" /Q
 							ECHO.   SOURCE:      !date_modified_source!
 							ECHO.   DESTINATION: !date_modified_destination!
 						) else (
 							ECHO Test.copy\region\%%G\%%A on Google Drive Does exist.
 						)
 					) else (
 						ECHO Test.copy\region\%%G\%%A on Google Drive Does NOT exist.
 					)
					if not exist "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G\%%A" (
						IF NOT EXIST "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G" (
							MKDIR "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G"
						)
						copy "%%G\%%A" "Z:\MAZINGWORLD\The Netherlands. Minecraft 1.12.2 format. (Concrete 16 colors only) Build The Earth 1 to 1 projection\Test.copy\region\%%G\%%A"
					) else (
						ECHO Test.copy\region\%%G\%%A on Google Drive Does exist.
					)
				) ELSE (
					echo NOT "!date_modified!" GTR "!date_mark2!"
				)
			)
		)
	)
)

:WAIT_FOR_FILES

if exist NO_NEW_FILES3.TXT (
	del NO_NEW_FILES3.TXT >NUL
	echo No new files waiting....
	TIMEOUT 1200
)

rem CALL COPY_FROM_F_SAVES_TEST.COPY_REGION.BAT

if exist NO_NEW_FILES3.TXT (
	CALL :WAIT_FOR_FILES
)

TIMEOUT 1800

GOTO :AGAIN

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
