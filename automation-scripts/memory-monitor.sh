#!/bin/bash
# Memory Monitoring Script
# Displays memory usage and alerts on high usage

THRESHOLD=80

USED=$(free | awk 'NR==2{printf "%.0f", $3*100/$2 }')

if [ "$USED" -gt "$THRESHOLD" ]; then
  echo "ALERT: High memory usage detected: ${USED}%"
else
  echo "OK: Memory usage is ${USED}%"
fi