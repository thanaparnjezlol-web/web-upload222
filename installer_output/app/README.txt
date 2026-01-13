# Monitor Agent (Desktop Agent)

## Installation Steps

1. Run install.bat as Administrator
   - Copies files to Program Files
   - Installs MonitorAgent as Windows Service using shawl
   - Starts the service automatically

2. Run agent-status.bat to check registration status
   - Shows verification code if not yet registered
   - Shows "Registered" status once approved

3. Give the verification code to your administrator for approval

4. Once approved, agent runs automatically as Windows Service!

## Files

- MonitorAgent-Register.exe : Registration UI (manual registration)
- MonitorAgent-Service.exe  : Background monitoring agent
- shawl.exe                 : Windows Service wrapper
- agent-status.bat          : Check registration status

## Directories

- Program files: C:\Program Files\MonitorAgent
- Log files: C:\ProgramData\MonitorAgent\logs\agent.log
- Credentials: C:\ProgramData\MonitorAgent\credentials.json

## Service Management

- Check status: sc query MonitorAgent
- Start service: sc start MonitorAgent
- Stop service: sc stop MonitorAgent
- Restart: sc stop MonitorAgent && sc start MonitorAgent

## Re-running Registration

If you need to re-register:
1. Stop service: sc stop MonitorAgent
2. Delete: C:\ProgramData\MonitorAgent\credentials.json
3. Start service: sc start MonitorAgent
4. Run agent-status.bat to see new verification code

## Live Monitoring

Watch agent logs in real-time:
- Run agent-monitor.bat to see live logs (like running agent.py on dev machine)
- Press Ctrl+C to exit
- Useful to verify agent is working and sending data

## Troubleshooting

Check logs at: C:\ProgramData\MonitorAgent\logs\agent.log
