# 🔣 Variables & User Input

## 📌 Purpose
Scripts must be dynamic to be reusable. Hardcoding values like server IPs, usernames, or database names makes scripts rigid and error-prone. By using variables, reading runtime arguments, and accepting environment inputs, DevOps engineers can write highly adaptable scripts that run seamlessly across development, staging, and production environments.

---

## ⚙️ Core Concepts & Commands

### 1. Variables
In Bash, variables are declared by writing `VARIABLE_NAME=value` (without spaces around the `=` sign) and referenced using `$VARIABLE_NAME` or `${VARIABLE_NAME}`.
- **Local Variables**: Scope is limited to the script.
- **Environment Variables**: Available to the script and any child processes it spawns. Created using `export`.

### 2. Positional Arguments (Command Line Arguments)
When running a script (`./script.sh arg1 arg2`), parameters are automatically captured in special variables:
*   `$0`: Name of the script itself.
*   `$1`, `$2` ... `$9`: First, second, etc., arguments passed to the script.
*   `$#`: Total number of arguments passed.
*   `$@`: Lists all arguments passed as separate items.
*   `$?`: Exit status of the last executed command.

### 3. User Input (`read`)
Allows interactive scripts to pause and prompt the user for input during execution.

---

## 💻 Practical Examples

### 1. Declaring and Referencing Variables
```bash
#!/bin/bash
APP_NAME="Payment Service"
PORT=8080

echo "Starting ${APP_NAME} on port ${PORT}..."
```

### 2. Handling Command Line Arguments
```bash
#!/bin/bash
# Check if at least one argument was passed
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

ENV=$1
echo "Deploying applications to the ${ENV} environment."
echo "Total arguments passed: $#"
```

### 3. Interactive Prompts
```bash
#!/bin/bash
# Prompt the user for verification
read -p "Do you want to proceed with deployment? (y/n): " USER_CHOICE

# Prompt securely for passwords (hides characters)
read -sp "Enter Database Password: " DB_PASS
echo -e "\nPassword captured successfully."
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Environment-Driven Deployments
A single deployment script is used to deploy containers to Development, QA, and Production clusters. Instead of writing three scripts, variables are dynamically injected at runtime by the CI/CD pipeline using environment variables:
```bash
#!/bin/bash
# CI/CD pipeline executes: export TARGET_ENV="staging"
# This script reads it:
echo "Target Environment: ${TARGET_ENV}"
kubectl apply -f k8s/${TARGET_ENV}-manifests.yaml
```

---

## 💡 Interview Q&A & Tips

**Q1: What is the difference between `$*` and `$@` in Bash?**
*   **Answer:** Both are used to represent all command-line arguments. However:
    *   `"$*"` expands to a single double-quoted string: `"arg1 arg2 arg3"`.
    *   `"$@"` expands to separate individual double-quoted strings: `"arg1"` `"arg2"` `"arg3"`. In loops, you should almost always use `"$@"` to preserve arguments with spaces.

**Q2: What happens if there is a space around the equals sign when declaring a variable? (e.g., `NAME = Sanket`)**
*   **Answer:** Bash will throw a syntax error. It will interpret `NAME` as a command/program to execute, and `=` and `Sanket` as its arguments. In Bash, variable declarations must never have spaces around the `=` sign.
