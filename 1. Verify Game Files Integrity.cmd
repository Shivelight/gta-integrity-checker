@echo off
set owd="%~dp0"
set bin="%~dp0bin"
set checksums="%~dp0checksums"
rem call .\scripts\bitness.cmd

%bin%\cecho.exe {lime}Select Game Directory{\n}---------------------{#}{\n}
choice /C YSC /M "Press Y to auto select, S to manually select GTA SA directory, C to cancel."

if ERRORLEVEL==3 exit 0
if ERRORLEVEL==2 goto DIRPICK

if exist gta_sa.exe (
	set "game_dir=%cd%"
	goto HASHCHECK
)

if exist ..\gta_sa.exe (
	cd ..
	rem Get current directory without setlocal.
	rem Exit the loop immediately because cd is outputting 2 lines.
	for /F "tokens=*" %%i in ('"cd"') do (
		set "game_dir=%%i"
		goto HASHCHECK
	)	
)

:DIRPICK
echo Select the game directory from the picker window.
echo Check your taskbar if you can't see the picker window.
%bin%\cecho.exe HINT: The icon has {red}red{#}, {green}green{#}, and {blue}blue{#} colors (Windows Script Host){\n}
call .\scripts\select_directory.cmd
set "game_dir=%selected_directory%"
%bin%\cecho.exe Selected game directory: {teal}%game_dir%{#}{\n}
if not exist %game_dir%\gta_sa.exe (
	%bin%\cecho.exe {yellow}WARNING!{#} Executable gta_sa.exe is {red}not found{#} in selected directory.{\n}
	choice /M "Try to verify file integrity anyway?"
	if ERRORLEVEL==2 exit 0
)
if not "%1"=="NOPAUSE" pause

cd /D %game_dir%

:HASHCHECK
set "integrity_report=%game_dir%\integrity_report.txt"
rem echo OS is %OS_BIT%
rem if %OS_BIT% == 32BIT (
rem 	%bin%\xxhsum.exe --check %checksums%\xxh32_gta_sa_1_0_checksums.txt | findstr /V /C:": OK"
rem ) else (
rem 	%bin%\xxhsum_x64.exe --check %checksums%\xxh3_gta_sa_1_0_checksums.txt | findstr /V /C:": OK"
rem )

%bin%\cecho.exe {\n}{lime}xxHash Logs{\n}-----------{\n}{#}
%bin%\cecho.exe Verifying integrity of game files in {teal}%game_dir%{#}{\n}
%bin%\xxhsum.exe --check %checksums%\xxh32_gta_sa_1_0_checksums.txt | findstr /V /C:": OK" | %bin%\tee.exe "%integrity_report%"

cd /D %owd%

%bin%\cecho.exe {white}Integrity verification finished.{#}{\n}Report is stored in {teal}%game_dir%\integrity_report.txt{#}{\n}
if not "%1"=="NOPAUSE" pause
