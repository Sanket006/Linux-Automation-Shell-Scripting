#!/bin/bash
# User Audit Script
# Lists users with UID >= 1000

echo "Regular Users on System:"
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
