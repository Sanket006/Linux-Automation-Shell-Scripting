# 🌐 Linux Networking Commands

Networking is one of the most common areas where DevOps engineers spend time troubleshooting. Whether a service is unreachable, a port is not listening, DNS is broken, or a firewall is blocking traffic — these commands are your toolkit for diagnosing and fixing connectivity issues quickly.

---

## Why Networking Knowledge Matters

Most production incidents involve a networking component:

- An application is deployed but users cannot reach it.
- A microservice cannot connect to its database.
- DNS resolution is failing for an internal hostname.
- A cloud security group or firewall rule is blocking traffic silently.

Knowing which command to run — and how to read its output — is the difference between a 5-minute fix and an hour-long outage.

---

## Network Interface & IP Address Commands

### `ip` — The Modern Network Command

`ip` is the standard tool for inspecting and configuring network interfaces and routing.

```bash
# Show all network interfaces and their IP addresses
ip addr

# Show only the IPv4 address of a specific interface
ip addr show eth0

# Show the routing table (where traffic is sent)
ip route

# Show interface link state (up/down)
ip link
```

> ⚠️ `ifconfig` is an older alternative you may see in legacy systems and some interviews, but it is deprecated. Use `ip` on modern Linux.

---

## Connectivity Testing

### `ping` — Test Network Reachability

Sends ICMP packets to a host and reports whether it responds. The simplest first-step in any connectivity troubleshooting.

```bash
# Send 4 packets to Google's DNS server
ping -c 4 8.8.8.8

# Test by hostname (also verifies DNS is working)
ping -c 4 google.com
```

**What the output tells you:**

- Round-trip time (ms) — how fast the host responds.
- Packet loss % — `100% packet loss` means the host is unreachable or ICMP is blocked.

### `traceroute` — Trace the Network Path

Shows every network hop a packet takes to reach a destination. Helps identify where packets are being dropped.

```bash
traceroute google.com
```

---

## DNS Troubleshooting

DNS (Domain Name System) converts hostnames like `api.myapp.com` into IP addresses. When applications cannot reach each other by hostname, DNS is often the culprit.

### `nslookup` — Query DNS

```bash
# Check if a hostname resolves correctly
nslookup api.myapp.com

# Query a specific DNS server
nslookup api.myapp.com 8.8.8.8
```

### `dig` — Detailed DNS Lookup

```bash
# Get full DNS record details
dig google.com

# Get only the answer section
dig +short google.com
```

**Common DNS files on the server:**
- `/etc/resolv.conf` — defines which DNS servers to use.
- `/etc/hosts` — local overrides (checked before DNS).

---

## Port & Service Checks

### `ss` — Socket Statistics (Recommended)

`ss` replaces the older `netstat` command. It shows active and listening network connections directly from kernel space — faster and more accurate.

```bash
# Show all TCP and UDP listening ports with process info
sudo ss -tulnp
```

**Flag breakdown:**

| Flag | Meaning |
| :--- | :--- |
| `-t` | TCP connections |
| `-u` | UDP connections |
| `-l` | Listening ports only |
| `-n` | Show port numbers (not service names) |
| `-p` | Show the process name and PID |

**Typical use:** Confirm your Nginx/Node/Java app is actually listening on the expected port.

```bash
# Check if port 443 is listening
sudo ss -tulnp | grep :443
```

> ⚠️ `netstat -tulnp` is the legacy equivalent. It still works on older systems and may appear in interviews, but prefer `ss` on modern Linux.

---

## Web & API Testing

### `curl` — Transfer Data to/from a Server

`curl` is essential for testing HTTP APIs, checking response headers, and verifying service health.

```bash
# Test if a local service is responding
curl http://localhost:8080

# Fetch HTTP response headers only
curl -I https://example.com

# Send a POST request with JSON data
curl -X POST -H "Content-Type: application/json" \
  -d '{"key":"value"}' https://api.example.com/endpoint

# Test with verbose output (shows TLS handshake, headers)
curl -Iv https://api.example.com
```

### `wget` — Download Files

```bash
# Download a file to the current directory
wget https://example.com/installer.tar.gz
```

---

## Firewall Management

### `ufw` — Uncomplicated Firewall (Ubuntu/Debian)

```bash
ufw status              # Show firewall status and rules
ufw allow 80            # Allow HTTP traffic
ufw allow 443           # Allow HTTPS traffic
ufw deny 22             # Block SSH (be careful!)
ufw enable              # Activate the firewall
```

### `iptables` — Low-Level Firewall Rules

```bash
iptables -L             # List all current rules
iptables -L -n -v       # Verbose output with packet counts
```

> 💡 In cloud environments (AWS, GCP, Azure), you also need to check **Security Groups** and **VPC firewall rules** — traffic can be blocked at the cloud level before it even reaches your server's OS firewall.

---

## Important Networking Configuration Files

| File | Purpose |
| :--- | :--- |
| `/etc/hosts` | Local hostname-to-IP overrides (checked before DNS) |
| `/etc/resolv.conf` | DNS server configuration |
| `/etc/sysconfig/network-scripts/` | Interface configuration (RHEL/CentOS) |
| `/etc/netplan/` | Interface configuration (Ubuntu 18.04+) |

---

## DevOps Use Cases

### Diagnosing "Connection Refused" vs "Connection Timeout"

These two errors have very different root causes:

- **Connection Refused** — the packet reached the server but no process is listening on that port. Check with `ss -tulnp`.
- **Connection Timeout** — the packet never reached the server. A firewall (cloud security group, `ufw`, `iptables`) is silently dropping it. Check firewall rules.

### Verifying a Deployment

After deploying an application, verify it is healthy before marking the deployment successful:

```bash
# Check the service is listening
sudo ss -tulnp | grep :8080

# Check the health endpoint responds
curl -f http://localhost:8080/health && echo "OK"
```

---

## Best Practices

- Use `ip` instead of the deprecated `ifconfig`.
- Use `ss` instead of the deprecated `netstat`.
- Troubleshoot connectivity layer by layer: DNS → ping → port → firewall → application.
- In cloud environments, always check both the OS firewall and the cloud-level security group.
- Use `curl -I` to check HTTP headers before assuming an application is broken.

---

## Interview Q&A

**Q1: What is the modern replacement for `netstat` and why?**
- **Answer:** `ss` (socket statistics) is the modern replacement. It reads network information directly from kernel space via netlink sockets, making it significantly faster than `netstat`, which parsed `/proc/net/tcp` line-by-line. `ss` is also part of the `iproute2` package that ships with all modern Linux distributions.

**Q2: How do you verify if a specific port is listening on a remote server?**
- **Answer:** You can use `nc` (netcat): `nc -zv <IP> <port>`. The `-z` flag means scan without sending data, `-v` gives verbose output. You can also use `curl` for HTTP ports or `telnet <IP> <port>` for a basic TCP handshake test.

**Q3: What is the difference between a "connection refused" and a "connection timeout" error?**
- **Answer:** "Connection refused" means the packet arrived at the target host but no application is listening on that port — the OS actively rejected the connection. "Connection timeout" means the packet was sent but no response was received at all, typically because a firewall (like AWS Security Groups or `iptables`) is silently dropping the packets before they reach the application.

---

> 🔖 **Note:** Linux networking knowledge is mandatory for DevOps, Cloud, and SRE roles. These commands are used daily — from diagnosing CI/CD pipeline failures to debugging microservice connectivity in Kubernetes clusters.
