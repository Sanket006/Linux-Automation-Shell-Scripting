# 🤖 Production Automation Scripts

## 📌 Overview
This directory contains six real-world, production-ready Bash automation scripts designed to solve common DevOps and system administration challenges. Each script focuses on reducing operational overhead, maintaining system uptime, automating repetitive system tasks, and performing security compliance audits.

---

## 📂 Scripts Reference & Directory Contents

| Script Link | Description | Key Commands Used | DevOps Significance |
| :--- | :--- | :--- | :--- |
| [System Health Check](system-health-check.sh) | Logs system CPU load, memory, disk, and uptime. | `uptime`, `free`, `df`, `cat /proc/loadavg` | Continuous monitoring and health diagnostics. |
| [Disk Usage Alert](disk-usage-alert.sh) | Checks disk partition space and alerts if usage exceeds a threshold (80%). | `df`, `awk`, `sed`, `while read` | Preventing full-disk production out-of-memory outages. |
| [Log Cleanup](log-cleanup.sh) | Finds and purges log files older than a specified number of days (default: 7). | `find`, `-mtime`, `-exec rm` | Automating storage maintenance and space clearing. |
| [Backup Automation](backup-script.sh) | Creates timestamped, compressed tarball backups of specified directories. | `tar -czf`, `date`, `mkdir -p` | Standardizing data backups and disaster recovery assets. |
| [Service Monitoring](service-monitor.sh) | Monitors service state and automatically restarts it if it goes down. | `systemctl is-active`, `systemctl restart` | Auto-recovering critical services (e.g., Nginx, Apache). |
| [User Audit](user-audit.sh) | Audits system accounts, listing users with active login shells and UID >= 1000. | `awk`, `cat /etc/passwd` | Verifying user access compliance and security posture. |
| [Memory Monitoring](memory-monitor.sh) | Displays memory usage percentage and alerts on high usage. | `free`, `awk` | Real-time RAM threshold checking and leak diagnostics. |

---

## 🚀 How to Install & Run

### 1. Make the Script Executable
Before running any script, you must grant execution permission using `chmod`:
```bash
chmod +x automation-scripts/system-health-check.sh
```

### 2. Manual Run
Execute the script from your terminal:
```bash
# Run the script directly
./automation-scripts/system-health-check.sh
```

### 3. Automated Scheduling (Cron Jobs)
To schedule a script to run automatically at intervals, add it to your user crontab:
```bash
# Open crontab editor
crontab -e
```
Add the following line to schedule the disk usage check to run every hour:
```bash
0 * * * * /absolute/path/to/automation-scripts/disk-usage-alert.sh >> /var/log/disk_alerts.log 2>&1
```

### 4. Running as a Background Daemon (systemd)
To run a script as a persistent service on system boot, set up a custom systemd service. Reference the guide in [`systemd-services/`](../systemd-services/README.md) for details.

---

## 🎯 Learning Outcomes
After inspecting, testing, and running these scripts, you will:
- Understand how to structure bash scripts for real production environments.
- Know how to combine core Linux tools (`awk`, `sed`, `find`, `grep`) to perform automation logic.
- Master log auditing, system health reporting, and volume management techniques.
- Be prepared to write custom automation scripts to support cloud and virtualized infrastructure.

---

## ⚠️ Production Best Practices
- **Never Run Unverified Scripts:** Always read and review the shell code before executing it on production VMs.
- **Run with Least Privilege:** Avoid running scripts as `root` unless they perform tasks requiring administrator privileges (like service restarts or partition checks).
- **Log Everything:** Ensure all scheduled scripts redirect their outputs (`stdout` and `stderr`) to log files for auditing and debugging.
