# 🔁 Loops in Bash

## 📌 Purpose
Loops allow scripts to execute a block of commands repeatedly. In DevOps, loops are heavily used to iterate over lists of servers, process files line-by-line, check service health in a loop until it returns healthy, or perform bulk modifications on directory structures.

---

## ⚙️ Core Concepts & Commands

### 1. The `for` Loop
Used when you know in advance how many times you want to iterate (e.g., over a range of numbers, files, or elements in a list/array).

### 2. The `while` Loop
Repeatedly executes a block of code as long as the test condition remains true. Useful for continuous monitoring or reading file streams.

### 3. The `until` Loop
Repeatedly executes a block of code until the test condition becomes true (runs as long as the condition evaluates to false).

---

## 💻 Practical Examples

### 1. `for` Loop: Processing Files in a Directory
Rename or backup all `.txt` files in a folder.
```bash
#!/bin/bash
for file in *.txt; do
  # Check if files actually exist (handles empty glob)
  [[ -e "$file" ]] || continue
  echo "Backing up: $file"
  cp "$file" "${file}.bak"
done
```

### 2. `while` Loop: Reading a Log File Line-by-Line
```bash
#!/bin/bash
LOG_FILE="/var/log/nginx/access.log"

# Read file line-by-line safely
while read -r line; do
  if [[ "$line" =~ "404" ]]; then
    echo "Found 404 error: $line"
  fi
done < "$LOG_FILE"
```
*   **Explanation:**
    *   `read -r`: Reads lines without escaping backslashes.
    *   `< "$LOG_FILE"`: Redirects the file contents into the while loop input.

### 3. `until` Loop: Waiting for a Service to Boot (Health Check)
Wait for a web application to become online before running subsequent deployment stages.
```bash
#!/bin/bash
APP_URL="http://localhost:8080/health"

# Wait until curl returns HTTP status 200
until curl -s --head --fail "$APP_URL" > /dev/null; do
  echo "Application is offline. Waiting 5 seconds..."
  sleep 5
done

echo "Application is online! Starting integration tests."
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Bulk Server Status Checks
DevOps engineers often use loops to query the API endpoints of multiple services or iterate over a list of hostnames to run remote ping checks:
```bash
#!/bin/bash
SERVERS=("db-srv-01" "web-srv-01" "cache-srv-01")

for server in "${SERVERS[@]}"; do
  ping -c 1 "$server" > /dev/null
  if [ $? -eq 0 ]; then
    echo "$server is UP"
  else
    echo "ALERT: $server is DOWN!"
  fi
done
```

---

## 💡 Interview Q&A & Tips

**Q1: How do you read a file line-by-line in a shell script?**
*   **Answer:** The safest way to read a file line-by-line is using a `while read -r line` loop with input redirection:
    ```bash
    while read -r line; do
      echo "$line"
    done < filename.txt
    ```
    This approach is memory efficient because it streams the file line-by-line instead of loading the entire content into memory at once.

**Q2: What is the purpose of `break` and `continue` inside a loop?**
*   **Answer:**
    *   `break` immediately terminates the loop entirely and passes execution to the command following the loop.
    *   `continue` skips the remaining commands in the current iteration of the loop and starts the next iteration evaluation.
