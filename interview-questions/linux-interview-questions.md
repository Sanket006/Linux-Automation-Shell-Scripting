# 🐧 Linux Interview Questions (DevOps Focus)

## Purpose

This document contains **commonly asked Linux interview questions** tailored for **DevOps, Cloud, and SRE roles**, with a strong focus on **practical usage and troubleshooting**.

---

## 1. Linux Basics

**Q1. What is Linux?**
Linux is an open-source, Unix-like operating system used widely for servers, cloud, containers, and DevOps automation.

**Q2. Difference between Linux and Unix?**
Unix is proprietary, Linux is open-source and community-driven.

---

## 2. Files & Permissions

**Q3. Explain file permissions in Linux.**
Linux uses read (r), write (w), execute (x) permissions for user, group, and others.

**Q4. What is umask?**
It defines default permissions for newly created files and directories.

---

## 3. Process & Services

**Q5. Difference between process and service?**
A process is a running instance of a program; a service is a long-running background process managed by systemd.

**Q6. How do you check running processes?**
Using `ps`, `top`, `htop`.

---

## 4. Disk & Memory

**Q7. Difference between df and du?**
`df` shows disk usage of filesystems, `du` shows usage of files/directories.

**Q8. What will you do if disk is full?**
Check usage, clean logs, remove unused files, extend disk if required.

---

## 5. Networking

**Q9. How do you check open ports?**
Using `ss -tuln` or `netstat`.

**Q10. How to test connectivity?**
Using `ping`, `curl`, `telnet`.

---

## Interview Tip

Always explain answers with **real troubleshooting examples**.
