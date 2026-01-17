#!/bin/bash
# Service Monitor Script
# Restarts service if not running

SERVICE="nginx"

if ! systemctl is-active --quiet $SERVICE; then
  echo "$SERVICE is down. Restarting..."
  systemctl restart $SERVICE
else
  echo "$SERVICE is running"
fi
