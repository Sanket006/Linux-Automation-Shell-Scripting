# ⚙️ systemd Basics

## 📌 Purpose
`systemd` is the initialization system (init) and service manager that bootstraps and administers user space processes in modern Linux distributions. This document covers the fundamental architecture of systemd, unit file classification, and the core command-line interfaces (`systemctl` and `journalctl`) used to manage and audit system services.

---

## ⚙️ Core Concepts & Commands

### 1. Systemd Units
Everything managed by systemd is a **Unit**. Unit configuration files end in specific suffixes:
-   **`.service`**: Represents a daemon or application service (e.g., `nginx.service`).
-   **`.target`**: Grouping units together to define system states (e.g., `multi-user.target` is equivalent to runlevel 3).
-   **`.timer`**: Schedules a service to run at specific times (a modern alternative to Cron).

### 2. Service Control Commands (`systemctl`)
Used to inspect, start, stop, and configure services:

| Command | Description | DevOps Use Case |
| :--- | :--- | :--- |
| `systemctl start <name>` | Starts a service immediately. | Activating a deployed application service. |
| `systemctl stop <name>` | Stops a running service. | Halting a service during maintenance/deployment windows. |
| `systemctl restart <name>` | Restarts a service (stops then starts). | Applying new configuration changes. |
| `systemctl status <name>` | Displays service state, PID, and recent logs. | Checking if a daemon crashed or is running healthily. |
| `systemctl enable <name>` | Configures service to start automatically at boot. | Ensuring persistence of monitoring tools across VM restarts. |
| `systemctl disable <name>` | Prevents service from starting at boot. | Disabling legacy or unneeded services. |
| `systemctl daemon-reload` | Reloads systemd manager configurations. | Registering new or modified unit files. |

### 3. Log Querying Commands (`journalctl`)
`systemd-journald` is the logging service. It collects logs from the kernel, system services, and stdout/stderr:
*   `journalctl -u <service>`: Views logs for a specific service.
*   `journalctl -f`: Streams logs in real-time.
*   `journalctl -u <service> -n 100`: Shows only the last 100 entries.

---

## 💻 Practical Examples

### 1. Checking and Starting Nginx Web Service
```bash
# Check status
systemctl status nginx

# Start Nginx if it is stopped
sudo systemctl start nginx

# Persist it across server restarts
sudo systemctl enable nginx
```

### 2. Retrieving Live Logs for a Custom Application
View the logs of a python-app service as they happen:
```bash
journalctl -u python-app -f
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving "Daemon Out of Sync" Failures
When you edit a systemd service file (e.g., changing memory limits or start commands), running `systemctl restart` will throw a warning:
`Warning: The unit file, source configuration file or drop-ins of my-app.service changed on disk.`
-   **Resolution:** You must tell systemd to scan the disk for changed unit configurations before applying them:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart my-app.service
    ```

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between `systemctl start` and `systemctl enable`?**
*   **Answer:** 
    *   `systemctl start` immediately launches the service in the current session. It does not persist; if the server restarts, the service will not start automatically unless it was previously enabled.
    *   `systemctl enable` configures the service to boot automatically when the operating system starts up. It creates symlinks inside the target directories. It does *not* start the service immediately in the current session (unless the `--now` flag is appended: `systemctl enable --now <service>`).

**Q2: How do you inspect kernel crash messages using systemd logging tools?**
*   **Answer:** Run `journalctl -k` (or `journalctl -xb`) to view kernel-level log entries and filter out standard user-space logs.
