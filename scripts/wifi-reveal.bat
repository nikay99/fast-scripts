@echo off
REM ============================================================
REM wifi-reveal.bat - Shows all saved WiFi names and passwords
REM Uses netsh (built-in Windows). No installation required.
REM ============================================================
setlocal EnableDelayedExpansion
title WiFi Password Revealer

echo.
echo   [*] Scanning saved WiFi profiles...
echo.

for /f "skip=3 tokens=2*" %%a in ('netsh wlan show profiles') do (
    set "profile=%%b"
    if not "!profile!"=="" (
        echo   --- !profile! ---
        for /f "tokens=2 delims=:" %%p in ('netsh wlan show profile name^="!profile!" key^=clear ^| findstr "Key Content"') do (
            set "pass=%%p"
            set "pass=!pass:~1!"
            echo   Password: !pass!
        )
        echo.
    )
)

echo   [Done] Press any key to close.
pause >nul
