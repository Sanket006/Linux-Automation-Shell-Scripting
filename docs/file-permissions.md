# 🔐 Linux File Permissions & Ownership

File permissions and ownership control who can access, modify, or execute files and directories. A strong grasp of permissions theory, default masks (umask), special permission bits (SUID, SGID, Sticky Bit), and Access Control Lists (ACLs) is vital for maintaining system security and troubleshooting application deployment issues.

> 📖 **See also:** For practical command usage, flag-by-flag breakdowns, and direct troubleshooting steps, see [`linux-commands/permissions.md`](../linux-commands/permissions.md).

---

## ⚙️ Core Concepts

### 1. The Linux Permissions Model (ugo/rwx)
Every file and directory is associated with:
*   **User/Owner (`u`)**: The specific account that owns the file.
*   **Group (`g`)**: A collection of users sharing identical access privileges.
*   **Others (`o`)**: All other accounts on the system.

For each owner category, three basic permission bits apply:
*   **Read (`r` / `4`)**: View file content or list directory contents.
*   **Write (`w` / `2`)**: Edit file content or create/delete files within a directory.
*   **Execute (`x` / `1`)**: Run a file as a program or navigate (`cd`) into a directory.

### 2. Default Permissions & umask
The `umask` (user mask) is an octal value subtracted from the system default permission level when creating new objects:
*   **Default Files Base**: `666` (read/write for all)
*   **Default Directories Base**: `777` (read/write/execute for all)
*   **Example**: A umask of `022` yields new files with `644` (`666 - 022`) and new directories with `755` (`777 - 022`).

### 3. Special Permissions (SUID, SGID, Sticky Bit)
*   **SUID (Set User ID)**: When set on an executable file, users run it with the permissions of the file owner (e.g., `/usr/bin/passwd` runs as root).
*   **SGID (Set Group ID)**: When set on an executable, it runs with the group's permissions. When set on a directory, files created inside inherit the parent directory's group instead of the creator's primary group.
*   **Sticky Bit**: When set on a directory (e.g., `/tmp`), only the owner of a file or the root user can rename or delete files within it, even if others have write access.

### 4. Access Control Lists (ACLs)
Standard permissions only support one user and one group. ACLs extend this by allowing you to define permissions for multiple individual users and groups on a single file or directory.

---

## 💻 Practical Examples

### 1. Checking and Modifying Standard Permissions
```bash
# View permissions of file.sh
ls -l file.sh

# Grant owner execute and remove others write permissions
chmod u+x,o-w file.sh
```

### 2. Setting Special Permission Bits
```bash
# Set SUID (Symbolic: u+s, Numeric: 4000)
chmod u+s /usr/local/bin/custom-admin-tool

# Set SGID on a shared directory (Symbolic: g+s, Numeric: 2000)
chmod g+s /var/shared/devops-docs

# Set the Sticky Bit on a temp directory (Symbolic: +t, Numeric: 1000)
chmod +t /var/shared/tmp
```

### 3. Implementing ACLs for Multi-User Access
```bash
# Grant read-write permission to user 'sanket' on a file owned by 'app'
setfacl -m u:sanket:rw /etc/myapp/config.yaml

# View active ACL permissions on the file
getfacl /etc/myapp/config.yaml
```

---

## 🛠️ DevOps Use Cases

### Hardening Container Shared Volumes
When running microservices that share directories (e.g., Nginx web server and a PHP-FPM application container), DevOps engineers set the SGID bit on the shared mount directory. This ensures all files created by either service inherit the shared group ownership, avoiding "Permission Denied" errors when the other container attempts to write to them.

---

## 💡 Interview Q&A

**Q1: What is the security risk of having SUID set on a script or application?**
*   **Answer:** If an executable has the SUID bit set and is owned by `root`, any user executing it runs it with root privileges. If the application contains vulnerabilities (such as buffer overflows or shell escapes), a low-privileged user can exploit them to execute arbitrary commands as root, leading to full system compromise.

**Q2: Why does a user need execute permissions on a directory just to read a file inside it?**
*   **Answer:** In Linux, directory execute permission (`x`) acts as the "pass-through" or "traverse" permission. Without it, you cannot change directory (`cd`) into it or access its metadata. Even if you have read (`r`) permission on a file inside that directory, you cannot access or read the file if you cannot traverse the parent directory.

---

> 🔖 **Note:** Managing file permissions effectively is a cornerstone of the Principle of Least Privilege (PoLP) in DevSecOps.
