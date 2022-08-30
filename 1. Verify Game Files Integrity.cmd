@echo off
set owd="%~dp0"
set bin="%~dp0bin"
set checksums="%~dp0checksums"

call .\scripts\bitness.cmd
call .\scripts\find_game_dir.cmd

if not exist "%game_dir%\gta_sa.exe" (
	%bin%\cecho.exe {yellow}WARNING!{#} Executable gta_sa.exe is {red}not found{#} in selected directory.{\n}
	choice /M "Try to verify file integrity anyway?"
	if ERRORLEVEL==2 exit 0
)

if not "%1"=="NOPAUSE" pause

cd /D %game_dir%

:HASHCHECK
set "integrity_report=%game_dir%\integrity_report.txt"
%bin%\cecho.exe {\n}{lime}xxHash Logs{\n}-----------{\n}{#}
echo OS is %OS_BIT%
%bin%\cecho.exe Verifying integrity of game files in {teal}%game_dir%{#}{\n}

if %OS_BIT% == 32BIT (
	%bin%\xxhsum.exe --check %checksums%\xxh32_gta_sa_1_0_checksums.txt | findstr /V /C:": OK" | %bin%\tee.exe "%integrity_report%"
) else (
	%bin%\xxhsum_x64.exe --check %checksums%\xxh3_gta_sa_1_0_checksums.txt | findstr /V /C:": OK" | %bin%\tee.exe "%integrity_report%"
)

cd /D %owd%

%bin%\cecho.exe {white}Integrity verification finished.{#}{\n}Report is stored in {teal}%game_dir%\integrity_report.txt{#}{\n}

if not "%1"=="NOPAUSE" pause
