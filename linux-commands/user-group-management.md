# 👥 User & Group Management

## 📌 Purpose
Linux is a multi-user operating system. Proper administration of user accounts and group memberships is critical for maintaining access controls, securing servers, and implementing security compliance. In DevOps, this is vital for configuring build agents (e.g., Jenkins, runner agents) and creating non-root service accounts for running microservices.

---

## ⚙️ Core Concepts & Commands

### Important Account Files
- **`/etc/passwd`**: Stores user account details (username, UID, home directory, login shell).
- **`/etc/shadow`**: Stores encrypted user passwords and expiration settings.
- **`/etc/group`**: Lists system groups and the users belonging to them.

| Command | Description | Syntax / Common Arguments | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `useradd` | Create a new user account | `useradd -m -s /bin/bash <username>` | Adding a system user for running a new node service. |
| `usermod` | Modify existing user account | `usermod -aG <group> <user>` | Granting a user access to run Docker commands by adding them to the docker group. |
| `groupadd`| Create a new group | `groupadd <group_name>` | Setting up a shared deployment group for DevOps teams. |
| `passwd` | Update user password | `passwd <username>` | Setting or rotating passwords for local administrator accounts. |

---

## 💻 Practical Examples

### 1. Creating a Service User with Bash Shell
Create a new user with a home directory and default bash shell.
```bash
sudo useradd -m -s /bin/bash appuser
```
*   **Explanation:**
    *   `-m`: Automatically creates the user's home directory (usually `/home/appuser`).
    *   `-s /bin/bash`: Sets the default interactive shell to bash.

### 2. Adding a User to a Group (e.g., docker group)
Grant an existing user permission to run Docker commands without prefixing with `sudo`.
```bash
sudo usermod -aG docker appuser
```
*   **Explanation:**
    *   `-a`: Appends the user to the supplementary group. Always use this with `-G`.
    *   `-G docker`: Specifies the supplementary group.
*   **Production Warning:** Omitting `-a` will remove the user from all other supplementary groups they belong to!

### 3. Creating a System/Daemon User (No Login Shell)
Create a secure user account that cannot log in interactively, designed solely to run background services.
```bash
sudo useradd -r -s /usr/sbin/nologin prometheus
```
*   **Explanation:**
    *   `-r`: Creates a system account (usually with a UID less than 1000).
    *   `-s /usr/sbin/nologin`: Blocks shell login attempts, reducing the attack surface.

---

## 🛠️ DevOps Use Cases & Scenarios

### Restricting Access & Configuring CI/CD Runners
When setting up a self-hosted runner (e.g., GitHub Actions Runner or Jenkins Agent), you should never run the agent process as `root`. Instead, create a dedicated user:
```bash
sudo useradd -m -d /opt/actions-runner -s /bin/bash runner
sudo usermod -aG docker runner
```
This restricts the runner to running in `/opt/actions-runner` and only gives it permissions to execute Docker containers, protecting the host system.

---

## 💡 Interview Q&A & Tips

**Q1: How do you add an existing user to the `sudo` group?**
*   **Answer:** Run `sudo usermod -aG sudo <username>` on Ubuntu/Debian, or `sudo usermod -aG wheel <username>` on CentOS/RHEL.

**Q2: What is the significance of the UID 0 in Linux?**
*   **Answer:** The User ID (UID) `0` is reserved for the root administrator account. Any user account assigned UID `0` in `/etc/passwd` will have full root privileges on the system, regardless of the username.
