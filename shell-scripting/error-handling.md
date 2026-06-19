# ⚠️ Error Handling & Fault Tolerance

## 📌 Purpose
By default, Bash scripts continue executing the next line even if a previous command failed. This "ignore errors" behavior is highly dangerous in production automation. If a download or configuration step fails, proceeding with subsequent commands could deploy broken software, delete incorrect paths, or corrupt data. This guide teaches you how to implement fail-fast behaviors and graceful error handling.

---

## ⚙️ Core Concepts & Commands

### 1. Fail-Fast Configurations (`set` options)
To change the default loose behavior of Bash scripts, we inject configurations at the top of the file:
*   **`set -e`**: Tells Bash to exit the script immediately if any command exits with a non-zero status.
*   **`set -o pipefail`**: Ensures that pipelined commands (e.g., `cmd1 | cmd2`) propagate a failure. Without this, the exit status of the pipeline is only determined by the last command (`cmd2`), ignoring failures in `cmd1`.
*   **`set -u`**: Exits the script if an uninitialized/unbound variable is referenced. This prevents typos from executing commands like `rm -rf $TYPO_VAR/`.

### 2. Trap Handlers (`trap`)
The `trap` command registers a cleanup function or command to execute when specific signals or events occur (e.g., script exit, shell error, interruption).

### 3. Exit Codes
*   `exit 0`: Indicates successful completion.
*   `exit 1-255`: Indicates specific errors. Always return a non-zero exit code upon encountering an unrecoverable failure.

---

## 💻 Practical Examples

### 1. Simple Command Chaining (Inline Fallbacks)
Execute a secondary command or print an alert only if the primary command fails.
```bash
#!/bin/bash
mkdir /var/log/my-app || { echo "Failed to create log directory!"; exit 1; }
```

### 2. Implementing Fail-Fast Behaviour
```bash
#!/bin/bash
set -eo pipefail

# If curl fails (e.g. 404/DNS error), the script exits immediately.
curl -s --fail https://example.com/api/bundle.tar.gz -o bundle.tar.gz

# This command won't run if curl failed.
tar -xzf bundle.tar.gz
```

### 3. Automatic Cleanup on Failure (using Trap)
Ensure that temporary assets are deleted, regardless of whether the script succeeds or crashes.
```bash
#!/bin/bash
set -e

# Define temporary path
TEMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
echo "Created temp directory: $TEMP_DIR"

# Cleanup function
cleanup_temp() {
  echo "Executing trap: removing temporary directory..."
  rm -rf "$TEMP_DIR"
}

# Register cleanup function to run on EXIT signal
trap cleanup_temp EXIT

# Perform tasks
echo "Simulating tasks..."
# If any command here fails, script exits, and trap runs automatically
cd "$TEMP_DIR"
touch deployment.log
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Preventing Disaster in Cleanup Scripts
Consider a script designed to delete files from a release directory. If the variable `$RELEASE_DIR` is empty or unbound due to a pipeline parameter bug:
```bash
# Typos/Empty vars with 'set -u' disabled:
rm -rf "$RELEASE_DIR/"
```
Without `set -u`, the variable expands to nothing, executing `rm -rf /` which deletes the entire host filesystem!
By implementing standard error options at the top of every script, we guarantee safety:
```bash
#!/bin/bash
set -euo pipefail
# Script will terminate with 'unbound variable' error before running rm!
```

---

## 💡 Interview Q&A & Tips

**Q1: What does the combination `set -euo pipefail` do?**
*   **Answer:**
    *   `-e` (errexit): Exits the script immediately if any command returns a non-zero exit status.
    *   `-u` (nounset): Exits the script if it references a variable that hasn't been declared/bound.
    *   `-o pipefail`: Prevents masking failures in pipelines; if any command in a pipe fails, the exit code of the entire pipe represents that failure.

**Q2: What is the purpose of the `trap` command in Bash?**
*   **Answer:** `trap` is used to intercept signals (like SIGINT, SIGTERM, EXIT, or ERR) and run specific cleanup code. It is commonly used to clean up temporary files, release database locks, terminate background worker processes, or send slack notifications on failures.
