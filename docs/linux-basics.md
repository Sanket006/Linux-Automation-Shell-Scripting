# 🐧 Linux Basics — Foundations for DevOps

Linux is the **backbone of modern DevOps, cloud, and server infrastructure**. Almost every production server, container, and CI/CD runner runs on Linux. This document builds a solid foundation — from what Linux is, to how it is structured, to the core concepts you will use every day.

---

## What Is Linux?

**Linux** is a free, open-source operating system kernel created by **Linus Torvalds in 1991**. The kernel is the core software that manages hardware resources (CPU, memory, disk, network) and provides services to all applications running on the machine.

A complete operating system built around the Linux kernel is called a **Linux distribution** (or distro). Each distro bundles the kernel with a package manager, system utilities, and default configurations.

### Why Linux Dominates DevOps

- Most production servers and cloud VMs (AWS EC2, GCP, Azure) run Linux.
- All major DevOps tools (Docker, Kubernetes, Ansible, Terraform) are built for Linux.
- Linux provides deep, scriptable control over processes, networking, and permissions.
- Automation is native — shell scripts can configure and manage entire server fleets.

> 💡 If you understand Linux well, learning Docker, Kubernetes, and cloud platforms becomes significantly easier.

---

## Linux Architecture

```
User
 ↓
Applications & DevOps Tools  (Nginx, Python, Jenkins, Docker)
 ↓
Shell / CLI                  (Bash, Zsh — your command interpreter)
 ↓
Kernel                       (Core OS — manages hardware)
 ↓
Hardware                     (CPU, RAM, Disk, Network)
```

### The Kernel
The kernel is the privileged core of the OS. It manages CPU scheduling, physical memory, disk I/O, network packets, and hardware devices. Applications cannot talk to hardware directly — they must ask the kernel via **system calls** (e.g., `read()`, `write()`, `fork()`).

### The Shell
The shell is the command-line interpreter — the bridge between you and the kernel. When you type `ls`, the shell parses the command and asks the kernel to execute it.

Common shells:
- `bash` — default on most Linux systems
- `zsh` — default on macOS, popular for customization
- `sh` — minimal POSIX-compliant shell

### User Space
Everything outside the kernel (applications, services, scripts, your terminal) runs in user space. User space processes have restricted privileges and must go through the kernel to access hardware.

---

## Common Linux Distributions

| Distribution | Typical Use |
| :--- | :--- |
| Ubuntu | Cloud servers, DevOps environments, beginners |
| Amazon Linux | AWS EC2 instances |
| CentOS / Rocky Linux | Enterprise on-premises servers |
| RHEL (Red Hat) | Corporate and compliance-heavy environments |
| Debian | Stable, conservative production environments |

---

## Linux Directory Structure

Linux organizes everything under a single root directory `/`. This structure follows the **Filesystem Hierarchy Standard (FHS)**.

| Directory | Purpose |
| :--- | :--- |
| `/` | Root — the top of the entire filesystem |
| `/bin` | Essential user commands (`ls`, `cp`, `mv`, `bash`) |
| `/sbin` | System admin commands (`mount`, `reboot`, `iptables`) |
| `/etc` | Configuration files for all services |
| `/home` | Personal directories for human users |
| `/root` | Home directory for the root administrator |
| `/var` | Variable data — logs (`/var/log`), caches, queues |
| `/tmp` | Temporary files — cleared on reboot |
| `/opt` | Optional third-party software (Jenkins, Datadog) |
| `/usr` | User applications and shared libraries |
| `/proc` | Virtual filesystem — live process and kernel info |
| `/dev` | Device files (disks, USB, terminals) |
| `/boot` | Kernel and bootloader files |

---

## Terminal vs Shell

These two terms are often confused:

| Concept | What It Is | Example |
| :--- | :--- | :--- |
| **Terminal** | The GUI window that accepts keyboard input and displays output | VS Code Terminal, PuTTY, GNOME Terminal |
| **Shell** | The program inside the terminal that interprets and runs your commands | `bash`, `zsh`, `sh` |

Think of it this way: the **terminal is the vehicle**, the **shell is the engine**.

---

## Core Linux Concepts

### Everything Is a File
In Linux, almost everything is represented as a file — regular files, directories, hardware devices (`/dev/sda`), network sockets, and even running processes (`/proc/1234`). This consistency makes automation much simpler.

### Case Sensitivity
Linux filenames are case-sensitive. `Deploy.sh`, `deploy.sh`, and `DEPLOY.SH` are three different files.

### Multi-User and Multitasking
Linux was built from the ground up to support multiple users running multiple programs simultaneously. Access control (users, groups, permissions) enforces isolation between them.

### Every Running Task Is a Process
Every command you run, every service running in the background, is a **process** with a unique **PID (Process ID)**. All processes descend from PID 1 (`systemd`).

---

## Users, Groups & Permissions (Overview)

Linux enforces strict access control:

- Every file has an **owner** (a user) and a **group**.
- Permissions define what the owner, the group members, and everyone else can do (`read`, `write`, `execute`).
- Key files: `/etc/passwd` (users), `/etc/shadow` (passwords), `/etc/group` (groups).

---

## Package Management

Package managers install, update, and remove software.

### Debian / Ubuntu (apt)
```bash
sudo apt update          # Refresh package index
sudo apt install nginx   # Install a package
sudo apt upgrade         # Upgrade all installed packages
```

### RHEL / CentOS / Amazon Linux (yum / dnf)
```bash
sudo yum install nginx   # Install a package
sudo dnf install nginx   # Modern alternative (dnf)
```

---

## The Linux Boot Process

When a Linux server starts, it follows this sequence:

1. **BIOS / UEFI** — Hardware checks (POST) and locates the boot device.
2. **Bootloader (GRUB)** — Loads the Linux kernel image into memory.
3. **Kernel Initialization** — Kernel sets up drivers, mounts the temporary root filesystem.
4. **systemd (PID 1)** — The first user-space process; mounts all filesystems and starts configured services.
5. **Login Prompt** — Terminal or SSH prompt appears.

---

## Linux Networking Basics

Linux networking allows your server to communicate with other machines and the internet.

### Key Concepts
- **IP address** — unique address identifying a machine on a network.
- **Subnet** — a range of IP addresses in a network segment.
- **Gateway** — the router address that forwards traffic to other networks.
- **DNS** — converts hostnames (like `google.com`) into IP addresses.
- **Port** — a number (0–65535) identifying a specific service on a host.

### Important Configuration Files
- `/etc/hosts` — local manual hostname-to-IP mappings.
- `/etc/resolv.conf` — DNS server addresses.

### Basic Networking Commands
```bash
ip addr              # Show network interfaces and IP addresses
ping -c 4 google.com # Test connectivity (sends 4 packets)
ss -tuln             # Show listening ports (TCP and UDP)
curl http://localhost # Test a local HTTP service
```

---

## DevOps Relevance

These Linux fundamentals are used every day in:

- Managing AWS EC2, GCP, and Azure virtual machines.
- Writing shell scripts that run inside CI/CD pipelines.
- Building and running Docker containers.
- Debugging failing Kubernetes pods that run on Linux nodes.
- Investigating incident alerts and server failures.

---

## Interview Tips

- Be able to explain what the Linux kernel does vs what the shell does.
- Know the purpose of key directories (`/etc`, `/var`, `/tmp`, `/opt`).
- Understand what happens step-by-step during the Linux boot process.
- Know the difference between a terminal and a shell (a very common interview question).
- Be able to explain what a process is and how processes are organized (PID, parent/child).

---

> 🔖 **Note:** These fundamentals are the foundation for everything else in Linux. Strong basics here make debugging, automation, and cloud infrastructure significantly easier to learn and troubleshoot.
