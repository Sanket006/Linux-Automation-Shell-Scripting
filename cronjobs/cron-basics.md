# ⏰ Cron Basics

## Purpose

Understand how cron works and how to schedule automated tasks in Linux.

## What is Cron?

Cron is a Linux job scheduler used to run commands or scripts automatically at specified times.

## Cron Daemon

* `crond` runs in the background
* Executes scheduled jobs

## Crontab Syntax

```
* * * * * command
| | | | |
| | | | └── Day of week (0–7)
| | | └──── Month (1–12)
| | └────── Day of month (1–31)
| └──────── Hour (0–23)
└────────── Minute (0–59)
```

## Common Commands

```bash
crontab -e   # edit cron jobs
crontab -l   # list cron jobs
crontab -r   # remove cron jobs
```

## Interview Tip

Be ready to explain cron time fields clearly.
