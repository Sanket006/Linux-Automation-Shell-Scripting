# 🌐 Networking Commands

## 📌 Purpose
Networking commands are essential for configuring, managing, and debugging network connectivity on Linux servers. DevOps engineers spend a significant amount of time troubleshooting communication between services, verifying open ports, resolving DNS issues, and verifying firewall rules.

---

## ⚙️ Core Concepts & Commands

| Command | Description | Common Flags / Usage | DevOps Use Case |
| :--- | :--- | :--- | :--- |
| `ip` | Show / manipulate routing and network devices | `ip addr show` or `ip route` | Finding server IP addresses and checking routing tables. |
| `ss` | Utility to dump socket statistics (replaces netstat) | `ss -tulnp` | Checking which services are listening on which ports. |
| `ping` | Send ICMP ECHO_REQUEST to network hosts | `ping -c 4 <host>` | Verifying network connectivity to remote endpoints. |
| `curl` | Transfer data from or to a server | `curl -Iv https://example.com` | Testing APIs and checking HTTP header responses. |
| `wget` | Non-interactive network downloader | `wget <URL>` | Downloading installation packages or scripts. |
| `nslookup` | Query Internet name servers interactively | `nslookup <domain>` | Debugging DNS resolution and looking up IP mappings. |

---

## 💻 Practical Examples

### 1. Finding Listening Ports and Associated PIDs
Verify if your web service (e.g., Nginx, Node) is running and listening on port 80/443.
```bash
sudo ss -tulnp
```
*   **Explanation:**
    *   `-t`: Displays TCP sockets.
    *   `-u`: Displays UDP sockets.
    *   `-l`: Shows only listening sockets.
    *   `-n`: Shows numerical port numbers instead of service names (e.g., `80` instead of `http`).
    *   `-p`: Shows the process ID (PID) and name of the program owning the socket (requires `sudo` or `root`).

### 2. Troubleshooting DNS Issues
Verify if a server can resolve the address of an external database endpoint.
```bash
nslookup database.internal.net
```
*   **Explanation:** Queries the DNS servers defined in `/etc/resolv.conf` to check if the hostname resolves to an IP address.

### 3. Checking API Headers and Latency
Perform an HTTP request, outputting only headers to inspect redirects and TLS handshakes.
```bash
curl -Iv https://api.github.com
```
*   **Explanation:**
    *   `-I`: Fetches HTTP headers only (using HEAD request).
    *   `-v`: Verbose output, showing IP address, port connected to, SSL/TLS handshake, and full request/response headers.

---

## 🛠️ DevOps Use Cases & Scenarios

### Diagnosing "Connection Refused" vs "Connection Timeout"
- **Connection Refused:** Typically means the packet reached the target host, but no service is listening on that port, or a firewall actively rejected it.
  * *Troubleshooting:* Run `ss -tulnp` on the target server to check if the service is running.
- **Connection Timeout:** Means the packet was sent but no response was received. This is almost always caused by a firewall (like AWS Security Groups, iptables, or ufw) dropping packets.
  * *Troubleshooting:* Verify security groups, routes, and firewall rules:
    ```bash
    # Test connection to port 443
    curl -m 5 https://remote-service.com:443
    ```

---

## 💡 Interview Q&A & Tips

**Q1: What is the modern replacement for `netstat` and why is it preferred?**
*   **Answer:** `ss` is the modern replacement. It is faster and more efficient than `netstat` because it retrieves TCP statistics directly from kernel space (via netlink sockets) instead of parsing `/proc/net/tcp` line-by-line.

**Q2: How do you verify if a specific port is listening on a remote server?**
*   **Answer:** You can use tools like `nc` (netcat), `telnet`, or `curl`. For example: `nc -zv <IP> <port>` or `telnet <IP> <port>`.
