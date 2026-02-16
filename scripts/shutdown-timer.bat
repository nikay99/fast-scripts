@echo off
REM ============================================================
REM shutdown-timer.bat - Shutdown PC after X minutes
REM Asks user for minutes, then schedules shutdown. No install.
REM ============================================================
setlocal
title Shutdown Timer

set /p MIN="In how many minutes should the PC shut down? (number): "
set /a SEC=%MIN%*60
if %SEC% leq 0 (
    echo Invalid. Use a positive number.
    pause
    exit /b 1
)

echo.
echo   [*] PC will shut down in %MIN% minute(s). To cancel: shutdown /a
echo.
shutdown /s /t %SEC% /c "Scheduled by FastNet Toolbox"
echo   Timer set. Press any key to close this window (shutdown continues).
pause >nul
