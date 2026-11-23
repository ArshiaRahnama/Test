@echo off
REM ============================================================
REM  Apex Clothing Studio - Node.js locator
REM  Shared by convert.bat and make_ytd.bat. Sets NODE_EXE.
REM
REM  Order:  PATH  ->  normal install folders (installed but not
REM  on PATH)  ->  portable copy in %LOCALAPPDATA%\ApexScriptz
REM  ->  ask whether to download that portable copy.
REM
REM  Returns 0 with NODE_EXE set, or 1 if there is no Node.js.
REM  Set APEX_AUTO_NODE=1 to skip the question (unattended).
REM ============================================================

set "NODE_EXE="

REM --- 1) on PATH ---------------------------------------------------------
for /f "delims=" %%I in ('where node 2^>nul') do if not defined NODE_EXE set "NODE_EXE=%%I"
if defined NODE_EXE goto :verify

REM --- 2) installed, but not on PATH (very common) ------------------------
if exist "%ProgramFiles%\nodejs\node.exe" set "NODE_EXE=%ProgramFiles%\nodejs\node.exe"
if not defined NODE_EXE if exist "%ProgramW6432%\nodejs\node.exe" set "NODE_EXE=%ProgramW6432%\nodejs\node.exe"
if not defined NODE_EXE if exist "%ProgramFiles(x86)%\nodejs\node.exe" set "NODE_EXE=%ProgramFiles(x86)%\nodejs\node.exe"
if not defined NODE_EXE if exist "%LOCALAPPDATA%\Programs\nodejs\node.exe" set "NODE_EXE=%LOCALAPPDATA%\Programs\nodejs\node.exe"

REM --- 3) portable copy fetched earlier by this script --------------------
if not defined NODE_EXE if exist "%LOCALAPPDATA%\ApexScriptz\node\node.exe" set "NODE_EXE=%LOCALAPPDATA%\ApexScriptz\node\node.exe"

if not defined NODE_EXE goto :offer

:verify
REM A node.exe that is present but broken counts as missing.
"%NODE_EXE%" -v >nul 2>nul
if errorlevel 1 (
    set "NODE_EXE="
    goto :offer
)
exit /b 0

:offer
echo.
echo  ============================================================
echo   Node.js was not found on this PC.
echo   The converter is a small Node script, so it needs it to run.
echo  ============================================================
echo.
echo   [Y] Download a portable copy now (about 30 MB, one time).
echo       It goes to %LOCALAPPDATA%\ApexScriptz\node
echo       Nothing is installed, no admin rights, no PATH changes -
echo       it is just a folder you can delete later.
echo.
echo   [N] Cancel. You can also install it yourself from
echo       https://nodejs.org (LTS), then run this again.
echo.
if /i "%APEX_AUTO_NODE%"=="1" goto :download
set "ANS="
set /p "ANS=  Download it now? [Y/N] "
if /i "%ANS%"=="Y" goto :download
if /i "%ANS%"=="YES" goto :download
if /i "%ANS%"=="S" goto :download
if /i "%ANS%"=="SIM" goto :download
echo.
echo   Cancelled. Install Node.js from https://nodejs.org and run this again.
exit /b 1

:download
if not exist "%~dp0get_node.ps1" (
    echo.
    echo  [STOP] get_node.ps1 is not next to this file, so Node cannot be
    echo  fetched automatically. Download the whole apex_clothing folder to
    echo  your PC and run tools\\convert.bat from there, or install Node.js
    echo  yourself from https://nodejs.org
    echo.
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_node.ps1"
if errorlevel 1 goto :failed
if exist "%LOCALAPPDATA%\ApexScriptz\node\node.exe" set "NODE_EXE=%LOCALAPPDATA%\ApexScriptz\node\node.exe"
if not defined NODE_EXE goto :failed
exit /b 0

:failed
echo.
echo   Could not set up Node.js automatically (blocked download,
echo   antivirus, or no internet).
echo.
echo   Install it by hand instead - it takes a minute:
echo     1. Open https://nodejs.org and get the LTS installer.
echo     2. Install it with the default options.
echo     3. Close this window and double-click this tool again.
echo.
exit /b 1
