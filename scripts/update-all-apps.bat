@echo off
REM ============================================================
REM update-all-apps.bat - Updates all apps via winget in one go
REM Windows 10/11. One-click update. No extra install if winget exists.
REM ============================================================
title Update All Apps

echo   [*] Updating all installed apps (winget upgrade --all)...
echo.
winget upgrade --all
echo.
echo   [Done] Press any key to close.
pause >nul
