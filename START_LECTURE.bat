@echo off
title Immersive Lecture - local server
cd /d "%~dp0"

set "PORT=8777"
set "URL=http://localhost:%PORT%/index.html"

echo ============================================================
echo   Immersive Lecture - starting local server
echo ============================================================
echo.

if not exist "index.html" (
  echo [X] index.html not found next to this .bat file.
  echo     Put START_LECTURE.bat in the same folder as index.html.
  echo.
  pause
  exit /b 1
)

REM ---- pick a runtime: py -3, python, then node -------------------------
set "RUN="
py -3 --version >nul 2>&1 && set "RUN=py -3 -m http.server %PORT% --bind 127.0.0.1"
if not defined RUN python --version >nul 2>&1 && set "RUN=python -m http.server %PORT% --bind 127.0.0.1"
if not defined RUN if exist "server.js" node --version >nul 2>&1 && set "RUN=node server.js %PORT%"

if not defined RUN (
  echo [X] Python and Node.js were both not found.
  echo.
  echo     Install one of these, then run this file again:
  echo       Python  ^-^-^>  https://www.python.org/downloads/
  echo       Node.js ^-^-^>  https://nodejs.org/
  echo.
  echo     During Python setup, tick "Add python.exe to PATH".
  echo.
  pause
  exit /b 1
)

REM ---- find Chrome (best support for Speech Recognition) ---------------
set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"

echo   Server : %RUN%
echo   Address: %URL%
if defined CHROME (echo   Browser: Chrome) else (echo   Browser: system default)
echo.
echo   Opening the browser in a moment...
echo.
echo   HOW TO USE THE MICROPHONE
echo     1. Go to slide 39 (Speech to Text)
echo     2. Click the pink button "Open microphone"
echo     3. Chrome asks for permission - click Allow
echo     4. Pick your mic in the dropdown next to it, then speak
echo.
echo   KEEP THIS WINDOW OPEN while presenting.
echo   Closing this window stops the server.
echo ============================================================
echo.

REM ---- open the browser a moment after the server comes up -------------
if defined CHROME (
  start "" cmd /c "timeout /t 2 /nobreak >nul & start "" "%CHROME%" --new-window "%URL%""
) else (
  start "" cmd /c "timeout /t 2 /nobreak >nul & start "" "%URL%""
)

REM ---- run the server in this window (Ctrl+C or close = stop) ---------
%RUN%

echo.
echo Server stopped.
pause
