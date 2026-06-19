# 👥 Linux User & Group Management – Complete Guide

This document explains **Linux user and group management** concepts used to control **access, security, and permissions** on Linux systems. This is a **core topic for system administration, DevOps, and security roles**.

---

## 📌 Why User & Group Management Is Important

Linux is a **multi-user operating system**. Proper user and group management ensures:

* Secure access to servers
* Controlled permission assignment
* Isolation between applications and users
* Compliance with security best practices

Most production security issues are caused by **incorrect user or permission configuration**.

---

## 📌 Types of Users in Linux

### 🔹 Root User

* Username: `root`
* User ID (UID): `0`
* Has full administrative privileges
* Can access and modify any file

⚠️ **Best Practice:** Avoid logging in as root directly.

---

### 🔹 System Users

* Used by services and applications
* Usually have UID < 1000
* Example: `nginx`, `mysql`, `docker`

**Purpose:** Run services securely without root access.

---

### 🔹 Normal Users

* Created for human users
* Usually have UID ≥ 1000
* Limited privileges by default

---

## 📌 Groups in Linux

A **group** is a collection of users.

### Why Groups Are Used

* Simplify permission management
* Share access to files & directories
* Apply least-privilege principle

Each user has:

* **Primary group**
* **Secondary (supplementary) groups**

---

## 📌 Important User & Group Files

| File           | Purpose                  |
| -------------- | ------------------------ |
| `/etc/passwd`  | User account information |
| `/etc/shadow`  | Encrypted passwords      |
| `/etc/group`   | Group definitions        |
| `/etc/gshadow` | Group passwords          |

---

## 📌 Understanding `/etc/passwd`

Example entry:

```text
sanket:x:1001:1001:Sanket:/home/sanket:/bin/bash
```

**Fields Explained:**

1. Username
2. Password placeholder (`x`)
3. UID
4. GID
5. User info
6. Home directory
7. Default shell

---

## 📌 User Management Commands

### Create a User

```bash
useradd sanket
passwd sanket
```

### Create User with Home Directory

```bash
useradd -m devuser
```

### Delete a User

```bash
userdel devuser
userdel -r devuser   # remove home directory
```

---

## 📌 Group Management Commands

### Create a Group

```bash
groupadd devops
```

### Add User to Group

```bash
usermod -aG devops sanket
```

### Remove User from Group

```bash
gpasswd -d sanket devops
```

---

## 📌 Switching Users

### Switch User

```bash
su - sanket
```

### Run Command as Root

```bash
sudo command
```

---

## 📌 Sudo Access & Security

Sudo allows users to run commands with elevated privileges.

### Add User to Sudo Group

```bash
usermod -aG sudo sanket     # Ubuntu
usermod -aG wheel sanket   # RHEL/CentOS
```

### Sudo Configuration File

```bash
/etc/sudoers
```

⚠️ Always edit using:

```bash
visudo
```

---

## 📌 User Environment

Important files:

* `~/.bashrc`
* `~/.bash_profile`
* `~/.profile`

Used to configure:

* Environment variables
* Aliases
* PATH

---

## 📌 Password Policies

Configured via:

* `/etc/login.defs`
* `/etc/pam.d/`

Controls:

* Password length
* Expiry
* Complexity

---

## 🚀 DevOps & Production Use Cases

* Creating service users for applications
* Managing CI/CD runner access
* Securing servers using least privilege
* Managing shared directories
* Auditing user access

---

## 🎯 Interview Tips

* Difference between root and sudo
* Purpose of system users
* Explain `/etc/passwd` vs `/etc/shadow`
* How to give sudo access

---

## ⭐ Best Practices

* Never use root for daily work
* Use groups instead of individual permissions
* Follow least privilege principle
* Regularly audit users & groups

---

### 🔖 Note

User and group management is a **foundational Linux skill** and directly impacts **system security, DevOps operations, and compliance**.













# 👥 Linux User & Group Management – Complete Guide

This document explains **Linux user and group management** concepts used to control **access, security, and permissions** on Linux systems. This is a **core topic for system administration, DevOps, and security roles**.

---

## 📌 Why User & Group Management Is Important

Linux is a **multi-user operating system**. Proper user and group management ensures:

* Secure access to servers
* Controlled permission assignment
* Isolation between applications and users
* Compliance with security best practices

Most production security issues are caused by **incorrect user or permission configuration**.

---

## 📌 Types of Users in Linux

### 🔹 Root User

* Username: `root`
* User ID (UID): `0`
* Has full administrative privileges
* Can access and modify any file

⚠️ **Best Practice:** Avoid logging in as root directly.

---

### 🔹 System Users

* Used by services and applications
* Usually have UID < 1000
* Example: `nginx`, `mysql`, `docker`

**Purpose:** Run services securely without root access.

---

### 🔹 Normal Users

* Created for human users
* Usually have UID ≥ 1000
* Limited privileges by default

---

## 📌 Groups in Linux

A **group** is a collection of users.

### Why Groups Are Used

* Simplify permission management
* Share access to files & directories
* Apply the least-privilege principle

Each user has:

* **Primary group**
* **Secondary (supplementary) groups**

---

## 📌 Important User & Group Files (DETAILED EXPLANATION)

Linux stores user and group information in a set of critical system files. Understanding **each file and every field** is mandatory for **system administration, DevOps, security audits, and troubleshooting**.

---

### 📄 `/etc/passwd` — User Account Database

Stores **basic (non-sensitive) user account information**.

Example:

```text
sanket:x:1001:1001:Sanket:/home/sanket:/bin/bash
```

**Fields Explained (7 fields):**

1. **Username** – Login name
2. **Password placeholder** (`x`) – Actual password stored in `/etc/shadow`
3. **UID (User ID)** – Unique identifier for the user
4. **GID (Group ID)** – Primary group ID
5. **GECOS** – User description (full name, contact info)
6. **Home directory** – User’s default working directory
7. **Login shell** – Default shell after login

📌 **Why it matters:** The system uses this file to identify users and their environments.

---

### 📄 `/etc/shadow` — Secure Password Database

Stores **encrypted passwords and password aging policies**.

Example:

```text
sanket:$6$abc123...:19500:0:99999:7:14:30
```

**Fields Explained (9 fields):**

1. **Username**
2. **Password hash** (`$6$` = SHA-512)
3. **Last password change** (days since 1970)
4. **Minimum password age**
5. **Maximum password age**
6. **Warning period** before expiry
7. **Inactive period** after expiry
8. **Account expiration date**
9. **Reserved field**

📌 **Security Notes:**

* Readable only by root
* Prevents password theft
* Critical for compliance & audits

---

### 📄 `/etc/group` — Group Definitions

Stores **group information and group members**.

Example:

```text
devops:x:1002:sanket,rahul
```

**Fields Explained (4 fields):**

1. **Group name**
2. **Group password placeholder**
3. **GID (Group ID)**
4. **Group members** (comma-separated)

📌 **Why it matters:** Controls shared access to files and directories.

---

### 📄 `/etc/gshadow` — Secure Group Database

Stores **secure group-related information**.

Example:

```text
devops:!:admin:sanket,rahul
```

**Fields Explained (4 fields):**

1. **Group name**
2. **Encrypted group password**
3. **Group administrators**
4. **Group members**

📌 **Why it matters:** Enhances group-level security and delegation.

---

### 📄 `/etc/login.defs` — Login Policy Configuration

Defines **default user and password policies**.

Controls:

* UID/GID ranges
* Password aging rules
* Home directory defaults

Common fields:

* `UID_MIN`, `UID_MAX`
* `PASS_MAX_DAYS`
* `PASS_MIN_DAYS`
* `PASS_WARN_AGE`

📌 **Why it matters:** Enforces organization-wide security rules.

---

### 📄 `/etc/skel/` — User Home Template

Contains **default files copied into new user home directories**.

Common files:

* `.bashrc`
* `.profile`

📌 **Why it matters:** Standardizes user environments.

---

### 📄 `/etc/sudoers` — Privilege Delegation Rules

Controls **who can run commands as root and how**.

Example:

```text
sanket ALL=(ALL) NOPASSWD:ALL
```

**Fields Explained:**

1. User or group
2. Host
3. Run-as user
4. Allowed commands

⚠️ Always edit using:

```bash
visudo
```

📌 **Why it matters:** Misconfiguration can completely lock admin access.

---

## 📌 User Management Commands

### Create a User

```bash
useradd sanket
passwd sanket
```

### Create User with Home Directory

```bash
useradd -m devuser
```

### Delete a User

```bash
userdel devuser
userdel -r devuser   # remove home directory
```

---

## 📌 Group Management Commands

### Create a Group

```bash
groupadd devops
```

### Add User to Group

```bash
usermod -aG devops sanket
```

### Remove User from Group

```bash
gpasswd -d sanket devops
```

---

## 📌 Switching Users

### Switch User

```bash
su - sanket
```

### Run Command as Root

```bash
sudo command
```

---

## 📌 Sudo Access & Security

Sudo allows users to run commands with elevated privileges.

### Add User to Sudo Group

```bash
usermod -aG sudo sanket     # Ubuntu
usermod -aG wheel sanket   # RHEL/CentOS
```

### Sudo Configuration File

```bash
/etc/sudoers
```

⚠️ Always edit using:

```bash
visudo
```

---

## 📌 User Environment

Important files:

* `~/.bashrc`
* `~/.bash_profile`
* `~/.profile`

Used to configure:

* Environment variables
* Aliases
* PATH

---

## 📌 Password Policies

Configured via:

* `/etc/login.defs`
* `/etc/pam.d/`

Controls:

* Password length
* Expiry
* Complexity

---

## 🚀 DevOps & Production Use Cases

* Creating service users for applications
* Managing CI/CD runner access
* Securing servers using least privilege
* Managing shared directories
* Auditing user access

---

## 🎯 Interview Tips

* Difference between root and sudo
* Purpose of system users
* Explain `/etc/passwd` vs `/etc/shadow`
* How to give sudo access

---

## ⭐ Best Practices

* Never use root for daily work
* Use groups instead of individual permissions
* Follow least privilege principle
* Regularly audit users & groups

---

### 🔖 Note

User and group management is a **foundational Linux skill** and directly impacts **system security, DevOps operations, and compliance**.

