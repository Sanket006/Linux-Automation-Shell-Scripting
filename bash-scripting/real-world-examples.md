## 1. Log Rotation Script
This script compresses and archives old log files:
```bash
#!/bin/bash

# Directory containing the logs
LOG_DIR="/var/log/myapp"

# Directory to store archived logs
ARCHIVE_DIR="/var/log/myapp/archive"

# Number of days after which logs are archived
DAYS=7

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Find and compress log files older than $DAYS
find "$LOG_DIR" -type f -mtime +"$DAYS" -exec tar -czf "$ARCHIVE_DIR/$(basename {}).tar.gz" {} \; -exec rm -f {} \;

echo "Log rotation completed."
```

## 2. Backup Script
This script uses `rsync` to back up files:
```bash
#!/bin/bash

# Source directory to back up
SOURCE_DIR="/home/user/documents"

# Destination directory for backup
DEST_DIR="/backup/user/documents"

# Log file for backup process
LOG_FILE="/var/log/backup.log"

# Run the backup using rsync
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
else
    echo "Backup failed. Check the log file for details."
fi
```

## 3. Disk Usage Monitor
This script checks disk usage and sends an alert if it exceeds a certain threshold:
```bash
#!/bin/bash

# Threshold for disk usage in percentage
THRESHOLD=80

# Directory to check
CHECK_DIR="/"

# Get the current disk usage percentage
USAGE=$(df "$CHECK_DIR" | awk 'NR==2 {print $5}' | sed 's/%//')

# Compare usage with threshold
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Warning: Disk usage on $CHECK_DIR is at ${USAGE}% which exceeds the threshold of ${THRESHOLD}%." | mail -s "Disk Usage Alert" user@example.com
fi
```

## 4. System Update Script
This script updates all packages and cleans up:
```bash
#!/bin/bash

# Update package lists
sudo apt update
# Upgrade all packages
sudo apt upgrade -y
# Remove unused packages
sudo apt autoremove -y
# Clean up package cache
sudo apt clean

echo "System update and cleanup completed."
```

## 5. User Management Script
This script can create a new user and set a password:
```bash
#!/bin/bash

# Username to create
USERNAME="newuser"

# Home directory
HOME_DIR="/home/$USERNAME"

# Default shell
SHELL="/bin/bash"

# Create the user
sudo useradd -m -d "$HOME_DIR" -s "$SHELL" "$USERNAME"

# Set the user password
echo "$USERNAME:password" | sudo chpasswd

echo "User $USERNAME created and password set."
```

## 6. Process Monitoring Script
This script checks if a specific process is running and sends an alert if it’s not:
```bash
#!/bin/bash

# Name of the process to check
PROCESS_NAME="myapp"

# Email to send alert to
EMAIL="user@example.com"

# Check if the process is running
if pgrep "$PROCESS_NAME" > /dev/null; then
    echo "$PROCESS_NAME is running."
else
    echo "Alert: $PROCESS_NAME is not running!" | mail -s "$PROCESS_NAME Alert" "$EMAIL"
fi
```

## 7. Automated Cleanup Script
This script removes temporary files and clears cache:
```bash
#!/bin/bash

# Directories to clean
TEMP_DIRS=("/tmp" "/var/tmp" "/home/user/.cache")

# Remove files in each temp directory
for DIR in "${TEMP_DIRS[@]}"; do
    echo "Cleaning $DIR..."
    sudo rm -rf "$DIR"/*
done

echo "Cleanup completed."
```

## 8. Network Health Check Script
This script pings multiple servers and reports their status:
```bash
#!/bin/bash

# List of servers to ping
SERVERS=("8.8.8.8" "1.1.1.1" "google.com")

# Ping each server and report status
for SERVER in "${SERVERS[@]}"; do
    if ping -c 1 "$SERVER" &>/dev/null; then
        echo "$SERVER is reachable."
    else
        echo "Warning: $SERVER is not reachable!" | mail -s "Network Alert" user@example.com
    fi
done
```

## 9. Data Extraction Script
This script extracts specific information from a log file:
```bash
#!/bin/bash

# Log file to parse
LOG_FILE="/var/log/myapp.log"

# Output file for extracted data
OUTPUT_FILE="/home/user/extracted_data.txt"

# Extract lines containing a specific keyword
grep "ERROR" "$LOG_FILE" > "$OUTPUT_FILE"

echo "Data extraction completed. See $OUTPUT_FILE for results."
```

## 10. Notification Script
This script sends an email notification based on certain triggers:
```bash
#!/bin/bash

# Condition to check (e.g., CPU usage)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')
THRESHOLD=80

# Check if CPU usage exceeds threshold
if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
    echo "Warning: CPU usage is at ${CPU_USAGE}% which exceeds the threshold of ${THRESHOLD}%." | mail -s "CPU Usage Alert" user@example.com
fi
```

## 11. Automated Database Backup Script
This script backs up a MySQL database and compresses the backup:
```bash
#!/bin/bash

# Database credentials
DB_USER="username"
DB_PASSWORD="password"
DB_NAME="mydatabase"

# Backup directory
BACKUP_DIR="/backups/mysql"

# Date format
DATE=$(date +\%F)

# Create backup
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

echo "Database backup completed and saved to $BACKUP_DIR."
```

## 12. File Synchronization Script
This script synchronizes files between two directories using `rsync`:
```bash
#!/bin/bash

# Source and destination directories
SOURCE_DIR="/home/user/documents"
DEST_DIR="/backup/documents"

# Synchronize files
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR"

echo "File synchronization completed."
```

## 13. System Health Check Script
This script checks CPU, memory, and disk usage and logs the results:
```bash
#!/bin/bash

# Log file
LOG_FILE="/var/log/system_health.log"

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Get memory usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get disk usage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')

# Log the results
echo "$(date): CPU: $CPU_USAGE%, Memory: $MEM_USAGE%, Disk: $DISK_USAGE%" >> "$LOG_FILE"

echo "System health check completed and logged."
```

## 14. Log Monitoring and Alert Script
This script monitors a log file for specific keywords and sends an alert:
```bash
#!/bin/bash

# Log file to monitor
LOG_FILE="/var/log/myapp.log"

# Keyword to search for
KEYWORD="ERROR"

# Email to send alert to
EMAIL="user@example.com"

# Monitor the log file for the keyword
tail -F "$LOG_FILE" | while read LINE; do
    if echo "$LINE" | grep -q "$KEYWORD"; then
        echo "Alert: Found $KEYWORD in log!" | mail -s "$KEYWORD Alert" "$EMAIL"
    fi
done
```

## 15. Automated User Cleanup Script
This script removes inactive users from the system:
```bash
#!/bin/bash

# Inactive days threshold
INACTIVITY_DAYS=30

# Find users inactive for more than the threshold
for USER in $(cut -d: -f1 /etc/passwd); do
    LAST_LOGIN=$(lastlog -u "$USER" | awk 'NR==2 {print $4, $5, $6, $7}')
    if [ -z "$LAST_LOGIN" ] || [ "$(date -d "$LAST_LOGIN" +%s)" -lt "$(date -d "-$INACTIVITY_DAYS days" +%s)" ]; then
        sudo userdel -r "$USER"
        echo "User $USER removed due to inactivity."
    fi
done
```

## 16. Automated SSL Certificate Renewal Script 
This script checks and renews SSL certificates using `certbot`:
```bash
#!/bin/bash

# Domain to renew certificate for
DOMAIN="example.com"

# Path to certbot
CERTBOT="/usr/bin/certbot"

# Renew the certificate
$CERTBOT renew --domain "$DOMAIN"

# Reload the web server (assuming Apache here)
sudo systemctl reload apache2

echo "SSL certificate renewed and web server reloaded."
```
## 17. Automated System Update and Reboot Script
This script updates the system and reboots if necessary:
```bash
#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
    echo "Reboot is required. Rebooting now..."
    sudo reboot
else
    echo "System update completed. No reboot needed."
fi
```
## 18. Automated Disk Space Alert Script
This script monitors disk space and sends alerts if usage exceeds a threshold:
```bash
#!/bin/bash

# Threshold for disk usage
THRESHOLD=90

# Disk to monitor
DISK="/"

# Email to send alert to
EMAIL="user@example.com"

# Get disk usage
USAGE=$(df "$DISK" | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if usage exceeds threshold
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Warning: Disk usage on $DISK is at ${USAGE}% which exceeds the threshold of ${THRESHOLD}%." | mail -s "Disk Space Alert" "$EMAIL"
fi
```
## 19. Automated Log Backup Script
This script backs up log files to a remote server:
```bash
#!/bin/bash

# Local log directory
LOG_DIR="/var/log/myapp"

# Remote server and directory
REMOTE_USER="user"
REMOTE_HOST="remote.example.com"
REMOTE_DIR="/backups/logs"

# Create a compressed archive of the logs
tar -czf /tmp/log_backup_$(date +\%F).tar.gz -C "$LOG_DIR" .

# Transfer the archive to the remote server
scp /tmp/log_backup_$(date +\%F).tar.gz "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Clean up local temporary file
rm /tmp/log_backup_$(date +\%F).tar.gz

echo "Log backup completed and transferred to remote server."
```

## 20. Automated Security Patch Script
This script applies security patches and notifies the admin:
```bash
#!/bin/bash

# Update and upgrade only security patches
sudo apt-get update
sudo apt-get upgrade -y --only-upgrade

# Check for new security patches
SECURITY_UPDATES=$(sudo unattended-upgrades --dry-run | grep "^Reading package lists..." | wc -l)

# Notify admin if there are security updates
if [ "$SECURITY_UPDATES" -gt 0 ]; then
    echo "Security patches applied. Please review the updates." | mail -s "Security Patch Alert" admin@example.com
fi

echo "Security patch applied and notifies the admin."
```
