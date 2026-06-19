# 🐧 Linux Automation & Shell Scripting

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-0A0A0A?style=for-the-badge&logo=devdotto&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

*Hands-on Linux automation for DevOps — 7 production-ready scripts, cron scheduling, systemd services, command references across 7 domains, shell scripting from basics to error handling, and interview preparation*

</div>

---

## 📌 Overview

This repository is a structured, hands-on Linux learning resource tailored for DevOps and platform engineers. It bridges the gap between raw commands and production-grade automation. Inside, you will find:
- **Comprehensive Command Guides**: Detailed references with production tips across 7 core operating system domains.
- **Structured Scripting Tutorials**: Tutorials covering Bash script syntax from initial execution to advanced error trapping, scopes, and debugging.
- **Production-Ready Scripts**: 7 automation scripts solving actual administration tasks (backups, service monitoring, log rotation, and audits).
- **Daemon & Job Scheduling**: In-depth setup walkthroughs for Cron Jobs and systemd background services.
- **Interview Q&A Sets**: Structured, scenario-based questions to help you succeed in technical screenings.

Every script is runnable, every command is explained, and every concept is mapped directly to real DevOps use cases.

---

## 📁 Repository Structure

```
linux-automation-shell-scripting/
│
├── commands/                         # Linux command reference (7 domains)
│   ├── readme.md                     # Overview table of core commands
│   ├── file-management.md            # File manipulation & search (ls, cp, mv, find, stat)
│   ├── permissions.md                # Permission models & access control (chmod, chown, umask)
│   ├── process-management.md         # Resource analysis & signals (ps, top, kill, nice)
│   ├── user-group-management.md      # User administration & system files (/etc/passwd, useradd)
│   ├── networking.md                 # Connectivity troubleshooting (ip, ss, ping, curl)
│   ├── disk-management.md            # Partition management & inode exhaustion (df, du, mount)
│   └── troubleshooting.md            # Live logging & diagnostics (journalctl, dmesg)
│
├── shell-scripting/                  # Bash scripting — basics to advanced (9 topics)
│   ├── readme.md                     # Curricula map & learning outcomes
│   ├── basics.md                     # Interpreters, shebangs, execution methods
│   ├── variables-input.md            # Parameters, env variables, arguments ($@, $#)
│   ├── conditions.md                 # If/else conditions, operators, cases
│   ├── loops.md                      # For, while, until, streaming file inputs
│   ├── functions.md                  # Scope isolation (local), modular log functions
│   ├── arrays.md                     # Collections, arrays, and key-value maps
│   ├── error-handling.md             # Fail-fast options (set -euo pipefail) & traps
│   ├── debugging.md                  # Execution tracing (set -x, Selective trace)
│   ├── best-practices.md             # Clean code, ShellCheck lint rules
│   └── real-world-examples.md        # 20 practical scripts (log rotation, backups)
│
├── automation-scripts/               # 7 real-world production-ready scripts
│   ├── readme.md                     # Execution permissions & cron scheduling guides
│   ├── system-health-check.sh        # CPU, memory, disk, uptime → /var/log/system_health.log
│   ├── disk-usage-alert.sh           # Partition space threshold alert (default: 80%)
│   ├── log-cleanup.sh                # find + rm log files older than N days (default: 7)
│   ├── backup-script.sh              # tar.gz timestamped backups of /home → /backup
│   ├── service-monitor.sh            # systemctl status check + auto-restart (default: nginx)
│   ├── user-audit.sh                 # Audits users with active login shells and UID >= 1000
│   └── memory-monitor.sh             # Displays memory usage and alerts on high RAM

│
├── cronjobs/                         # Cron scheduling — basics + production examples
│   ├── readme.md                     # Overview of scheduling mechanisms
│   ├── cron-basics.md                # Crontab syntax, time fields, crontab commands
│   └── production-cron-examples.md   # flock locks, logging redirects, slack hooks
│
├── systemd-services/                 # systemd — basics + custom service creation
│   ├── readme.md                     # Overview of unit states & persistence
│   ├── systemd-basics.md             # Units, targets, systemctl commands, journalctl
│   └── custom-service-example.md     # Setup guide for custom health-check.service on boot
│
├── interview-questions/              # Linux + shell scripting interview Q&A
│   ├── readme.md                     # Study guide & communication tips
│   ├── linux-interview-questions.md  # 10 Q&A: permissions, processes, disk, networking
│   └── shell-scripting-interview.md  # 9 Q&A: variables, conditions, error handling, debug
│
├── docs/                             # Linux internals and reference notes
│   ├── readme.md                     # Conceptual outlines
│   ├── linux-filesystem-hierarchy.md # Filesystem Hierarchy Standard (FHS) directories
│   ├── terminal-vs-shell.md          # Visualizing terminal wrappers vs shell interpreters
│   ├── linux-internals.md            # Kernel space, syscalls, process fork/exec lifecycle
│   ├── linux-basics.md               # Detailed notes on shell environments & distros
│   ├── file-permissions.md           # Permissions theory & ACL parameters
│   ├── process-management.md         # Advanced process states & scheduling niceness
│   ├── user-group-management.md      # System accounts, shadow structure details
│   ├── networking-concepts.md        # Socket details, port checks & multi-server debug
│   ├── disk-memory-management.md     # Disk usage, filesystems & virtual memory
│   ├── systemd-services.md           # systemd unit definitions & daemon reloads
│   └── system-troubleshooting.md     # System errors tracing, dmesg, syslog filters
│
└── LICENSE                           # MIT License file
```

---

## 🗺️ DevOps Roadmap (4-Week Linux & Automation Guide)

If you are a fresher or entry-level DevOps engineer, follow this structured weekly roadmap using the resources in this repository to master Linux system administration and automation:

### 📅 Week 1: Linux Basics & Filesystem
*   **Goal:** Learn how Linux is structured, navigate directory layouts, and run commands.
*   **Study Materials:**
    *   [Linux Filesystem Hierarchy](docs/linux-filesystem-hierarchy.md) — Master the absolute paths (`/etc`, `/var`, `/bin`, etc.).
    *   [Terminal vs. Shell Concepts](docs/terminal-vs-shell.md) — Learn how displays map to interpreters.
    *   [Linux Basics Reference](docs/linux-basics.md) — Read about distributions and environment setups.
*   **Hands-on Practice:** Log into a VM/WSL, check configuration paths in `/etc`, and view system logs inside `/var/log`.

### 📅 Week 2: User Security, Permissions & Commands
*   **Goal:** Manage system accounts, configure secure file access, and solve permission blockers.
*   **Study Materials:**
    *   [File Permissions Theory](docs/file-permissions.md) & [Command Permissions](commands/permissions.md) — SUID, SGID, Sticky Bits, and `chmod`/`chgrp`.
    *   [User & Group Management](commands/user-group-management.md) & [Detailed Reference](docs/user-group-management.md) — System files (`/etc/passwd`, `/etc/shadow`) and account management.
    *   [File Management Commands](commands/file-management.md) — Navigating files with `find`, `grep`, and `tar`.
*   **Hands-on Practice:** Create a new user group, assign a folder to that group, enable the Sticky Bit, and configure an ACL to grant read-only access to a specific user.

### 📅 Week 3: Bash Shell Scripting & Error Handling
*   **Goal:** Automate manual steps using clean, error-tolerant, and trace-monitored scripts.
*   **Study Materials:**
    *   [Shell Scripting Basics & Loops](shell-scripting/readme.md) — Variables, conditionals, loops, functions, and arrays.
    *   [Error Handling Guide](shell-scripting/error-handling.md) — Fail-safe scripting configurations (`set -euo pipefail`) and traps.
    *   [Execution Debugging](shell-scripting/debugging.md) — Trace bugs using selective logging and `set -x`.
    *   [Real-World Shell Examples](shell-scripting/real-world-examples.md) — Study the 20 pre-written automation scripts.
*   **Hands-on Practice:** Write a script that checks if a directory exists, creates it if missing, writes a timestamp, and terminates gracefully on error.

### 📅 Week 4: Scheduling, Background Services & Troubleshooting
*   **Goal:** Deploy scripts as background services, run recurring jobs, and monitor system resources.
*   **Study Materials:**
    *   [Cron Jobs Scheduling](cronjobs/readme.md) — Crontab timing syntax, log redirection, and execution locks (`flock`).
    *   [systemd Service Units](systemd-services/readme.md) — Declaring unit configurations and auto-starting daemons on boot.
    *   [Process & Storage Management](commands/process-management.md) & [Disk/Memory Reference](docs/disk-memory-management.md) — System monitoring via `top`, `df`, `free`, and `vmstat`.
    *   [System Troubleshooting Reference](docs/system-troubleshooting.md) — System error tracing, `dmesg`, and `syslog` analysis.
*   **Hands-on Practice:** Create a custom systemd service to run a script, schedule a cron job to purge temporary logs, and use `df -h` to monitor storage.

### 🎯 Capstone: Portfolio Projects & Interview Preparation
*   **Goal:** Standardize your DevOps skillset and prepare for technical screening rounds.
*   **Hands-on Practice:** Run the 7 production-ready [Automation Scripts](automation-scripts/readme.md) inside a virtual machine or cloud instance.
*   **Interview Prep:** Review the scenario-based interview guides:
    *   [Linux OS Interview Q&A](interview-questions/linux-interview-questions.md)
    *   [Bash Scripting Interview Q&A](interview-questions/shell-scripting-interview.md)

---

## 🚀 Getting Started & Installation

To study, test, and run the scripts locally or on an EC2 instance, follow these steps:

### 1. Prerequisites
Ensure you are running a Linux distribution (e.g., Ubuntu, Debian, CentOS, RHEL). If you are using Windows, you can use **WSL2** (Windows Subsystem for Linux), a local Virtual Machine, or launch an AWS EC2 instance.

### 2. Clone the Repository
Clone the repository using Git and navigate to the directory:
```bash
git clone https://github.com/Sanket006/linux-automation-shell-scripting.git
cd linux-automation-shell-scripting
```

### 3. Folder Configurations
Some automation scripts write to system directories (like `/var/log` or `/backup`). Ensure your user has permissions, or run these scripts with administrative privileges (e.g., using `sudo`).

---

## ⚙️ Usage Guide

### Running Automation Scripts
To run any script in the [`automation-scripts/`](automation-scripts/readme.md) directory:

1.  **Grant Execution Permissions**:
    ```bash
    chmod +x automation-scripts/system-health-check.sh
    ```
2.  **Execute the Script**:
    ```bash
    # Execute directly
    ./automation-scripts/system-health-check.sh
    ```

---

### Scheduling Scripts with Cron
To schedule a script to run automatically in the background:
1.  Open the crontab editor:
    ```bash
    crontab -e
    ```
2.  Add a schedule. For example, to run the database backup script every night at 1:00 AM, appending log outputs to a file:
    ```bash
    0 1 * * * /absolute/path/to/automation-scripts/backup-script.sh >> /var/log/db_backup.log 2>&1
    ```

---

### Running as a Persistent Service (systemd)
To run a script continuously or start it on system boot:
1.  Copy or write a service unit configuration inside `/etc/systemd/system/` (e.g., `health-check.service`).
2.  Reload the daemon configurations:
    ```bash
    sudo systemctl daemon-reload
    ```
3.  Enable and start the service:
    ```bash
    sudo systemctl enable health-check.service --now
    ```
4.  Monitor status and logs:
    ```bash
    systemctl status health-check.service
    journalctl -u health-check.service -f
    ```

---

## 🤝 Contribution Guidelines

We welcome contributions to expand command references, add new scripting topics, or optimize automation scripts! To contribute:

1.  **Fork the Repository**: Create a fork of this repository to your GitHub account.
2.  **Create a Branch**: Create a feature branch with a descriptive name:
    ```bash
    git checkout -b feature/new-script-topic
    ```
3.  **Adhere to Code Standards**:
    - Include comments detailing script headers (Purpose, Usage, Inputs).
    - Enable fail-fast variables (`set -euo pipefail`) in all script submissions.
    - Always wrap variables in double quotes to prevent word-splitting.
4.  **Lint Your Scripts**: Verify your scripts against **ShellCheck** before committing:
    ```bash
    shellcheck automation-scripts/*.sh
    ```
5.  **Submit a Pull Request (PR)**: Open a PR detailing the changes and explaining the DevOps utility of the additions.

---

## 📄 License

This repository is licensed under the [MIT License](LICENSE). You are free to copy, modify, distribute, and run the code for personal or commercial purposes. See the license file for details.

---

## 👨‍💻 Author & Connect

**Sanket Ajay Chopade** — DevOps Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sanketchopade07)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sanket006)
