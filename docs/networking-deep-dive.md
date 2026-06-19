# 🌐 Linux Networking Commands

This document covers **essential Linux networking concepts and commands** used to **troubleshoot connectivity, diagnose network issues, and validate services** in DevOps, cloud, and production environments.

---

## 📌 Why Networking Matters in Linux

Most production issues are related to:

* Service not reachable
* Port not listening
* DNS failure
* Firewall misconfiguration

Strong networking fundamentals help in **faster incident resolution**.

---

## 📌 Network Configuration & Interfaces

### `ip` – Modern Network Command

```bash
ip addr
ip link
ip route
```

**Use cases:**

* Check IP addresses
* Verify network interfaces
* Inspect routing table

---

### `ifconfig` – Legacy Interface Command

```bash
ifconfig
```

⚠️ Deprecated but still seen in interviews.

---

## 📌 Connectivity Testing

### `ping` – Test Network Reachability

```bash
ping google.com
ping -c 4 8.8.8.8
```

**Use case:** Check basic network connectivity.

---

### `traceroute` – Trace Network Path

```bash
traceroute google.com
```

**Use case:** Identify where packets are getting dropped.

---

## 📌 DNS Troubleshooting

### `nslookup`

```bash
nslookup google.com
```

### `dig`

```bash
dig google.com
```

**Use case:** Validate DNS resolution.

---

## 📌 Port & Service Checks

### `ss` – Socket Statistics (Recommended)

```bash
ss -tuln
```

* `t` → TCP
* `u` → UDP
* `l` → listening
* `n` → numeric output

---

### `netstat` – Legacy Port Check

```bash
netstat -tulnp
```

⚠️ Deprecated but commonly used.

---

## 📌 Web & API Testing

### `curl` – Data Transfer Tool

```bash
curl http://localhost:8080
curl -I https://example.com
```

### `wget` – File Download

```bash
wget https://example.com/file.zip
```

**Use case:** Test application endpoints & APIs.

---

## 📌 Firewall Basics

### `ufw` – Uncomplicated Firewall

```bash
ufw status
ufw allow 80
ufw deny 22
```

### `iptables` – Advanced Firewall

```bash
iptables -L
```

**Use case:** Allow or block traffic on servers.

---

## 📌 Network Files & Configs

Important files:

* `/etc/hosts`
* `/etc/resolv.conf`
* `/etc/sysconfig/network-scripts/`

**Use case:** Manual DNS or host mapping fixes.

---

## 🚀 DevOps & Production Use Cases

* Debugging application not reachable errors
* Checking ports on EC2 / cloud VMs
* Verifying CI/CD service connectivity
* API health checks
* Firewall & security validation

---

## ⭐ Best Practices

* Prefer `ip` over `ifconfig`
* Use `ss` instead of `netstat`
* Test connectivity layer by layer
* Always verify firewall rules

---

## 🎯 Interview Tips

* Difference between `ss` and `netstat`
* How to check if a port is open
* DNS vs IP connectivity issues
* Curl vs ping usage

---

### 🔖 Note

Linux networking knowledge is **mandatory for DevOps, Cloud, and SRE roles**. These commands are used daily for troubleshooting and validation.
