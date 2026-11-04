@echo off
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Life Dashboard.lnk" 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder" /v "Life Dashboard.lnk" /f >nul 2>nul
echo Life Dashboard will no longer open when you sign in.
pause
