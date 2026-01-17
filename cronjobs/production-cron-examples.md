# 🏭 Production Cron Job Examples

## Purpose

Demonstrate real-world cron jobs used in DevOps and system administration.

---

## Daily System Health Check

```bash
0 9 * * * /scripts/system-health-check.sh >> /var/log/health.log 2>&1
```

## Disk Usage Monitoring (Every Hour)

```bash
0 * * * * /scripts/disk-usage-alert.sh
```

## Log Cleanup (Weekly)

```bash
0 2 * * 0 /scripts/log-cleanup.sh
```

## Backup Automation (Daily)

```bash
0 1 * * * /scripts/backup-script.sh
```

---

## Logging Best Practice

Always redirect output:

```bash
command >> /var/log/cron.log 2>&1
```

## DevOps Use Case

Used for backups, monitoring, cleanup, and reporting.

## Interview Tip

Mention logging and failure handling when discussing cron jobs.
