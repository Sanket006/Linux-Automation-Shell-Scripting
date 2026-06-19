# 🧾 Linux Commands Reference

## 📌 Overview
This directory serves as a comprehensive reference guide for essential Linux commands. Understanding these commands is a fundamental requirement for DevOps engineering, system administration, and infrastructure management. Every command documented here is framed in the context of real-world production environments, highlighting not just the syntax, but **when, why, and how** to use it.

---

## 📂 Directory Contents

| Category | File | Description | Key Commands Covered |
| :--- | :--- | :--- | :--- |
| **📁 File & Directory** | [`file-management.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/file-management.md) | Managing, finding, and inspecting files & directories. | `ls`, `cp`, `mv`, `rm`, `find`, `stat` |
| **🔐 Permissions & Ownership** | [`permissions.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/permissions.md) | Securing resources and debugging permission errors. | `chmod`, `chown`, `chgrp`, `umask` |
| **⚙️ Process Management** | [`process-management.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/process-management.md) | Monitoring resource consumption and system performance. | `ps`, `top`, `htop`, `kill`, `nice`, `uptime` |
| **👥 User & Group** | [`user-group-management.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/user-group-management.md) | Access control and managing system user accounts. | `useradd`, `usermod`, `groupadd`, `passwd` |
| **🌐 Networking** | [`networking.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/networking.md) | Analyzing system connectivity, sockets, and ports. | `ip`, `ss`, `ping`, `curl`, `wget` |
| **💽 Disk & Storage** | [`disk-management.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/disk-management.md) | Analyzing storage capacity and mounting filesystems. | `df`, `du`, `lsblk`, `mount`, `umount` |
| **🛠️ Troubleshooting** | [`troubleshooting.md`](file:///c:/Users/Lenovo/Sanket%20Personal/DevOps/Linux-Automation-Shell-Scripting/commands/troubleshooting.md) | Inspecting logs, system events, and service issues. | `journalctl`, `dmesg`, `systemctl` |

---

## 🎯 Learning Outcomes
After reviewing this section, you will be able to:
- Confidently navigate and manage the Linux operating system from the CLI.
- Secure files and directory paths using correct group, owner, and mode permissions.
- Inspect running processes to identify memory or CPU performance bottlenecks.
- Troubleshoot network connectivity and storage-related production issues.
- Retrieve and analyze service and kernel logs to debug application failures.

---

## 🚀 DevOps Advantage
Modern Cloud Platforms, Containers (Docker), and CI/CD Runners (Jenkins, GitHub Actions) run almost exclusively on Linux. Direct command-line competency enables DevOps engineers to:
- **Write Better Automation:** Commands form the building blocks of shell automation scripts.
- **Reduce Outage Duration:** Quickly finding the root cause of service failure or disk exhaustion.
- **Configure Environments Securely:** Restricting process permissions and user access following the principle of least privilege.

---

## ℹ️ How to Use & Next Steps
1. Navigate to the specific command file of interest.
2. Read the explanation and copy the command to test it inside a safe sandbox environment (e.g., local Ubuntu VM or AWS EC2 instance).
3. Try out the **Practical Examples** provided in each file.
4. Review the **Interview Q&A** sections to prepare for technical screenings.
