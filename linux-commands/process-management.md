# ⚙️ Process Management

## 📌 Purpose
Every running application, utility, or shell command in Linux runs as a process. Process management is critical for DevOps engineers to monitor system resource consumption (CPU, Memory), troubleshoot hanging applications, control background tasks, and adjust scheduling priorities to maintain stable production environments.

---

## ⚙️ Core Concepts & Commands

### What is a Process?
Each process is allocated a unique **PID (Process ID)**. Processes can spawn child processes, creating a tree starting from the parent `systemd` process (PID 1).

| Command | Description | Common Flags / Usage | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `ps` | Snapshot of current processes | `ps aux` or `ps -ef` | Listing running processes and tracking down a specific PID. |
| `top` | Dynamic, real-time process viewer | Interactive | Monitoring active system resource usage. |
| `htop` | Interactive, colorized process viewer | Interactive | Visually managing processes, sorting, and killing directly. |
| `kill` | Send signals to processes (terminate) | `kill -9 <PID>` | Stopping hanging or unresponsive application processes. |
| `nice` | Run command with modified scheduling priority | `nice -n <niceness> <cmd>` | Launching resource-intensive backups with lower CPU priority. |
| `renice` | Alter priority of running processes | `renice -n <niceness> -p <PID>` | Adjusting a database migration process priority in real-time. |
| `uptime` | Display system load average & uptime | `uptime` | Checking if the CPU load average is within normal limits. |

---

## 💻 Practical Examples

### 1. Identifying the Top Resource-Consuming Processes
Find the top 5 memory-consuming processes.
```bash
ps aux --sort=-%mem | head -n 6
```
*   **Explanation:**
    *   `aux`: Lists all processes (`a`), including those of other users (`u`), and those without a controlling terminal (`x`).
    *   `--sort=-%mem`: Sorts processes in descending order (`-`) of memory usage (`%mem`).
    *   `head -n 6`: Outputs the header plus the top 5 processes.

### 2. Terminating a Hanging Process Safely
Gracefully terminate a process, and force-kill it only if it does not respond.
```bash
# 1. Attempt graceful termination (SIGTERM)
kill 1234

# 2. If it remains stuck, force kill (SIGKILL)
kill -9 1234
```
*   **Explanation:**
    *   `kill 1234` sends `SIGTERM` (signal 15), giving the process time to save state and clean up resources.
    *   `kill -9 1234` sends `SIGKILL` (signal 9), which immediately terminates the process at the kernel level without cleanup.

### 3. Lowering Process Priority (Nice values)
Run a backup compression script with low CPU priority so it does not degrade user traffic.
```bash
nice -n 19 tar -czf backup.tar.gz /data
```
*   **Explanation:**
    *   Nice values range from `-20` (highest priority) to `19` (lowest priority). A value of `19` tells the scheduler to yield CPU time to other processes first.

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving High Load and CPU Starvation
When alerts trigger for high load average, a DevOps engineer runs `top` or `htop` to identify the culprit. If a Java application is stuck in an infinite garbage collection loop consuming 100% CPU, they capture a thread dump and restart the process gracefully using:
```bash
systemctl restart tomcat
```

---

## 💡 Interview Q&A & Tips

**Q1: What are the three values shown in `uptime` (Load Average)?**
*   **Answer:** They represent the average system load over the last **1 minute**, **5 minutes**, and **15 minutes**. System load represents the number of processes currently running or waiting for CPU time. If your system has 4 CPU cores, a load average of 4.0 means the CPU is at 100% utilization. Anything higher indicates queueing.

**Q2: What is the difference between `SIGTERM` (15) and `SIGKILL` (9)?**
*   **Answer:** `SIGTERM` is the default termination signal. It can be caught, handled, or ignored by the process, allowing it to perform cleanup tasks (closing file handles, connections). `SIGKILL` cannot be caught or ignored; the OS immediately kills the process, which can lead to data corruption or incomplete writes.
