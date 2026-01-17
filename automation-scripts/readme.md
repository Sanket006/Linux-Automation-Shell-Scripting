# 🤖 Automation Scripts – README

## 📌 Overview

This directory contains **real-world Linux automation scripts** commonly used by **DevOps and System Engineers** in production environments.

Each script focuses on:

* Reducing manual operational work
* Improving system reliability
* Automating repetitive administrative tasks

---

## 📂 Scripts Included

### 🩺 System Health Check

* `system-health-check.sh`
* CPU, memory, disk, uptime checks
* Daily health reporting

### 💽 Disk Usage Alert

* `disk-usage-alert.sh`
* Threshold-based disk monitoring
* Email/alert-ready logic

### 🧹 Log Cleanup

* `log-cleanup.sh`
* Automated old log deletion
* Prevents disk full issues

### 💾 Backup Automation

* `backup-script.sh`
* File/database backup
* Timestamped backups

### 🔁 Service Monitoring

* `service-monitor.sh`
* Service status checks
* Auto-restart on failure

### 👥 User Audit

* `user-audit.sh`
* User & permission audits
* Security compliance support

---

## ⚙️ How to Use a Script

```bash
chmod +x script-name.sh
./script-name.sh
```

For scheduled automation:

```bash
crontab -e
```

---

## 🎯 Learning Outcome

After practicing these scripts, you will:

* Automate Linux server operations
* Understand real DevOps automation scenarios
* Be production-ready for junior DevOps roles

---

## ⚠️ Production Note

* Always review scripts before execution
* Test on staging servers
* Add logging & alerts for critical tasks

---

⭐ This folder represents **hands-on DevOps automation experience**.
