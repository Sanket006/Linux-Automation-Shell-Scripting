# 🌟 Shell Scripting Best Practices

## 📌 Purpose
Writing shell scripts is easy, but writing *robust, maintainable, and secure* shell scripts is difficult. Poorly structured scripts lead to outages, security gaps, and configuration drift. This guide compiles industry-standard best practices followed by professional DevOps teams to ensure scripts are reliable and clean.

---

## ⚙️ Core Concepts & Guidelines

### 1. Always Quote Variables
Unquoted variables are subject to word splitting and globbing, leading to syntax crashes when variables contain spaces or special characters.
*   **Bad**: `rm -rf $DIR_NAME`
*   **Good**: `rm -rf "$DIR_NAME"`

### 2. Use ShellCheck
**ShellCheck** is a static analysis tool for shell scripts. It points out syntax errors, semantic bugs, and security weaknesses. Integrate it into your IDE or local git hook setup.

### 3. Fail Fast
Always enable options that terminate execution immediately on failures:
```bash
set -euo pipefail
```

### 4. Prefer `$()` over Backticks
Command substitution should use `$()` rather than legacy backticks `` ` ``. `$()` handles nesting easily and improves readability.
*   **Bad**: `DATE=\`date\``
*   **Good**: `DATE=$(date)`

---

## 💻 Practical Examples: Bad vs. Good Script

### The Bad Script (Fragile & Insecure)
```bash
#!/bin/bash
# Problems: No error configuration, unquoted variables, hardcoded path, uses backticks
BACKUP_DIR=/tmp/backups
FILE_NAME=backup_`date +%F`.tar.gz
mkdir $BACKUP_DIR
tar -czf $BACKUP_DIR/$FILE_NAME /data/logs
echo Backup done
```

### The Good Script (Robust & Professional)
```bash
#!/bin/bash
# Enhancements: Shebang, fail-fast configs, quoted vars, path defaults, error tracking
set -euo pipefail

BACKUP_DIR="${1:-/tmp/backups}"
TIMESTAMP=$(date +%F-%H-%M)
FILE_NAME="backup-${TIMESTAMP}.tar.gz"

# Logging function
log_info() {
  echo "[INFO] [$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

# Create backup directory safely
if [[ ! -d "$BACKUP_DIR" ]]; then
  log_info "Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
fi

log_info "Starting backup compression..."
tar -czf "${BACKUP_DIR}/${FILE_NAME}" -C /data logs

log_info "Backup compression completed successfully."
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Integrating ShellCheck into CI/CD Pipelines
To prevent faulty shell scripts from reaching production repositories, DevOps engineers configure a pre-commit hook or a CI/CD job (e.g., GitHub Actions) to run ShellCheck on all changed script files:
```yaml
# GitHub Actions Step Example
- name: Run ShellCheck
  run: shellcheck automation-scripts/*.sh
```

---

## 💡 Interview Q&A & Tips

**Q1: Why should you double-quote variables in shell scripts?**
*   **Answer:** Double-quoting variables (e.g., `"$VAR"`) prevents the shell from performing **word splitting** (splitting a single string with spaces into multiple arguments) and **path expansion/globbing** (interpreting wildcard characters like `*` or `?`). This makes the script secure against files/paths containing spaces or special characters.

**Q2: What is ShellCheck?**
*   **Answer:** ShellCheck is an open-source static analysis tool for shell scripts. It scans script files for common developer errors, syntax warnings, security hazards, and code smells, providing direct suggestions on how to refactor them.
