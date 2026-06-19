# 🛠️ Linux Troubleshooting – Practical Guide for DevOps

This document provides a **systematic, real-world approach to Linux troubleshooting**. It covers **common production issues**, how to **analyze problems step by step**, and which **commands, logs, and files** to check. This is a **high-value topic** for DevOps, SRE, and system administration interviews.

---

## 📌 How to Think While Troubleshooting

Before running commands, always follow this mindset:

1. **Understand the problem** (What is broken?)
2. **Identify the scope** (Single user, service, or entire server?)
3. **Check recent changes** (Deployments, configs, updates)
4. **Verify system resources** (CPU, memory, disk, network)
5. **Check logs** (System & application)
6. **Fix → Verify → Monitor**

> 💡 Good troubleshooting is about **methodology**, not memorizing commands.

---

## 📌 Basic System Health Checks (First Step)

```bash
uptime
whoami
hostname
```

Check:

* Load average
* Logged-in user
* Server identity

---

## 📌 CPU-Related Issues

### Symptoms

* High load average
* Slow response
* Applications timing out

### Commands to Use

```bash
top
htop
ps aux --sort=-%cpu
uptime
```

### What to Look For

* High CPU-consuming processes
* Zombie or stuck processes

### Fixes

* Restart or kill misbehaving processes
* Reduce priority using `nice` / `renice`

---

## 📌 Memory-Related Issues

### Symptoms

* Application crashes
* "Out of memory" errors
* Server freezing

### Commands

```bash
free -h
vmstat
dmesg | tail
```

### What to Look For

* High memory usage
* Swap usage
* OOM killer messages

### Fixes

* Restart leaking applications
* Add swap (temporary fix)
* Increase server memory

---

## 📌 Disk Space Issues

### Symptoms

* "No space left on device"
* Services failing to start

### Commands

```bash
df -h
du -sh /*
lsblk
```

### What to Look For

* Full root partition
* Large log files

### Fixes

* Clean logs
* Remove unused files
* Expand disk (cloud environments)

---

## 📌 Service Not Running / Failed

### Commands

```bash
systemctl status service-name
systemctl restart service-name
journalctl -u service-name
```

### Common Causes

* Configuration error
* Port already in use
* Permission issues

### Fixes

* Check logs carefully
* Validate config files
* Restart service after fix

---

## 📌 Networking Issues

### Symptoms

* Application not reachable
* API timeouts

### Commands

```bash
ip addr
ping google.com
ss -tuln
curl localhost
```

### What to Check

* IP address assigned
* Port listening
* Firewall rules

---

## 📌 Permission Issues

### Symptoms

* "Permission denied"

### Commands

```bash
ls -l
id username
getfacl file
```

### Fixes

* Correct ownership (`chown`)
* Correct permissions (`chmod`)
* Use groups instead of 777

---

## 📌 User Login Issues

### Symptoms

* User cannot log in

### Commands

```bash
id username
passwd -S username
last
```

### Common Causes

* Locked account
* Expired password
* Wrong shell

---

## 📌 Log-Based Troubleshooting (MOST IMPORTANT)

### Important Log Locations

| Log            | Location                                 |
| -------------- | ---------------------------------------- |
| System logs    | `/var/log/syslog` or `/var/log/messages` |
| Authentication | `/var/log/auth.log`                      |
| Boot logs      | `journalctl -b`                          |
| Service logs   | `/var/log/` or `journalctl`              |

### journald Commands

```bash
journalctl
journalctl -xe
journalctl -u nginx
```

---

## 📌 Disk & File System Issues

### Commands

```bash
mount
lsblk
fsck
```

### Use Cases

* Disk not mounting
* Read-only filesystem

---

## 📌 Troubleshooting Checklist (Quick)

* ✅ Is the server up?
* ✅ Is disk full?
* ✅ Is memory exhausted?
* ✅ Is service running?
* ✅ Is port listening?
* ✅ Any errors in logs?

---

## 🚀 DevOps & Production Scenarios

* CI/CD pipeline failing on agent
* Application down after deployment
* Disk full due to logs
* Docker service not starting
* SSH access issues

---

## 🎯 Interview Questions You Should Be Ready For

* How do you troubleshoot a down server?
* What do you check first when an app is down?
* How do you debug a failed systemd service?
* How do logs help in troubleshooting?

---

## ⭐ Best Practices

* Always start with basics
* Check logs before making changes
* Avoid random command execution
* Document root cause and fix

---

### 🔖 Note

Troubleshooting is the **core skill that differentiates a DevOps engineer from a beginner**. Strong troubleshooting ability shows real production readiness.
