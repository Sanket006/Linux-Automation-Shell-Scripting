#!/bin/bash
# ============================================================
# Script: system_health_check.sh
# Purpose: Monitor system health and alert on high usage
# Usage: ./system_health_check.sh
# Schedule: */5 * * * * /path/to/system_health_check.sh
# ============================================================

set -euo pipefail

# --- Configuration ---
CPU_THRESHOLD=80      # Alert if CPU usage > 80%
MEM_THRESHOLD=85      # Alert if memory usage > 85%
DISK_THRESHOLD=90     # Alert if disk usage > 90%
LOG_FILE="/var/log/health_check.log"
ALERT_EMAIL="admin@example.com"

# --- Helper Functions ---
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

log() {
    echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

send_alert() {
    local SUBJECT=$1
    local MESSAGE=$2
    log "ALERT: $SUBJECT — $MESSAGE"
    # Uncomment below to send actual email alerts
    # echo "$MESSAGE" | mail -s "$SUBJECT" "$ALERT_EMAIL"
}

# --- Check CPU Usage ---
check_cpu() {
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1)
    CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc | awk '{printf "%d", $1}')

    log "CPU Usage: ${CPU_USAGE}%"

    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        send_alert "HIGH CPU ALERT" "CPU usage is at ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
    fi
}

# --- Check Memory Usage ---
check_memory() {
    TOTAL_MEM=$(free | grep Mem | awk '{print $2}')
    USED_MEM=$(free | grep Mem | awk '{print $3}')
    MEM_USAGE=$(( (USED_MEM * 100) / TOTAL_MEM ))

    log "Memory Usage: ${MEM_USAGE}%"

    if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
        send_alert "HIGH MEMORY ALERT" "Memory usage is at ${MEM_USAGE}% (threshold: ${MEM_THRESHOLD}%)"
    fi
}

# --- Check Disk Usage ---
check_disk() {
    while IFS= read -r LINE; do
        USAGE=$(echo "$LINE" | awk '{print $5}' | cut -d'%' -f1)
        MOUNT=$(echo "$LINE" | awk '{print $6}')

        log "Disk ($MOUNT): ${USAGE}% used"

        if [ "$USAGE" -gt "$DISK_THRESHOLD" ]; then
            send_alert "HIGH DISK ALERT" "Disk at $MOUNT is ${USAGE}% full (threshold: ${DISK_THRESHOLD}%)"
        fi
    done < <(df -h | grep -vE '^(Filesystem|tmpfs|udev)')
}

# --- Main Execution ---
log "============ Health Check Started ============"
check_cpu
check_memory
check_disk
log "============ Health Check Complete ============"
