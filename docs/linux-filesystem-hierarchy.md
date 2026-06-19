# 📁 Linux Filesystem Hierarchy (FHS)

## 📌 Purpose
Linux structures its system directories according to the **Filesystem Hierarchy Standard (FHS)**. Rather than scattering files arbitrarily, every category of file (e.g., user binaries, configuration scripts, logs, libraries, device files) has a strict, standardized home directory. DevOps engineers must understand this structure to configure application pathways, locate system logs, store variables, and place custom utility binaries correctly.

---

## ⚙️ Core System Directories

| Directory | Name/Purpose | Contents | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `/` | **Root** | The primary top-level directory. Everything mounts here. | Starting point for system paths. |
| `/bin` | **Essential Binaries** | Fundamental user command binaries (e.g., `ls`, `cp`, `sh`, `bash`). | Available even in single-user mode. |
| `/sbin` | **System Binaries** | Administrator binaries required to boot and recover the system (`fsck`, `iptables`, `reboot`). | Executed primarily by `root`. |
| `/etc` | **System Configuration** | Server-specific configuration files for services (e.g., `/etc/nginx/`, `/etc/ssh/`). | Storing application config files. |
| `/var` | **Variable Data** | Dynamic files that change continuously: logs (`/var/log`), caches, queues. | Finding service error logs. |
| `/usr` | **User Utilities** | User programs, libraries, and secondary binaries (e.g., `/usr/bin`, `/usr/lib`). | Destination for non-essential software. |
| `/opt` | **Optional Software** | Third-party standalone application bundles (e.g., `/opt/jenkins`, `/opt/datadog`). | Installing self-hosted agents. |
| `/home` | **User Homes** | Personal directories for system users (e.g., `/home/sanket`). | User-level configs (`~/.ssh`, `~/.bashrc`). |
| `/tmp` | **Temporary Files** | Volatile files deleted automatically on system boot. | Storing temporary build artifacts. |

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving Mount Point Outages
When deploying database applications (e.g., MySQL/PostgreSQL), the default storage location is `/var/lib/mysql`. Because `/var` is often on the root partition, a high-volume database can quickly exhaust disk space, crashing the server.
- **Resolution:** DevOps engineers mount a separate, high-performance volume (such as an AWS EBS drive) directly to `/var/lib/mysql` or `/data`, separating user-generated database growth from critical operating system files.

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between `/bin`, `/usr/bin`, and `/usr/local/bin`?**
*   **Answer:**
    *   `/bin` contains essential binaries needed to boot the system and run in emergency recovery mode (e.g., `ls`, `cat`, `mkdir`).
    *   `/usr/bin` contains non-essential binaries used by standard users, installed by the system package manager (e.g., `curl`, `git`, `python`).
    *   `/usr/local/bin` is reserved for custom programs compiled or installed manually by the administrator, ensuring they aren't overwritten by system package manager updates.

**Q2: Which directory contains server configuration files, and what is its significance?**
*   **Answer:** The `/etc` directory. It holds static configuration files for the operating system and installed services (e.g., sshd configurations, network interface settings, package manager repositories). It does not contain binary executables.
