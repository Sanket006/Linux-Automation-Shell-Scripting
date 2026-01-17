#!/bin/bash
# Log Cleanup Script
# Deletes logs older than defined days

LOG_DIR="/var/log"
DAYS=7

find $LOG_DIR -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;

echo "Old logs cleaned successfully"
