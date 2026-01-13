@echo off
echo ============================================
echo Monitor Agent Uninstaller
echo ============================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Administrator privileges required
    echo Please right-click and select "Run as Administrator"
    pause
    exit /b 1
)

set INSTALL_DIR=%ProgramFiles%\MonitorAgent
set DATA_DIR=%ProgramData%\MonitorAgent

echo [1/6] Stopping Windows Service...
sc stop MonitorAgent >nul 2>&1
timeout /t 2 /nobreak >nul
sc stop MonitorAgent >nul 2>&1
timeout /t 2 /nobreak >nul
echo    Done

echo [2/6] Killing agent processes...
taskkill /F /IM MonitorAgent-Service.exe >nul 2>&1
taskkill /F /IM MonitorAgent-Status.exe >nul 2>&1
taskkill /F /IM MonitorAgent-Monitor.exe >nul 2>&1
taskkill /F /IM MonitorAgent-Register.exe >nul 2>&1
timeout /t 1 /nobreak >nul
echo    Done

echo [3/6] Removing Windows Service...
if exist "%INSTALL_DIR%\shawl.exe" (
    "%INSTALL_DIR%\shawl.exe" remove --name MonitorAgent >nul 2>&1
)
sc delete MonitorAgent >nul 2>&1
timeout /t 2 /nobreak >nul
echo    Done

echo [4/6] Verifying service removal...
sc query MonitorAgent >nul 2>&1
if %errorLevel% equ 0 (
    echo    WARNING: Service still exists, trying again...
    sc stop MonitorAgent >nul 2>&1
    timeout /t 2 /nobreak >nul
    sc delete MonitorAgent >nul 2>&1
    timeout /t 2 /nobreak >nul
)
echo    Done

echo [5/6] Final process cleanup...
taskkill /F /IM MonitorAgent-Service.exe >nul 2>&1
timeout /t 1 /nobreak >nul
echo    Done

echo [6/6] Removing installation files...
rd /s /q "%INSTALL_DIR%" 2>nul
if exist "%INSTALL_DIR%" (
    echo    WARNING: Some files remain, trying again...
    timeout /t 2 /nobreak >nul
    rd /s /q "%INSTALL_DIR%" 2>nul
)
echo    Done

echo.
set /p KEEP_DATA="Keep logs and credentials for reinstall? (Y/N, default=Y): "
if /i "%KEEP_DATA%"=="N" (
    echo Removing data directory...
    rd /s /q "%DATA_DIR%" 2>nul
    echo    Done
) else (
    echo Data preserved: %DATA_DIR%
)

echo.
echo ============================================
echo Uninstallation Complete!
echo ============================================
echo.

REM Final verification
sc query MonitorAgent >nul 2>&1
if %errorLevel% equ 0 (
    echo [!] WARNING: Service still running! Restart required.
    echo.
) else (
    echo [OK] Service removed successfully
    echo.
)

if exist "%INSTALL_DIR%" (
    echo [!] WARNING: Some files remain. Restart may be required.
    echo     Location: %INSTALL_DIR%
    echo.
) else (
    echo [OK] All files removed
    echo.
)

pause
