# ⏰ Cron Basics

## 📌 Purpose
Linux systems must run administrative tasks continuously without human intervention. Cron is the system daemon that handles this scheduling. This document introduces how cron works, how to read and write scheduling syntax, and the commands used to configure the crontab configuration for users.

---

## ⚙️ Core Concepts & Commands

### The Cron Daemon (`crond`)
The `crond` service runs continuously in the background. Every minute, it wakes up and checks user crontab files (`/var/spool/cron/crontabs/` or `/var/spool/cron/`) and system-wide crontab directories (`/etc/crontab`, `/etc/cron.d/`) to execute commands that match the current time.

### Crontab Commands
Users manage their schedule file using the `crontab` utility:
*   `crontab -e`: Opens the current user's crontab in the default text editor (e.g., nano or vi) to add, modify, or delete tasks.
*   `crontab -l`: Lists all currently scheduled cron jobs for the logged-in user.
*   `crontab -r`: Deletes the user's entire crontab file (use with caution!).

### Crontab Syntax
A crontab line consists of 5 time fields followed by the absolute command to execute:
```text
* * * * * /path/to/command
| | | | |
| | | | └── Day of the week (0 - 7, where 0 and 7 are Sunday)
| | | └──── Month (1 - 12)
| | └────── Day of the month (1 - 31)
| └──────── Hour (0 - 23)
└────────── Minute (0 - 59)
```

#### Special Characters:
- `*` (Asterisk): Match any value (e.g., `*` in the hour field means "every hour").
- `,` (Comma): Define a list of values (e.g., `1,15,30` in the minute field).
- `-` (Hyphen): Define a range of values (e.g., `1-5` in the day of week field for Monday to Friday).
- `/` (Slash): Specify step/increment values (e.g., `*/15` in the minute field means "every 15 minutes").

---

## 💻 Practical Examples

### 1. Daily Midnight Cleanup
Run a cleanup script every night at exactly midnight:
```bash
0 0 * * * /usr/local/bin/cleanup.sh
```

### 2. Every 15 Minutes Checks
Run a service status health-check command every 15 minutes:
```bash
*/15 * * * * /usr/local/bin/health-check.sh
```

### 3. Business Hours Run
Run a database synchronization script at 8 AM and 5 PM, Monday through Friday:
```bash
0 8,17 * * 1-5 /usr/local/bin/sync-db.sh
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Troubleshooting Cron Environment Issues
A very common problem is that a script works when run manually, but fails when executed via cron. This happens because **cron runs with a very minimal environment**. It does not load your user's `.bashrc` or `.bash_profile`, meaning variables like `$PATH` are limited, and commands like `docker` or `aws` might not be found.
- **Best Practice Resolution:**
  1. Always use **absolute paths** inside your crontab and scripts (e.g., `/usr/bin/docker` instead of `docker`).
  2. Declare the shell and environment path variables at the very top of your user crontab:
     ```text
     SHELL=/bin/bash
     PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
     
     0 2 * * * /usr/local/bin/backup-db.sh
     ```

---

## 💡 Interview Q&A & Tips

**Q1: How do you redirect both standard output (stdout) and standard error (stderr) to a log file in a cron job?**
*   **Answer:** You append `>> /path/to/log.log 2>&1` to the command.
    - `>> /path/to/log.log` appends standard output to the file.
    - `2>&1` redirects standard error (file descriptor 2) to the same location as standard output (file descriptor 1).
    - If you don't redirect output, the cron daemon will attempt to email any stdout/stderr output to the local user account (via mailx/postfix), which can fill up the system mailbox or disk.

**Q2: How do you run a cron job on the first day of every month?**
*   **Answer:** Set the day-of-month field to `1`. E.g., to run at 3 AM on the 1st of every month:
    `0 3 1 * * /path/to/script.sh`
