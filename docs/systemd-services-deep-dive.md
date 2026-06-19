# ⚙️ systemd & Services in Linux – Complete Guide

This document explains **systemd**, the modern init system used in most Linux distributions, and how **services (daemons)** are managed in production environments. This is a **core topic for DevOps, Cloud, and SRE roles**.

---

## 📌 What Is systemd?

**systemd** is the **system and service manager** in Linux. It is responsible for:

* Booting the system
* Starting and stopping services
* Managing system states
* Handling logs and dependencies

Most modern Linux distributions (Ubuntu, RHEL, CentOS, Amazon Linux) use **systemd**.

---

## 📌 Why systemd Is Important for DevOps

systemd is critical because:

* All production services run under it
* CI/CD agents, monitoring tools, and apps depend on it
* It supports auto-restart and dependency management
* It enables faster boot and better control

> 💡 If a service fails in production, `systemctl` is usually the first tool you use.

---

## 📌 What Is a Service (Daemon)?

A **service (daemon)** is a background process that:

* Starts automatically or manually
* Runs continuously
* Provides system or application functionality

### Common Examples

* `sshd` – SSH access
* `nginx` – Web server
* `docker` – Container engine
* `jenkins` – CI/CD service

---

## 📌 systemd Architecture (Simplified)

```
Bootloader
   ↓
Kernel
   ↓
systemd (PID 1)
   ↓
Services & Targets
```

* `systemd` always runs as **PID 1**
* It manages all other processes

---

## 📌 systemctl – Service Management Command

### Check Service Status

```bash
systemctl status nginx
```

### Start / Stop / Restart Service

```bash
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
```

### Enable / Disable at Boot

```bash
systemctl enable nginx
systemctl disable nginx
```

---

## 📌 Service States

| State            | Meaning                |
| ---------------- | ---------------------- |
| active (running) | Service is running     |
| inactive         | Service stopped        |
| failed           | Service crashed        |
| enabled          | Starts at boot         |
| disabled         | Does not start at boot |

---

## 📌 Unit Files in systemd

systemd uses **unit files** to define resources.

### Common Unit Types

| Unit Type  | Purpose            |
| ---------- | ------------------ |
| `.service` | Service definition |
| `.target`  | Group of services  |
| `.mount`   | Mount points       |
| `.timer`   | Scheduled tasks    |

---

## 📌 Location of Unit Files

* `/etc/systemd/system/` → Custom & override units
* `/usr/lib/systemd/system/` → Default system units

---

## 📌 Example: Service Unit File

```ini
[Unit]
Description=My App Service
After=network.target

[Service]
ExecStart=/usr/bin/myapp
Restart=always
User=appuser

[Install]
WantedBy=multi-user.target
```

---

## 📌 Targets (Runlevels Replacement)

Targets define system states.

| Target            | Purpose  |
| ----------------- | -------- |
| multi-user.target | CLI mode |
| graphical.target  | GUI mode |
| reboot.target     | Reboot   |
| poweroff.target   | Shutdown |

### Check Current Target

```bash
systemctl get-default
```

---

## 📌 journald & Logs

systemd uses **journald** for logging.

### View Logs

```bash
journalctl
journalctl -u nginx
journalctl -xe
```

**Why journald matters:**

* Centralized logging
* Easy troubleshooting
* Time-based filtering

---

## 📌 Auto-Restart & Self-Healing

systemd supports automatic restarts.

```ini
Restart=always
RestartSec=5
```

**Use case:** Keep critical services running in production.

---

## 🚀 DevOps & Production Use Cases

* Managing application services
* Running CI/CD agents
* Monitoring service health
* Implementing self-healing systems
* Debugging service failures

---

## 🎯 Interview Tips

* What is systemd and why it replaced init
* Role of PID 1
* Difference between start and enable
* How to debug a failed service
* journald vs log files

---

## ⭐ Best Practices

* Always check logs after failure
* Use `Restart=always` for critical services
* Do not run services as root unless required
* Reload systemd after unit file changes

```bash
systemctl daemon-reexec
systemctl daemon-reload
```

---

### 🔖 Note

Understanding systemd and services is **mandatory for DevOps, SRE, and Cloud engineers**. Nearly every production issue involves service management at some level.










# ⚙️ systemd & Services in Linux – Complete Guide

This document explains **systemd**, **services**, and **service management** in Linux. It covers concepts, commands, configuration files, boot targets, and real-world DevOps use cases. This is a **must-know topic** for system administration, DevOps, and SRE roles.

---

## 📌 What Is systemd?

**systemd** is the **init system and service manager** used by most modern Linux distributions (Ubuntu, Amazon Linux, RHEL, CentOS, Rocky, Debian).

### What systemd Does

* Starts the system during boot
* Manages system services (daemons)
* Handles dependencies between services
* Manages logs (via `journald`)
* Controls system states (targets)

> 💡 systemd replaces older init systems like **SysVinit** and **Upstart**.

---

## 📌 What Is a Service (Daemon)?

A **service (daemon)** is a **long-running background process** that starts at boot or on demand.

### Examples of Services

* `sshd` → SSH service
* `nginx` → Web server
* `docker` → Container runtime
* `jenkins` → CI/CD server

Services usually run **without user interaction**.

---

## 📌 systemd Components (Important)

| Component   | Purpose                        |
| ----------- | ------------------------------ |
| `systemctl` | Manage services & system state |
| `journald`  | Logging service                |
| Units       | Configuration objects          |
| Targets     | System states                  |

---

## 📌 systemd Unit Files

A **unit file** defines how a resource is managed by systemd.

### Common Unit Types

| Unit Type | Extension  | Purpose                 |
| --------- | ---------- | ----------------------- |
| Service   | `.service` | Manage services         |
| Target    | `.target`  | System state            |
| Mount     | `.mount`   | Filesystem mount        |
| Timer     | `.timer`   | Scheduled tasks         |
| Socket    | `.socket`  | Socket-based activation |

---

## 📌 Service Unit File Structure

Example: `nginx.service`

```ini
[Unit]
Description=NGINX Web Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
Restart=always
User=nginx

[Install]
WantedBy=multi-user.target
```

### Sections Explained

#### `[Unit]`

* `Description` → Service description
* `After` / `Before` → Dependency order

#### `[Service]`

* `ExecStart` → Command to start service
* `ExecReload` → Reload command
* `Restart` → Restart policy
* `User` → Run as specific user

#### `[Install]`

* `WantedBy` → Target where service starts

---

## 📌 Managing Services – `systemctl`

### Check Service Status

```bash
systemctl status nginx
```

### Start / Stop / Restart

```bash
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
```

### Enable / Disable at Boot

```bash
systemctl enable nginx
systemctl disable nginx
```

### Reload Configuration

```bash
systemctl reload nginx
```

---

## 📌 Service States

| State            | Meaning                |
| ---------------- | ---------------------- |
| active (running) | Service is running     |
| inactive         | Not running            |
| failed           | Crashed or error       |
| enabled          | Starts at boot         |
| disabled         | Does not start at boot |

---

## 📌 systemd Targets (Runlevels)

Targets represent **system states**.

| Target              | Purpose             |
| ------------------- | ------------------- |
| `multi-user.target` | Non-GUI server mode |
| `graphical.target`  | GUI mode            |
| `rescue.target`     | Single-user rescue  |
| `emergency.target`  | Emergency shell     |

### Check Default Target

```bash
systemctl get-default
```

### Change Default Target

```bash
systemctl set-default multi-user.target
```

---

## 📌 Logs with journald

systemd uses **journald** for logging.

### View Logs

```bash
journalctl
journalctl -u nginx
journalctl -xe
```

### View Logs by Time

```bash
journalctl --since "1 hour ago"
```

---

## 📌 Creating a Custom systemd Service

Steps:

1. Create a service file
2. Reload systemd
3. Enable & start service

```bash
sudo nano /etc/systemd/system/myapp.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp
```

---

## 🚀 DevOps & Production Use Cases

* Managing application services on servers
* Auto-restarting failed services
* Running CI/CD agents
* Managing Docker & Kubernetes services
* Boot-time service orchestration

---

## 🎯 Interview Questions (Common)

* What is systemd?
* Difference between service and process?
* What are systemd targets?
* How do you troubleshoot a failed service?
* Explain a systemd unit file

---

## ⭐ Best Practices

* Run services as non-root users
* Use `Restart=always` for critical services
* Always check logs with `journalctl`
* Reload the daemon after editing unit files

---

### 🔖 Note

systemd and service management are **core Linux skills** and heavily used in **DevOps, SRE, and Cloud environments**. Mastery of this topic significantly improves troubleshooting and automation capabilities.
