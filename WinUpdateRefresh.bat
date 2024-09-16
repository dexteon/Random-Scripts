@echo off
title WINDOWS UPDATE REFRESH

:: Elevate privileges if not running as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (echo Please run as Administrator & exit /b)

:: Stop pending updates and related services
for %%w in (dism setuphost tiworker usoclient sihclient wuauclt culauncher sedlauncher osrrb ruximics ruximih) do (
    taskkill /im %%w.exe /f 2>nul
)
for %%w in (msiserver wuauserv bits usosvc dosvc cryptsvc) do (
    net stop %%w /y 2>nul
)

:: Backup before clearing update logs and files
echo Backing up Windows Update Logs...
xcopy "%SystemRoot%\Logs\WindowsUpdate" "%SystemRoot%\Logs\WindowsUpdateBackup" /s /e /i /h /y >nul

:: Clear update logs and files
del /f /s /q "%ProgramData%\USOShared\Logs\*" "%ProgramData%\USOPrivate\UpdateStore\*" "%SystemRoot%\Logs\WindowsUpdate\*" "%SystemDrive%\Windows.old\Cleanup" >nul 2>nul
powershell -nop -c "try {Get-WindowsUpdateLog -LogPath $env:temp\WU.log -ForceFlush -Confirm:$false -ErrorAction SilentlyContinue} catch {}" >nul
rmdir /s /q "%SystemRoot%\SoftwareDistribution" "%ProgramFiles%\UNP" "%SystemDrive%\$WINDOWS.~BT" >nul 2>nul

:: Uninstall forced upgraders and remediators
call "%SystemRoot%\UpdateAssistant\Windows10Upgrade.exe" /ForceUninstall 2>nul
msiexec /X {1BA1133B-1C7A-41A0-8CBF-9B993E63D296} /qn 2>nul
msiexec /X {8F2D6CEB-BC98-4B69-A5C1-78BED238FE77} /qn 2>nul
msiexec /X {76A22428-2400-4521-96AF-7AC4A6174CA5} /qn 2>nul

:: Restart update services
net start bits /y || exit /b
net start wuauserv /y || exit /b
net start usosvc /y || exit /b

echo Windows Update Refresh complete. Reboot if necessary.
pause
exit /b
