# 📦 Functions & Modularity

## 📌 Purpose
As automation scripts grow in size, they can become difficult to maintain and debug. Functions allow DevOps engineers to write modular, reusable blocks of code. Instead of copying and pasting code (e.g., for logging, notifications, or parameter validation), you can define a function once and call it multiple times across the script, improving readability and reducing bugs.

---

## ⚙️ Core Concepts & Commands

### 1. Declaring Functions
Functions are declared using one of two formats:
```bash
# Standard Unix Format (Recommended)
function_name() {
  # commands
}

# Alternative Format
function function_name {
  # commands
}
```

### 2. Function Scope & Variables
- **Arguments**: Functions do not use the main script's arguments directly. Instead, they accept their own positional arguments (`$1`, `$2`, etc.) passed when invoking the function: `function_name arg1 arg2`.
- **`local` Keyword**: By default, all variables in Bash are global. Inside a function, you must use the `local` keyword to restrict variable scope to that function, preventing side-effects elsewhere in the script.
- **Return Values**: Functions exit with status codes (`$?`) using the `return` statement. To return text data, functions use `echo` which is captured by the caller using command substitution `result=$(my_function)`.

---

## 💻 Practical Examples

### 1. Declaring a Function with Local Variables
```bash
#!/bin/bash

calculate_days() {
  local days=7  # local scope variable
  echo "Calculating files older than $days days."
}

# Invoke the function
calculate_days
```

### 2. A Modular Logging Function
A clean logger that prints formatted logs with severity levels and timestamps.
```bash
#!/bin/bash

# Logger Function
log_message() {
  local level=$1
  local message=$2
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  
  echo "[$timestamp] [$level] - $message"
}

# Usage
log_message "INFO" "Starting deployment process..."
log_message "WARNING" "Disk usage is high on /dev/xvda1."
log_message "ERROR" "Failed to connect to Database server!"
```

### 3. Function returning a value via stdout
```bash
#!/bin/bash

get_backup_filename() {
  local prefix="backup"
  local date_str=$(date +%F)
  # "Return" value by echo
  echo "${prefix}-${date_str}.tar.gz"
}

# Capture function output
FILE_NAME=$(get_backup_filename)
echo "Backup will be saved as: $FILE_NAME"
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Parameterized Deployment Step Function
In complex deploy scripts, you want each deployment step to have consistent logging and error reporting. Wrapping each step in a function achieves this cleanly without repeating code:
```bash
#!/bin/bash

# Generic step runner: logs the step name, runs the command, and checks the result
run_step() {
    local STEP_NAME=$1
    local STEP_CMD=$2

    echo "--- Running: $STEP_NAME ---"
    eval "$STEP_CMD"

    if [ $? -eq 0 ]; then
        echo "✅ $STEP_NAME succeeded."
    else
        echo "❌ $STEP_NAME failed. Aborting deployment."
        exit 1
    fi
}

# Each step is a single function call — easy to add, remove, or reorder
run_step "Install Dependencies"  "npm install --production"
run_step "Run Tests"             "npm test"
run_step "Build Application"     "npm run build"
run_step "Restart Service"       "systemctl restart myapp"
```

> **📎 Note:** For the `trap cleanup EXIT` pattern that runs cleanup on script failure, see [`error-handling.md`](error-handling.md).


---

## 💡 Interview Q&A & Tips

**Q1: How do variables declared inside a function behave compared to main script variables?**
*   **Answer:** By default, variables in Bash are global, meaning a variable declared inside a function can overwrite or modify a variable in the main script body. To prevent this, variables inside functions should be declared using the `local` keyword (e.g., `local var_name="value"`), which isolates them to the function's execution frame.

**Q2: How do you return a string value from a Bash function?**
*   **Answer:** Bash functions can only return an integer status code (0 to 255) using the `return` statement. To return a string, print the string to standard output using `echo` or `printf` inside the function, and capture that output in the caller using command substitution: `RESULT=$(my_function)`.
