@echo off
setlocal EnableDelayedExpansion

set bin="%~dp0bin"
set checksums="%~dp0checksums"
set download_dir=%~dp0downloaded_original_files
cd %download_dir%

%bin%\cecho.exe {lime}xxHash Logs{\n}-----------{\n}{#}
%bin%\cecho.exe Verifying integrity of downloaded game files in {teal}%download_dir%{#}{\n}
%bin%\xxhsum.exe --check %checksums%\xxh32_gta_sa_1_0_checksums.txt | findstr /C:": FAILED"
%bin%\cecho.exe {white}Integrity verification finished.{#}{\n}
pause
