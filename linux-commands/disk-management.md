# 💽 Disk & Storage Management

Storage is one of the most critical resources on any server. When a disk fills up, applications cannot write logs or database records, services crash, and the server can become unresponsive. DevOps engineers use disk management commands to monitor storage health, find which directories are consuming space, attach new storage volumes, and plan capacity before problems occur.

> 📖 **See also:** For LVM (Logical Volume Management), swap configuration, memory monitoring, and production scenarios like expanding AWS EBS volumes, see [`docs/disk-memory-management.md`](../docs/disk-memory-management.md).

---

## Core Commands

| Command | What It Does | Key Flags & Usage |
| :--- | :--- | :--- |
| `df` | Report disk space usage for all mounted filesystems | `df -h` human-readable, `df -i` inode usage |
| `du` | Estimate disk space used by specific files/directories | `du -sh <dir>`, `du -ah \| sort -rh` |
| `lsblk` | List all block devices (physical disks and partitions) | `lsblk` |
| `mount` | Mount a filesystem at a directory | `mount /dev/sdb1 /mnt` |
| `umount` | Unmount a filesystem safely | `umount /mnt` |
| `fdisk` | Partition management tool | `sudo fdisk -l` to list partitions |
| `mkfs` | Format a partition with a filesystem | `sudo mkfs.ext4 /dev/sdb` |

---

## Practical Examples

### 1. High-Level Disk Space Check

The first command to run when investigating a disk-full alert.

```bash
df -h
```

**Sample output:**

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   17G  2.3G  88% /
/dev/xvdb        50G   12G   38G  24% /data
tmpfs           3.9G     0  3.9G   0% /dev/shm
```

> 📌 **Watch the `Use%` column.** Set alerts at 80%. At 100%, the system may refuse to write new files, causing service crashes.

---

### 2. Finding the Largest Directories (Disk Hogs)

After `df -h` shows a partition is full, use `du` to find exactly which folder is consuming the most space.

```bash
# Find the top 10 largest directories/files under /var
sudo du -ah /var | sort -rh | head -n 10
```

**Flag breakdown:**

| Flag | Meaning |
| :--- | :--- |
| `-a` | Show sizes for both files and directories (not just directories) |
| `-h` | Human-readable sizes (K, M, G) |
| `sort -rh` | Sort in reverse (`-r`) by human-readable size (`-h`) — largest first |
| `head -n 10` | Show only the top 10 results |

---

### 3. Listing All Disks and Their Partitions

Use `lsblk` to see all attached physical disks, their partitions, sizes, and where they are mounted.

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

This tells you that a 50GB disk (`xvdb`) is mounted at `/data`.

---

### 4. Mounting a New Storage Volume

When you attach a new disk (e.g., an AWS EBS volume), you must format it and mount it before using it.

```bash
# Step 1: Confirm the new disk is visible
lsblk

# Step 2: Format the disk with the ext4 filesystem
sudo mkfs.ext4 /dev/xvdb

# Step 3: Create the mount point directory
sudo mkdir -p /data

# Step 4: Mount the disk
sudo mount /dev/xvdb /data

# Step 5: Verify it is mounted correctly
df -h | grep /data
```

**To make the mount persistent across reboots**, add it to `/etc/fstab`:

```text
/dev/xvdb  /data  ext4  defaults  0  2
```

> 💡 Use the disk's **UUID** (from `blkid`) in `/etc/fstab` instead of device names like `/dev/xvdb`, which can change between reboots.

---

## DevOps Use Cases

### Resolving Inode Exhaustion (Disk Full with Free Space)

Sometimes a server reports "No space left on device" but `df -h` shows plenty of available space. This happens when the filesystem runs out of **inodes** — the metadata slots that store information about each file. This occurs when an application creates millions of tiny files (e.g., email queues, PHP session files).

**Diagnose:**

```bash
# Check inode usage across filesystems
df -i
```

**Sample output showing inode exhaustion:**

```text
Filesystem     Inodes  IUsed   IFree IUse% Mounted on
/dev/xvda1    1310720 1310720       0  100% /
```

**Fix:**

```bash
# Find directories with a huge number of files
find /var/spool -type d -exec sh -c 'echo "$(ls {} | wc -l) {}"' \; | sort -rn | head

# Delete the accumulated files
find /var/spool/clientmqueue -type f -delete
```

### Preventing Disk Full Outages

Automate disk usage monitoring with a simple script scheduled as a cron job:

```bash
# Alert if any partition is above 85% full
df -h | awk 'NR>1 && $5+0 > 85 {print "ALERT: " $6 " is at " $5 " usage"}'
```

---

## Best Practices

- Monitor disk usage with alerts at **80%** (warning) and **90%** (critical).
- Never let the root partition (`/`) fill completely — always keep at least 10% free.
- Separate high-growth directories (`/var/log`, `/var/lib/docker`, databases) onto their own dedicated disks or partitions.
- Always use `umount` before physically removing or detaching a storage device.
- Use the disk UUID in `/etc/fstab` (not device names) to ensure mounts survive hardware changes or reboots.

---

## Interview Q&A

**Q1: What is the difference between `df` and `du`?**
- **Answer:** `df` (disk free) shows space usage at the filesystem level by reading superblock metadata — it is fast and shows overall totals for each mounted partition, including space used by deleted files still held open. `du` (disk usage) walks the directory tree file-by-file — it is slower but shows exactly which folders and files are consuming space. Use `df` to identify the full partition, then `du` to find which directory inside it is the culprit.

**Q2: Why might `df -h` show a disk as 100% full but `du` reports much less usage?**
- **Answer:** This is caused by deleted files that are still held open by a running process. When a file is deleted (`rm`), the filesystem marks its space as free, but the space is not physically released until all processes that have the file open close their file descriptor. `df` reads the filesystem-level usage and counts this space as used; `du` scans the directory tree, does not find the deleted file, and reports lower usage. The fix is to find the process holding the file open (`lsof +L1`) and restart or reload it.

**Q3: How do you attach a new disk on an AWS EC2 instance and make it available for use?**
- **Answer:**
  1. In the AWS Console, create and attach an EBS volume to the EC2 instance.
  2. On the instance, find the new device: `lsblk`.
  3. Format it: `sudo mkfs.ext4 /dev/xvdb`.
  4. Create a mount point: `sudo mkdir -p /data`.
  5. Mount it: `sudo mount /dev/xvdb /data`.
  6. Make it persistent: add the UUID-based entry to `/etc/fstab`.

---

> 🔖 **Note:** Disk management is a critical daily skill for DevOps and cloud engineers. Understanding how to quickly find what is consuming disk space, how to attach and configure new storage, and how to prevent outages through proactive monitoring is essential for keeping production systems healthy.
