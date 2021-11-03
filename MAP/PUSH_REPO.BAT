@ECHO OFF
setlocal EnableDelayedExpansion

:AGAIN

for /f "tokens=*" %%G in ('dir /b /a:d ".\*"') do (
	if exist files.txt del files.txt
	dir %%G\*.* /b >> files.txt 2>NUL
	for %%A in (files.txt) do (
		if not %%~za == 0 (
			for /F "tokens=*" %%A in (files.txt) do (
				REM echo TESTING: %%G\%%A
				REM ECHO "\sample-utrecht\Test.copy\%%G\%%A"
				REM PAUSE
				if exist "\sample-utrecht\Test.copy\%%G\%%A" ( rem check if date changed.... (size...) )
					FOR %%X IN ("\sample-utrecht\Test.copy\%%G\%%A") DO (
						set /a date_modified_destination=%%~zX
					)
					FOR %%X IN ("%%G\%%A") DO (
						set /a date_modified_source=%%~zX 
					)
					if not "!date_modified_source!" == "!date_modified_destination!" (
						ECHO \sample-utrecht\Test.copy\%%G\%%A Does exist.
						ECHO.   Filesize changed - deleting destination file \sample-utrecht\Test.copy\%%G\%%A
						del "\sample-utrecht\Test.copy\%%G\%%A" /Q
						ECHO.   SOURCE:      !date_modified_source!
						ECHO.   DESTINATION: !date_modified_destination!
					) else (
						ECHO \sample-utrecht\Test.copy\%%G\%%A Does exist.
					)
				) else (
					ECHO \sample-utrecht\Test.copy\%%G\%%A Does not exist.
					
					
				)
				
				
 				if not exist "\sample-utrecht\Test.copy\%%G\%%A" (
 					echo DOING: %%G\%%A
 					IF NOT EXIST "\sample-utrecht\Test.copy\%%G" MKDIR "\sample-utrecht\Test.copy\%%G" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 ECHO error on mkdir >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					ECHO BEFORE COPY >> "\sample-utrecht-from\last.log"
 					copy %%G\%%A "\sample-utrecht\Test.copy\%%G" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 ECHO error on copy >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					cd "\sample-utrecht"
 					IF ERRORLEVEL 1 ECHO error on cd >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 
 					ECHO BEFORE GIT ADD>> "\sample-utrecht-from\last.log"
 					git add "/sample-utrecht/Test.copy/%%G/%%A" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 ECHO error on git add >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					ECHO BEFORE COMMIT >> "\sample-utrecht-from\last.log"
 					git commit -m 'New' "/sample-utrecht/Test.copy/%%G/%%A" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 ECHO error on git commit >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					ECHO BEFORE PUSH >> "\sample-utrecht-from\last.log"
 					git push
 					IF ERRORLEVEL 1 ECHO error on git push >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 (
						ECHO error on git push, git fetch + git push
						TIMEOUT 3
						ECHO BEFORE PUSH AGAIN 1 >> "\sample-utrecht-from\last.log"
						git fetch
						git push
						IF ERRORLEVEL 1 ECHO error on git push again 1>> "\sample-utrecht-from\last.log"
						IF ERRORLEVEL 1 (
							ECHO error on git push again 1
							TIMEOUT 3
							ECHO BEFORE PUSH AGAIN 2 >> "\sample-utrecht-from\last.log"
							git push
							IF ERRORLEVEL 1 ECHO error on git push again 2>> "\sample-utrecht-from\last.log"
						)
					)
					IF ERRORLEVEL 1 (
						ECHO error on git push
					)
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					cd "\sample-utrecht-from"
 					IF ERRORLEVEL 1 ECHO error on cd back >> "\sample-utrecht-from\last.log"
 					IF ERRORLEVEL 1 GOTO :EOF
 					TIMEOUT 1
 					rem CLS
 				) else (
 					rem echo EXISTS: %%G\%%A
 				)
			)
		)
	)
)

:WAIT_FOR_FILES

if exist NO_NEW_FILES.TXT (
	del NO_NEW_FILES.TXT >NUL
	echo No new files waiting....
	TIMEOUT 1200
)

CALL COPY_FROM_D_SAVES_TEST.COPY_REGION.BAT

if exist NO_NEW_FILES.TXT (
	CALL :WAIT_FOR_FILES
)

TIMEOUT 1200


GOTO :AGAIN

:EOF
CALL :LOGGER
ECHO ERROR
ECHO ERROR > PUSH.LOG
PAUSE
exit /b

:LOGGER
IF EXIST "\sample-utrecht-from\OUTPUT.MSG" (
	TIME /T >> "\sample-utrecht-from\PUSH.LOG"
	TIME /T
) ELSE (
	IF EXIST "\sample-utrecht-from\OUTPUT.ERR" (
		TIME /T >> "\sample-utrecht-from\PUSH.LOG"
		TIME /T
	)
)

IF EXIST "\sample-utrecht-from\OUTPUT.MSG" (
	TYPE "\sample-utrecht-from\OUTPUT.MSG"
	TYPE "\sample-utrecht-from\OUTPUT.MSG" >> \sample-utrecht-from\PUSH.LOG
	IF EXIST DEL  "\sample-utrecht-from\OUTPUT.MSG"
)
IF EXIST "\sample-utrecht-from\OUTPUT.ERR" (
	TYPE "\sample-utrecht-from\OUTPUT.ERR"
	TYPE "\sample-utrecht-from\OUTPUT.ERR" >> \sample-utrecht-from\PUSH.LOG
	DEL  "\sample-utrecht-from\OUTPUT.ERR"
)

EXIT /B

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