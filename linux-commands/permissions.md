# 🔐 File Permissions & Ownership

Linux enforces strict security boundaries using a **file ownership and permission model**. Every file and directory is owned by a specific user and group, and each has a defined set of access rules. Misconfigured permissions are one of the most common causes of deployment failures, "permission denied" errors, and security vulnerabilities. Mastering this topic is essential.

> 📖 **See also:** For SUID, SGID, Sticky Bit, and ACL (`setfacl`/`getfacl`) coverage, see [`docs/file-permissions.md`](../docs/file-permissions.md).

---

## How Linux Permissions Work

Every file and directory has permissions defined for three groups of people:

| Group | Who It Applies To |
| :--- | :--- |
| **User (Owner)** | The user who owns the file |
| **Group** | All members of the file's assigned group |
| **Others** | Everyone else on the system |

For each group, three types of access can be granted or denied:

| Permission | Symbol | Octal Value | On a File | On a Directory |
| :--- | :--- | :--- | :--- | :--- |
| Read | `r` | `4` | View file contents | List directory contents (`ls`) |
| Write | `w` | `2` | Modify the file | Create, rename, or delete files inside |
| Execute | `x` | `1` | Run as a program | Enter the directory (`cd`) |

When you run `ls -l`, permissions appear as a 10-character string:

```text
-rwxr-xr--  1  appuser  appgroup  4096  Jun 22  deploy.sh
```

| Characters | Meaning |
| :--- | :--- |
| `-` | File type: `-` = regular file, `d` = directory, `l` = symlink |
| `rwx` | Owner: read + write + execute |
| `r-x` | Group: read + execute (no write) |
| `r--` | Others: read only |

---

## Core Commands

| Command | Purpose | Example |
| :--- | :--- | :--- |
| `chmod` | Change file permissions | `chmod 750 deploy.sh` |
| `chown` | Change file owner and/or group | `chown appuser:appgroup /var/www` |
| `chgrp` | Change group ownership only | `chgrp devops /var/log/myapp` |
| `umask` | View or set default permissions for new files | `umask 022` |

---

## Practical Examples

### 1. Securing a Private SSH Key

SSH clients will refuse to use a private key if its permissions are too open.

```bash
chmod 600 ~/.ssh/id_rsa
```

**Why `600`:**

| Octal | Who | Permissions |
| :--- | :--- | :--- |
| `6` | Owner | Read + Write (`4 + 2`) |
| `0` | Group | No access |
| `0` | Others | No access |

---

### 2. Making a Script Executable

Give the owner full access, the group read and execute, and block all other users.

```bash
chmod 750 deploy.sh
```

**Why `750`:**

| Octal | Who | Permissions |
| :--- | :--- | :--- |
| `7` | Owner | Read + Write + Execute (`4 + 2 + 1`) |
| `5` | Group | Read + Execute (`4 + 1`) |
| `0` | Others | No access |

---

### 3. Fixing Web Server Ownership Recursively

After copying new files into `/var/www/html`, the Nginx service (which runs as `www-data`) cannot read them because the files are still owned by root.

```bash
# Transfer ownership to the web server user and group
sudo chown -R www-data:www-data /var/www/html

# Set appropriate permissions
sudo chmod -R 755 /var/www/html
```

The `-R` flag applies the change recursively to all files and subdirectories inside the path.

---

### 4. Understanding `umask`

`umask` is a filter that is subtracted from the maximum permission when a new file or directory is created.

```bash
# Check current umask
umask

# Set a common, secure umask
umask 022
```

**How it works:**

| Type | Base Permission | `umask 022` | Result |
| :--- | :--- | :--- | :--- |
| New file | `666` (rw-rw-rw-) | `− 022` | `644` (rw-r--r--) |
| New directory | `777` (rwxrwxrwx) | `− 022` | `755` (rwxr-xr-x) |

A `umask` of `022` means: remove write permission from group and others for all new files.

---

## DevOps Use Cases

### Resolving "403 Forbidden" on Nginx

A very common deployment mistake: you copy application files as root into `/var/www`, but the Nginx process runs under `www-data`. Since `www-data` does not own the files and "others" has no read permission, every request returns a `403 Forbidden` error.

**Diagnosis:**

```bash
# Check file ownership
ls -la /var/www/html/

# Check what user Nginx runs as
systemctl show nginx -p User
```

**Fix:**

```bash
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

### Securing Application Configuration Files

Config files often contain secrets (database passwords, API keys). Restrict access so only the application's service user can read them:

```bash
# Owner can read/write, no one else can access
sudo chmod 600 /etc/myapp/config.yaml
sudo chown myapp:myapp /etc/myapp/config.yaml
```

---

## Best Practices

- Use the **narrowest permission needed** — never grant `777` to fix a permission error.
- Use `chown` to fix ownership issues — do not give "others" write access to work around ownership problems.
- Never store secrets in world-readable files. Use `chmod 600` for config files containing passwords.
- Use `groups` to share access between multiple users — add them to the same group and set `chmod 770`.
- When creating service accounts, use `chmod 750` for scripts so the service user can execute them but random users cannot.

---

## Interview Q&A

**Q1: How do you represent `rwxr-xr-x` in octal notation?**
- **Answer:**
  - Owner: `rwx` = 4 + 2 + 1 = **7**
  - Group: `r-x` = 4 + 0 + 1 = **5**
  - Others: `r-x` = 4 + 0 + 1 = **5**
  - Octal: **`755`**

**Q2: What is the risk of using `chmod 777` to fix permission errors?**
- **Answer:** `chmod 777` grants full read, write, and execute access to everyone on the system — the owner, any group member, and any other user. This is a critical security risk because it allows any user or compromised application to read sensitive data, overwrite application files, or execute malicious scripts. Permission issues should be fixed by correcting file ownership (`chown`) and using the minimum necessary permissions (e.g., `644` for files, `755` for directories).

**Q3: What does the `-R` flag do in `chown -R`?**
- **Answer:** The `-R` flag means "recursive". `chown -R appuser:appgroup /var/www/myapp` changes the owner and group of the `/var/www/myapp` directory itself and every file and subdirectory inside it, all in one command.

---

> 🔖 **Note:** Permissions are one of the most frequently tested topics in Linux and DevOps interviews. More importantly, they are the root cause of a large percentage of real production issues — from deployment failures to security breaches. Getting comfortable with `chmod`, `chown`, and the octal model is essential.
