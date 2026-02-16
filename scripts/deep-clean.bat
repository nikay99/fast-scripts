@echo off
REM ============================================================
REM deep-clean.bat - Cleans temp files, caches, empties recycle bin
REM Run as Administrator for full effect. No install required.
REM ============================================================
title Deep Clean - System Cleaner

REM Check for admin (optional; some paths need it)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] For best results, right-click and "Run as administrator"
    echo.
)

echo   [*] Starting deep clean...
echo.

echo   [1/6] Temp folder...
rd /s /q "%TEMP%" 2>nul
mkdir "%TEMP%" 2>nul

echo   [2/6] Windows Temp...
rd /s /q "C:\Windows\Temp" 2>nul
mkdir "C:\Windows\Temp" 2>nul

echo   [3/6] Windows Update cache (may need admin)...
rd /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul

echo   [4/6] Browser caches...
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>nul
rd /s /q "%APPDATA%\Mozilla\Firefox\Profiles\*\cache2" 2>nul

echo   [5/6] Prefetch (optional)...
del /q "C:\Windows\Prefetch\*" 2>nul

echo   [6/6] Emptying Recycle Bin...
rd /s /q "%SystemDrive%\$Recycle.bin" 2>nul

echo.
echo   [Done] Deep clean finished. Your PC should feel snappier!
echo.
pause
