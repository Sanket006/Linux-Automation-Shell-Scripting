# 💾 Disk & Memory Management

Disk and memory are two of the most critical resources on any Linux server. When either runs out, services crash, applications fail, and the entire server can become unresponsive. This document covers the commands and concepts you need to monitor these resources, prevent outages, and troubleshoot problems when they occur.

---

## Why This Matters

The most common causes of production outages related to resources are:

- **Disk full** — applications cannot write logs, temporary files, or database records. Services crash or hang.
- **Memory exhausted** — the Linux OOM (Out-Of-Memory) Killer terminates running processes to free RAM.
- **Incorrect mounts** — data written to the wrong partition fills the wrong disk.
- **Unchecked growth** — log files and caches quietly grow until they cause a sudden failure.

Proactive monitoring prevents all of these.

---

## Disk Space Commands

### `df` — Disk Free Space

Shows how much space is used and available on each mounted filesystem.

```bash
# Human-readable output (shows GB, MB instead of blocks)
df -h

# Check inode usage (important when df shows space but writes fail)
df -i
```

**Sample output:**

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   14G  5.1G  74% /
/dev/xvdb        50G   12G   38G  24% /data
```

> 📌 **Watch the `Use%` column.** Set monitoring alerts at 80% and escalate at 90%. A full root partition (`/`) causes the entire server to malfunction.

### `du` — Disk Usage by Directory

Scans the file tree and calculates how much space specific directories and files are consuming.

```bash
# Show total size of a specific directory (human-readable)
du -sh /var/log

# Show the top 10 largest items under /var, sorted by size
sudo du -ah /var | sort -rh | head -n 10
```

**Key difference:** `df` reads filesystem metadata (fast). `du` walks the directory tree (slower but granular). Use `df` to find which partition is full, then use `du` to find which folder inside it is the problem.

---

## Block Devices & Partitions

### `lsblk` — List Block Devices

Shows all physical and virtual disks, their partitions, sizes, and mount points.

```bash
lsblk
```

**Sample output:**

```text
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   20G  0 disk
└─xvda1 202:1    0   20G  0 part /
xvdb    202:16   0   50G  0 disk /data
```

### `blkid` — Block Device Information

Shows the UUID, filesystem type, and label of each device — useful when configuring `/etc/fstab`.

```bash
blkid
```

---

## Mounting & Unmounting Filesystems

When you attach a new disk (e.g., an AWS EBS volume), you must format it and mount it before you can use it.

### Mount a Filesystem

```bash
# Mount a device to a directory
sudo mount /dev/xvdf /data

# Verify it is mounted
mount | grep /data
```

### Unmount a Filesystem

```bash
# Unmount safely before detaching a disk
sudo umount /data
```

### Persistent Mounts with `/etc/fstab`

Mounts defined in `/etc/fstab` are applied automatically on every boot.

```text
# Format: <device>  <mount point>  <filesystem>  <options>  <dump>  <pass>
/dev/xvdf  /data  ext4  defaults  0  2
```

> 💡 Use the UUID (from `blkid`) instead of device names like `/dev/xvdf` in `/etc/fstab`. Device names can change between reboots; UUIDs do not.

---

## Logical Volume Management (LVM)

LVM allows you to resize storage volumes without downtime — critical for production databases and growing log directories.

**Basic components:**
- **Physical Volume (PV)** — a raw physical disk or partition.
- **Volume Group (VG)** — a pool of storage made from one or more PVs.
- **Logical Volume (LV)** — a flexible virtual partition carved from a VG.

```bash
pvdisplay    # Show physical volumes
vgdisplay    # Show volume groups
lvdisplay    # Show logical volumes

# Extend a logical volume by 10GB
sudo lvextend -L +10G /dev/vg0/data

# Resize the filesystem to use the new space (ext4)
sudo resize2fs /dev/vg0/data
```

---

## Memory Commands

### `free` — Memory Usage Overview

Shows total, used, and available RAM and swap space.

```bash
free -h
```

**Sample output:**

```text
              total        used        free      shared  buff/cache   available
Mem:           7.8G        3.2G        512M        128M        4.1G        4.3G
Swap:          2.0G        200M        1.8G
```

- **`used`** — memory actively in use by processes.
- **`buff/cache`** — memory used by disk cache (Linux reclaims this when needed).
- **`available`** — memory available for new processes (more reliable than `free`).

### `vmstat` — Memory & CPU Statistics

Shows a snapshot of memory, swap, CPU, and I/O statistics.

```bash
vmstat 2 5     # Refresh every 2 seconds, show 5 readings
```

---

## Swap Memory

Swap is disk space used as an **overflow extension of RAM**. When physical RAM fills up, the Linux kernel moves inactive memory pages to swap to free RAM for active processes.

**Important tradeoff:** Swap prevents crashes but significantly slows performance — disk access is 100x slower than RAM. High swap usage is a warning sign that the server needs more RAM.

### Check Swap Status

```bash
swapon --show

free -h     # Also shows swap usage
```

### Create and Enable a Swap File

```bash
# Create a 1GB swap file
sudo fallocate -l 1G /swapfile

# Secure it — swap must only be readable by root
sudo chmod 600 /swapfile

# Format it as swap space
sudo mkswap /swapfile

# Enable it immediately
sudo swapon /swapfile
```

To make it permanent across reboots, add to `/etc/fstab`:

```text
/swapfile   none   swap   sw   0   0
```

---

## CPU Monitoring

### `top` — Real-Time Process and Resource Monitor

```bash
top
```

Key columns to watch: `%CPU`, `%MEM`, `COMMAND`. Press `M` to sort by memory, `P` to sort by CPU.

### `uptime` — Load Average

```bash
uptime
```

**Sample output:** `12:30:00 up 5 days, 3:22, 2 users, load average: 1.20, 0.85, 0.60`

The three load average numbers represent the average number of processes waiting for CPU over the last **1 minute**, **5 minutes**, and **15 minutes**. If load average consistently exceeds your CPU core count, the server is under pressure.

---

## Disk Cleanup

Free up disk space safely without deleting important data:

```bash
# Clear old system journal logs (keep only last 7 days)
sudo journalctl --vacuum-time=7d

# Clear the apt package cache (Debian/Ubuntu)
sudo apt clean

# Remove temporary files
sudo rm -rf /tmp/*
```

---

## DevOps Use Cases

### Preventing "Disk Full" Outages

Set up a cron job or monitoring alert to check disk usage daily. When a server exceeds 80%, investigate before it hits 100%:

```bash
# Quick check — show only partitions above 80% full
df -h | awk 'NR==1 || $5+0 > 80 {print}'
```

### Expanding an AWS EBS Volume Without Downtime

1. Resize the volume in the AWS Console.
2. Tell the OS about the new size: `sudo growpart /dev/xvda 1`
3. Resize the filesystem: `sudo resize2fs /dev/xvda1`

No reboot required.

### Diagnosing Memory Leaks

If an application's memory grows over time without releasing it, it has a memory leak:

```bash
# Watch a specific process's memory usage every 2 seconds
watch -n 2 'ps -o pid,rss,comm -p <PID>'
```

---

## Best Practices

- Set disk usage monitoring alerts at **80%** (warning) and **90%** (critical).
- Never let the root partition (`/`) fill up — keep at least 10% free at all times.
- Separate high-growth directories (`/var/log`, `/var/lib/docker`, `/data`) onto their own partitions or disks.
- Use **LVM** for production storage so you can expand volumes without downtime.
- Configure swap on all servers as a safety net, but address the root cause if swap is consistently used.

---

## Interview Q&A

**Q1: What is the difference between `df` and `du`?**
- **Answer:** `df` (disk free) shows space usage at the filesystem level by reading superblock metadata — it is fast and shows total/used/free for each mounted partition. `du` (disk usage) walks the directory tree and calculates how much space each file and folder consumes — it is slower but shows exactly which directories are taking up space. Use `df` to find the full partition, then `du` to find the culprit inside it.

**Q2: What could cause `df -h` to show 100% disk usage but no large files appear?**
- **Answer:** Two common causes: (1) **Deleted files still held open** — if a process deleted a large log file but is still writing to it, the space is not released until the process is closed. Find these with `lsof +L1`. (2) **Inode exhaustion** — the filesystem may have run out of inodes (file metadata slots) even though physical space exists. Check with `df -i`. This happens when millions of tiny files accumulate (e.g., in mail queues or session caches).

**Q3: What is swap memory and when does Linux use it?**
- **Answer:** Swap is a reserved area on disk that acts as overflow RAM. When physical RAM fills up, the Linux kernel moves the least-recently-used memory pages from RAM to swap, freeing RAM for active tasks. While this prevents out-of-memory crashes, disk access is much slower than RAM, so heavy swap usage ("thrashing") causes significant performance degradation. Consistent swap usage is a signal to add more RAM to the server.

---

> 🔖 **Note:** Disk and memory management is a critical daily skill for DevOps, SRE, and Cloud engineers. Proactive monitoring and knowing how to investigate resource issues quickly is what keeps production systems healthy and prevents 3am outages.
