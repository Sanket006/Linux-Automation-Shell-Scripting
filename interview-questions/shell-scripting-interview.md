# 🐚 Shell Scripting Interview Questions (DevOps Focus)

## 📌 Purpose
This document covers commonly asked Bash and shell scripting interview questions. In DevOps interviews, questions focus heavily on writing robust, production-safe scripts, handling errors gracefully, passing parameters dynamically, and implementing automated recovery tasks.

---

## ⚙️ Core Questions & Answers

### 1. Basics & Interpreter Configuration

#### **Q1. What is a shebang (`#!`) and why is it important at the top of a script?**
*   **Answer**: The shebang (hash-bang) is the first line in a script (e.g., `#!/bin/bash`). It starts with the characters `#!` followed by the absolute path to the interpreter that should execute the script. It is important because:
    *   It specifies the exact execution environment (e.g., Bash, Python, Perl) so the OS knows which parser to use.
    *   If omitted, the OS defaults to the user's current shell, which can cause syntax failures if Zsh or Sh is used to run a script containing Bash-specific features (like arrays).

#### **Q2. How do you pass arguments dynamically to a shell script at runtime?**
*   **Answer**: You pass arguments directly after the script execution command (e.g., `./deploy.sh staging app-v2`). Inside the script, these parameters are accessed using positional variables:
    *   `$1` (first argument, e.g., `staging`)
    *   `$2` (second argument, e.g., `app-v2`)
    *   `$#` returns the total count of arguments passed.
    *   `"$@"` returns a list of all arguments as individual quoted strings.

---

### 2. Control Flow & Logic

#### **Q3. What are exit codes in Linux and how do you use them inside scripts?**
*   **Answer**: Exit codes (or exit statuses) are integers from `0` to `255` returned by a process to indicate the outcome of its execution:
    *   `0` represents successful execution.
    *   Any value from `1` to `255` represents a specific error or failure.
    *   In scripts, you retrieve the exit code of the last command using the special variable `$?`. You can enforce custom terminations using the `exit` command (e.g., `exit 1` on error).

#### **Q4. When should you use a `case` statement instead of `if-elif-else` conditions?**
*   **Answer**: You should use a `case` statement when comparing a single variable against multiple string patterns (like command line flags: `start|stop|restart`). `case` improves readability, avoids deeply nested `if` statements, and supports wildcard glob matching for fallback options.

---

### 3. Error Handling & Robustness

#### **Q5. What does the configuration `set -euo pipefail` do, and why should it be used?**
*   **Answer**: It is a collection of safety configurations that forces a script to "fail fast" instead of proceeding silently with errors:
    *   `-e` (errexit): Terminate the script immediately if any command returns a non-zero exit status.
    *   `-u` (nounset): Terminate if the script tries to expand an undeclared/unbound variable (prevents typos from causing destructive commands like `rm -rf $TYPO/`).
    *   `-o pipefail`: Prevents masked pipeline failures. The exit code of a pipe (e.g., `cmd1 | cmd2`) will represent the code of the rightmost command that failed, rather than always representing `cmd2`'s exit code.

#### **Q6. Explain how the `trap` command helps in writing robust automation.**
*   **Answer**: `trap` allows you to intercept system signals (like script exit `EXIT`, shell error `ERR`, or termination `SIGTERM`) and execute cleanup functions. It is used to:
    *   Remove temporary folders (`rm -rf "$TEMP_DIR"`).
    *   Release file locks or database transactions.
    *   Send crash alerts or logs to Slack/monitoring tools upon script failure.

---

### 4. Debugging & Troubleshooting

#### **Q7. How do you trace the execution of a Bash script to find errors?**
*   **Answer**:
    *   **Globally**: Inject `set -x` (execution trace) at the top of the script. This prints every line of code after variable expansion but before execution, prefixed with a `+` symbol.
    *   **Selectively**: Wrap the buggy section with `set -x` (enable trace) and `set +x` (disable trace).
    *   **Invocation**: Execute the script with the `-x` flag directly: `bash -x script.sh`.

---

### 5. DevOps Automation Scenarios

#### **Q8. How would you automate a disk monitoring script that checks usage and triggers alerts?**
*   **Answer**:
    1.  **Write the script**: Create a shell script that reads partition space using `df -h` and parses values:
        ```bash
        #!/bin/bash
        set -euo pipefail
        THRESHOLD=80
        df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read -r output; do
          usep=$(echo "$output" | awk '{ print $1}' | cut -d'%' -f1)
          partition=$(echo "$output" | awk '{ print $2 }')
          if [ "$usep" -ge "$THRESHOLD" ]; then
            echo "ALERT: Partition $partition is ${usep}% full!" | mail -s "Disk Alert: $partition" admin@company.com
          fi
        done
        ```
    2.  **Make executable**: Run `chmod +x disk_monitor.sh`.
    3.  **Schedule it**: Set it to run every hour using Cron by running `crontab -e` and adding:
        `0 * * * * /usr/local/bin/disk_monitor.sh`
