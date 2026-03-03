#!/bin/bash

set -e

read -p "How much MB to clean from journal logs? (default 500) " MBY
MBY=${MBY:-500}

echo "=== Disk usage before cleanup ==="
df -h /

echo "=== Cleaning journal logs ($MBY MB) ==="
sudo journalctl --vacuum-size=${MBY}M

echo "=== Cleaning package cache and autoremove ==="
sudo apt clean
sudo apt autoremove -y

echo "=== Cleaning old .gz archives older than 2 months ==="
sudo find /var/log -type f -name "*.gz" -mtime +60 -delete

echo "=== Cleaning tmp files older than 7 days ==="
sudo find /tmp -type f -atime +7 -delete
sudo find /var/tmp -type f -atime +7 -delete

echo "=== Disk usage after cleanup ==="
df -h /

echo "=== Done! ==="
echo "----------------------------------------------------------"
echo "REMEMBER to manually type: history -c"
echo "----------------------------------------------------------"
echo "You must do this to prevent bash history living in memory!"

# Cleaning BASH history
> ~/.bash_history
for f in ~/.bash_history-*.tmp; do > "$f"; done

