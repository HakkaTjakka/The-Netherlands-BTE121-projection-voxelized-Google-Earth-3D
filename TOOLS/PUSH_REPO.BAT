@ECHO OFF

:AGAIN

for /f "tokens=*" %%G in ('dir /b /a:d ".\*"') do (
	if exist files.txt del files.txt

	dir PNG_TILES\*.exe /b >> files.txt 2>NUL
	dir PNG_TILES\*.rar /b >> files.txt 2>NUL
	dir REGION\*.exe /b >> files.txt 2>NUL
	dir REGION\*.rar /b >> files.txt 2>NUL
	dir TOOLS\*.* /b >> files.txt 2>NUL
	for %%a in (files.txt) do (
		if not %%~za == 0 (
			for /F "tokens=*" %%A in (files.txt) do (
				echo DOING: %%G\%%A
				IF NOT EXIST \FINAL\The-Netherlands-BTE121-projection-voxelized-Google-Earth-3D\%%G MKDIR \FINAL\The-Netherlands-BTE121-projection-voxelized-Google-Earth-3D\%%G > \FINAL\FROM\output.msg 2> \FINAL\FROM\output.err
				IF ERRORLEVEL 1 GOTO :EOF
				CALL :LOGGER

 				move %%G\%%A \FINAL\The-Netherlands-BTE121-projection-voxelized-Google-Earth-3D\%%G > \FINAL\FROM\output.msg 2> \FINAL\FROM\output.err
				IF ERRORLEVEL 1 GOTO :EOF
				CALL :LOGGER

 				cd \FINAL\The-Netherlands-BTE121-projection-voxelized-Google-Earth-3D
				IF ERRORLEVEL 1 GOTO :EOF

				git add %%G/%%A > \FINAL\FROM\output.msg 2> \FINAL\FROM\output.err
				IF ERRORLEVEL 1 GOTO :EOF
				CALL :LOGGER

 				git commit -m 'New' %%G/%%A > \FINAL\FROM\output.msg 2> \FINAL\FROM\output.err
				IF ERRORLEVEL 1 GOTO :EOF
				CALL :LOGGER

REM  				git push > \FINAL\FROM\output.msg 2> \FINAL\FROM\output.err
REM 				git push 2> \FINAL\FROM\output.err
 				git push
				IF ERRORLEVEL 1 GOTO :EOF
				CALL :LOGGER

				cd \FINAL\FROM
				IF ERRORLEVEL 1 GOTO :EOF
				TIMEOUT 5
				CLS
			)
		)
	)
)

TIMEOUT 8800

GOTO :AGAIN

:EOF
CALL :LOGGER
ECHO ERROR
ECHO ERROR > PUSH.LOG
PAUSE
exit /b

:LOGGER
IF EXIST \FINAL\FROM\OUTPUT.MSG (
	TIME /T >> \FINAL\FROM\PUSH.LOG
	TIME /T
) ELSE (
	IF EXIST \FINAL\FROM\OUTPUT.ERR (
		TIME /T >> \FINAL\FROM\PUSH.LOG
		TIME /T
	)
)

IF EXIST \FINAL\FROM\OUTPUT.MSG (
	TYPE \FINAL\FROM\OUTPUT.MSG
	TYPE \FINAL\FROM\OUTPUT.MSG >> \FINAL\FROM\PUSH.LOG
	DEL \FINAL\FROM\OUTPUT.MSG
)
IF EXIST \FINAL\FROM\OUTPUT.ERR (
	TYPE \FINAL\FROM\OUTPUT.ERR
	TYPE \FINAL\FROM\OUTPUT.ERR >> \FINAL\FROM\PUSH.LOG
	DEL \FINAL\FROM\OUTPUT.ERR
)

EXIT /B