# 🔐 File Permissions & Ownership

## Purpose

Control access to files and directories for security and stability.

## Key Commands

* `chmod` – Change permissions
* `chown` – Change ownership
* `chgrp` – Change group
* `umask` – Default permission mask

## Permission Model

* Read (r), Write (w), Execute (x)
* User, Group, Others

## Examples

```bash
chmod 755 script.sh
chown appuser:appgroup app/
```

## DevOps Scenario

Fix permission issues during deployments or service failures.

## Interview Tip

Be ready to explain numeric vs symbolic permissions.
