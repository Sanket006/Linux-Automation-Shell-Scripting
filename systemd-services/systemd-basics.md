# ⚙️ systemd Basics

## Purpose

Understand **systemd**, the init system and service manager used in modern Linux distributions.

systemd is a **core skill for DevOps and SRE roles** because it controls how services start, stop, restart, and recover.

---

## What is systemd?

* Initializes the system during boot
* Manages services, sockets, timers, mounts
* Replaces SysVinit and Upstart

---

## Key Concepts

### 🔹 Units

Configuration files that describe resources managed by systemd.

Common unit types:

* `.service` – Services
* `.timer` – Scheduling (cron alternative)
* `.socket` – Socket activation
* `.mount` – Mount points

---

## Common systemctl Commands

```bash
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl status nginx
systemctl enable nginx
systemctl disable nginx
```

---

## Logs with journalctl

```bash
journalctl -u nginx
journalctl -xe
```

---

## DevOps Use Case

* Ensure applications restart automatically
* Debug service failures
* Manage background automation reliably

---

## Interview Tip

Be ready to explain **systemd vs cron** and **enable vs start**.
