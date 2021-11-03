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
				REM ECHO "\utrecht-demo3\Test.copy\%%G\%%A"
				REM PAUSE
				if exist "\utrecht-demo3\Test.copy\%%G\%%A" ( rem check if date changed....
					FOR %%X IN ("\utrecht-demo3\Test.copy\%%G\%%A") DO (
						set /a date_modified_destination=%%~zX
					)
					FOR %%X IN ("%%G\%%A") DO (
						set /a date_modified_source=%%~zX 
					)
					if not "!date_modified_source!" == "!date_modified_destination!" (
						ECHO \utrecht-demo3\Test.copy\%%G\%%A Does exist.
						ECHO.   Filesize changed - deleting destination file \utrecht-demo3\Test.copy\%%G\%%A
						del "\utrecht-demo3\Test.copy\%%G\%%A" /Q
						ECHO.   SOURCE:      !date_modified_source!
						ECHO.   DESTINATION: !date_modified_destination!
					) else (
						ECHO \utrecht-demo3\Test.copy\%%G\%%A Does exist.
					)
				) else (
					ECHO \utrecht-demo3\Test.copy\%%G\%%A Does not exist.
				)
 				if not exist "\utrecht-demo3\Test.copy\%%G\%%A" (
 					echo DOING: %%G\%%A
 					IF NOT EXIST "\utrecht-demo3\Test.copy\%%G" MKDIR "\utrecht-demo3\Test.copy\%%G" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					copy %%G\%%A "\utrecht-demo3\Test.copy\%%G" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					cd "\utrecht-demo3"
 					IF ERRORLEVEL 1 GOTO :EOF
 
 					git add "/utrecht-demo3/Test.copy/%%G/%%A" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					git commit -m 'New' "/utrecht-demo3/Test.copy/%%G/%%A" > "\sample-utrecht-from\output.msg" 2> "\sample-utrecht-from\output.err"
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					git push
 					IF ERRORLEVEL 1 GOTO :EOF
 					CALL :LOGGER
 
 					cd "\sample-utrecht-from"
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
	TIMEOUT 600
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
	IF EXIST "\DENHAAG_BTE_GIT\FROM\OUTPUT.ERR" (
		TIME /T >> "\sample-utrecht-from\PUSH.LOG"
		TIME /T
	)
)

IF EXIST "\sample-utrecht-from\OUTPUT.MSG" (
	TYPE "\sample-utrecht-from\OUTPUT.MSG"
	TYPE "\sample-utrecht-from\OUTPUT.MSG" >> \DENHAAG_BTE_GIT\FROM\PUSH.LOG
	DEL  "\sample-utrecht-from\OUTPUT.MSG"
)
IF EXIST "\sample-utrecht-from\OUTPUT.ERR" (
	TYPE "\sample-utrecht-from\OUTPUT.ERR"
	TYPE "\sample-utrecht-from\OUTPUT.ERR" >> \DENHAAG_BTE_GIT\FROM\PUSH.LOG
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