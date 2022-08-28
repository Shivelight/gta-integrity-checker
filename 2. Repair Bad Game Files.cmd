@echo off
setlocal EnableDelayedExpansion


rem ===========================================================================

set _available_host[1]=https://ilypetals.net/upload/gtasa/files
set _available_host[2]=https://archive.org/download/gta-sa-data

rem You may change the download directory here.
set download_dir=%~dp0downloaded_original_files

rem ===========================================================================


set bin="%~dp0bin"

%bin%\cecho.exe {lime}Repair Settings{\n}---------------{#}{\n}
echo Available hosts:
%bin%\cecho.exe ^1. {yellow}ilypetals.net{#}{\n}
%bin%\cecho.exe ^2. {yellow}archive.org{#}{\n}
choice /C 12 /M "Choose your preferred download host."
set gta_file_host=!_available_host[%ERRORLEVEL%]!
%bin%\cecho.exe Preferred game files host: {yellow}%gta_file_host%{#}{\n}
%bin%\cecho.exe Download directory: {teal}%download_dir%{#}{\n}{\n}

call ".\1. Verify Game Files Integrity.cmd" NOPAUSE

%bin%\cecho.exe {\n}{lime}Repair Confirmation{\n}-------------------{#}{\n}
%bin%\cecho.exe Using integrity report from {teal}%integrity_report%{#}{\n}
choice /C YN /M "Press Y to continue downloading game files, N to cancel."
if ERRORLEVEL==2 exit 0

set /A file_count=0
rem For testing use `.\scripts\test_failed_hash.cmd`
rem usebackq incase there is a space in the path.
for /F "usebackq tokens=*" %%a in ("%integrity_report%") do (
	set "file=%%a"
	if not "!file:: FAILED=!"=="!file!" (
		set file_path=!file:: FAILED=!
		!bin!\cecho.exe Downloading {aqua}!file_path:~2!{#}{\n}
		set file_path=!file_path:~1!
	    !bin!\curl.exe --location --progress-bar --create-dirs -o "!download_dir!!file_path!" "!gta_file_host!!file_path!"
	    set /A file_count=!file_count! + 1
	)
)
if not %file_count%==0 (
	echo Total download: %file_count% file^(s^).
	%bin%\cecho.exe {\n}Downloaded files are stored in {teal}%download_dir%{#}{\n}
	echo You need to manually copy the files to your GTA San Andreas installation folder.
) else (
	%bin%\cecho.exe {green}No bad game file found in the integrity report.{#}{\n}
)

if not "%1"=="NOPAUSE" pause
