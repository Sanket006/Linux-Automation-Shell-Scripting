# 🐚 Shell Scripting Basics

## 📌 Purpose
A shell script is a text file containing a sequence of commands executed by a shell interpreter. Rather than entering commands manually one-by-one, scripts allow DevOps engineers to automate complex tasks, orchestrate builds, and bootstrap server setups. This guide introduces the core building blocks of any shell script, including interpreters, execution modes, and inline documentation.

---

## ⚙️ Core Concepts & Commands

### 1. The Shebang (`#!/bin/bash`)
The very first line of any shell script must be the shebang. It starts with `#!` followed by the absolute path to the shell interpreter that should execute the script.
- **`#!/bin/bash`**: Executes the script using the Bash shell (standard for Linux automation).
- **`#!/bin/sh`**: Executes the script using the system's POSIX-compliant default shell (often dash or bash in compatibility mode).

### 2. Script Execution Methods
There are three primary ways to run a shell script:
1.  **Direct Execution (`./script.sh`)**: The script is executed in a new child subshell. Requires execution permissions (`chmod +x script.sh`).
2.  **Explicit Interpreter (`bash script.sh`)**: Runs the script under a new bash subshell directly. Does *not* require execution permissions on the file.
3.  **Sourcing (`source script.sh` or `. script.sh`)**: Executes the script inside the *current* shell session. Any variables or environment changes defined in the script will persist in the active terminal.

---

## 💻 Practical Examples

### 1. Your First Shell Script
Create a file named `hello_devops.sh` with the following contents:
```bash
#!/bin/bash
# This is a comment explaining what the script does.
# Purpose: Print a welcoming message and show system uptime.

echo "Hello, DevOps Engineer!"
echo "System Uptime:"
uptime
```
*   **Explanation:**
    *   Line 1 (`#!/bin/bash`): Specifies the interpreter.
    *   Lines 2-3 (`#...`): Comments for documentation, ignored by the shell.
    *   Lines 5-7: Standard command execution (`echo` prints to stdout, `uptime` shows system state).

*   **To Run the Script:**
    ```bash
    chmod +x hello_devops.sh
    ./hello_devops.sh
    ```

---

## 🛠️ DevOps Use Cases & Scenarios

### Bootstrapping Infrastructure (EC2 User Data / Cloud-Init)
When provisioning cloud virtual machines (e.g., AWS EC2, Azure VMs), you can supply a "User Data" script that runs on startup. These are standard shell scripts starting with `#!/bin/bash` that automate initial software installation (e.g., installing Docker, Git, Nginx) and configure firewalls before the server is handed over to applications.

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between executing `./script.sh` and `source ./script.sh`?**
*   **Answer:**
    *   `./script.sh` runs the script in a **new subshell** process. Any variables or environment modifications created during script execution are destroyed when the script finishes.
    *   `source ./script.sh` (or `. ./script.sh`) executes the script commands within the **current shell process**. This means variables, aliases, or functions defined in the script remain active in the terminal after the script completes. This is commonly used to load configuration files or environment variables (e.g., `source .env`).

**Q2: What happens if you omit the shebang line?**
*   **Answer:** If the shebang is omitted, the operating system will typically execute the script using the default login shell of the user running the command (e.g., Bash, Zsh, Sh). However, to guarantee cross-compatibility and prevent parsing errors when using shell-specific features (like arrays in Bash), always explicitly include `#!/bin/bash` at the top of the file.
