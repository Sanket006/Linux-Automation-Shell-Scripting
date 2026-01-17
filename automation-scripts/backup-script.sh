#!/bin/bash
# Backup Script
# Creates timestamped backups

SOURCE_DIR="/home"
BACKUP_DIR="/backup"
TIMESTAMP=$(date +%F-%H-%M)

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/backup-$TIMESTAMP.tar.gz $SOURCE_DIR

echo "Backup completed: backup-$TIMESTAMP.tar.gz"
