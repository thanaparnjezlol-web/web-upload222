@echo off
echo ============================================
echo Monitor Agent Installer (Desktop Agent)
echo Using shawl for Windows Service
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

REM Change to script directory
cd /d "%~dp0"

echo Installing Monitor Agent...
echo.

REM Set directories
set INSTALL_DIR=%ProgramFiles%\MonitorAgent
set DATA_DIR=%ProgramData%\MonitorAgent

REM Stop and remove existing service if running
echo Checking for existing service...
sc query MonitorAgent >nul 2>&1
if %errorLevel% equ 0 (
    echo Stopping existing service...
    sc stop MonitorAgent >nul 2>&1
    timeout /t 3 /nobreak >nul
    
    echo Removing existing service...
    REM Try shawl remove first (if shawl exists)
    if exist "%INSTALL_DIR%\shawl.exe" (
        "%INSTALL_DIR%\shawl.exe" remove --name MonitorAgent >nul 2>&1
    )
    
    REM Fallback: Use sc delete to ensure service is removed
    sc delete MonitorAgent >nul 2>&1
    timeout /t 2 /nobreak >nul
    
    echo Service removed successfully.
)

REM Kill any remaining agent processes
echo Killing agent processes...
taskkill /F /IM MonitorAgent-Service.exe >nul 2>&1
taskkill /F /IM MonitorAgent-Status.exe >nul 2>&1
taskkill /F /IM MonitorAgent-Monitor.exe >nul 2>&1
timeout /t 2 /nobreak >nul

REM Create directories
echo Creating directories...
mkdir "%INSTALL_DIR%" 2>nul
mkdir "%DATA_DIR%\logs" 2>nul

REM Copy files (retry on failure)
echo Copying files...
xcopy /Y /E /I /Q app\*.* "%INSTALL_DIR%\"
if %errorLevel% neq 0 (
    echo Retry copying after delay...
    timeout /t 2 /nobreak >nul
    xcopy /Y /E /I /Q app\*.* "%INSTALL_DIR%\"
)

REM Verify shawl.exe exists
if not exist "%INSTALL_DIR%\shawl.exe" (
    echo ERROR: shawl.exe not found after copy!
    echo Expected location: %INSTALL_DIR%\shawl.exe
    pause
    exit /b 1
)

REM Note: Credentials migration is handled automatically by agent.py on first run
REM No manual migration needed!

REM Install Windows Service using shawl
echo.
echo Installing Windows Service...
"%INSTALL_DIR%\shawl.exe" add --name MonitorAgent --cwd "%INSTALL_DIR%" --log-dir "%DATA_DIR%\logs" --log-as "MonitorAgent" --log-cmd-as "MonitorAgent-cmd" --env "MONITOR_AGENT_DATA_DIR=%DATA_DIR%" -- "%INSTALL_DIR%\MonitorAgent-Service.exe"

if %errorLevel% neq 0 (
    echo ERROR: Failed to install service
    pause
    exit /b 1
)

REM Configure service to auto-start
sc config MonitorAgent start= auto >nul
REM Ensure service account is LocalSystem (default, but we enforce it)
sc config MonitorAgent obj= "LocalSystem" >nul 2>&1

REM Start the service
echo Starting service...
sc start MonitorAgent

REM Create agent-status.bat wrapper (runs the compiled status checker and pauses)
echo Creating status checker wrapper...
echo @echo off > "%INSTALL_DIR%\agent-status.bat"
echo "%INSTALL_DIR%\MonitorAgent-Status.exe" >> "%INSTALL_DIR%\agent-status.bat"
echo pause >> "%INSTALL_DIR%\agent-status.bat"

REM Create agent-monitor.bat wrapper (runs live log monitor - exits with Ctrl+C)
echo Creating live monitor wrapper...
echo @echo off > "%INSTALL_DIR%\agent-monitor.bat"
echo "%INSTALL_DIR%\MonitorAgent-Monitor.exe" >> "%INSTALL_DIR%\agent-monitor.bat"

REM Copy wrappers to installer output too
copy "%INSTALL_DIR%\agent-status.bat" "%~dp0agent-status.bat" >nul
copy "%INSTALL_DIR%\agent-monitor.bat" "%~dp0agent-monitor.bat" >nul

echo.
echo ============================================
echo Installation Complete!
echo ============================================
echo.
echo Service installed: MonitorAgent
echo Installation: %INSTALL_DIR%
echo Logs: %DATA_DIR%\logs\agent.log
echo.
echo Next steps:
echo   1. Run agent-status.bat to check registration
echo   2. Look for verification code in the log
echo   3. Give the code to your administrator
echo   4. Once approved, monitoring starts automatically!
echo.
echo Monitoring commands:
echo   agent-status.bat        - Check status (one-time)
echo   agent-monitor.bat       - Watch live logs (Ctrl+C to exit)
echo.
echo Service commands:
echo   sc query MonitorAgent   - Check status
echo   sc stop MonitorAgent    - Stop service
echo   sc start MonitorAgent   - Start service
echo.
pause
