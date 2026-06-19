# 🏭 Production Cron Job Examples

## 📌 Purpose
In enterprise DevOps environments, cron jobs must be reliable, monitored, and safe from conflicts. If a backup task takes 2 hours but is scheduled to run every hour, overlapping processes will execute, starving the server of CPU/RAM and potentially corrupting database files. This document details production scheduling layouts and advanced patterns like locking and redirection.

---

## ⚙️ Core Concepts & Production Standards

### Output Logging Redirection
For production auditing, all cron outputs must be captured in log directories (e.g., `/var/log/cron/` or `/var/log/`).
```text
>> /var/log/cron_job.log 2>&1
```

### Avoiding Overlapping Executions (`flock`)
To prevent a cron job from starting if the previous run is still active, use `flock` (file lock). `flock` creates an exclusive lock file. If another instance of the cron job starts, it will see the locked file and exit immediately.

---

## 💻 Practical Examples

### 1. Daily System Health Check (9:00 AM)
Run system status diagnostics and save the output.
```bash
0 9 * * * /scripts/system-health-check.sh >> /var/log/system_health.log 2>&1
```
*   **Schedule**: Runs at 9:00 AM every day.

### 2. Disk Usage Alert (Every Hour)
Run partition monitoring and warn if thresholds are reached.
```bash
0 * * * * /scripts/disk-usage-alert.sh >> /var/log/disk_alert.log 2>&1
```
*   **Schedule**: Runs at minute 0 of every hour.

### 3. Log Cleanup with Execution Lock (Sunday at 2:00 AM)
Run log purges safely, preventing overlapping using `flock`.
```bash
0 2 * * 0 flock -n /tmp/log_cleanup.lock /scripts/log-cleanup.sh >> /var/log/log_cleanup.log 2>&1
```
*   **Schedule**: Runs at 2:00 AM on Sundays.
*   **Locking**: If the previous log-cleanup process is still running, `flock -n` fails to acquire the lock and exits without starting another instance.

### 4. Database Backup Automation (Daily at 1:00 AM)
Run compressed file/database backups.
```bash
0 1 * * * /scripts/backup-script.sh >> /var/log/db_backup.log 2>&1
```
*   **Schedule**: Runs at 1:00 AM every day.

---

## 🛠️ DevOps Use Cases & Scenarios

### Centralized Logging and Monitoring
Instead of writing outputs to a local file, production setups often pipe cron alerts directly to remote monitoring endpoints or messaging webhooks:
```bash
# Example: Send alerts directly to Slack if disk usage exceeds limits
0 * * * * /scripts/disk-usage-alert.sh | grep "Warning" && curl -X POST -H 'Content-type: application/json' --data '{"text":"Disk Space Warning!"}' https://hooks.slack.com/services/T00/B00/X00
```

---

## 💡 Interview Q&A & Tips

**Q1: What happens if a cron job takes longer to run than the scheduling interval? (e.g., runs every 5 minutes but takes 6 minutes to complete)**
*   **Answer:** By default, cron will start a second instance of the script at the 5-minute mark, resulting in both processes running concurrently. This can lead to race conditions, database corruption, or high CPU utilization.
*   **Solution:** To prevent this, wrap the command in `flock`. For example:
    `*/5 * * * * flock -n /tmp/myjob.lock /scripts/myjob.sh`
    The second process will fail to acquire the lock file `/tmp/myjob.lock` and will terminate instantly.

**Q2: How do you verify if your cron job ran successfully?**
*   **Answer:**
    1. Inspect the custom log file specified in your redirection (`/var/log/...`).
    2. Check the system-wide cron log files (e.g., `/var/log/cron` on RHEL/CentOS or `/var/log/syslog` on Ubuntu/Debian) to see execution timestamps:
       `grep CRON /var/log/syslog`
