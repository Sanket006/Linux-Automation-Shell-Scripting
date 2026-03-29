# 🐧 Linux Automation & Shell Scripting

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-0A0A0A?style=for-the-badge&logo=devdotto&logoColor=white)

*Hands-on Linux automation for DevOps — 6 production-ready scripts, cron scheduling, systemd services, command references across 7 domains, shell scripting from basics to error handling, and interview prep*

</div>

---

## 📌 Overview

A structured, hands-on Linux learning repository built for DevOps engineers — covering everything from core Linux commands and shell scripting fundamentals to real automation scripts, cron jobs, systemd services, and interview preparation. Every script is runnable, every concept tied to a real DevOps use case.

---

## 📁 Repository Structure

```
linux-automation-shell-scripting/
│
├── commands/                        # Linux command reference (7 domains)
│   ├── file-management.md           # ls, cp, mv, rm, find, stat
│   ├── permissions.md               # chmod, chown, chgrp, umask
│   ├── process-management.md        # ps, top, htop, kill, nice
│   ├── user-group-management.md     # useradd, usermod, groupadd, /etc/passwd
│   ├── networking.md                # ip, ss, ping, curl, wget
│   ├── disk-management.md           # df, du, lsblk, mount, umount
│   └── troubleshooting.md           # journalctl, systemctl, dmesg
│
├── shell-scripting/                 # Bash scripting — basics to advanced (9 topics)
│   ├── basics.md                    # Shebang, execution, comments
│   ├── variables-input.md           # Variables, $1/$2, read, env vars
│   ├── conditions.md                # if/elif/else, case, exit codes
│   ├── loops.md                     # for, while, until, infinite loops
│   ├── functions.md                 # Function syntax, arguments, reuse
│   ├── arrays.md                    # Arrays, string iteration
│   ├── error-handling.md            # set -e, trap, exit codes, logging
│   ├── debugging.md                 # set -x, debug logs
│   └── best-practices.md            # Clean, maintainable, production-safe scripts
│
├── automation-scripts/              # 6 real-world production-ready scripts
│   ├── system-health-check.sh       # CPU, memory, disk, uptime → /var/log/system_health.log
│   ├── disk-usage-alert.sh          # df -h threshold alert (default: 80%)
│   ├── log-cleanup.sh               # find + rm logs older than N days (default: 7)
│   ├── backup-script.sh             # tar.gz timestamped backup of /home → /backup
│   ├── service-monitor.sh           # systemctl check + auto-restart (default: nginx)
│   └── user-audit.sh                # List users with UID >= 1000 from /etc/passwd
│
├── cronjobs/                        # Cron scheduling — basics + production examples
│   ├── cron-basics.md               # Crontab syntax, cron fields, crontab commands
│   └── production-cron-examples.md  # 4 real production cron schedules
│
├── systemd-services/                # systemd — basics + custom service creation
│   ├── systemd-basics.md            # Units, targets, systemctl commands, journalctl
│   └── custom-service-example.md    # health-check.service file — run script on boot
│
├── interview-questions/             # Linux + shell scripting interview Q&A
│   ├── linux-interview-questions.md # 10 Q&A: permissions, processes, disk, networking
│   └── shell-scripting-interview.md # 9 Q&A: variables, conditions, error handling, debug
│
└── docs/                            # Linux internals and reference notes
    ├── linux-filesystem.md          # /bin, /sbin, /etc, /var, /home, /usr, /tmp
    ├── terminal-vs-shell.md         # Terminal vs shell — key differences
    └── linux-internals.md           # Boot process, kernel vs user space, process lifecycle
```

---

## 🤖 Automation Scripts

Six ready-to-run scripts covering the most common DevOps automation tasks:

### `system-health-check.sh`
Logs uptime, CPU load, memory, and disk usage to `/var/log/system_health.log` with a timestamp header.
```bash
# Output to: /var/log/system_health.log
uptime | free -h | df -h | cat /proc/loadavg
```

### `disk-usage-alert.sh`
Reads all `/dev` partitions via `df -h`, extracts usage percentages with `awk + sed`, and warns on any partition at or above 80%.
```bash
THRESHOLD=80
# Parses: df -h | grep '^/dev'
# Output: "Warning: /dev/xvda1 is 85% full"
```

### `log-cleanup.sh`
Finds and deletes `.log` files older than 7 days from `/var/log` using `find -mtime`.
```bash
LOG_DIR="/var/log"
DAYS=7
find $LOG_DIR -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;
```

### `backup-script.sh`
Creates a timestamped `.tar.gz` backup of `/home` into `/backup/` — directory is auto-created if missing.
```bash
SOURCE_DIR="/home"
BACKUP_DIR="/backup"
TIMESTAMP=$(date +%F-%H-%M)
tar -czf $BACKUP_DIR/backup-$TIMESTAMP.tar.gz $SOURCE_DIR
```

### `service-monitor.sh`
Checks if `nginx` is active via `systemctl is-active --quiet` — restarts it automatically if down.
```bash
SERVICE="nginx"
if ! systemctl is-active --quiet $SERVICE; then
  systemctl restart $SERVICE
fi
```

### `user-audit.sh`
Lists all regular user accounts (UID ≥ 1000) by parsing `/etc/passwd` with `awk`.
```bash
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```

### Run Any Script
```bash
chmod +x script-name.sh
./script-name.sh
```

---

## ⏰ Cron Scheduling

### Crontab Syntax

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0–7, 0=Sunday)
│ │ │ └──── Month (1–12)
│ │ └────── Day of month (1–31)
│ └──────── Hour (0–23)
└────────── Minute (0–59)
```

### Production Cron Examples

```bash
# Daily system health check at 9 AM
0 9 * * * /scripts/system-health-check.sh >> /var/log/health.log 2>&1

# Disk monitoring every hour
0 * * * * /scripts/disk-usage-alert.sh

# Weekly log cleanup (Sunday at 2 AM)
0 2 * * 0 /scripts/log-cleanup.sh

# Daily backup at 1 AM
0 1 * * * /scripts/backup-script.sh
```

> Always redirect cron output: `command >> /var/log/cron.log 2>&1`

---

## ⚙️ systemd Services

### Common Commands

```bash
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl status nginx
systemctl enable nginx       # start on boot
systemctl disable nginx      # remove from boot
journalctl -u nginx          # service logs
journalctl -xe               # recent errors
```

### Create a Custom Service

Create `/etc/systemd/system/health-check.service`:

```ini
[Unit]
Description=System Health Check Service
After=network.target

[Service]
ExecStart=/scripts/system-health-check.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl enable health-check.service
systemctl start  health-check.service
systemctl status health-check.service
```

**Restart policies:** `always` | `on-failure` | `no`

---

## 📋 Command Reference Summary

| Domain | Key Commands | DevOps Use Case |
|---|---|---|
| **File management** | `ls`, `cp`, `mv`, `rm`, `find`, `stat` | Log handling, deployment files, cleanup |
| **Permissions** | `chmod`, `chown`, `chgrp`, `umask` | Fix deploy/service permission errors |
| **Process management** | `ps`, `top`, `htop`, `kill`, `nice` | Identify CPU/memory bottlenecks |
| **User management** | `useradd`, `usermod`, `passwd` | CI/CD agent access control |
| **Networking** | `ip`, `ss`, `ping`, `curl`, `wget` | Debug app connectivity and port issues |
| **Disk management** | `df`, `du`, `lsblk`, `mount` | Prevent disk-full production outages |
| **Troubleshooting** | `journalctl`, `dmesg`, `systemctl` | Production outage investigation |

---

## 🐚 Shell Scripting Topics

| File | Concept | Key Example |
|---|---|---|
| `basics.md` | Shebang, execution | `#!/bin/bash` |
| `variables-input.md` | `$1`, `read`, env vars | `name=$1` |
| `conditions.md` | `if/elif/case`, exit codes | `if [ $1 -gt 80 ]` |
| `loops.md` | `for`, `while`, `until` | `for i in {1..5}` |
| `functions.md` | Reusable functions | `check_disk() { df -h; }` |
| `arrays.md` | Arrays, iteration | `arr=(one two three)` |
| `error-handling.md` | `set -e`, `trap` | `command \|\| echo "Failed"` |
| `debugging.md` | `set -x` | Step-through execution tracing |
| `best-practices.md` | Logging, validation | No hardcoded values |

---

## 🎯 Interview Q&A Highlights

### Linux
- `df` vs `du` — `df` shows filesystem-level usage, `du` shows directory/file-level usage
- `ss` vs `netstat` — `ss` is modern, faster; `netstat` is legacy
- What to do when disk is full — check `df`, `du`, clean logs, extend if needed
- Process vs service — process is a running program; service is a long-running background process managed by systemd

### Shell Scripting
- What is a shebang — tells the OS which interpreter to use (`#!/bin/bash`)
- Exit codes — `0` = success, non-zero = failure; used for conditional logic
- How to debug a script — `set -x` for trace output, `set -e` to exit on error
- How to handle failures — `set -e`, `trap`, `|| echo "Failed"`, logging

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/Sanket006/linux-automation-shell-scripting.git
cd linux-automation-shell-scripting

# 1. Study Linux commands
cat commands/file-management.md

# 2. Learn shell scripting concepts
cat shell-scripting/basics.md

# 3. Run automation scripts
chmod +x automation-scripts/system-health-check.sh
./automation-scripts/system-health-check.sh

# 4. Schedule with cron
crontab -e
# Add: 0 9 * * * /path/to/system-health-check.sh >> /var/log/health.log 2>&1

# 5. Revise for interviews
cat interview-questions/linux-interview-questions.md
```

---

## 🔗 Related Projects

| Repo | Description |
|---|---|
| [jenkins-cicd-pipelines](https://github.com/Sanket006/jenkins-cicd-pipelines) | Jenkins pipelines that use shell scripts in build and deploy stages |
| [terraform-aws-iac](https://github.com/Sanket006/terraform-aws-iac) | Terraform provisioners use `local-exec` and `remote-exec` shell scripts |
| [student-app-kubernetes](https://github.com/Sanket006/student-app-kubernetes) | Kubernetes manifests deployed via `kubectl apply` shell commands |

---

## 👨‍💻 Author

**Sanket Ajay Chopade** — DevOps Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sanketchopade07)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/Sanket006)
