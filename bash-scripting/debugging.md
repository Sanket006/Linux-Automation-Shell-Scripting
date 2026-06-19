# 🐛 Debugging Shell Scripts

## 📌 Purpose
Because Bash scripts are interpreted at runtime, a syntax error or a variable expansion bug can cause silent failures or unexpected executions. Debugging techniques allow DevOps engineers to trace the execution path line-by-line, print expanded variables before command execution, and isolate buggy sections in complex scripts.

---

## ⚙️ Core Concepts & Commands

### 1. The `set` Options for Debugging
*   **`set -x` (xtrace)**: Prints every command after variables are expanded but before execution. Each traced line is prefixed with a `+` symbol. This is the primary tool for step-through debugging.
*   **`set +x`**: Disables the trace mode. Useful to wrap a specific block of code without printing trace logs for the entire script.
*   **`set -v` (verbose)**: Prints shell input lines as they are read by the interpreter.

### 2. Command Line Invocation
If you cannot edit the script file, you can debug it at invocation:
`bash -x script.sh`

---

## 💻 Practical Examples

### 1. Enabling Trace Logs Globally
```bash
#!/bin/bash
set -x

NAME="Sanket"
# Traces how the variable is expanded
echo "Hello, $NAME"
```

### 2. Toggling Debug Mode (Selective Tracing)
Trace only a specific, complex command block to keep log outputs clean and readable.
```bash
#!/bin/bash

echo "Starting deployment setup..."

# Enable debugging only for this critical block
set -x
DB_URL="db.prod.internal"
curl -s --fail "http://$DB_URL:5432/status"
set +x

echo "Deployment setup complete."
```

### 3. Custom Debug Function (Verbosity Levels)
Write a custom logging mechanism that only outputs debug information if a `DEBUG` environment variable is set.
```bash
#!/bin/bash
DEBUG_MODE=${DEBUG:-false}

debug_log() {
  if [[ "$DEBUG_MODE" == "true" ]]; then
    echo "[DEBUG] $1"
  fi
}

# Usage
debug_log "Checking configurations..."
echo "Running main process..."
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Troubleshooting Variable Expansion in CI/CD Runners
In Jenkins or GitHub Actions pipelines, scripts often fail because secrets or dynamic parameters are not populated as expected. By running the script with `bash -x script.sh`, you can inspect the exact expanded parameters in the pipeline logs.
*(Note: Ensure sensitive credentials/tokens are masked in the runner logs to prevent credential leakage).*

---

## 💡 Interview Q&A & Tips

**Q1: How do you debug a Bash script without editing its code?**
*   **Answer:** You can invoke the script using the bash interpreter with the `-x` flag: `bash -x script.sh`. This tells the shell to run the script in execution trace mode.

**Q2: What is the meaning of the `+` symbols in the output when running a script with `set -x`?**
*   **Answer:** The `+` symbol is the default value of the `PS4` shell prompt. It indicates that the line is an execution trace showing the command and its arguments *after* expansion, differentiating it from the script's actual stdout output.
