# 📁 File & Directory Management

Files and directories are the primary building blocks of a Linux system. Every configuration, log, application binary, and script lives in a file somewhere. As a DevOps engineer, you will constantly be navigating directories, copying config files, searching for specific files across the filesystem, and cleaning up old logs. Mastering these commands is the foundation for everything else.

---

## Core Commands

| Command | What It Does | Key Flags |
| :--- | :--- | :--- |
| `ls` | List directory contents | `-l` long format, `-a` show hidden, `-h` human-readable sizes, `-t` sort by time |
| `cp` | Copy files or directories | `-r` recursive (for directories), `-p` preserve permissions and timestamps |
| `mv` | Move or rename files | `mv source destination` |
| `rm` | Remove files or directories | `-r` recursive, `-f` force (no confirmation prompt) |
| `find` | Search files by name, type, size, or age | `find <path> -name "*.log" -type f -mtime +7` |
| `stat` | Show detailed file metadata | `stat <filename>` — shows size, owner, permissions, timestamps |
| `touch` | Create an empty file or update a file's timestamp | `touch newfile.txt` |
| `mkdir` | Create a directory | `-p` creates parent directories if they do not exist |
| `ln` | Create hard or symbolic links | `-s` creates a symbolic (soft) link |

---

## Practical Examples

### 1. Advanced Directory Listing

List all files (including hidden files), with sizes in a human-readable format, sorted by most recently modified.

```bash
ls -lath
```

**Flag breakdown:**

| Flag | Effect |
| :--- | :--- |
| `-l` | Long format — shows permissions, owner, group, size, and modification date |
| `-a` | Shows hidden files (files that start with `.`, like `.bashrc`, `.env`) |
| `-h` | Shows file sizes in human-readable units (K, M, G) instead of bytes |
| `-t` | Sorts by modification time, newest first |

---

### 2. Finding and Deleting Old Files

Find all `.log` files in `/var/log` older than 7 days and delete them.

```bash
find /var/log -type f -name "*.log" -mtime +7 -exec rm -f {} \;
```

**Flag breakdown:**

| Part | Meaning |
| :--- | :--- |
| `/var/log` | Directory to search in |
| `-type f` | Match files only (not directories) |
| `-name "*.log"` | Match files ending in `.log` |
| `-mtime +7` | Modified more than 7 days ago |
| `-exec rm -f {} \;` | Execute force-delete on each matched file |

> 📌 **Production Tip:** Always run `find` without the `-exec rm` part first to see exactly which files will be deleted before committing:
> ```bash
> find /var/log -type f -name "*.log" -mtime +7
> ```

---

### 3. Copying a Directory with Metadata Preserved

Back up a configuration directory before making changes, preserving all file permissions, ownership, and timestamps.

```bash
cp -rp /etc/nginx /etc/nginx_backup
```

| Flag | Effect |
| :--- | :--- |
| `-r` | Recursively copies all files and subdirectories |
| `-p` | Preserves file mode, ownership, and timestamps |

---

### 4. Searching for a File by Name

Find where a specific file is located anywhere on the system.

```bash
# Find a file named 'nginx.conf' anywhere under /etc
find /etc -name "nginx.conf"

# Case-insensitive search
find /etc -iname "nginx.conf"
```

---

### 5. Creating a Symbolic Link (Symlink)

Create a shortcut that points to another file or directory. Commonly used for versioned software installations.

```bash
# Link /usr/local/bin/python to a specific Python version
ln -s /usr/bin/python3.11 /usr/local/bin/python

# Verify the link
ls -la /usr/local/bin/python
```

---

## DevOps Use Cases

### Log Rotation & Disk Maintenance

Runaway log files are one of the most common causes of disk exhaustion on production servers. DevOps engineers use `find` and `rm` to locate and purge stale files automatically:

```bash
# Delete logs older than 30 days from application log directory
find /var/log/myapp -type f -name "*.log" -mtime +30 -delete
```

This is often scheduled as a cron job to run nightly.

### Zero-Downtime Deployment with `mv`

During a static asset deployment, a script copies new files to a staging directory and then switches the live symlink atomically, avoiding a window where the site serves partial content:

```bash
# Copy new build to staging location
cp -rp /builds/v2.1/ /var/www/myapp_new

# Atomically switch the live symlink
ln -sfn /var/www/myapp_new /var/www/myapp_live
```

---

## Best Practices

- Always **preview** `find -exec rm` commands before running them — use `find` alone first.
- Use `rm -rf` with extreme care — always double-check the path before pressing Enter.
- Use `cp -p` when backing up config files so ownership and permissions are preserved.
- Use symbolic links (`ln -s`) for versioned software so you can switch versions by updating a single link.
- Use `mkdir -p` to create nested directory structures without intermediate errors.

---

## Interview Q&A

**Q1: How do you find all files modified in the last 24 hours in a specific directory?**
- **Answer:** Use `find` with the `-mtime` or `-mmin` flag:
  ```bash
  find /path/to/search -type f -mtime -1     # Last 1 day
  find /path/to/search -type f -mmin -1440   # Last 1440 minutes (24 hours)
  ```
  The `-` prefix in `-mtime -1` means "less than 1 day ago". The `+` prefix would mean "more than 1 day ago".

**Q2: What is the difference between `rm -r` and `rm -f`?**
- **Answer:** `rm -r` (recursive) removes a directory and all its contents. `rm -f` (force) removes files without prompting for confirmation and does not error on missing files. Combined — `rm -rf` — recursively deletes a directory structure without any confirmation prompts. It is one of the most dangerous commands on a Linux system and must be used with extreme care.

**Q3: What is the difference between a hard link and a symbolic (soft) link?**
- **Answer:** A **symbolic link** (`ln -s`) creates a new file that simply points to the path of another file. If the original is deleted, the symlink breaks. A **hard link** (`ln`) creates another reference to the same data on disk (same inode). If the original filename is deleted, the data still exists through the hard link until all links are removed. Hard links cannot cross filesystem boundaries or link to directories.

---

> 🔖 **Note:** File and directory management commands are the building blocks of every shell script and automation task. Strong proficiency here directly translates to faster, more reliable deployment scripts and cleaner server maintenance procedures.
