# ⚙️ Linux Process Management

This document explains **Linux process management concepts and commands** used for **monitoring, controlling, and troubleshooting running applications** in production, cloud, and DevOps environments.

---

## 📌 What Is a Process?

A **process** is a running instance of a program. Every process in Linux has:

* Process ID (**PID**)
* Parent Process ID (**PPID**)
* Owner (user)
* Priority & state

Process management is critical for **system stability and performance**.

---

## 📌 Process States

| State | Meaning                          |
| ----- | -------------------------------- |
| R     | Running / Runnable               |
| S     | Sleeping                         |
| D     | Uninterruptible sleep (I/O wait) |
| T     | Stopped                          |
| Z     | Zombie                           |

---

## 📌 Viewing Processes

### `ps` – Process Status

```bash
ps
ps -ef
ps aux
```

* `-e` → all processes
* `-f` → full format
* `aux` → detailed BSD format

**Use case:** Identify running services and their owners.

---

### `top` – Real-Time Process Monitoring

```bash
top
```

* Shows CPU, memory usage, load average

**Use case:** Detect high CPU or memory-consuming processes.

---

### `htop` – Enhanced Process Viewer

```bash
htop
```

* Interactive UI (if installed)

**Use case:** Easier real-time monitoring during incidents.

---

## 📌 Controlling Processes

### `kill` – Terminate Process by PID

```bash
kill PID
kill -9 PID
```

* `-9` → force kill (SIGKILL)

**Use case:** Stop unresponsive applications.

---

### `pkill` / `killall` – Kill by Name

```bash
pkill nginx
killall java
```

**Use case:** Restart services without knowing PID.

---

## 📌 Foreground & Background Jobs

### Run Process in Background

```bash
command &
```

### View Jobs

```bash
jobs
```

### Bring Job to Foreground

```bash
fg %1
```

### Send Job to Background

```bash
bg %1
```

**Use case:** Run scripts without blocking terminal.

---

## 📌 Process Priority (Nice Value)

### `nice` – Start with Priority

```bash
nice -n 10 script.sh
```

### `renice` – Change Running Process Priority

```bash
renice 5 -p PID
```

* Range: `-20` (highest) to `19` (lowest)

**Use case:** Reduce resource impact of non-critical jobs.

---

## 📌 System Load & Resource Monitoring

### Load Average

```bash
uptime
```

### CPU & Memory Info

```bash
free -h
vmstat
```

**Use case:** Diagnose performance degradation.

---

## 📌 Zombie Processes

Zombie processes occur when:

* Process has finished execution
* Parent has not collected exit status

```bash
ps aux | grep Z
```

**Fix:** Restart parent process or service.

---

## 📌 Signals (Important for Interviews)

| Signal  | Number | Purpose              |
| ------- | ------ | -------------------- |
| SIGTERM | 15     | Graceful termination |
| SIGKILL | 9      | Force termination    |
| SIGHUP  | 1      | Reload configuration |

---

## 🚀 DevOps & Production Use Cases

* Troubleshooting high CPU/memory usage
* Managing CI/CD runners
* Restarting failed application processes
* Handling zombie processes
* Incident response & recovery

---

## ⭐ Best Practices

* Use `SIGTERM` before `SIGKILL`
* Monitor processes proactively
* Avoid killing critical system processes
* Use systemd for long-running services

---

## 🎯 Interview Tips

* Difference between `ps aux` and `ps -ef`
* When to use `kill -9`
* Explain zombie processes
* Nice vs renice

---

### 🔖 Note

Process management is a **core Linux skill** and heavily used in **DevOps, SRE, and Cloud engineering roles**. Mastery here improves system reliability and incident handling.
