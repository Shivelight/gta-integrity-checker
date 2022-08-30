@echo off

set bin="%~dp0bin"

call .\scripts\find_game_dir.cmd

if not exist "%game_dir%\gta_sa.exe" (
	%bin%\cecho.exe {yellow}WARNING!{#} Executable gta_sa.exe is {red}not found{#} in selected directory.{\n}
	choice /M "Export directory anyway?"
	if ERRORLEVEL==2 exit 0
)
pause

%bin%\cecho.exe {\n}{lime}Export Installed Mods List{\n}--------------------------{\n}{#}
echo Export options:
%bin%\cecho.exe ^1. {yellow}Export modloader directory only{#}{\n}
%bin%\cecho.exe ^2. {yellow}Export installation directory (original data + modloader){#}{\n}
%bin%\cecho.exe {aqua}Tips^:{#} Choose ^2 if you don't use modloader or when you need a full report.{#}{\n}
choice /C 12 /M "Choose your export option"


if %ERRORLEVEL%==2 (
	set root_dir_path=%game_dir%
	set page_title=Snapshot of Installation Directory (Original Data + modloader^)
	goto SNAP
)

if %ERRORLEVEL%==1 (
	set root_dir_path=%game_dir%\modloader
	set page_title=Snapshot of modloader Directory
	goto SNAP
)

:SNAP
%bin%\snap2html\Snap2HTML.exe -silent -path:"%root_dir_path%" -outfile:"%game_dir%\Installed-Mods.html" -title:"%page_title%"
%bin%\cecho.exe {white}Export finished.{#}{\n}HTML page is stored in {teal}%game_dir%\Installed-Mods.html{#}{\n}
choice /C NY /M "Press Y to open the page, N to close this window."
if %ERRORLEVEL%==2 start "" "%game_dir%\Installed-Mods.html"

