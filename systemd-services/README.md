# ⚙️ systemd Services & Daemon Management

## 📌 Overview
`systemd` is the default system and service manager for modern Linux operating systems. It acts as the initialization system (PID 1) that bootstraps user space and manages user processes, daemons, and background services throughout the server lifecycle. DevOps engineers use systemd to deploy, monitor, restart, and persist applications (e.g., APIs, databases, CI/CD runners) on virtual machines.

---

## 📂 Directory Contents

| Document Link | Type | Description | Key Focus Areas |
| :--- | :--- | :--- | :--- |
| [systemd Basics](systemd-basics.md) | Guide | Core systemd components, unit files, targets, and systemctl command reference. | `systemctl start/stop/status/enable/disable`. |
| [Custom systemd Service](custom-service-example.md) | Hands-on | Step-by-step creation of a custom service (`health-check.service`) running a shell script. | Service units, `[Service]` configurations, auto-restart. |

---

## 🎯 Learning Outcomes
After completing this section, you will:
- Understand the systemd init process, target levels, and unit configurations.
- Control background services (start, stop, restart, enable, disable) using `systemctl`.
- Write custom systemd service unit files (`.service`) from scratch to persist custom applications.
- Troubleshoot service failures, verify logs using `journalctl`, and reload the daemon safely.

---

## 🚀 DevOps Advantage
Modern container engines like Docker and container orchestrators (Kubernetes) handle process persistence automatically. However, the host operating systems, databases, message brokers, and self-hosted build runners themselves are managed directly via systemd. Mastering systemd enables DevOps engineers to:
- **Ensure High Availability**: Configure auto-restart policies so services revive immediately after a crash.
- **Manage Service Dependencies**: Define start order constraints (e.g., start the API only *after* the Database service is healthy).
- **Automate VM Bootups**: Persist vital monitoring agents and scripts across server restarts.

---

## ℹ️ How to Use & Next Steps
1. Read the [systemd Basics](systemd-basics.md) guide to learn how to monitor system services.
2. Follow the [Custom systemd Service](custom-service-example.md) tutorial to build and deploy a custom systemd service that launches a shell script automatically on system boot.
3. Practice debugging service logs using `journalctl -u <service-name>`.
