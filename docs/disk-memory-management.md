# 💾 Linux Disk & Memory Management

This document covers **Linux disk, storage, and memory management commands** used to **monitor system resources, prevent outages, and troubleshoot performance issues** in DevOps and production environments.

---

## 📌 Why Disk & Memory Management Matters

Common production failures happen due to:

* Disk full errors
* Memory exhaustion
* Improper mounts
* Unmonitored resource usage

Effective monitoring helps ensure **system stability and uptime**.

---

## 📌 Disk Usage & Space Monitoring

### `df` – Disk Free Space

```bash
df
df -h
```

* `-h` → human-readable output

**Use case:** Check available disk space on servers.

---

### `du` – Disk Usage by Directory

```bash
du
du -sh /var/log
du -ah | sort -h
```

**Use case:** Identify directories consuming most space.

---

## 📌 Block Devices & Partitions

### `lsblk` – List Block Devices

```bash
lsblk
```

### `blkid` – Block Device Info

```bash
blkid
```

**Use case:** Inspect disks, partitions, and mount points.

---

## 📌 Mounting & Unmounting Filesystems

### `mount`

```bash
mount
mount /dev/xvdf /data
```

### `umount`

```bash
umount /data
```

### Persistent Mounts – `/etc/fstab`

```text
/dev/xvdf  /data  ext4  defaults  0  2
```

**Use case:** Attach storage volumes permanently.

---

## 📌 Logical Volume Management (LVM)

Basic components:

* Physical Volume (PV)
* Volume Group (VG)
* Logical Volume (LV)

```bash
pvdisplay
vgdisplay
lvdisplay
```

**Use case:** Resize storage without downtime.

---

## 📌 Memory Monitoring

### `free` – Memory Usage

```bash
free
free -h
```

### `vmstat` – Memory & CPU Stats

```bash
vmstat
```

**Use case:** Diagnose memory pressure.

---

## 📌 Swap Memory

### Check Swap

```bash
swapon --show
```

### Create Swap File

```bash
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

**Use case:** Prevent out-of-memory crashes.

---

## 📌 CPU Monitoring

### `top`

```bash
top
```

### `uptime`

```bash
uptime
```

**Use case:** Check load average & CPU stress.

---

## 📌 Disk Cleanup & Maintenance

```bash
journalctl --vacuum-time=7d
rm -rf /tmp/*
```

**Use case:** Free disk space safely.

---

## 🚀 DevOps & Production Use Cases

* Preventing "disk full" outages
* Managing EC2 EBS volumes
* Monitoring memory leaks
* Capacity planning
* CI/CD runner resource tuning

---

## ⭐ Best Practices

* Monitor disk & memory proactively
* Keep alerts for high usage
* Avoid filling root partition
* Use LVM for scalability
* Configure swap carefully

---

## 🎯 Interview Tips

* Difference between `df` and `du`
* What happens when disk is full
* Swap vs RAM
* Load average explanation

---

### 🔖 Note

Disk and memory management is a **critical Linux skill** for **DevOps, SRE, and Cloud engineers**, directly impacting system reliability and performance.
