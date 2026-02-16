@echo off
REM Double-click to open FastNet Toolbox GUI. No install required.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0FastNet-Toolbox-GUI.ps1"
pause
