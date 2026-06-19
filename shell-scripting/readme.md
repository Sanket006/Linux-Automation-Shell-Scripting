# 🐚 Bash Shell Scripting Reference

## 📌 Overview
This directory contains a complete structured guide to Bash shell scripting, going from initial fundamentals to advanced error handling and debugging. Shell scripting is the primary mechanism for automating repetitive tasks, bootstrapping servers, and gluing tools together in DevOps environments. Every topic here includes executable examples, real DevOps use cases, and tips for technical interviews.

---

## 📂 Directory Contents

| Topic | File | Key Focus Areas | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| **🐚 Basics** | [`basics.md`](basics.md) | Shebang (`#!/bin/bash`), execution, permissions, comments. | Bootstrapping script structure. |
| **🔣 Variables & Input** | [`variables-input.md`](variables-input.md) | Local vars, env vars, CLI arguments (`$1`, `$2`), `read`. | Writing dynamic and configurable automation. |
| **⚖️ Conditions & Logic** | [`conditions.md`](conditions.md) | `if/elif/else`, `case` statements, exit codes. | Branching logic based on command success/failure. |
| **🔁 Loops** | [`loops.md`](loops.md) | `for`, `while`, `until` loops, infinite execution. | Iterating over server lists, files, or waiting for services. |
| **📦 Functions** | [`functions.md`](functions.md) | Syntax, local variables, passing arguments. | Reusing logic (e.g., logging, cleanup) across scripts. |
| **📊 Arrays** | [`arrays.md`](arrays.md) | Declaring arrays, listing items, string iteration. | Batch processing multiple servers or directories. |
| **⚠️ Error Handling** | [`error-handling.md`](error-handling.md) | `set -e`, `trap` cleanups, custom exit codes. | Ensuring scripts exit immediately upon errors. |
| **🐛 Debugging** | [`debugging.md`](debugging.md) | `set -x`, verbose tracing, custom log functions. | Diagnosing line-by-line execution failures. |
| **🌟 Best Practices** | [`best-practices.md`](best-practices.md) | Writing clean, readable, robust scripts. | Maintainable scripts in repository standards. |
| **🚀 Real-World Examples** | [`real-world-examples.md`](real-world-examples.md) | 20 practical scripts (log rotation, backups, monitors). | Custom script building reference. |

---

## 🎯 Learning Outcomes
After completing this section, you will be able to:
- Write clean, modular, and robust shell scripts from scratch.
- Pass parameters dynamically to scripts using arguments and environment variables.
- Write complex branching logic and loops to interact with files and commands.
- Handle script failures gracefully using standard error trapping patterns.
- Debug and trace scripts systematically to identify lines causing failures.

---

## 🚀 DevOps Advantage
Automating server infrastructure is the core of Platform and DevOps engineering. Mastering Bash allows you to:
- **Build Custom Tooling:** Create lightweight backup, monitoring, or deployment tools.
- **Customize CI/CD Pipelines:** Inject custom build, test, and release logic into pipelines (e.g., Jenkins, GitLab CI).
- **Configure Container Entrypoints:** Write robust docker entrypoint scripts (`entrypoint.sh`) that prepare databases or environment variables before launching primary containers.

---

## ℹ️ How to Use & Next Steps
1. Browse through the topics in order starting from **Basics** to **Best Practices**.
2. Run the code snippets in a safe playground shell.
3. Review the **DevOps Use Case** and **Interview Q&A** sections in each document.
4. Practice by inspecting and rewriting the production-ready scripts in the `automation-scripts` directory.
