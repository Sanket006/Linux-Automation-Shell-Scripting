# ⚙️ Creating a Custom systemd Service

## 📌 Purpose
Deploying applications (like Node.js servers, Python worker processes, or automation scripts) requires that they run persistently in the background. Running them manually in a terminal session will cause them to terminate when the SSH session closes. This guide walks you through wrapping a custom script as a managed systemd service, configuring automatic crash recoveries, and enabling start on system boot.

---

## 🛠️ Step-by-Step Hands-On Guide

### Step 1: Prepare the Automation Script
Ensure you have an executable script ready. For this example, we will use our system health script located at `/scripts/system-health-check.sh` (ensure it is executable):
```bash
sudo chmod +x /scripts/system-health-check.sh
```

### Step 2: Create the Service Unit File
Create a new file named `/etc/systemd/system/health-check.service` using `sudo`:
```ini
[Unit]
Description=System Health Check Daemon
After=network.target

[Service]
Type=simple
ExecStart=/scripts/system-health-check.sh
Restart=on-failure
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
```

#### Unit File Sections Explained:
*   **`[Unit]`**: Defines metadata and order of execution.
    *   `Description`: A human-readable description of the service.
    *   `After=network.target`: Tells systemd to delay starting this service until the network interfaces are up.
*   **`[Service]`**: Defines process execution properties.
    *   `Type=simple`: The default type, meaning the process started by `ExecStart` is the main process of the service.
    *   `ExecStart`: The absolute path to the script or binary to execute.
    *   `Restart=on-failure`: Configures systemd to automatically restart the service if it exits with a non-zero exit code or crashes.
    *   `RestartSec=5`: Wait 5 seconds before attempting restart.
    *   `User=root`: Runs the script under the root user security context.
*   **`[Install]`**: Defines installation behaviors.
    *   `WantedBy=multi-user.target`: Configures the service to start during a normal multi-user command-line system boot.

### Step 3: Register and Launch the Service
Reload the systemd daemon to register the unit file, enable it to start on boot, and run it:
```bash
# 1. Force systemd to scan the disk for new service files
sudo systemctl daemon-reload

# 2. Enable service boot persistence
sudo systemctl enable health-check.service

# 3. Start the service now
sudo systemctl start health-check.service
```

### Step 4: Verify Service Health & Logs
Check the status of the service and view its outputs:
```bash
# Check status
systemctl status health-check.service

# Stream service logs
journalctl -u health-check.service -f
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Deploying a Go or Node.js API Service
When deploying microservices to raw VMs, you should never run them as `root` for security reasons. The systemd service file is updated to run the binary under a dedicated system user (e.g., `appuser`) and set environment variables:
```ini
[Service]
ExecStart=/var/www/api/bin/server
User=appuser
Group=appgroup
Environment=PORT=3000 NODE_ENV=production
Restart=always
```

---

## 💡 Interview Q&A & Tips

**Q1: What does `WantedBy=multi-user.target` mean in the `[Install]` section?**
*   **Answer:** It defines target levels during boot. A "target" is a synchronization point during system bootup (similar to runlevels). `multi-user.target` represents a fully booted command-line environment with networking. Specifying `WantedBy=multi-user.target` creates a symlink when the service is enabled, telling systemd to start the service when the system reaches the multi-user CLI state.

**Q2: What are the options for `Restart` in the `[Service]` section?**
*   **Answer:**
    *   `no` (default): The service will never restart.
    *   `always`: The service will restart regardless of how it exited (clean exit or crash).
    *   `on-failure`: The service restarts only if it exits with a non-zero status code, is terminated by a signal, or times out. This is recommended for standard system daemons to prevent looping clean exits.
