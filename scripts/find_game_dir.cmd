@echo off

rem This script meant to be called by other script!
rem Caller is required to set the bin variable

%bin%\cecho.exe {lime}Select Game Directory{\n}---------------------{#}{\n}
choice /C YSC /M "Press Y to auto select, S to manually select GTA SA directory, C to cancel."

if ERRORLEVEL==3 exit 0
if ERRORLEVEL==2 goto DIRPICK

if exist gta_sa.exe (
	set "game_dir=%cd%"
	goto PRINT_SELECT
)

if exist ..\gta_sa.exe (
	cd ..
	rem Get current directory without setlocal.
	rem Exit the loop immediately because cd is outputting 2 lines.
	for /F "tokens=*" %%i in ('"cd"') do (
		set "game_dir=%%i"
		goto PRINT_SELECT
	)	
)

%bin%\cecho.exe {red}Can't find GTA SA directory, please select manually.{#}{\n}

:DIRPICK
echo Select the game directory from the picker window.
echo Check your taskbar if you can't see the picker window.
%bin%\cecho.exe HINT: The icon has {red}red{#}, {green}green{#}, and {blue}blue{#} colors (Windows Script Host){\n}
call .\scripts\select_directory.cmd
if "%selected_directory%"=="" exit 0
set "game_dir=%selected_directory%"
goto PRINT_SELECT

:PRINT_SELECT
%bin%\cecho.exe Selected game directory: {teal}%game_dir%{#}{\n}
