# 📊 Arrays in Bash

## 📌 Purpose
In automated setups, we often work with collections of data, such as a list of IP addresses, server names, docker containers, or directory paths. Arrays allow DevOps engineers to organize and manipulate these lists easily under a single variable, performing bulk actions like parallel deployments, status checks, and data updates.

---

## ⚙️ Core Concepts & Commands

### 1. Indexed Arrays
Arrays where elements are referenced by a zero-based integer index.
- **Declaration**: `MY_ARRAY=("item1" "item2" "item3")`
- **Access element**: `${MY_ARRAY[0]}` (returns "item1")
- **List all elements**: `${MY_ARRAY[@]}`
- **Array size/length**: `${#MY_ARRAY[@]}`
- **Append element**: `MY_ARRAY+=("new_item")`

### 2. Associative Arrays (Key-Value Maps)
Introduced in Bash 4+, these map keys (strings) to values.
- **Declaration**: `declare -A MY_MAP`
- **Set Value**: `MY_MAP[key]="value"`
- **Access Value**: `${MY_MAP[key]}`

---

## 💻 Practical Examples

### 1. Iterating Over an Indexed Array
Define a list of microservices and iterate to print their deployment status.
```bash
#!/bin/bash
SERVICES=("nginx" "mongodb" "redis" "payment-api")

# Print array length
echo "Total services to check: ${#SERVICES[@]}"

# Loop through all elements
for service in "${SERVICES[@]}"; do
  echo "Checking status of: $service"
done
```

### 2. Dynamically Appending to an Array
Scan a directory and capture a list of configurations dynamically.
```bash
#!/bin/bash
declare -a CONFIGS=()

for conf in /etc/nginx/conf.d/*.conf; do
  # Check if files exist to handle empty globbing
  if [[ -f "$conf" ]]; then
    CONFIGS+=("$conf")
  fi
done

echo "Found Nginx configuration files:"
for c in "${CONFIGS[@]}"; do
  echo "  - $c"
done
```

### 3. Using Associative Arrays (Key-Value Maps)
Store service names and their expected listening ports.
```bash
#!/bin/bash
# Note: Requires Bash 4.0 or higher
declare -A PORT_MAP

PORT_MAP[web]=80
PORT_MAP[api]=8080
PORT_MAP[db]=5432

# Access by key
echo "Database Port: ${PORT_MAP[db]}"

# Loop through keys
for role in "${!PORT_MAP[@]}"; do
  echo "Role: $role is assigned port: ${PORT_MAP[$role]}"
done
```

---

## 🛠️ DevOps Use Cases & Scenarios

### Dynamic Backups of Multiple Folders
Use arrays to define paths that need backups. This allows scaling the backup script easily by modifying a single list:
```bash
#!/bin/bash
BACKUP_PATHS=("/var/log" "/etc/nginx" "/home/appuser/configs")
BACKUP_DEST="/backup"

for path in "${BACKUP_PATHS[@]}"; do
  folder_name=$(basename "$path")
  echo "Backing up $path to $BACKUP_DEST/${folder_name}.tar.gz..."
  tar -czf "$BACKUP_DEST/${folder_name}.tar.gz" "$path" 2>/dev/null
done
```

---

## 💡 Interview Q&A & Tips

**Q1: How do you get the total number of items in a Bash array?**
*   **Answer:** You can get the array size by using the syntax `${#array_name[@]}` or `${#array_name[*]}`.

**Q2: What is the risk of using `for item in ${ARRAY[*]}` without double quotes?**
*   **Answer:** If array elements contain spaces (e.g., `"web server 1"`), omitting quotes causes Bash to perform word splitting, treating `"web"`, `"server"`, and `"1"` as three separate items in the loop. Always wrap the array expansion in double quotes: `"${ARRAY[@]}"`.
