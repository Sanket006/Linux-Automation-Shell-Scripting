#!/bin/bash
# ============================================================
# Script: backup.sh
# Purpose: Backup MySQL databases and application files
# Usage: ./backup.sh
# Schedule: 0 2 * * * /path/to/backup.sh   (daily at 2:00 AM)
# ============================================================

set -euo pipefail

# --- Configuration ---
DB_HOST="localhost"
DB_USER="backup_user"
DB_PASS="your_secure_password"
DATABASES=("appdb" "userdb" "analyticsdb")
FILES_TO_BACKUP=("/var/www/myapp" "/etc/nginx")
BACKUP_ROOT="/mnt/backups"
RETENTION_DAYS=30
LOG_FILE="/var/log/backup.log"

# S3 Configuration (optional)
S3_BUCKET="s3://my-company-backups"
USE_S3=false   # Set to true to enable S3 upload

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

mkdir -p "$BACKUP_DIR"
log "=== Backup started: $TIMESTAMP ==="

# --- Database Backups ---
log "--- Backing up databases ---"
for DB in "${DATABASES[@]}"; do
    DUMP_FILE="$BACKUP_DIR/${DB}_${TIMESTAMP}.sql.gz"
    log "Dumping database: $DB"
    mysqldump \
        --host="$DB_HOST" \
        --user="$DB_USER" \
        --password="$DB_PASS" \
        --single-transaction \
        --routines \
        --triggers \
        "$DB" | gzip > "$DUMP_FILE"

    SIZE=$(du -sh "$DUMP_FILE" | cut -f1)
    log "✅ $DB backup complete: $DUMP_FILE ($SIZE)"
done

# --- File Backups ---
log "--- Backing up files ---"
for DIR in "${FILES_TO_BACKUP[@]}"; do
    if [ -d "$DIR" ]; then
        DIR_NAME=$(basename "$DIR")
        ARCHIVE="$BACKUP_DIR/${DIR_NAME}_${TIMESTAMP}.tar.gz"
        tar -czf "$ARCHIVE" "$DIR"
        SIZE=$(du -sh "$ARCHIVE" | cut -f1)
        log "✅ $DIR backed up: $ARCHIVE ($SIZE)"
    else
        log "⚠️  Directory not found, skipping: $DIR"
    fi
done

# --- Upload to S3 (if enabled) ---
if [ "$USE_S3" = true ]; then
    log "--- Uploading to S3: $S3_BUCKET ---"
    aws s3 sync "$BACKUP_DIR" "$S3_BUCKET/$TIMESTAMP/" --quiet
    log "✅ S3 upload complete."
fi

# --- Remove old backups ---
log "--- Removing backups older than $RETENTION_DAYS days ---"
find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +"$RETENTION_DAYS" | while read -r OLD_DIR; do
    log "Removing old backup: $OLD_DIR"
    rm -rf "$OLD_DIR"
done

TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
log "=== Backup complete. Total size: $TOTAL_SIZE ==="
