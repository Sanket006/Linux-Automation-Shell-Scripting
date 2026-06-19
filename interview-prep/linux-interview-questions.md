# 🐧 Linux Interview Questions (DevOps Focus)

## 📌 Purpose
This document contains commonly asked Linux systems engineering and administration questions tailored for DevOps, Cloud, and SRE roles. Rather than simple definition-based answers, this guide provides structured responses that show conceptual depth, real-world troubleshooting experience, and command mastery.

---

## ⚙️ Core Questions & Answers

### 1. Linux Basics

#### **Q1. What is Linux and why is it dominant in DevOps?**
*   **Answer**: Linux is an open-source, Unix-like operating system kernel. It is dominant in DevOps because:
    *   **Resource Efficiency**: It is lightweight and can run without a Graphical User Interface (GUI), saving CPU and memory.
    *   **Open Source & Flexibility**: There are no licensing fees, allowing teams to scale thousands of virtual machines easily.
    *   **Automation & CLI**: Everything in Linux can be configured and automated via the command line and configuration text files.
    *   **Container Support**: Linux namespaces and cgroups form the foundation of modern container technologies like Docker and Kubernetes.

#### **Q2. What is the difference between Linux and Unix?**
*   **Answer**:
    *   **Unix** is a proprietary operating system family originally developed by AT&T Bell Labs in the 1970s (e.g., AIX, Solaris, HP-UX). It is commercial software requiring licenses.
    *   **Linux** is an open-source clone of Unix created by Linus Torvalds in 1991. It is free, community-driven, and compatible with Unix standards, but does not share any code with the original Unix OS.

---

### 2. Files & Permissions

#### **Q3. Explain the Linux permission model and how to change permissions.**
*   **Answer**: Linux assigns permissions to three scopes: **Owner (User)**, **Group**, and **Others**. For each scope, there are three basic permissions:
    *   **Read (`r` / `4`)**: Ability to read file contents or list directories.
    *   **Write (`w` / `2`)**: Ability to edit files or add/delete files in directories.
    *   **Execute (`x` / `1`)**: Ability to run files as executables or traverse into directories.
    *   **Syntax**: Use `chmod` to modify permissions (e.g., `chmod 755 script.sh` sets `rwxr-xr-x`). Use `chown` to modify ownership (e.g., `chown appuser:appgroup file.txt`).

#### **Q4. What is `umask` and how does it determine default file permissions?**
*   **Answer**: `umask` (user file-creation mask) is a system setting that determines default permissions for newly created files and directories. It acts as a subtraction filter:
    *   Base permission for new directories is `777` (`rwxrwxrwx`), and for new files is `666` (`rw-rw-rw-`).
    *   If the system `umask` is set to `022`, new directories get `755` ($777 - 022$) and new files get `644` ($666 - 022$).

---

### 3. Process & Services

#### **Q5. What is the difference between a process and a service?**
*   **Answer**:
    *   A **process** is an active, running instance of any program on the operating system. It has a unique Process ID (PID) and consumes CPU, memory, and file descriptors.
    *   A **service** (or daemon) is a long-running background process that performs specific system or application functions (like a web server or database agent). It is usually managed by a service controller like `systemd` and persists across system reboots.

#### **Q6. How do you find and terminate a process consuming too much CPU?**
*   **Answer**:
    1.  **Identify**: Run `top` or `htop` in interactive mode, sorting by CPU usage. Alternatively, run:
        `ps aux --sort=-%cpu | head -n 5`
    2.  **Terminate**: Get the Process ID (PID) and run:
        `kill <PID>` (sends SIGTERM, letting the process shut down gracefully).
    3.  **Force Terminate**: If the process is hanging and does not respond, run:
        `kill -9 <PID>` (sends SIGKILL, forcing immediate kernel-level termination).

---

### 4. Disk & Memory

#### **Q7. What is the difference between `df` and `du` commands?**
*   **Answer**:
    *   `df` (disk free) displays storage statistics for mounted filesystems by reading superblock metadata. It is fast and shows disk-level usage.
    *   `du` (disk usage) estimates space consumed by specific directories and files by traversing the file tree. It is slower but provides granular directory sizes.

#### **Q8. What steps do you take when a server alerts that its disk is 100% full?**
*   **Answer**:
    1.  **Check mount points**: Run `df -h` to see which partition is exhausted.
    2.  **Find large folders**: Run `sudo du -h --max-depth=1 / | sort -hr` starting from the full partition to identify disk hogs (usually `/var/log` or `/tmp`).
    3.  **Clean logs**: Truncate active logs rather than deleting them to free space instantly:
        `echo "" > /var/log/app/huge_log.log`
    4.  **Check for deleted-but-open files**: If space is not freed, run `lsof +L1` to find deleted files still held open by active processes, then reload/restart those processes.
    5.  **Check inodes**: Run `df -i` to verify if the disk is full due to running out of metadata files (inodes) rather than physical storage space.

---

### 5. Networking

#### **Q9. How do you find which application is listening on a specific network port?**
*   **Answer**: Run the socket statistics command:
    `sudo ss -tulnp | grep :80`
    *   `-t`: TCP ports.
    *   `-u`: UDP ports.
    *   `-l`: Listening ports.
    *   `-n`: Numerical representations.
    *   `-p`: Shows the process name and PID owning the port.
    *(Note: `netstat -tulnp` is legacy and may not be installed).*

#### **Q10. How do you troubleshoot network connectivity between two application servers?**
*   **Answer**:
    1.  **Verify host resolution (DNS)**: Run `nslookup <target-hostname>` to check if DNS resolves to the correct IP.
    2.  **Ping target**: Run `ping -c 4 <target-ip>` to verify basic ICMP routing connectivity.
    3.  **Check port availability**: Run `nc -zv <target-ip> <port>` or `telnet <target-ip> <port>` to check if the port is open and listening.
    4.  **Trace route**: Run `traceroute <target-ip>` to locate where packets are dropping.
    5.  **Check local firewalls**: Run `sudo iptables -L` or `sudo ufw status` to check if traffic is blocked locally.

---

### 6. Filesystems & System Daemon Management

#### **Q11. What is the difference between soft links (symlinks) and hard links?**
*   **Answer**:
    *   **Soft Link (Symlink)**: A symbolic shortcut pointing to the *filename* of another file.
        *   It has its own unique inode number.
        *   If the original file is deleted, the symlink becomes "dangling" (broken).
        *   Can link to directories and span across different physical disk drives (filesystems).
        *   *Command:* `ln -s target.txt link.txt`
    *   **Hard Link**: A direct reference pointing to the same physical memory space (*inode*) on disk.
        *   It shares the exact same inode number as the target file.
        *   If the original file is deleted, the hard link still works and retains the content until all links to that inode are deleted.
        *   Cannot cross filesystems or link to directories.
        *   *Command:* `ln target.txt link.txt`

#### **Q12. What are systemd unit files, and how do you reload a service after changing its configuration?**
*   **Answer**: Systemd unit files (like `.service` files) are configuration definitions that dictate how background services start, stop, restart, handle dependencies, and bind to boot levels. 
    *   When modifying a unit configuration or a service file (e.g., in `/etc/systemd/system/`), you must run:
        `sudo systemctl daemon-reload`
        This tells systemd to reload all unit files from disk into system controller memory.
    *   To apply the configuration changes to the running service, execute:
        `sudo systemctl restart <service-name>`
        *(Or run `sudo systemctl reload <service-name>` if the service supports parsing its files on the fly without dropping connections, like Nginx).*

#### **Q13. What is Swap memory and when is it utilized by the system?**
*   **Answer**: Swap space is a designated partition or a block file on the disk storage that Linux uses as an extension of physical RAM (virtual memory).
    *   **Utilization**: When RAM becomes full, the Linux kernel moves inactive memory pages (pages not accessed in a while) from RAM to Swap space to free up fast memory for active tasks.
    *   **DevOps Note**: Swap prevents the system from immediately triggering the **Out-Of-Memory (OOM) Killer** to terminate processes when RAM is exhausted. However, because disk reads/writes are significantly slower than RAM, high swap usage ("thrashing") will slow down application performance.

