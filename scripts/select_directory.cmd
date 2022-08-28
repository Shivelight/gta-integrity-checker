@if (@a==@b) @end /*

:: fchooser2.bat
:: batch portion

@echo off

for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
    set selected_directory=%%I
)

goto :EOF

:: JScript portion */

var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, "Please choose your GTA San Andreas installation directory.", 0, 0x00);
WSH.Echo(folder ? folder.self.path : '');
