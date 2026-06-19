# 🧠 Linux Internals (DevOps View)

## 📌 Purpose
Linux internals refer to the architecture and execution mechanisms of the Linux operating system kernel. A solid grasp of internals—such as the separation of memory spaces, the sequence of system boot, and process lifecycles—is essential for diagnosing application crashes, debugging resource starvation, profiling application performance, and understanding container isolation.

---

## ⚙️ Core Concepts

### 1. Kernel Space vs. User Space
Linux divides system memory into two distinct privilege rings:
*   **Kernel Space**: The privileged memory area where the core operating system kernel executes. It has direct, unrestricted access to the CPU, physical memory, network cards, and hardware drives.
*   **User Space**: The non-privileged memory area where all user applications, services, and shells run (e.g., Python, Nginx, Docker). Applications in user space cannot access hardware directly.
*   **System Calls (Syscalls)**: When a user-space application needs to write a file, send network packets, or allocate memory, it must request access from the kernel using a **System Call** (e.g., `read()`, `write()`, `fork()`).

### 2. The Linux Boot Process
Understanding the boot process helps debug instances that fail to launch:
1.  **BIOS/UEFI**: Physical hardware checks (POST) and locates the primary boot device.
2.  **Bootloader (GRUB)**: Loads the Linux kernel image (`vmlinuz`) and initial RAM disk (`initramfs`) into memory.
3.  **Kernel Initialization**: Kernel mounts the temporary root filesystem, initializes drivers, and starts hardware.
4.  **`systemd` (PID 1)**: The kernel launches the systemd process as the first user-space process (PID 1). systemd mounts real filesystems and starts configured background services.
5.  **User Login**: The display manager or login terminal prompt is loaded.

### 3. Process Lifecycle & States
Every process is created by cloning an existing process:
*   **`fork()`**: A parent process clones itself to create a child process.
*   **`exec()`**: The child process immediately replaces its program code with a new binary.
*   **Zombie Process (`[defunct]`)**: A process that has finished execution but still has an entry in the system process table because its parent has not yet read its exit status.
*   **Orphan Process**: A child process whose parent terminated before it. Orphan processes are automatically adopted by `systemd` (PID 1), which cleans up their resource states when they exit.

---

## 💻 Practical Commands

### 1. Inspecting System Calls (`strace`)
Trace all system calls made by a basic command:
```bash
strace -c ls
```
*   **Explanation:** Outputs a summary table of all system calls (like `openat`, `read`, `mmap`) used by `ls` during its execution, showing where execution time was spent in kernel space.

### 2. Checking Process States and Zombie Counts
```bash
ps -eo pid,ppid,state,cmd | grep defunct
```
*   **Explanation:** Lists all running process PIDs, Parent PIDs (PPID), states, and filters for processes in the Zombie state (indicated by `defunct`).

---

## 🛠️ DevOps Use Cases & Scenarios

### How Containers Work Under the Hood
Docker containers are not virtual machines; they are standard user-space processes running directly on the host Linux kernel. They achieve isolation using two kernel features:
*   **Namespaces**: Restrict what a process can *see* (isolates processes, network routing tables, mount paths, user lists).
*   **Control Groups (cgroups)**: Restrict what a process can *use* (limits memory, CPU cores, network bandwidth, disk I/O).

---

## 💡 Interview Q&A & Tips

**Q1: What is a System Call (Syscall) in Linux?**
*   **Answer:** A system call is the programmatic interface that allows a user-space application to request services from the privileged Linux kernel (such as allocating memory, reading/writing files on disk, or creating network connections).

**Q2: What is a zombie process and how do you clean it up?**
*   **Answer:** A zombie process is a process that has completed execution but still exists in the process table because its parent has not yet read its exit status via `wait()`. Since they are already dead, you cannot kill them with `kill -9`. To clean them up:
    1.  Notify the parent process to read the status.
    2.  If the parent is unresponsive, restart or terminate the parent process. Once the parent dies, the zombie becomes an orphan, is adopted by `systemd` (PID 1), and is immediately cleared.
