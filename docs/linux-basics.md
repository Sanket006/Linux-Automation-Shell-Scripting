# 🐧 Linux Basics – Complete Foundations 

This document provides a **detailed, end-to-end foundation of Linux** covering everything from **what Linux is** to **Linux networking basics**. It is designed for **DevOps, Cloud, and System Administration roles**, combining theory, practical relevance, and interview-ready explanations.

---

## 📌 What Is Linux?

**Linux** is an open-source, Unix-like operating system kernel created by **Linus Torvalds**. An operating system manages hardware resources and provides services to applications.

### Why Linux Exists

* To provide a free, open alternative to proprietary UNIX systems
* To offer stability, security, and flexibility
* To support multi-user and multitasking environments

Linux is widely used in:

* Servers & data centers
* Cloud platforms (AWS, Azure, GCP)
* DevOps tooling & CI/CD pipelines
* Containers (Docker) & orchestration (Kubernetes)

---

## 📌 Why Linux Is Critical for DevOps

Linux is the **backbone of DevOps infrastructure** because:

* Most production servers run Linux
* DevOps tools are built for Linux environments
* Linux provides deep control over processes, networking, and permissions
* Automation is native using shell scripting

> 💡 If you understand Linux well, learning Docker, Kubernetes, CI/CD, and Cloud becomes much easier.

---

## 📌 Linux Architecture (Deep Explanation)

```
User
 ↓
Applications / DevOps Tools
 ↓
Shell (CLI)
 ↓
Kernel
 ↓
Hardware
```

### 🔹 Kernel

* Core of the operating system
* Manages CPU scheduling, memory, disk I/O, networking, and devices
* Provides system calls for applications

### 🔹 Shell

* Command-line interpreter
* Acts as a bridge between user and kernel
* Executes commands and scripts

Common shells:

* `bash` (most common)
* `sh`
* `zsh`

### 🔹 User Space

* Contains applications, utilities, and services
* Includes DevOps tools, scripts, and background services

---

## 📌 Linux Distributions (Distros)

A **Linux distribution** bundles:

* Linux kernel
* Package manager
* System utilities
* Default configurations

### Common Linux Distros in Industry

| Distribution   | Used For                       |
| -------------- | ------------------------------ |
| Ubuntu         | Cloud, DevOps, beginners       |
| Amazon Linux   | AWS EC2                        |
| CentOS / Rocky | Enterprise servers             |
| Debian         | Stable environments            |
| RHEL           | Corporate & enterprise systems |

---

## 📌 Linux Directory Structure (DETAILED)

Linux follows a **hierarchical directory structure**. Understanding this is essential for server administration.

| Directory        | Purpose                                    |
| ---------------- | ------------------------------------------ |
| `/`              | Root of the filesystem                     |
| `/bin`           | Essential user binaries (ls, cp, mv)       |
| `/sbin`          | System binaries (mount, reboot)            |
| `/boot`          | Bootloader & kernel files                  |
| `/dev`           | Device files (disks, USB, terminals)       |
| `/etc`           | System-wide configuration files            |
| `/home`          | User home directories                      |
| `/lib`, `/lib64` | Shared system libraries                    |
| `/media`         | Temporary mount points (USB, CD)           |
| `/mnt`           | Manual mount points                        |
| `/opt`           | Optional/third-party applications          |
| `/proc`          | Virtual filesystem (process & kernel info) |
| `/root`          | Home directory for root user               |
| `/run`           | Runtime process data                       |
| `/srv`           | Service-related data                       |
| `/sys`           | Kernel & hardware information              |
| `/tmp`           | Temporary files                            |
| `/usr`           | User applications & libraries              |
| `/var`           | Logs, cache, spool files                   |

---

## 📌 Terminal vs Shell (Clear Concept)

### Terminal

* Interface (CLI or window)
* Used to type commands

### Shell

* Program that interprets commands
* Executes instructions

📌 Example:
Terminal = **vehicle** | Shell = **engine**

---

## 📌 Core Linux Concepts (MUST KNOW)

### 🔹 Everything Is a File

* Files, directories, devices, sockets, processes

### 🔹 Case Sensitivity

* `File.txt` ≠ `file.txt`

### 🔹 Multi-User OS

* Multiple users can work simultaneously

### 🔹 Multitasking OS

* Multiple processes run at the same time

### 🔹 Process-Based System

* Every running task is a process

---

## 📌 Users, Groups & Permissions (Overview)

* Linux is a multi-user system
* Access is controlled using permissions
* Users belong to groups

Key files:

* `/etc/passwd`
* `/etc/shadow`
* `/etc/group`

---

## 📌 File Permissions (Overview)

* Read (r)
* Write (w)
* Execute (x)

Applied to:

* User
* Group
* Others

Permissions protect system integrity and security.

---

## 📌 Processes & Services (Overview)

* A process is a running program
* Each process has a PID
* Services are long-running background processes

Managed using:

* `ps`, `top`, `kill`
* `systemctl`

---

## 📌 Package Management (Basics)

Used to install, update, and remove software.

### Debian / Ubuntu

```bash
apt update
apt install nginx
```

### RHEL / CentOS / Amazon Linux

```bash
yum install nginx
```

---

## 📌 Linux Boot Process (Simplified)

1. BIOS / UEFI
2. Bootloader (GRUB)
3. Kernel initialization
4. systemd starts services
5. Login prompt

---

## 📌 Linux Networking (FOUNDATION)

Linux networking allows systems to communicate.

### Key Networking Concepts

* IP address
* Subnet
* Gateway
* DNS
* Ports & protocols

### Important Networking Files

* `/etc/hosts`
* `/etc/resolv.conf`

### Basic Networking Commands

```bash
ip addr
ping google.com
ss -tuln
curl http://localhost
```

Networking knowledge is critical for:

* Application connectivity
* Cloud servers
* CI/CD pipelines
* Kubernetes & Docker

---

## 🚀 DevOps & Production Relevance

These Linux fundamentals are used daily in:

* AWS EC2 server management
* CI/CD execution nodes
* Docker & Kubernetes clusters
* Monitoring & logging systems
* Incident troubleshooting

---

## 🎯 Interview Tips

* Explain Linux architecture clearly
* Know important directories and their purpose
* Difference between terminal and shell
* Why Linux dominates DevOps
* Basic networking concepts in Linux

---

### 🔖 Note

This document intentionally covers Linux **from zero to networking**. Strong fundamentals here make advanced DevOps tools significantly easier to learn and troubleshoot.
