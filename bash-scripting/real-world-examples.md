# 🚀 Real-World Scripting Examples

This document contains practical Bash script examples commonly used by DevOps engineers to automate backups, log rotations, service status checks, and system maintenance tasks. Each example is kept concise to illustrate the core logic, while adhering to scripting best practices.

> 📖 **See also:** For production-grade versions with structured logging, email notifications, and cloud uploads, see the scripts in [`../scripts/`](../scripts/).

---

## ⚙️ Core Automation Patterns

These scripts demonstrate typical automation patterns:
*   Iterating over lists (arrays) of servers or files.
*   Checking exit codes (`$?`) to handle errors.
*   Redirecting stdout/stderr to log files.
*   Interacting with system services (`systemctl`) and APIs.

---

## 💻 Practical Examples

### 1. Log Rotation Script
Compresses and archives log files older than a specified number of days.
```bash
#!/bin/bash
set -euo pipefail

LOG_DIR="/var/log/myapp"
ARCHIVE_DIR="/var/log/myapp/archive"
DAYS=7

mkdir -p "$ARCHIVE_DIR"

# Find and compress log files older than $DAYS, then remove the original file
find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS" -exec tar -czf "$ARCHIVE_DIR/\$(basename {}).tar.gz" {} \; -exec rm -f {} \;

echo "Log rotation completed."
```

### 2. Backup Script (rsync)
Synchronizes a source directory to a backup destination and logs the outcome.
```bash
#!/bin/bash

SOURCE_DIR="/home/user/documents"
DEST_DIR="/backup/user/documents"
LOG_FILE="/var/log/backup.log"

mkdir -p "$DEST_DIR"

# Run the backup using rsync
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "$(date): Backup completed successfully." >> "$LOG_FILE"
else
  echo "$(date): Backup failed!" >> "$LOG_FILE"
fi
```

### 3. System Update & Cleanup
Updates package lists, upgrades installed packages, and clears package cache.
```bash
#!/bin/bash
set -euo pipefail

echo "Starting system update..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean
echo "System update and cleanup completed."
```

### 4. Service Monitoring
Checks if a specific service is active and attempts to restart it if offline.
```bash
#!/bin/bash

PROCESS_NAME="nginx"
EMAIL="admin@example.com"

# Check if the process is running
if systemctl is-active --quiet "$PROCESS_NAME"; then
  echo "$PROCESS_NAME is running."
else
  echo "Alert: $PROCESS_NAME is not running! Attempting restart."
  sudo systemctl restart "$PROCESS_NAME"
  
  # Send an alert email
  echo "Alert: $PROCESS_NAME was down. Attempted restart on \$(hostname)" | mail -s "Service Alert: $PROCESS_NAME" "$EMAIL"
fi
```

### 5. Automated Directory Cleanup
Cleans out temporary files in specified directories.
```bash
#!/bin/bash

TEMP_DIRS=("/tmp" "/var/tmp" "/home/user/.cache")

for dir in "${TEMP_DIRS[@]}"; do
  if [[ -d "$dir" ]]; then
    echo "Cleaning $dir..."
    sudo find "$dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
  fi
done

echo "Cleanup completed."
```

### 6. Network Host Check
Pings multiple servers to check connectivity.
```bash
#!/bin/bash

SERVERS=("8.8.8.8" "1.1.1.1" "google.com")
EMAIL="admin@example.com"

for server in "${SERVERS[@]}"; do
  if ping -c 1 -W 2 "$server" &>/dev/null; then
    echo "$server is reachable."
  else
    echo "Warning: $server is not reachable!" | mail -s "Network Alert" "$EMAIL"
  fi
done
```

### 7. Keyword Log Extraction
Scans log files for errors and exports them to an output file.
```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/myapp.log"
OUTPUT_FILE="/home/user/extracted_errors.txt"

if [[ -f "$LOG_FILE" ]]; then
  grep -i "ERROR" "$LOG_FILE" > "$OUTPUT_FILE" || true
  echo "Data extraction completed. See $OUTPUT_FILE for results."
else
  echo "Error: Log file $LOG_FILE not found!"
  exit 1
fi
```

### 8. CPU Usage Threshold Alert
Triggers an alert if CPU usage exceeds a defined threshold.
```bash
#!/bin/bash

THRESHOLD=80
EMAIL="admin@example.com"

# Extract CPU idle percentage and calculate usage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
  echo "Warning: CPU usage is at ${CPU_USAGE}% (Threshold: ${THRESHOLD}%)." | mail -s "CPU Usage Alert" "$EMAIL"
fi
```

### 9. Database Backup (MySQL)
Creates a compressed MySQL database backup.
```bash
#!/bin/bash
set -euo pipefail

DB_USER="root"
DB_PASS="password"
DB_NAME="mydatabase"
BACKUP_DIR="/backups/mysql"
DATE=$(date +%F-%H%M)

mkdir -p "$BACKUP_DIR"

# Perform backup and compress it
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

echo "Database backup completed successfully."
```

### 10. Automated SSL Renewal (Let's Encrypt)
Checks and renews SSL certificates using certbot and reloads the web server.
```bash
#!/bin/bash
set -euo pipefail

DOMAIN="example.com"

# Renew certificate
sudo certbot renew --quiet

# Reload Nginx to apply new certificate
sudo systemctl reload nginx

echo "SSL renewal check completed."
```

---

## 🛠️ DevOps Use Cases

### Continuous System Auditing
DevOps teams schedule the **Service Monitoring** and **CPU Usage Threshold Alert** scripts via Cron or run them as systemd timers to achieve simple, lightweight agentless monitoring on independent host nodes.

---

## 💡 Interview Q&A

**Q1: How do you prevent a backup script from writing to an unmounted disk partition?**
*   **Answer:** You should check if the backup destination directory is a mount point before running the backup. This can be done using the `mountpoint` command:
    ```bash
    if mountpoint -q /backup; then
      # Run backup
    else
      echo "Backup disk not mounted! Aborting."
      exit 1
    fi
    ```

**Q2: What is the significance of using `set -euo pipefail` in real-world scripts?**
*   **Answer:** It ensures the script behaves predictably and fails fast on errors. It catches uninitialized variables, stops execution if any intermediate command fails, and prevents pipeline errors from being masked, preventing scripts from continuing in a corrupt or unexpected system state.

---

> 🔖 **Note:** Practice building scripts in this directory by running them in a local virtual environment or container.
