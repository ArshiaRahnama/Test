@echo off
REM ============================================================
REM  Apex Clothing Studio - convert your .ydd clothes to .glb
REM  for the studio's 3D viewer.
REM
REM  Needs: Node.js. Nothing else - the .ydd/.ytd are read right
REM  here (tools\rage.js): no internet, no account, no quota,
REM  NO Blender, NO Sollumz, NO CodeWalker.
REM
REM  Put your .ydd (+ its .ytd) under ..\templates\male\ or
REM  ..\templates\female\, or list any other folder in
REM  sources.txt, then double-click this file.
REM
REM  THIS RUNS ON YOUR PC. If your game server is somewhere else
REM  (a VPS, or shared hosting like RocketNode/ZAP/FiveM Hosting)
REM  that is normal and supported. Read what this prints at the
REM  end: it names the two things you upload afterwards.
REM ============================================================

cd /d "%~dp0"

if exist "%~dp0ensure_node.bat" if exist "%~dp0convert.js" goto :apex_ok

REM ============================================================
REM  A file this launcher needs is not next to it. Work out WHY
REM  before saying anything: it is almost always that the .bat
REM  was opened on the remote side of an FTP client, which
REM  copies only the file you clicked.
REM ============================================================
set "APEX_MISSING="
if not exist "%~dp0ensure_node.bat" if not defined APEX_MISSING set "APEX_MISSING=ensure_node.bat"
if not exist "%~dp0convert.js" if not defined APEX_MISSING set "APEX_MISSING=convert.js"
set "APEX_WHY=unknown"
echo "%~dp0" | findstr /i /c:"\AppData\Local\Temp\" >nul
if not errorlevel 1 set "APEX_WHY=temp"
echo "%~dp0" | findstr /i /c:"\Temp\scp" >nul
if not errorlevel 1 set "APEX_WHY=winscp"
echo "%~dp0" | findstr /i /c:"fz3temp" >nul
if not errorlevel 1 set "APEX_WHY=filezilla"
echo "%~dp0" | findstr /i /c:"Rar$" >nul
if not errorlevel 1 set "APEX_WHY=archive"
echo "%~dp0" | findstr /i /c:"\Temp\7z" >nul
if not errorlevel 1 set "APEX_WHY=archive"

echo.
if "%APEX_WHY%"=="winscp"    echo  [STOP]  You opened this from inside WinSCP.
if "%APEX_WHY%"=="filezilla" echo  [STOP]  You opened this from inside FileZilla.
if "%APEX_WHY%"=="archive"   echo  [STOP]  You opened this from inside the .zip.
if "%APEX_WHY%"=="temp"      echo  [STOP]  You opened this from a temporary folder.
if "%APEX_WHY%"=="unknown"   echo  [STOP]  %APEX_MISSING% is missing next to this file.
echo.
echo  It ran from:
echo    %~dp0
echo.
if not "%APEX_WHY%"=="unknown" echo  Opening a file on the remote side of an FTP program downloads only
if not "%APEX_WHY%"=="unknown" echo  THAT ONE FILE into a temporary folder and runs it there, so
if not "%APEX_WHY%"=="unknown" echo  %APEX_MISSING% was never downloaded next to it.
if not "%APEX_WHY%"=="unknown" echo.
if not "%APEX_WHY%"=="unknown" echo  This tool is meant to run on YOUR PC, not on the server. That is
if not "%APEX_WHY%"=="unknown" echo  normal and supported: you convert here, then upload the result.
if not "%APEX_WHY%"=="unknown" echo.
:apex_nocopy
echo.
echo  WHAT TO DO
echo  ----------
echo   1. In WinSCP/FileZilla, find the apex_clothing folder on your server.
echo   2. Drag the WHOLE folder to your Desktop (not just this file).
echo   3. Open the copy on your Desktop, go into tools, and
echo      double-click convert.bat there.
echo   4. When it finishes, upload what it tells you back to the server.
echo.
echo  See tools\README.md for the full step by step with pictures of
echo  what the output should look like.
echo.
pause
exit /b 1

:apex_ok

REM Finds Node.js on PATH, in the usual install folders, or as a
REM portable copy - and offers to fetch one if there is none.
REM ("where node" alone fails on the very common case of Node
REM being installed but not on PATH.)
call "%~dp0ensure_node.bat"
if errorlevel 1 (
    echo.
    pause
    exit /b 1
)

"%NODE_EXE%" convert.js %*

echo.
pause
