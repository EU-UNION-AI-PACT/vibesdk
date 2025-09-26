@echo off
REM VibeSDK Windows Launcher
REM Dieses Skript startet die VibeSDK Development-Umgebung

echo ============================================
echo           VibeSDK Development Launcher
echo ============================================
echo.

REM Überprüfe ob Node.js/Bun installiert ist
where bun >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo FEHLER: Bun ist nicht installiert!
    echo Bitte installiere Bun von: https://bun.sh/
    pause
    exit /b 1
)

REM Wechsle zum Projektverzeichnis (passe den Pfad an)
set PROJECT_DIR=%~dp0
cd /d "%PROJECT_DIR%"

echo Aktives Verzeichnis: %CD%
echo.

REM Installation der Dependencies
echo [1/3] Installiere Dependencies...
bun install

REM Build das Projekt
echo [2/3] Baue das Projekt...
bun run build

REM Starte die Development-Umgebung
echo [3/3] Starte VibeSDK...
echo.
echo Frontend URL: http://localhost:5173/
echo Backend URL:  http://localhost:8787/
echo.
echo Drücke Ctrl+C um den Server zu stoppen
echo.

REM Starte sowohl Frontend als auch Backend
start /B bun run dev:frontend
timeout /t 3 >nul
start /B bun run dev:fullstack

REM Warte auf Benutzer-Input
echo VibeSDK läuft! Drücke eine beliebige Taste um zu beenden...
pause >nul

REM Stoppe alle Background-Prozesse
taskkill /F /IM bun.exe >nul 2>nul
taskkill /F /IM node.exe >nul 2>nul

echo VibeSDK wurde beendet.
pause