#!/bin/bash
# System Health Check Script
# Checks CPU, Memory, Disk, and Uptime

LOG_FILE="/var/log/system_health.log"

echo "===== System Health Check: $(date) =====" >> $LOG_FILE

echo "Uptime:" >> $LOG_FILE
uptime >> $LOG_FILE

echo "\nCPU Load:" >> $LOG_FILE
cat /proc/loadavg >> $LOG_FILE

echo "\nMemory Usage:" >> $LOG_FILE
free -h >> $LOG_FILE

echo "\nDisk Usage:" >> $LOG_FILE
df -h >> $LOG_FILE

echo "========================================" >> $LOG_FILE
