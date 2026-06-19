# 🔐 File Permissions & Ownership

## 📌 Purpose
Linux enforces strict security boundaries using a granular file ownership and permission model. Misconfigured permissions are one of the most common causes of application deployment failures, broken build pipelines, and security vulnerabilities. DevOps engineers must master permissions to secure system binaries, configure SSH keys, and run services securely under non-privileged accounts.

---

## ⚙️ Core Concepts & Commands

### The Linux Permission Model
Every file and directory is assigned ownership for a **User (Owner)**, a **Group**, and **Others** (everyone else).
Permissions are represented by three actions:
*   **Read (`r` / `4`)**: Permission to view file contents or list directory contents.
*   **Write (`w` / `2`)**: Permission to modify file contents or add/delete files in a directory.
*   **Execute (`x` / `1`)**: Permission to run a file as a program or traverse into a directory.

| Command | Description | Syntax / Common Arguments | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `chmod` | Change file/directory permissions | `chmod [octal/symbolic] <file>` | Making shell scripts executable, restricting SSH key access. |
| `chown` | Change file owner and/or group | `chown [owner]:[group] <file>` | Assigning ownership of web directories to `www-data`. |
| `chgrp` | Change group ownership | `chgrp [group] <file>` | Changing group ownership of log files for monitoring tools. |
| `umask` | View or set default file creation mask | `umask [octal]` | Securing files automatically at creation time. |

---

## 💻 Practical Examples

### 1. Securing a Private Key File
Private SSH keys must be kept private. Linux ssh-clients will refuse connection if permissions are too open.
```bash
# Grant read-write to owner only
chmod 600 ~/.ssh/id_rsa
```
*   **Explanation:**
    *   `6` (Owner): Read + Write ($4 + 2$).
    *   `0` (Group): No permissions.
    *   `0` (Others): No permissions.

### 2. Making a Script Executable
Give execution permissions to owner and group, but read-only to others.
```bash
chmod 750 deploy.sh
```
*   **Explanation:**
    *   `7` (Owner): Read + Write + Execute ($4 + 2 + 1$).
    *   `5` (Group): Read + Execute ($4 + 1$).
    *   `0` (Others): No access.

### 3. Modifying Ownership Recursively
Transfer ownership of the entire directory tree to the application user and group.
```bash
chown -R appuser:appgroup /var/www/my-app
```
*   **Explanation:**
    *   `-R`: Recursive action, modifying all files and directories inside `/var/www/my-app`.
    *   `appuser:appgroup`: Sets `appuser` as owner and `appgroup` as group.

### 4. Understanding umask
A default file creation mask determines initial permissions of new files.
```bash
# Check current umask
umask

# Set umask to 022 (Default: Files get 644, Directories get 755)
umask 022
```
*   **Explanation:** New files are created with base mode `666` and directories with `777`. The `umask` value is subtracted from these. E.g., $666 - 022 = 644$ (rw-r--r--).

---

## 🛠️ DevOps Use Cases & Scenarios

### Resolving Nginx 403 Forbidden Errors
A common deployment mistake is copying files with `root` ownership into `/var/www`. Since the Nginx process runs under `www-data`, it cannot read the files, resulting in a `403 Forbidden` error. This is resolved by running:
```bash
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

---

## 💡 Interview Q&A & Tips

**Q1: How do you represent `rwxr-xr-x` in octal notation?**
*   **Answer:**
    *   `rwx` = $4 + 2 + 1 = 7$ (Owner)
    *   `r-x` = $4 + 0 + 1 = 5$ (Group)
    *   `r-x` = $4 + 0 + 1 = 5$ (Others)
    *   Octal notation is **`755`**.

**Q2: What is the risk of using `chmod 777` to fix permission errors?**
*   **Answer:** `chmod 777` gives full read, write, and execute permissions to everyone on the system. This is a critical security risk as it allows unauthorized users or compromised applications to read, modify, or run malicious code in those files/directories. Permission issues should instead be resolved by correcting owner/group settings and using the narrowest scope of permissions needed (e.g., `755` or `644`).
