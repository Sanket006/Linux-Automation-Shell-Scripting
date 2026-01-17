# 🐚 Shell Scripting Interview Questions

## Purpose

Prepare for **shell scripting interview questions** with a focus on **automation, reliability, and DevOps best practices**.

---

## 1. Basics

**Q1. What is shell scripting?**
Shell scripting is writing scripts to automate Linux commands and administrative tasks.

**Q2. What is a shebang?**
It tells the system which interpreter to use for the script.

---

## 2. Variables & Input

**Q3. Difference between local and environment variables?**
Local variables are script-specific; environment variables are inherited by child processes.

**Q4. How do you pass arguments to a script?**
Using `$1`, `$2`, etc.

---

## 3. Conditions & Loops

**Q5. What are exit codes?**
They indicate success or failure of a command.

**Q6. Explain if vs case.**
`if` handles conditions; `case` handles multiple pattern matches.

---

## 4. Error Handling

**Q7. How do you handle errors in shell scripts?**
Using exit codes, `set -e`, `trap`, and logging.

---

## 5. Debugging

**Q8. How do you debug a script?**
Using `set -x`, echo statements, and logs.

---

## DevOps Scenario Question

**Q9. How would you automate disk monitoring?**
Write a script to check disk usage and trigger alerts, scheduled via cron or systemd.

---

## Interview Tip

Explain **why your script is reliable**, not just how it works.
