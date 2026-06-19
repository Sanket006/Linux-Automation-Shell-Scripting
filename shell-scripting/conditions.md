# ⚖️ Conditions & Logic

## 📌 Purpose
Conditional logic allows a script to make decisions based on changing system states, such as checking if a directory exists, verifying if a service is running, or asserting that the previous command completed successfully. DevOps engineers use conditional statements to control execution flows and protect scripts from running commands in incorrect system states.

---

## ⚙️ Core Concepts & Commands

### 1. Conditional Syntax
- **`if / elif / else`**: Evaluates a test condition.
- **`case`**: Cleans up nested `if` statements when matching a single variable against multiple patterns.

### 2. Operators & Test Brackets
- **`[` (test command)**: Standard POSIX tool for evaluation.
- **`[[` (extended test)**: Bash-specific keyword offering advanced features like regex matching, logical operators (`&&`, `||`), and fewer quoting requirements.

#### Comparison Operators:
*   **Strings**: `==` (equal), `!=` (not equal), `-z` (string is empty).
*   **Integers**: `-eq` (equal), `-ne` (not equal), `-gt` (greater than), `-lt` (less than), `-ge` (greater or equal), `-le` (less or equal).
*   **Files**: `-f` (exists and is a file), `-d` (exists and is a directory), `-e` (exists).

---

## 💻 Practical Examples

### 1. File and Directory Check
Verify if a backup directory exists before writing to it; create it if missing.
```bash
#!/bin/bash
BACKUP_DIR="/backup/daily"

if [[ ! -d "$BACKUP_DIR" ]]; then
  echo "Backup directory does not exist. Creating: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
else
  echo "Backup directory exists."
fi
```

### 2. Integer Comparison (Disk Usage Check)
Check if disk usage is above a defined threshold.
```bash
#!/bin/bash
USAGE=85
THRESHOLD=80

if [[ "$USAGE" -gt "$THRESHOLD" ]]; then
  echo "Warning: Disk usage ($USAGE%) has crossed threshold ($THRESHOLD%)!"
fi
```

### 3. Case Statements for Menu Options / CLI Args
```bash
#!/bin/bash
ACTION=$1

case "$ACTION" in
  start)
    echo "Starting application..."
    ;;
  stop)
    echo "Stopping application..."
    ;;
  restart)
    echo "Restarting application..."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Exit Code Check for Step Orchestration
In CI/CD, if a step fails, the script must abort immediately to prevent deploying broken code. This is done by checking the exit status (`$?`):
```bash
#!/bin/bash
npm run build

# Capture exit status of build command
if [ $? -ne 0 ]; then
  echo "Build failed! Aborting deployment."
  exit 1
fi

echo "Build succeeded. Proceeding to deploy."
```

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between `[` and `[[` in Bash conditional statements?**
*   **Answer:** 
    *   `[` is a POSIX standard command (equivalent to the `test` command). It is compatible with all Unix shells, but requires careful variable quoting and uses operators like `-a` and `-o` for logical AND and OR.
    *   `[[` is a Bash-specific keyword. It is more robust because it does not perform word splitting or glob expansion on variables, preventing syntax errors on empty variables. It also supports regular expression matching (`=~`), wildcard globbing, and modern logical operators (`&&`, `||`).

**Q2: What exit code represents success in Linux?**
*   **Answer:** In Linux, an exit code of `0` represents success. Any non-zero exit code (from `1` to `255`) represents a failure or a specific error code.
