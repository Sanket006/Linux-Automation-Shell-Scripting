# 👥 User & Group Management

Linux is a **multi-user operating system** — multiple people and services share the same machine simultaneously. User and group management controls who can log in, what files they can access, and what commands they can run. Every file, process, and running service is tied to a specific user account. Getting this right keeps systems secure and services isolated.

> 📖 **See also:** For a deep dive on the `/etc/passwd`, `/etc/shadow`, `/etc/group`, and `/etc/sudoers` file formats with field-by-field breakdowns, see [`docs/user-group-management.md`](../docs/user-group-management.md).

---

## Core Commands

| Command | What It Does | Key Flags & Usage |
| :--- | :--- | :--- |
| `useradd` | Create a new user account | `-m` create home dir, `-s` set shell, `-r` system account |
| `usermod` | Modify an existing user account | `-aG` append to supplementary group |
| `userdel` | Delete a user account | `-r` also removes home directory |
| `groupadd` | Create a new group | `groupadd <groupname>` |
| `gpasswd` | Manage group membership | `-d` remove a user from a group |
| `passwd` | Set or change a user's password | `sudo passwd <username>` |
| `id` | Display a user's UID, GID, and group memberships | `id <username>` |
| `whoami` | Show the currently logged-in username | `whoami` |
| `su` | Switch to another user account | `su - <username>` |
| `sudo` | Run a command with elevated (root) privileges | `sudo <command>` |

---

## Practical Examples

### 1. Creating a Regular User Account

Create a new user with a home directory and the bash shell.

```bash
sudo useradd -m -s /bin/bash sanket
sudo passwd sanket
```

| Flag | Meaning |
| :--- | :--- |
| `-m` | Automatically creates `/home/sanket` |
| `-s /bin/bash` | Sets the default interactive shell to bash |

---

### 2. Creating a Service (System) User

Create a secure account for running a service like Prometheus or Jenkins. This account cannot log in interactively, which reduces the attack surface.

```bash
sudo useradd -r -s /usr/sbin/nologin prometheus
```

| Flag | Meaning |
| :--- | :--- |
| `-r` | Creates a system account (UID below 1000, no home directory by default) |
| `-s /usr/sbin/nologin` | Prevents interactive login — the shell rejects any login attempt |

---

### 3. Adding a User to a Group (e.g., docker)

Grant an existing user permission to run Docker commands without `sudo`.

```bash
sudo usermod -aG docker sanket
```

| Flag | Meaning |
| :--- | :--- |
| `-a` | Append — add to the group without removing from other groups |
| `-G docker` | The supplementary group to add the user to |

> ⚠️ **Critical:** Always use `-a` with `-G`. Without `-a`, `usermod -G` removes the user from all their existing supplementary groups.

The user must **log out and back in** for this change to take effect in their session.

---

### 4. Grant a User Sudo Access

```bash
sudo usermod -aG sudo sanket     # Ubuntu / Debian
sudo usermod -aG wheel sanket    # RHEL / CentOS / Amazon Linux
```

---

### 5. Check a User's Groups and IDs

```bash
id sanket
```

**Sample output:**

```text
uid=1001(sanket) gid=1001(sanket) groups=1001(sanket),27(sudo),998(docker)
```

This shows that `sanket` is a member of their primary group `sanket`, and supplementary groups `sudo` and `docker`.

---

## DevOps Use Cases

### Setting Up a CI/CD Runner Securely

Never run a Jenkins or GitHub Actions runner as root. Create a dedicated, limited account:

```bash
# Create the runner user with a specific home directory
sudo useradd -m -d /opt/actions-runner -s /bin/bash runner

# Give it Docker access (so it can build and run containers)
sudo usermod -aG docker runner
```

If the runner process is ever compromised by a malicious build, it cannot escalate to root or access other users' files.

### Auditing Who Can Log In

List all user accounts that have a valid login shell (real human or incorrectly configured service accounts):

```bash
awk -F: '$7 !~ /nologin|false/ {print $1, $7}' /etc/passwd
```

---

## Best Practices

- Never log in directly as `root` — use `sudo` for individual privileged commands.
- Create a **dedicated system user** for every service (Nginx, MySQL, Prometheus, CI runners).
- Always use `-a` with `usermod -G` to avoid accidentally removing existing group memberships.
- Use `visudo` to edit `/etc/sudoers` — it validates syntax before saving.
- Regularly review `/etc/passwd` to identify accounts that should be removed.
- Follow the **principle of least privilege**: grant only the minimum access required for the task.

---

## Interview Q&A

**Q1: How do you add an existing user to the `sudo` group?**
- **Answer:** On Ubuntu/Debian: `sudo usermod -aG sudo username`. On RHEL/CentOS/Amazon Linux: `sudo usermod -aG wheel username`. The user must log out and back in for the group change to take effect in their active session.

**Q2: What is the difference between `su` and `sudo`?**
- **Answer:** `su` (substitute user) opens a new shell session as a completely different user and requires knowing that user's password. `sudo` runs a single command with elevated privileges and requires the current user's own password — provided that user is listed in `/etc/sudoers`. `sudo` is preferred in production because it logs every privileged command, creating an audit trail, without requiring anyone to know or share the root password.

**Q3: What is the significance of UID 0?**
- **Answer:** UID `0` is exclusively reserved for the `root` account. Any account in `/etc/passwd` with UID `0` has full root privileges on the system, regardless of its username. Auditing for unexpected UID `0` entries is a standard security hardening check.

---

> 🔖 **Note:** User and group management is a foundational Linux skill that directly underpins production security. It is tested in virtually every DevOps and system administration interview and is essential for working with Docker, Kubernetes RBAC, and CI/CD security hardening.
