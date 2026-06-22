# ⚙️ Process Management

Every program running on a Linux system — whether it is a web server, a database, a shell script, or a background monitoring agent — is a **process**. As a DevOps engineer, you need to know how to see what is running, how to identify processes that are consuming too many resources, how to safely stop them, and how to control their CPU priority. These skills are critical for managing production servers and responding to incidents.

> 📖 **See also:** For process states (R/S/D/T/Z), zombie processes, background jobs (`fg`/`bg`/`jobs`), and the full signals reference table, see [`docs/process-management.md`](../docs/process-management.md).

---

## Core Concepts

### What Is a Process?

A process is a **running instance of a program**. Every process has:

- **PID** (Process ID) — a unique number assigned by the kernel.
- **PPID** (Parent Process ID) — the PID of the process that created it.
- **Owner** — the user account the process runs under.
- **State** — whether it is running, sleeping, waiting, or stopped.
- **Priority** — how much CPU time the kernel allocates to it.

All processes on a Linux system form a tree, with **PID 1 (systemd)** at the root.

---

## Core Commands

| Command | What It Does | Key Usage |
| :--- | :--- | :--- |
| `ps` | Takes a snapshot of currently running processes | `ps aux` or `ps -ef` |
| `top` | Live, real-time process and resource monitor | Run interactively |
| `htop` | Enhanced interactive process viewer (color-coded) | Run interactively |
| `kill` | Send a signal to a process (default: terminate) | `kill <PID>` or `kill -9 <PID>` |
| `pkill` | Send a signal to a process by name | `pkill nginx` |
| `nice` | Start a command with a modified CPU priority | `nice -n 19 <command>` |
| `renice` | Change the priority of an already-running process | `renice -n 10 -p <PID>` |
| `uptime` | Show system uptime and load average | `uptime` |

---

## Practical Examples

### 1. Finding the Top Resource-Consuming Processes

Find the top 5 processes consuming the most memory:

```bash
ps aux --sort=-%mem | head -n 6
```

**Flag breakdown:**

| Part | Meaning |
| :--- | :--- |
| `a` | Show processes from all users |
| `u` | Show user-oriented format (username, CPU%, MEM%) |
| `x` | Include processes not attached to a terminal |
| `--sort=-%mem` | Sort by memory usage, descending (highest first) |
| `head -n 6` | Show the header row + top 5 processes |

Similarly, sort by CPU:

```bash
ps aux --sort=-%cpu | head -n 6
```

---

### 2. Terminating a Process Safely

The correct two-step approach when a process is misbehaving:

```bash
# Step 1: Graceful termination — sends SIGTERM (signal 15)
# The process can catch this signal and shut down cleanly
kill <PID>

# Wait a few seconds, then check if it is still running
ps aux | grep <PID>

# Step 2: If it is still alive, force-kill it — sends SIGKILL (signal 9)
# The kernel terminates the process immediately, no cleanup possible
kill -9 <PID>
```

> ⚠️ Always try `kill` (SIGTERM) before `kill -9` (SIGKILL). SIGKILL can cause data corruption if the process was in the middle of a write operation.

---

### 3. Running a Background Task with Lower CPU Priority

Run a resource-intensive backup job without affecting the performance of your live application:

```bash
nice -n 19 tar -czf /backups/app_backup.tar.gz /var/www/myapp
```

**Nice values:**
- Range: `-20` (highest priority) to `19` (lowest priority).
- Default: `0` for normal processes.
- `19` means: "give CPU time to every other process before this one".

To change the priority of an already-running process:

```bash
renice -n 15 -p <PID>
```

---

### 4. Reading the `uptime` Load Average

```bash
uptime
```

**Sample output:** `15:42:01 up 3 days, 2:10, 1 user, load average: 0.85, 1.20, 1.05`

The three load average numbers represent the average number of processes **waiting for CPU** over the last:

| Number | Time Period |
| :--- | :--- |
| `0.85` | Last 1 minute |
| `1.20` | Last 5 minutes |
| `1.05` | Last 15 minutes |

**How to interpret:** If your server has 4 CPU cores, a load average of `4.0` means 100% utilization. A load above your core count means processes are queueing for CPU time — the server is overloaded.

---

## DevOps Use Cases

### Responding to a High CPU Alert

When a monitoring alert fires for high CPU usage:

```bash
# 1. Check current load
uptime

# 2. Identify the culprit process
top   # or: ps aux --sort=-%cpu | head -n 6

# 3. If it is a stuck application process, restart it cleanly via systemd
sudo systemctl restart myapp

# 4. If it is a runaway one-off process, terminate it
kill <PID>
```

### Running Long Database Migrations Without Impacting Live Traffic

A database migration can be CPU-intensive. Run it at a lower priority to keep the web application responsive:

```bash
nice -n 15 python manage.py migrate --database=production
```

---

## Best Practices

- Always try `kill` (SIGTERM) before `kill -9` (SIGKILL) to allow a clean shutdown.
- Use `systemctl restart <service>` instead of `kill` for services managed by systemd — systemd will handle restart policies correctly.
- Use `nice` for background batch jobs (backups, compressions, migrations) to prevent them from starving live application processes.
- Monitor load average alongside your CPU count — a load of `1.0` on a single-core system is very different from `1.0` on an 8-core system.

---

## Interview Q&A

**Q1: What are the three load average values shown by `uptime`?**
- **Answer:** They represent the average number of processes in a runnable or waiting state over the last **1 minute**, **5 minutes**, and **15 minutes**. A load average equal to the number of CPU cores means 100% utilization. A load consistently higher than the core count means the CPU is overloaded and processes are queuing.

**Q2: What is the difference between `SIGTERM` (signal 15) and `SIGKILL` (signal 9)?**
- **Answer:** `SIGTERM` is a request to terminate — the process can catch this signal, perform cleanup tasks (closing file handles, saving state, flushing buffers), and then exit gracefully. `SIGKILL` cannot be caught or ignored — the operating system kernel immediately terminates the process with no cleanup. Using `SIGKILL` on a process that was writing to a database or file can result in data corruption.

**Q3: What is the difference between `ps aux` and `ps -ef`?**
- **Answer:** Both show all running processes, but in different formats. `ps aux` uses BSD syntax and shows additional columns including `%CPU`, `%MEM`, and `VSZ`/`RSS` (memory sizes). `ps -ef` uses UNIX/POSIX syntax and shows `UID`, `PID`, `PPID`, `C` (CPU utilization), `STIME`, `TTY`, `TIME`, and the command. In practice, `ps aux` is more commonly used for DevOps troubleshooting because of the CPU and memory percentage columns.

---

> 🔖 **Note:** Process management is a core Linux skill for every DevOps and SRE role. Being able to quickly identify a misbehaving process, control its priority, and safely terminate it is fundamental to production incident response.
