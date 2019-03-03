@echo off

rem This batchfile starts a command prompt with the TeX Live
rem Windows binary directory as first path component.

rem Public domain

@echo off
setlocal enableextensions

rem Add bin dir to beginning of PATH only if it is not already there
for /f "tokens=1,2 delims=;" %%I in ("%~dp0..\..\bin\win32;%PATH%") do if not "%%~fI"=="%%~fJ" set "PATH=%%~fI;%PATH%"

rem Start new console
start "TeX Live" "%COMSPEC%"
