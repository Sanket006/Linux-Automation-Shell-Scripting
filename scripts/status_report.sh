#!/bin/bash
# ============================================================
# Script: status_report.sh
# Purpose: Generate a comprehensive server status report
# Usage: ./status_report.sh
# Schedule: 0 8 * * * /path/to/status_report.sh   (daily at 8:00 AM)
# ============================================================

# --- Collect system info ---
HOSTNAME=$(hostname)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
UPTIME=$(uptime -p)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
TOTAL_MEM=$(free -h | awk '/^Mem:/ {print $2}')
USED_MEM=$(free -h | awk '/^Mem:/ {print $3}')
FREE_MEM=$(free -h | awk '/^Mem:/ {print $4}')
DISK_INFO=$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 " full)"}')
TOP_PROCESSES=$(ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %-20s CPU: %5s%%  MEM: %5s%%\n", $11, $3, $4}')
LOGGED_IN_USERS=$(who | wc -l)
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date +%b\ %e)" | wc -l || echo "N/A")

# --- Check key services ---
check_service_status() {
    local SVC=$1
    if systemctl is-active --quiet "$SVC" 2>/dev/null; then
        echo "✅ Running"
    else
        echo "❌ STOPPED"
    fi
}

NGINX_STATUS=$(check_service_status nginx)
MYSQL_STATUS=$(check_service_status mysql)
DOCKER_STATUS=$(check_service_status docker)

# --- Generate the report ---
REPORT=$(cat <<EOF
====================================================
  SERVER STATUS REPORT — $HOSTNAME
  Generated: $DATE
====================================================

📋 SYSTEM OVERVIEW
  Uptime:       $UPTIME
  Load Average: $LOAD_AVG
  Users Online: $LOGGED_IN_USERS

💾 MEMORY
  Total:  $TOTAL_MEM
  Used:   $USED_MEM
  Free:   $FREE_MEM

💿 DISK
  Root:   $DISK_INFO

⚙️  SERVICES
  Nginx:  $NGINX_STATUS
  MySQL:  $MYSQL_STATUS
  Docker: $DOCKER_STATUS

🔥 TOP CPU PROCESSES
$TOP_PROCESSES

🔒 SECURITY
  Failed SSH logins today: $FAILED_LOGINS

====================================================
EOF
)

echo "$REPORT"

# Save to file
echo "$REPORT" > "/var/log/status_report_$(date +%Y%m%d).txt"

# Optional: send via email
# echo "$REPORT" | mail -s "Daily Status Report: $HOSTNAME" admin@example.com
