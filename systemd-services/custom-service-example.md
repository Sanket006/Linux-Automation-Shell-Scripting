# 🧩 Custom systemd Service Example

## Purpose

Learn how to create a **custom systemd service** to run scripts or applications automatically.

This is a **very common DevOps task** in production environments.

---

## Example Scenario

Run a shell script as a background service that starts on boot.

---

## Sample Service File

Create a file:

```bash
/etc/systemd/system/health-check.service
```

### Service Definition

```ini
[Unit]
Description=System Health Check Service
After=network.target

[Service]
ExecStart=/scripts/system-health-check.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

---

## Enable & Start Service

```bash
systemctl daemon-reload
systemctl enable health-check.service
systemctl start health-check.service
systemctl status health-check.service
```

---

## Restart Policies

* `Restart=always`
* `Restart=on-failure`
* `Restart=no`

---

## DevOps Use Case

* Run monitoring scripts
* Keep services highly available
* Replace cron for long-running jobs

---

## Interview Tip

Explain each section: **[Unit]**, **[Service]**, **[Install]**.
