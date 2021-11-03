@ECHO OFF

setlocal EnableExtensions EnableDelayedExpansion

IF NOT EXIST TILES MKDIR TILES

SET /A COUNT=0
for /F "tokens=*" %%A in (HOLLAND_TILES.LST) do (
	SET /A COUNT=!COUNT! + 1
	IF EXIST E:\PACMAN\CUT\%%A (
		COPY E:\PACMAN\CUT\%%A TILES> NUL
		ECHO !COUNT! E:\PACMAN\CUT\%%A
	)
)

PAUSE