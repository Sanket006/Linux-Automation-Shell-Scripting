# 🌐 Networking Commands

Networking commands are your toolkit for understanding and troubleshooting how your Linux server communicates with the outside world. As a DevOps engineer, you will use these commands daily — to verify that a service is listening, to diagnose connectivity failures, to inspect firewall rules, and to test API endpoints.

> 📖 **See also:** For networking concepts (IP, DNS, subnet, firewall architecture), port conflict diagnosis, and full networking troubleshooting scenarios, see [`docs/networking-concepts.md`](../docs/networking-concepts.md).

---

## Core Commands

| Command | What It Does | Key Flags & Usage |
| :--- | :--- | :--- |
| `ip` | Show and manage network interfaces, IP addresses, and routing | `ip addr`, `ip route`, `ip link` |
| `ss` | Show active and listening network connections (replaces `netstat`) | `ss -tulnp` |
| `ping` | Test basic network reachability using ICMP | `ping -c 4 <host>` |
| `curl` | Transfer data to/from a server; test HTTP APIs | `curl -Iv https://example.com` |
| `wget` | Download files from the web non-interactively | `wget <URL>` |
| `nslookup` | Query DNS and look up hostname-to-IP mappings | `nslookup <domain>` |
| `dig` | Detailed DNS record lookup | `dig +short <domain>` |
| `nc` | Test raw TCP/UDP connectivity (netcat) | `nc -zv <host> <port>` |
| `traceroute` | Show the network path to a destination hop-by-hop | `traceroute <host>` |

---

## Practical Examples

### 1. Finding Listening Ports and Associated Services

The most common networking task: verify that your application is actually listening on the expected port.

```bash
sudo ss -tulnp
```

**Flag breakdown:**

| Flag | Meaning |
| :--- | :--- |
| `-t` | Show TCP connections |
| `-u` | Show UDP connections |
| `-l` | Show only listening sockets (not established connections) |
| `-n` | Show numeric port numbers instead of service names (e.g., `80` not `http`) |
| `-p` | Show the process name and PID that owns each socket |

**Filter to a specific port:**

```bash
sudo ss -tulnp | grep :8080
```

---

### 2. Checking Your Server's IP Address

```bash
# Show all network interfaces and their IP addresses
ip addr

# Show a specific interface (eth0, ens3, etc.)
ip addr show eth0
```

---

### 3. Troubleshooting DNS Resolution

When a hostname is not resolving correctly, or you need to verify an internal service endpoint:

```bash
# Check if a hostname resolves to the expected IP
nslookup api.internal.myapp.com

# Quick one-line DNS lookup
dig +short api.internal.myapp.com

# Query a specific DNS server (e.g., Google's public DNS)
nslookup api.internal.myapp.com 8.8.8.8
```

---

### 4. Testing an HTTP API Endpoint

```bash
# Simple GET request — shows response body
curl http://localhost:8080/health

# Show HTTP headers only (useful for checking redirects and TLS)
curl -I https://api.example.com

# Verbose output — shows TLS handshake, headers, and body
curl -Iv https://api.example.com

# Send a POST request with JSON
curl -X POST https://api.example.com/data \
  -H "Content-Type: application/json" \
  -d '{"status": "ok"}'
```

---

### 5. Testing Raw TCP Connectivity

Test whether a port is reachable on a remote server, without needing a full HTTP client:

```bash
# -z: scan only (no data), -v: verbose output
nc -zv database.internal 5432

# Test if port 443 is reachable on a remote server
nc -zv api.example.com 443
```

If the port is open, you will see `Connection to <host> <port> port [tcp] succeeded`. If it fails, the port is blocked by a firewall or the service is not running.

---

## DevOps Use Cases

### Diagnosing "Connection Refused" vs "Connection Timeout"

These two error messages have very different root causes:

| Error | Root Cause | How to Investigate |
| :--- | :--- | :--- |
| **Connection Refused** | Packet reached the server but no service is listening on that port | `sudo ss -tulnp` on the target server |
| **Connection Timeout** | Packet never reached the server — a firewall is silently dropping it | Check security groups, `ufw`, or `iptables` rules |

### Verifying a Deployment

After deploying a new application version, run a quick health check before marking the deployment as successful:

```bash
# 1. Confirm the service is listening
sudo ss -tulnp | grep :8080

# 2. Confirm the health endpoint responds with HTTP 200
curl -sf http://localhost:8080/health && echo "✅ Healthy" || echo "❌ Unhealthy"
```

---

## Best Practices

- Use `ip` instead of the deprecated `ifconfig`.
- Use `ss` instead of the deprecated `netstat`.
- Troubleshoot connectivity layer by layer: DNS → ping → port → firewall → application logs.
- In cloud environments (AWS, GCP), always check both the OS firewall (`ufw`, `iptables`) **and** the cloud-level security group — they are independent.
- Use `curl -sf` in scripts: `-s` suppresses progress output, `-f` makes curl exit with an error code on HTTP failures.

---

## Interview Q&A

**Q1: What is the modern replacement for `netstat` and why is it preferred?**
- **Answer:** `ss` (socket statistics) is the modern replacement. It retrieves TCP/UDP information directly from kernel space via netlink sockets, making it faster and more accurate than `netstat`, which had to parse the `/proc/net/tcp` file line-by-line. `ss` is part of the standard `iproute2` package on all modern Linux distributions.

**Q2: How do you verify if a specific port is listening on a remote server?**
- **Answer:** Use `nc` (netcat): `nc -zv <hostname> <port>`. The `-z` flag scans without sending data, `-v` gives verbose output showing success or failure. You can also use `curl` for HTTP ports or `telnet <host> <port>` for a basic TCP connection test.

**Q3: What is the difference between "connection refused" and "connection timed out"?**
- **Answer:** "Connection refused" means the packet successfully reached the target host, but the OS rejected it because no process was listening on that port. "Connection timed out" means the packet was sent but received no response — this is almost always caused by a firewall (like AWS Security Groups, `iptables`, or `ufw`) silently dropping the packet before it reaches the application.

---

> 🔖 **Note:** Networking commands are used in every production incident that involves service connectivity. Mastering `ss`, `curl`, `nc`, and `ip` allows you to quickly isolate whether a connectivity problem is a DNS issue, a firewall issue, or an application issue — dramatically reducing time to resolution.
