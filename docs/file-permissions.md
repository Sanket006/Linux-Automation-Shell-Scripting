# 🔐 Linux File Permissions & Ownership

This document explains **Linux file permissions and ownership concepts** that are critical for **system administration, security, and DevOps operations**. It covers theory, commands, examples, and real-world use cases.

---

## 📌 Why File Permissions Matter

Linux is a **multi-user operating system**. Permissions ensure:

* Data security
* Controlled access to files & directories
* Safe execution of applications
* Isolation between users and services

Incorrect permissions are one of the **most common causes of production issues**.

---

## 📌 Permission Types

Each file/directory has three permission types:

| Permission | Symbol | Meaning                            |
| ---------- | ------ | ---------------------------------- |
| Read       | `r`    | View file content / list directory |
| Write      | `w`    | Modify file / create-delete files  |
| Execute    | `x`    | Run file / access directory        |

---

## 📌 Permission Levels (Who)

Permissions are applied to:

| Level        | Description   |
| ------------ | ------------- |
| User (`u`)   | File owner    |
| Group (`g`)  | Group members |
| Others (`o`) | Everyone else |

---

## 📌 Viewing Permissions

### `ls -l`

```bash
ls -l
```

Example output:

```text
-rwxr-xr-- 1 sanket devops 1024 file.sh
```

**Breakdown:**

* `-` → file type (`d` for directory)
* `rwx` → owner permissions
* `r-x` → group permissions
* `r--` → others permissions

---

## 📌 Changing Permissions – `chmod`

### 🔹 Symbolic Mode

```bash
chmod u+x script.sh
chmod g-w file.txt
chmod o+r report.txt
```

### 🔹 Numeric (Octal) Mode

| Number | Permission |
| ------ | ---------- |
| 4      | Read       |
| 2      | Write      |
| 1      | Execute    |

```bash
chmod 755 script.sh
chmod 644 config.conf
```

**Common Permission Sets:**

* `755` → executable scripts
* `644` → config & text files
* `700` → private files

---

## 📌 Changing Ownership – `chown` & `chgrp`

### `chown`

```bash
chown user file.txt
chown user:group file.txt
chown -R user:group app/
```

### `chgrp`

```bash
chgrp devops file.txt
```

**Use case:** Assign correct ownership to application or service users.

---

## 📌 Default Permissions – `umask`

`umask` defines default permissions for new files and directories.

```bash
umask
umask 022
```

* Default file permission: `666 - umask`
* Default directory permission: `777 - umask`

---

## 📌 Special Permissions

### 🔹 SUID (Set User ID)

```bash
chmod u+s file
```

* Runs file with owner privileges

### 🔹 SGID (Set Group ID)

```bash
chmod g+s directory
```

* Files inherit group ownership

### 🔹 Sticky Bit

```bash
chmod +t /shared
```

* Only owner can delete files

**Common Example:** `/tmp` directory

---

## 📌 Access Control Lists (ACL)

ACLs provide **fine-grained permissions** beyond basic ownership.

```bash
setfacl -m u:user:rwx file.txt
getfacl file.txt
```

**Use case:** Grant access to specific users without changing ownership.

---

## 🚀 DevOps & Production Use Cases

* Fixing "permission denied" errors
* Securing application config files
* Managing CI/CD runner permissions
* Handling Docker volume access
* Shared directory management

---

## ⭐ Best Practices

* Follow **least privilege principle**
* Avoid `777` permissions
* Do not run applications as root
* Use groups instead of individual permissions
* Audit permissions regularly

---

## 🎯 Interview Tips

* Know difference between `chmod 755` and `chmod 777`
* Understand directory execute permission
* Explain SUID, SGID, Sticky bit
* Common permission-related production issues

---

### 🔖 Note

Strong understanding of Linux permissions is **mandatory for DevOps, Cloud, and Security roles**. This topic is frequently tested in interviews and real-world troubleshooting.
