#!/bin/bash

LOG_FILE="var/log/cowrie/cowrie.log"
OUTPUT_LOG="attackers_info.log"
SEEN_IPS=()

echo "[*] Monitoring $LOG_FILE for new attackers..."
echo "[*] Output will be saved in $OUTPUT_LOG"

tail -F "$LOG_FILE" | while read -r line; do
    if echo "$line" | grep -q "login attempt"; then
        # Extract IP address from the log line
        IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
        
        if [[ -n "$IP" && ! " ${SEEN_IPS[*]} " =~ " $IP " ]]; then
            SEEN_IPS+=("$IP")
            TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
            echo "[+] Detected new attacker IP: $IP at $TIMESTAMP"
            echo "$TIMESTAMP - $IP" >> "$OUTPUT_LOG"
        fi
    fi
done

