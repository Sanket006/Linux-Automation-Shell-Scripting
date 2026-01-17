#!/bin/bash
# Disk Usage Alert Script
# Alerts when disk usage crosses threshold

THRESHOLD=80

while read -r line; do
  usage=$(echo $line | awk '{print $5}' | sed 's/%//g')
  partition=$(echo $line | awk '{print $1}')

  if [ "$usage" -ge "$THRESHOLD" ]; then
    echo "Warning: $partition is ${usage}% full"
  fi
done < <(df -h | grep '^/dev')
