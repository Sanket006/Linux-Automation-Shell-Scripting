# 📁 File & Directory Management

## 📌 Purpose
Files and directories are the primary abstractions used by the Linux operating system to represent data, hardware, and configuration. Competence in file management allows DevOps engineers to deploy application assets, manage configuration files, clean up logs, and search for specific data structures efficiently.

---

## ⚙️ Core Concepts & Commands

| Command | Description | Common Flags & Arguments | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `ls` | List directory contents | `-l` (long format), `-a` (show hidden), `-h` (human-readable sizes) | Inspecting permissions/sizes of files. |
| `cp` | Copy files or directories | `-r` (recursive), `-p` (preserve file attributes) | Backing up configs before editing them. |
| `mv` | Move or rename files | `mv source destination` | Renaming configuration files or deploying builds. |
| `rm` | Remove files or directories | `-r` (recursive), `-f` (force removal, no prompt) | Deleting temporary builds or old rotated logs. |
| `find` | Search files in a directory hierarchy | `find <path> -name "<pattern>" -type f/d` | Finding old log files or locating assets. |
| `stat` | Display file or filesystem status | `stat <filename>` | Retrieving detailed file metadata, creation/modification times. |

---

## 💻 Practical Examples

### 1. Advanced Directory Listing
List all files, including hidden files, with sizes in a human-readable format, sorted by modification time.
```bash
ls -lath
```
* **Explanation:**
  * `-l`: Displays in long listing format (permissions, owner, group, size, date).
  * `-a`: Includes hidden files (files starting with `.`).
  * `-h`: Displays file sizes in human-readable units (e.g., K, M, G).
  * `-t`: Sorts files by modification time, showing the newest first.

### 2. Searching and Cleaning Up Old Files
Find all `.log` files in `/var/log` that are older than 7 days and delete them.
```bash
find /var/log -type f -name "*.log" -mtime +7 -exec rm -f {} \;
```
* **Explanation:**
  * `/var/log`: The search directory path.
  * `-type f`: Searches only for files.
  * `-name "*.log"`: Filters files ending with `.log`.
  * `-mtime +7`: Filters files modified more than 7 days ago.
  * `-exec rm -f {} \;`: Executes the force-delete command on every matched file.
* **Production Tip:** Always run the `find` command without the `-exec rm...` part first to verify the files you are about to delete!

### 3. Copying with Metadata Preservation
Copy a directory and preserve ownership, timestamps, and permissions.
```bash
cp -rp /etc/nginx /etc/nginx_backup
```
* **Explanation:**
  * `-r`: Recursively copies directories.
  * `-p`: Preserves file mode, ownership, and timestamps.

---

## 🛠️ DevOps Use Cases & Scenarios

### Log Rotation & Disk Maintenance
Servers often run out of disk space due to runaway application logs. DevOps engineers write automated shell scripts using `find` and `rm` to locate and purge stale files, preventing service degradation.

### Blue-Green Deployment Asset Management
When deploying static assets, a script might copy new files to a staging directory using `cp -r` and then switch symlinks or rename directories using `mv` for zero-downtime deployment.

---

## 💡 Interview Q&A & Tips

**Q1: How do you find files modified in the last 24 hours in a specific directory?**
* **Answer:** Use the `find` command with the `-mmin` or `-mtime` parameter. For example: `find /path/to/search -type f -mtime -1` (finds files modified less than 1 day ago) or `find /path/to/search -type f -mmin -1440` (last 1440 minutes/24 hours).

**Q2: What is the difference between `rm -r` and `rm -f`?**
* **Answer:** `rm -r` recursively removes directories and their contents. `rm -f` forces removal without prompting the user, ignoring non-existent files. Combined, `rm -rf` is a powerful and potentially dangerous command that recursively deletes a directory structure without prompt.
