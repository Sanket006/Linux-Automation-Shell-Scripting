# 💽 Disk & Storage Management

## 📌 Purpose
Storage is one of the most critical resources in server environments. Runaway logs, unmanaged cache directories, and bloating docker containers can easily exhaust disk space, causing applications to fail. DevOps engineers use disk management commands to monitor storage health, identify high-volume directories, attach new volumes, and plan storage capacities.

---

## ⚙️ Core Concepts & Commands

| Command | Description | Common Flags / Usage | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `df` | Report filesystem disk space usage | `df -h` | Checking total, used, and available space on all partitions. |
| `du` | Estimate file space usage | `du -sh <dir>` | Identifying which folder or file is consuming the most disk space. |
| `lsblk` | List block devices | `lsblk` | Inspecting available physical drives, sizes, and mount points. |
| `mount` | Mount a filesystem | `mount /dev/sdb1 /mnt` | Attaching a new storage volume to the filesystem. |
| `umount` | Unmount a filesystem | `umount /mnt` | Detaching a storage volume safely before removal. |

---

## 💻 Practical Examples

### 1. High-Level Disk Usage Check
Inspect space usage across all mounted filesystems.
```bash
df -h
```
*   **Explanation:** Shows total storage, used space, and percentage utilization in human-readable sizes (K, M, G).
*   **Production Tip:** Watch the "Use%" column. Alert thresholds are typically set at 80% or 90% utilization.

### 2. Identifying the Largest Directories (Disk Hogs)
Find and list the top 10 largest folders/files under a specific path (e.g., `/var`).
```bash
sudo du -ah /var | sort -rh | head -n 10
```
*   **Explanation:**
    *   `-a`: Lists sizes for both files and directories.
    *   `-h`: Displays size in human-readable units.
    *   `sort -rh`: Sorts the output numerically (`-n` is represented here implicitly) in reverse order (`-r`) based on human-readable values (`-h`).
    *   `head -n 10`: Limits output to the top 10 items.

### 3. Mounting a New Partition
Format and mount a new block device `/dev/sdb` to `/data`.
```bash
# 1. Format the partition as ext4
sudo mkfs.ext4 /dev/sdb

# 2. Create the mount directory
sudo mkdir -p /data

# 3. Mount the drive
sudo mount /dev/sdb /data
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving Inode Exhaustion (Disk Full with Free Space)
Sometimes, a server reports a "No space left on device" error, but `df -h` shows plenty of available space. This happens when the filesystem runs out of **inodes** (index nodes), which store metadata about files. If an application creates millions of tiny files, the inode limit is reached first.
- **Troubleshooting:**
  ```bash
  # Check inode usage
  df -i
  ```
- **Resolution:** Identify directories containing a large number of files (often `/var/spool` or session directories) and purge them:
  ```bash
  find /var/spool/clientmqueue -type f -delete
  ```

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between `df` and `du`?**
*   **Answer:** `df` (disk free) displays disk space usage at the filesystem level, reading the superblock metadata directly. It is fast and reflects deleted files whose file descriptors are still held open by processes. `du` (disk usage) calculates space by scanning the directory tree file-by-file. It is slower and shows how much disk space is consumed by specific folders/files.

**Q2: Why might `df` show higher disk usage than `du`?**
*   **Answer:** If a large log file is deleted (`rm logfile.log`) while a process (like Nginx) is still actively writing to it, the space will not be freed because the process holds the file descriptor open. `df` registers this space as used because the filesystem tracks the active write. `du` scans the directories, does not find the deleted file, and reports lower usage. Resolving this requires reloading/restarting the active process.
