#!/bin/bash


DATE=$(date)
HOSTNAME=$(hostname)

echo "========================================"
echo "     LINUX SYSTEM USER AUDIT REPORT     "
echo "========================================"
echo "Date: $DATE"
echo "Hostname: $HOSTNAME"
echo "----------------------------------------"

echo ""
echo "[+] 1. Root-Privileged Accounts (UID 0)"
awk -F: '$3 == 0 {print $0}' /etc/passwd

echo ""
echo "[+] 2. Standard Users (UID >= 1000)"
awk -F: '$3 >= 1000 && $1 != "nobody" {print $1 " (UID: " $3 ") - Shell: " $7}' /etc/passwd

echo ""
echo "[+] 3. Users with Active Shell Access"
grep -E '(/bin/bash|/bin/sh|/bin/zsh)$' /etc/passwd | awk -F: '{print $1 " (" $7 ")"}'

echo ""
echo "[+] 4. Sudo/Admin Group Members"
SUDO_USERS=$(grep -E '^sudo:|^wheel:' /etc/group | cut -d: -f4)
if [ -n "$SUDO_USERS" ]; then
	echo "sudo group members: $SUDO_USERS"
else
	echo "No users found in sudo/wheel groups."
fi


echo ""
echo "[+] 5. Empty Password Check (/etc/shadow)"
if [ "$EUID" -ne 0 ]; then
	echo "STATUS: UNKNOWN - Please run the script as root (sudo) to read /etc/shadow."
else

	EMPTY_PASS=$(awk -F: '$2 == ""' /etc/shadow | wc -l)
	if [ "$EMPTY_PASS" -eq 0 ]; then
	 	echo "STATUS: SECURE - No accounts with empty passwords detected."
	else
		echo "STATUS: WARNING - Found accounts without passwords!"
		awk -F: '$2 == "" {print "- " $1}' /etc/shadow
	fi
fi


echo ""
echo "[+] 6. Recent Logins (Last 3)"
last -w -n 3 | grep -v '^$' | grep -v 'wtmp begins'

echo ""
echo "[+] 7. Potential Privilege Escalation Vectors (SUID Binaries)"
echo "Scanning for SUID binaries (Top 3)..."
find / -type f -perm -4000 2>/dev/null | head -n 3

echo ""
echo "======================================="
echo "[i] Audit Completed Successfully."
echo "======================================="
