#!/bin/bash
# ============================================================
# Script: log_cleanup.sh
# Purpose: Archive and clean up old log files
# Usage: ./log_cleanup.sh /var/log/myapp 7
#   Arg 1: Log directory to clean (default: /var/log/myapp)
#   Arg 2: Retention period in days (default: 7)
# ============================================================

set -euo pipefail

LOG_DIR="${1:-/var/log/myapp}"     # Directory to clean
RETENTION_DAYS="${2:-7}"            # Keep logs for this many days
ARCHIVE_DIR="/var/log/archives"     # Where to store compressed archives
SCRIPT_LOG="/var/log/log_cleanup.log"

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
log() { echo "[$(timestamp)] $1" | tee -a "$SCRIPT_LOG"; }

# --- Validate input ---
if [ ! -d "$LOG_DIR" ]; then
    log "ERROR: Directory $LOG_DIR does not exist."
    exit 1
fi

# --- Create archive directory if it doesn't exist ---
mkdir -p "$ARCHIVE_DIR"

log "Starting log cleanup for: $LOG_DIR"
log "Retention period: $RETENTION_DAYS days"

# --- Archive logs older than 1 day but newer than retention period ---
log "--- Archiving logs ---"
ARCHIVE_NAME="logs_$(date +%Y%m%d_%H%M%S).tar.gz"

find "$LOG_DIR" -name "*.log" -mtime +1 -mtime -"$RETENTION_DAYS" | while read -r FILE; do
    log "Archiving: $FILE"
done

# Create a compressed archive
find "$LOG_DIR" -name "*.log" -mtime +1 -mtime -"$RETENTION_DAYS" \
    -exec tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" {} + 2>/dev/null || true

log "Archive created: $ARCHIVE_DIR/$ARCHIVE_NAME"

# --- Delete logs older than retention period ---
log "--- Deleting old logs (older than $RETENTION_DAYS days) ---"
DELETED_COUNT=0

while IFS= read -r FILE; do
    log "Deleting: $FILE"
    rm -f "$FILE"
    DELETED_COUNT=$((DELETED_COUNT + 1))
done < <(find "$LOG_DIR" -name "*.log" -mtime +"$RETENTION_DAYS")

log "Deleted $DELETED_COUNT old log files."

# --- Show disk space freed ---
log "Current disk usage of $LOG_DIR: $(du -sh "$LOG_DIR" | cut -f1)"
log "Log cleanup complete."
