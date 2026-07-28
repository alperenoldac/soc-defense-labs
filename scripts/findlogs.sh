#!/bin/bash

cat <<EOF
=================
Linux Log Finder
=================
EOF

if [ $# -eq 0 ]
then
	echo "Usage: ./findlogs.sh <logfile>"
	exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]
then
	echo "File not found!"
	exit 1
fi

echo ""
cat <<EOF
[+] Searching suspicious events...
EOF

echo ""
grep -iE "failed|error|denied|unauthorized|invalid" "$LOGFILE"

echo ""
echo "[+] Search completed."

