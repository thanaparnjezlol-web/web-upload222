#!/usr/bin/env python3
"""
Service Installation Helper
Convenient wrapper for installing/managing the Monitor Agent service
"""
import sys
import os
import subprocess
import argparse

try:
    import win32serviceutil
    import win32service
except ImportError:
    print("ERROR: pywin32 not installed. Install with: pip install pywin32")
    sys.exit(1)

# Service name
SERVICE_NAME = "MonitorAgent"


def is_admin():
    """Check if running with administrator privileges."""
    try:
        import ctypes
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False


def install_service():
    """Install the Windows service."""
    if not is_admin():
        print("ERROR: Administrator privileges required to install service")
        print("Please run this script as Administrator")
        return False
    
    try:
        # Get path to agent_service.py
        service_path = os.path.join(os.path.dirname(__file__), 'agent_service.py')
        
        if not os.path.exists(service_path):
            print(f"ERROR: Service file not found: {service_path}")
            return False
        
        print(f"Installing service from: {service_path}")
        
        # Install service
        cmd = [
            sys.executable,
            service_path,
            "install"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Service installed successfully!")
            print(f"   Service Name: {SERVICE_NAME}")
            print("\nNext steps:")
            print("  1. Start service: python install_service.py start")
            print("  2. Or use Services app: services.msc")
            return True
        else:
            print("❌ Service installation failed")
            print(f"Error: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Installation error: {e}")
        return False


def remove_service():
    """Remove the Windows service."""
    if not is_admin():
        print("ERROR: Administrator privileges required to remove service")
        print("Please run this script as Administrator")
        return False
    
    try:
        service_path = os.path.join(os.path.dirname(__file__), 'agent_service.py')
        
        print(f"Removing service: {SERVICE_NAME}")
        
        # Stop service first
        try:
            win32serviceutil.StopService(SERVICE_NAME)
            print("  Service stopped")
        except:
            pass  # Service might not be running
        
        # Remove service
        cmd = [
            sys.executable,
            service_path,
            "remove"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Service removed successfully!")
            return True
        else:
            print("❌ Service removal failed")
            print(f"Error: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Removal error: {e}")
        return False


def start_service():
    """Start the Windows service."""
    if not is_admin():
        print("ERROR: Administrator privileges required to start service")
        print("Please run this script as Administrator")
        return False
    
    try:
        print(f"Starting service: {SERVICE_NAME}")
        win32serviceutil.StartService(SERVICE_NAME)
        print("✅ Service started successfully!")
        print("\nCheck service status:")
        print("  1. Services app: services.msc")
        print("  2. Or: python install_service.py status")
        return True
        
    except Exception as e:
        print(f"❌ Failed to start service: {e}")
        return False


def stop_service():
    """Stop the Windows service."""
    if not is_admin():
        print("ERROR: Administrator privileges required to stop service")
        print("Please run this script as Administrator")
        return False
    
    try:
        print(f"Stopping service: {SERVICE_NAME}")
        win32serviceutil.StopService(SERVICE_NAME)
        print("✅ Service stopped successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Failed to stop service: {e}")
        return False


def restart_service():
    """Restart the Windows service."""
    if not is_admin():
        print("ERROR: Administrator privileges required to restart service")
        print("Please run this script as Administrator")
        return False
    
    try:
        print(f"Restarting service: {SERVICE_NAME}")
        win32serviceutil.RestartService(SERVICE_NAME)
        print("✅ Service restarted successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Failed to restart service: {e}")
        return False


def service_status():
    """Get service status."""
    try:
        status = win32serviceutil.QueryServiceStatus(SERVICE_NAME)[1]
        
        status_map = {
            win32service.SERVICE_STOPPED: "STOPPED",
            win32service.SERVICE_START_PENDING: "STARTING",
            win32service.SERVICE_STOP_PENDING: "STOPPING",
            win32service.SERVICE_RUNNING: "RUNNING",
            win32service.SERVICE_CONTINUE_PENDING: "CONTINUING",
            win32service.SERVICE_PAUSE_PENDING: "PAUSING",
            win32service.SERVICE_PAUSED: "PAUSED"
        }
        
        status_text = status_map.get(status, f"UNKNOWN ({status})")
        
        print(f"Service: {SERVICE_NAME}")
        print(f"Status: {status_text}")
        
        if status == win32service.SERVICE_RUNNING:
            print("\n📊 Service is running normally")
            print("   Logs: C:\\ProgramData\\MonitorAgent\\logs\\service.log")
        elif status == win32service.SERVICE_STOPPED:
            print("\n⚠️ Service is not running")
            print("   Start with: python install_service.py start")
        
        return True
        
    except Exception as e:
        print(f"❌ Service not found: {e}")
        print("\nService might not be installed.")
        print("Install with: python install_service.py install")
        return False


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Monitor Agent Service Manager",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Install service:  python install_service.py install
  Start service:    python install_service.py start
  Stop service:     python install_service.py stop
  Restart service:  python install_service.py restart
  Check status:     python install_service.py status
  Remove service:   python install_service.py remove

Note: Administrator privileges required for most operations
        """
    )
    
    parser.add_argument(
        'action',
        choices=['install', 'remove', 'start', 'stop', 'restart', 'status'],
        help='Action to perform'
    )
    
    args = parser.parse_args()
    
    actions = {
        'install': install_service,
        'remove': remove_service,
        'start': start_service,
        'stop': stop_service,
        'restart': restart_service,
        'status': service_status
    }
    
    success = actions[args.action]()
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
