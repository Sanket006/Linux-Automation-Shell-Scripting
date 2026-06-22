# 👥 User & Group Management

User and group management is how Linux controls **who can access the system and what they are allowed to do**. Every file, process, and service on a Linux server is owned by a user and a group. Getting this right is essential for security, compliance, and running services safely.

---

## Why This Matters

Linux is a **multi-user operating system** — multiple people and services share the same machine. Without proper user and group management, any user could read another user's files, break a running service, or gain root access. Most production security incidents trace back to incorrect user or permission configuration.

---

## Types of Users in Linux

Linux has three categories of users:

| Type | UID Range | Purpose | Example |
| :--- | :--- | :--- | :--- |
| **Root User** | `0` | Full administrator — can do anything on the system | `root` |
| **System Users** | `1 – 999` | Created automatically for services; cannot log in interactively | `nginx`, `mysql`, `www-data` |
| **Normal Users** | `1000+` | Real human users with limited privileges by default | `sanket`, `devuser` |

> ⚠️ **Best Practice:** Never log in directly as `root` for daily work. Use `sudo` instead.

---

## Groups in Linux

A **group** is a named collection of users. Instead of assigning permissions to each user one by one, you assign them to a group and all members inherit those permissions automatically.

Every user has:

- **Primary Group** — assigned at account creation; used by default when the user creates files.
- **Secondary (Supplementary) Groups** — additional groups the user belongs to (e.g., `docker`, `sudo`).

---

## Key System Files

Linux stores all user and group information in plain text files. Understanding each file is important for auditing and troubleshooting.

### `/etc/passwd` — User Account Database

Stores basic, non-sensitive information about every user account on the system.

```text
sanket:x:1001:1001:Sanket Kumar:/home/sanket:/bin/bash
```

**Each field (colon-separated):**

| Field | Example Value | Meaning |
| :--- | :--- | :--- |
| 1 | `sanket` | Username |
| 2 | `x` | Password placeholder — actual hash is in `/etc/shadow` |
| 3 | `1001` | UID — unique numeric user identifier |
| 4 | `1001` | GID — primary group identifier |
| 5 | `Sanket Kumar` | GECOS — full name or description |
| 6 | `/home/sanket` | Home directory |
| 7 | `/bin/bash` | Default login shell |

---

### `/etc/shadow` — Secure Password Database

Stores **encrypted passwords** and **password aging policies**. Only readable by root.

```text
sanket:$6$abc123...:19500:0:99999:7:14:30::
```

**Each field:**

| Field | Meaning |
| :--- | :--- |
| 1 | Username |
| 2 | Password hash (`$6$` = SHA-512 algorithm) |
| 3 | Days since 1970-01-01 when password was last changed |
| 4 | Minimum days before password can be changed |
| 5 | Maximum days a password is valid |
| 6 | Warning days before password expires |
| 7 | Days inactive after expiry before account is locked |
| 8 | Account expiration date (days since 1970) |
| 9 | Reserved |

> 🔒 This file is readable only by root. Keeping passwords here (separate from public user info) prevents regular users from running offline brute-force attacks.

---

### `/etc/group` — Group Definitions

Lists all groups and their members.

```text
devops:x:1002:sanket,rahul
```

**Each field:**

| Field | Meaning |
| :--- | :--- |
| 1 | Group name |
| 2 | Group password placeholder |
| 3 | GID (Group ID) |
| 4 | Comma-separated list of group members |

---

### `/etc/gshadow` — Secure Group Database

Stores secure group-level information such as encrypted group passwords and group administrators.

```text
devops:!:admin:sanket,rahul
```

| Field | Meaning |
| :--- | :--- |
| 1 | Group name |
| 2 | Encrypted group password (`!` means no password set) |
| 3 | Group administrators |
| 4 | Group members |

---

### `/etc/login.defs` — System-Wide Login Policies

Defines default rules applied when creating new users and passwords.

| Setting | Purpose |
| :--- | :--- |
| `UID_MIN` / `UID_MAX` | Range of UIDs for normal users |
| `PASS_MAX_DAYS` | Maximum number of days a password remains valid |
| `PASS_MIN_DAYS` | Minimum days before a password can be changed again |
| `PASS_WARN_AGE` | Days before expiry that the user receives a warning |

---

### `/etc/skel/` — New User Home Template

Files placed in `/etc/skel/` are **automatically copied** into every new user's home directory when their account is created. This standardizes the starting environment for all users.

Common files inside `/etc/skel/`:
- `.bashrc` — shell configuration and aliases
- `.profile` — login environment settings and PATH

---

### `/etc/sudoers` — Privilege Delegation Rules

Controls who can run commands with elevated privileges using `sudo`.

```text
sanket ALL=(ALL) NOPASSWD:ALL
```

| Part | Meaning |
| :--- | :--- |
| `sanket` | User this rule applies to (use `%groupname` for groups) |
| `ALL` | From any host |
| `(ALL)` | Can run commands as any user |
| `NOPASSWD:ALL` | Without being prompted for a password |

> ⚠️ **Always edit `/etc/sudoers` using `visudo`** — it validates syntax before saving, preventing a broken file from locking you out of the system.

---

## User Management Commands

### Create a User

```bash
# Create a user with a home directory and bash shell
sudo useradd -m -s /bin/bash sanket

# Set their password
sudo passwd sanket
```

### Create a System/Service User (No Interactive Login)

```bash
# -r creates a system account (UID < 1000)
# -s /usr/sbin/nologin blocks interactive login attempts
sudo useradd -r -s /usr/sbin/nologin prometheus
```

This is the correct pattern for service accounts (Nginx, Prometheus, Jenkins runners). The service gets its own isolated user but cannot be used to log in interactively, reducing the attack surface.

### Modify a User

```bash
# Add user to a supplementary group (e.g., the docker group)
sudo usermod -aG docker sanket
```

> ⚠️ Always include `-a` (append) when using `-G`. Without `-a`, `usermod` removes the user from all existing supplementary groups.

### Delete a User

```bash
# Delete the account only
sudo userdel sanket

# Delete the account and their home directory
sudo userdel -r sanket
```

---

## Group Management Commands

### Create a Group

```bash
sudo groupadd devops
```

### Add a User to a Group

```bash
sudo usermod -aG devops sanket
```

### Remove a User from a Group

```bash
sudo gpasswd -d sanket devops
```

---

## Switching Users and Using Sudo

### Switch to Another User

```bash
# Open a new login shell as 'sanket' — loads their full environment
su - sanket
```

### Run a Single Command as Root

```bash
sudo apt update
```

### Grant a User Sudo Access

```bash
sudo usermod -aG sudo sanket     # Ubuntu / Debian
sudo usermod -aG wheel sanket    # RHEL / CentOS / Amazon Linux
```

---

## User Environment Files

When a user logs in, bash reads startup files to configure their environment:

| File | When It Runs | Used For |
| :--- | :--- | :--- |
| `~/.bash_profile` | Login shells only | Setting `PATH`, loading `.bashrc` |
| `~/.bashrc` | Interactive non-login shells | Aliases, functions, prompt settings |
| `~/.profile` | Generic POSIX login shell | Environment variables (non-bash shells) |

---

## Password Policies

Password rules are enforced through two mechanisms:

- **`/etc/login.defs`** — system-wide defaults (max age, min age, warning period).
- **`/etc/pam.d/`** — PAM (Pluggable Authentication Modules) — enforces complexity rules, account lockout, and password history.

---

## DevOps Use Cases

### Setting Up a CI/CD Runner Securely

Never run a Jenkins or GitHub Actions runner as `root`. Instead, create a dedicated account:

```bash
# Create a runner user with a specific home directory
sudo useradd -m -d /opt/runner -s /bin/bash runner

# Give the runner Docker access only
sudo usermod -aG docker runner
```

This restricts the runner to `/opt/runner` and only grants Docker permissions. If the runner is ever compromised, the blast radius is contained.

### Auditing User Accounts

List all users who have a valid interactive login shell (i.e., real human accounts):

```bash
awk -F: '$7 !~ /nologin|false/ {print $1, $7}' /etc/passwd
```

---

## Best Practices

- Never use `root` for daily work — use `sudo` for individual privileged commands.
- Create a **dedicated system user** for every service (Nginx, MySQL, Prometheus, CI runners).
- Use **groups** to share access instead of modifying individual file permissions.
- Always use `visudo` to edit `/etc/sudoers` — never open it with a regular editor.
- Regularly audit accounts: remove users who no longer need access to the server.
- Follow the **principle of least privilege** — grant only the minimum permissions required.

---

## Interview Q&A

**Q1: What is the difference between `su` and `sudo`?**
- **Answer:** `su` opens a full new session as another user and requires knowing that user's password. `sudo` runs a single command with elevated privileges and requires the current user's own password — that user must also be listed in `/etc/sudoers`. `sudo` is preferred in production because it logs every privileged command, enabling an audit trail, without sharing the root password.

**Q2: How do you add a user to the `sudo` group?**
- **Answer:** On Ubuntu/Debian: `sudo usermod -aG sudo username`. On RHEL/CentOS/Amazon Linux: `sudo usermod -aG wheel username`. The user must log out and back in for the change to take effect in their session.

**Q3: What is the significance of UID 0?**
- **Answer:** UID `0` is exclusively reserved for the `root` account. Any user account assigned UID `0` in `/etc/passwd` will have full root privileges on the system, regardless of their username. This is why auditing `/etc/passwd` for unexpected UID `0` entries is a standard security check.

**Q4: What is the difference between `/etc/passwd` and `/etc/shadow`?**
- **Answer:** `/etc/passwd` is world-readable and stores non-sensitive user information — username, UID, home directory, and default shell. The password field shows only `x` as a placeholder. The actual encrypted password hashes live in `/etc/shadow`, which is readable only by root. This separation prevents regular users from obtaining password hashes and attempting offline brute-force attacks.

---

> 🔖 **Note:** User and group management is a foundational Linux skill tested in almost every DevOps and system administration interview. It also directly underpins Docker (running containers as non-root), Kubernetes (service accounts and RBAC), and CI/CD security hardening.
