# 🛠️ System Troubleshooting Commands

When a production issue occurs, you need to diagnose it quickly using the right commands. This document covers the core Linux troubleshooting commands — for inspecting service logs, analyzing kernel messages, monitoring log files in real-time, and filtering large log outputs for specific error patterns.

> 📖 **See also:** For a step-by-step troubleshooting methodology covering CPU, memory, disk, networking, and permission issues, see [`docs/system-troubleshooting.md`](../docs/system-troubleshooting.md).

---

## Core Commands

| Command | What It Does | Key Flags & Usage |
| :--- | :--- | :--- |
| `journalctl` | Query the systemd journal (logs for all services and the kernel) | `journalctl -u <service>` |
| `dmesg` | Print kernel ring buffer messages (hardware, drivers, OOM events) | `dmesg -T` |
| `systemctl` | Inspect and control systemd services | `systemctl status <service>` |
| `tail` | Display the last lines of a file; stream new lines in real-time | `tail -f /var/log/syslog` |
| `grep` | Search for patterns inside files or command output | `grep -i "error" <file>` |
| `lsof` | List all open files and the processes holding them | `lsof -p <PID>`, `lsof +L1` |

---

## Practical Examples

### 1. Debugging a Failed Service

When a service fails to start or crashes, this is the fastest way to find the error:

```bash
# Step 1: Check the service's current state and last few log lines
sudo systemctl status nginx

# Step 2: Get the full recent log history (last 50 lines)
journalctl -u nginx -n 50 --no-pager

# Step 3: See logs since the last hour only
journalctl -u nginx --since "1 hour ago" --no-pager
```

**Flag breakdown for `journalctl`:**

| Flag | Meaning |
| :--- | :--- |
| `-u nginx` | Filter logs for the nginx service only |
| `-n 50` | Show only the last 50 log entries |
| `--no-pager` | Print all output to stdout immediately (do not open `less`) |
| `-f` | Stream new log entries in real-time (like `tail -f`) |
| `--since "1 hour ago"` | Limit results to the last hour |

---

### 2. Streaming Logs in Real-Time

Monitor a log file as new lines are written — essential during deployments and incident response.

```bash
# Stream system log, filtering for errors and warnings only
tail -f /var/log/syslog | grep -iE 'error|warning|critical'

# Stream a service's journal logs in real-time
journalctl -u myapp -f
```

**Flag breakdown for `tail`:**

| Flag | Meaning |
| :--- | :--- |
| `-f` | Follow — continuously output new lines as they are appended |
| `-n 100` | Show the last 100 lines before following |

---

### 3. Detecting OOM Killer Events

If a service is mysteriously dying with no error in its own logs, the Linux OOM (Out-Of-Memory) Killer may have terminated it. Check kernel messages:

```bash
dmesg -T | grep -i -E 'oom|kill'
```

**Flag breakdown for `dmesg`:**

| Flag | Meaning |
| :--- | :--- |
| `-T` | Show timestamps in human-readable format instead of seconds since boot |

**What the output looks like:**

```text
[Mon Jun 22 10:15:32 2026] Out of memory: Kill process 8421 (java) score 892 or sacrifice child
[Mon Jun 22 10:15:32 2026] Killed process 8421 (java) total-vm:4096000kB, anon-rss:3800000kB
```

This tells you exactly which process was killed and when.

---

### 4. Finding Open Files Held by a Process

When a deleted file is still consuming disk space because a process has it open:

```bash
# Find all files deleted but still held open by running processes
sudo lsof +L1

# List all files opened by a specific process
sudo lsof -p <PID>
```

---

## DevOps Use Cases

### Resolving "Address Already in Use" Error

A web server fails to restart. `systemctl status nginx` shows `Active: failed`.

```bash
# Step 1: Get the exact error from journal logs
journalctl -xe -u nginx

# You see: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)

# Step 2: Find what process is using port 80
sudo ss -tulnp | grep :80

# You see: apache2 is holding port 80

# Step 3: Stop the competing service
sudo systemctl stop apache2

# Step 4: Start nginx
sudo systemctl start nginx
```

### Investigating a Service That Keeps Crashing

```bash
# Check how many times it has restarted
systemctl status myapp | grep "restarts"

# Get the full log history including previous start attempts
journalctl -u myapp --since "today" --no-pager

# Check if disk is full (a common hidden cause of crashes)
df -h
```

---

## Best Practices

- Always check logs with `journalctl` before attempting any fixes — the error message usually tells you exactly what is wrong.
- Use `--no-pager` with `journalctl` in scripts and when piping output to `grep`.
- Use `tail -f` + `grep` to filter live log streams rather than reading entire log files.
- Use `dmesg -T` (with timestamps) — default `dmesg` shows seconds since boot, which is hard to correlate with real events.
- Check `lsof +L1` any time disk usage does not decrease after deleting files.

---

## Interview Q&A

**Q1: How do you troubleshoot a service that fails to start?**
- **Answer:**
  1. Run `systemctl status <service>` — check the `Active:` state and the last few log lines displayed.
  2. Run `journalctl -u <service> -n 100 --no-pager` to get detailed log history.
  3. Identify the specific error — common causes: config syntax error, port conflict, missing file, permission denied.
  4. If a configuration file was changed, validate it (e.g., `nginx -t`) before restarting.
  5. If a unit file was changed, run `systemctl daemon-reload` before restarting.

**Q2: What is `dmesg` used for?**
- **Answer:** `dmesg` displays messages from the **kernel ring buffer** — a circular buffer that stores kernel-level messages from hardware drivers, device initialization, memory management, and security events. In DevOps, it is most commonly used to check for **OOM (Out-Of-Memory) Killer** events (which silently terminate processes when RAM is exhausted), disk read/write errors, and hardware driver failures.

**Q3: Why does disk usage not decrease after deleting a large log file?**
- **Answer:** Because the file is still held open by a running process (like Nginx writing to it). In Linux, when a file is deleted, the filesystem removes the directory entry but does not reclaim the disk space until all file descriptors pointing to it are closed. `df` registers the space as still in use; `du` does not find the file. Use `lsof +L1` to identify which process is holding the file open, then reload or restart that process to release the space.

---

> 🔖 **Note:** Troubleshooting commands are your investigative tools during production incidents. The ability to quickly read service logs, identify kernel events, and trace open file handles separates engineers who resolve incidents in minutes from those who take hours.
