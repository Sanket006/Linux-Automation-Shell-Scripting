# 🛠️ System Troubleshooting

Troubleshooting is the process of **systematically finding the root cause of a problem** and fixing it. In a production environment, this must be done quickly and carefully — running random commands without a methodology wastes time and can make things worse. This document teaches you a structured approach, the right commands to use at each step, and how to read what those commands tell you.

---

## The Troubleshooting Mindset

Before touching any command, think through these questions:

1. **What exactly is broken?** — Be specific. "The app is down" is not enough. Is it the service, the network, the disk, the database?
2. **Who and what is affected?** — Is it one user, all users, one service, the whole server?
3. **Did anything change recently?** — Deployments, config updates, cron jobs, or OS updates are the most common triggers.
4. **What does the monitoring alert say?** — Start from the evidence you have, not from assumptions.
5. **Fix → Verify → Monitor** — After applying a fix, confirm the problem is actually resolved and watch for recurrence.

> 💡 Good troubleshooting is about **methodology**, not memorizing commands. The right process finds the root cause; a random series of commands often wastes time or creates new problems.

---

## Step 1: Basic System Health Check

Always start here. These commands give you an instant snapshot of the server's state.

```bash
# How long has the server been up? What is the CPU load?
uptime

# Who is logged in as?
whoami

# What is this server's hostname?
hostname

# What is today's date and time? (check for timezone issues)
date
```

**What to look for:**
- `uptime` output: `load average: 5.20, 3.10, 2.80` — if load average is higher than your CPU core count, the server is under CPU pressure.
- A very short uptime (e.g., "1 minute") means the server recently rebooted unexpectedly.

---

## CPU Issues

### Symptoms
- Application is slow or timing out.
- SSH connection is sluggish.
- High load average in `uptime`.

### Investigate

```bash
# Real-time process and CPU monitor
top

# Enhanced interactive viewer (if installed)
htop

# Find the top 5 CPU-consuming processes
ps aux --sort=-%cpu | head -n 6
```

**What to look for:**
- Which process is consuming the most CPU?
- Is the `%wa` (wait) column high in `top`? High I/O wait means the CPU is idle but waiting for disk reads/writes.
- Are there many processes in zombie (`Z`) or uninterruptible sleep (`D`) state?

### Fix

```bash
# Gracefully terminate a misbehaving process
kill <PID>

# Force-terminate if it doesn't respond (data loss risk)
kill -9 <PID>

# Restart the service properly via systemd
sudo systemctl restart myapp
```

---

## Memory Issues

### Symptoms
- Application crashes with "out of memory" errors.
- Server becomes unresponsive.
- `dmesg` shows "OOM killer" messages.

### Investigate

```bash
# Show RAM and swap usage
free -h

# Memory and CPU statistics over time
vmstat 2 5

# Check kernel OOM killer events
dmesg -T | grep -i 'oom\|kill'
```

**What to look for:**
- Is the `available` column in `free -h` very low (< 10%)?
- Is swap usage at or near 100%? This causes severe slowdowns.
- Does `dmesg` show `Out of memory: Kill process` messages?

### Fix

```bash
# Restart the leaking application
sudo systemctl restart myapp

# Add swap as a temporary buffer (not a permanent solution)
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile
sudo mkswap /swapfile && sudo swapon /swapfile
```

---

## Disk Space Issues

### Symptoms
- "No space left on device" errors.
- Services fail to start or write logs.
- Database writes fail.

### Investigate

```bash
# Check which partition is full
df -h

# Find the largest directories/files in a partition
sudo du -ah /var | sort -rh | head -n 15

# Check if disk is full due to inode exhaustion (not actual space)
df -i

# Find deleted files still held open by running processes
sudo lsof +L1
```

**What to look for:**
- Which partition shows `Use%` at 100% in `df -h`?
- Is `/var/log` or `/var/lib/docker` consuming most of the space?
- Does `df -i` show 100% inode usage even if disk space is available?

### Fix

```bash
# Clean old system logs (keep last 7 days)
sudo journalctl --vacuum-time=7d

# Find and delete log files older than 30 days
find /var/log -name "*.log" -mtime +30 -delete

# If a process is holding a deleted file open, restart it
sudo systemctl restart myapp
```

---

## Service Not Running

### Symptoms
- Application endpoint returns no response.
- Port is not listening.
- systemd shows the service as `failed` or `inactive`.

### Investigate

```bash
# Check the current state and recent log output
sudo systemctl status nginx

# View the last 50 log lines for the service
journalctl -u nginx -n 50 --no-pager

# Check if the expected port is listening
sudo ss -tulnp | grep :80
```

**What to look for:**
- The `Active:` line in `systemctl status` — look for `failed`, `inactive`, or an exit code.
- The log lines below the status — they usually contain the exact error message.
- Is another process already using the same port? (Port conflict)

### Fix

```bash
# Restart the service
sudo systemctl restart nginx

# If a config was changed, validate it first
sudo nginx -t           # Nginx config test
sudo systemctl daemon-reload  # If the unit file was changed
```

---

## Network & Connectivity Issues

### Symptoms
- "Connection refused" or "Connection timed out" errors.
- An API call fails between two services.
- SSH access is not working.

### Investigate

```bash
# Is the server reachable at all?
ping -c 4 <target-ip>

# Does DNS resolve correctly?
nslookup api.myapp.com

# Is the expected port listening on this server?
sudo ss -tulnp | grep :8080

# Can this server reach the target port?
nc -zv <target-ip> <port>

# Follow the network path (where is traffic dropping?)
traceroute <target-ip>
```

**What to look for:**
- `ping` fails → network routing or firewall issue.
- `ping` works but port is unreachable → service is not running, or firewall is blocking the port.
- `nslookup` returns wrong IP → DNS misconfiguration.

---

## Permission Issues

### Symptoms
- "Permission denied" errors in logs.
- A service fails with "cannot open file" errors.
- A user cannot access a directory they should be able to.

### Investigate

```bash
# Check file ownership and permissions
ls -la /path/to/file

# Check what user a service runs as
systemctl show nginx -p User

# Check the current user's groups
id username
```

### Fix

```bash
# Fix ownership
sudo chown -R www-data:www-data /var/www/html

# Fix permissions
sudo chmod -R 755 /var/www/html
```

---

## Log-Based Troubleshooting

Logs are the most reliable source of truth during an incident. Know where to look.

### Important Log Locations

| Log | Location |
| :--- | :--- |
| System logs | `/var/log/syslog` (Ubuntu) or `/var/log/messages` (RHEL) |
| Authentication logs | `/var/log/auth.log` |
| Kernel messages | `dmesg` or `journalctl -k` |
| Service logs | `journalctl -u <service-name>` |
| Boot logs | `journalctl -b` |

### Useful Log Commands

```bash
# Stream logs for a service in real-time
journalctl -u nginx -f

# Show logs since the last boot
journalctl -b

# Show all ERROR/WARNING lines across system logs
journalctl -p err..warning

# Search a log file for a specific error
grep -i "error" /var/log/nginx/error.log | tail -n 20

# Live-monitor a log file and filter for errors
tail -f /var/log/syslog | grep -iE 'error|critical|warning'
```

---

## Quick Troubleshooting Checklist

When something breaks, run through this list:

- ✅ Is the server up? (`uptime`, `ping`)
- ✅ Is disk full? (`df -h`)
- ✅ Is memory exhausted? (`free -h`, `dmesg | grep -i oom`)
- ✅ Is the service running? (`systemctl status <service>`)
- ✅ Is the port listening? (`ss -tulnp`)
- ✅ Are there errors in the logs? (`journalctl -u <service> -n 50`)
- ✅ Is DNS working? (`nslookup <hostname>`)
- ✅ Is there a permission issue? (`ls -la`, `id`, `chown`, `chmod`)

---

## Best Practices

- Always check logs before making changes — the error message usually tells you exactly what is wrong.
- Make one change at a time. If you change multiple things simultaneously, you will not know which one fixed it.
- Document what you did and why — write down the root cause and the fix.
- After fixing, monitor for at least 10–15 minutes to confirm the issue does not return.
- Never run `rm -rf` without double-checking the path first.

---

## Interview Q&A

**Q1: How do you troubleshoot a service that fails to start?**
- **Answer:**
  1. Run `systemctl status <service>` — check the `Active:` state and read the last few log lines shown.
  2. Run `journalctl -u <service> -n 100 --no-pager` for full recent logs.
  3. Look for the specific error — common causes are: config syntax error, port already in use, missing file, permission denied.
  4. If a config was changed, validate it (e.g., `nginx -t`) before restarting.
  5. Run `systemctl daemon-reload` if the unit file was modified, then restart.

**Q2: What do you check first when an application is suddenly down?**
- **Answer:** Start with the service: `systemctl status <app>`. If it is failed, read the logs with `journalctl -u <app>`. Simultaneously check disk (`df -h`) and memory (`free -h`) — both running out will silently kill applications. Then check if the port is listening (`ss -tulnp`) and if the server can be reached from outside (firewall, security groups).

**Q3: What is the OOM Killer and how do you detect if it ran?**
- **Answer:** The OOM (Out-Of-Memory) Killer is a Linux kernel mechanism that terminates processes to free RAM when the system runs critically low on memory. To check if it ran: `dmesg -T | grep -i 'oom\|kill'`. The output shows which process was killed and when. The long-term fix is to add more RAM, optimize the application's memory usage, or configure swap to give the kernel more breathing room.

---

> 🔖 **Note:** Troubleshooting is the skill that separates a confident DevOps engineer from a beginner. The ability to systematically diagnose and fix production issues under pressure is one of the most valued skills in any SRE or infrastructure role. Practice with real systems, not just theory.
