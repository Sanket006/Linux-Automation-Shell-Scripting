# 🛠️ System Troubleshooting Commands

## 📌 Purpose
When production incidents occur, DevOps engineers must act quickly to restore services. Troubleshooting requires locating, filtering, and analyzing logs across different layers (kernel, services, and applications) to identify the root cause of an outage, such as memory exhaustion, permission errors, or service crash loops.

---

## ⚙️ Core Concepts & Commands

| Command | Description | Common Flags / Usage | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `journalctl` | Query the systemd journal logs | `journalctl -u nginx` | Inspecting service-specific logs and boot outputs. |
| `dmesg` | Print or control the kernel ring buffer | `dmesg -T` | Checking kernel-level hardware, driver, and OOM killer events. |
| `systemctl` | Control the systemd system and service manager | `systemctl status <service>` | Inspecting service operational state and error codes. |
| `tail` | Output the last part of files | `tail -f /var/log/syslog` | Live streaming log updates during a deployment or test. |
| `grep` | Pattern matching utility | `grep -i "error" <file>` | Filtering large log files for specific failure patterns. |

---

## 💻 Practical Examples

### 1. Live-Monitoring System Logs
Stream system logs in real-time, filtering for warnings or errors.
```bash
tail -f /var/log/syslog | grep -iE 'error|warning|critical'
```
*   **Explanation:**
    *   `tail -f`: Monitors the target file and outputs new lines as they are appended.
    *   `grep -iE`: Case-insensitive (`-i`) extended regex (`-E`) to filter for any lines containing 'error', 'warning', or 'critical'.

### 2. Debugging Service Startup Failures
Retrieve recent error logs for a failed systemd service (e.g., Nginx).
```bash
journalctl -u nginx --since "1 hour ago" -n 50 --no-pager
```
*   **Explanation:**
    *   `-u nginx`: Filters logs specifically for the Nginx service.
    *   `--since "1 hour ago"`: Limits log search window to the last hour.
    *   `-n 50`: Shows only the last 50 log lines.
    *   `--no-pager`: Displays output immediately without entering interactive pagers like `less`.

### 3. Finding Out-Of-Memory (OOM) Killer Evictions
Identify if the Linux kernel terminated your application because the server ran out of physical memory.
```bash
dmesg -T | grep -i -E 'oom|kill'
```
*   **Explanation:**
    *   `-T`: Formats timestamps in human-readable date/time format instead of uptime seconds.
    *   `grep -i -E 'oom|kill'`: Searches for system events indicating the Out-Of-Memory Killer was triggered.

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving Nginx "Address already in use" Error
A web server fails to restart. Running `systemctl status nginx` shows `Active: failed` with a vague exit code.
- **Troubleshooting Process:**
  1. Retrieve journal logs: `journalctl -xe -u nginx`
  2. The log reveals: `nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)`
  3. Identify which process is holding port 80: `sudo ss -tulnp | grep :80`
  4. Kill the competing process (e.g., Apache) or update configurations:
     ```bash
     sudo systemctl stop apache2
     sudo systemctl start nginx
     ```

---

## 💡 Interview Q&A & Tips

**Q1: How do you troubleshoot a service that fails to start?**
*   **Answer:**
    1. Run `systemctl status <service>` to check the current state and see the initial error lines.
    2. Inspect detailed logs using `journalctl -u <service> -n 100 --no-pager` or check the service's custom log files in `/var/log/`.
    3. Run the application binary directly in foreground mode with debug flags if available to see stdout/stderr error details.
    4. Check for port conflicts (`ss -tulnp`) and permission issues on config and log paths.

**Q2: What is `dmesg` used for?**
*   **Answer:** `dmesg` displays messages from the kernel ring buffer. It is used to diagnose issues related to hardware drivers, memory limits (like the Out-Of-Memory Killer terminating processes), firewall packet drops, and disk read/write errors.
