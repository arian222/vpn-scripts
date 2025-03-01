#!/bin/bash

# Culori
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

while true; do
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Statistici Sistem              ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"

    # CPU
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    echo -e "${CYAN}║${NC} CPU: ${cpu_usage}%"

    # RAM
    ram_total=$(free -m | awk 'NR==2 {print $2}')
    ram_used=$(free -m | awk 'NR==2 {print $3}')
    ram_percentage=$((ram_used * 100 / ram_total))
    echo -e "${CYAN}║${NC} RAM: ${ram_percentage}% (${ram_used}MB / ${ram_total}MB)"

    # Disk
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    echo -e "${CYAN}║${NC} Disk: ${disk_usage}%"

    # Conexiuni
    ssh_connections=$(netstat -tnpa | grep 'ESTABLISHED.*sshd' | wc -l)
    ssl_connections=$(netstat -tnpa | grep 'ESTABLISHED.*stunnel' | wc -l)
    echo -e "${CYAN}║${NC} Conexiuni SSH: ${ssh_connections}"
    echo -e "${CYAN}║${NC} Conexiuni SSL: ${ssl_connections}"

    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║         Utilizare Bandwidth            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"

    # Pentru fiecare utilizator activ
    for user in $(who | cut -d' ' -f1 | sort | uniq); do
        # Calculare bandwidth folosind iftop sau vnstat
        if command -v vnstat &> /dev/null; then
            rx_bytes=$(vnstat -h 1 | grep "rx" | tail -1 | awk '{print $2}')
            tx_bytes=$(vnstat -h 1 | grep "tx" | tail -1 | awk '{print $2}')
        else
            rx_bytes=$(iptables -nvx -L INPUT | grep "$user" | awk '{sum+=$2} END {print sum/1024/1024}')
            tx_bytes=$(iptables -nvx -L OUTPUT | grep "$user" | awk '{sum+=$2} END {print sum/1024/1024}')
        fi

        echo -e "${CYAN}║${NC} User: $user"
        echo -e "${CYAN}║${NC} Download: ${rx_bytes:-0} MB"
        echo -e "${CYAN}║${NC} Upload: ${tx_bytes:-0} MB"
        echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
    done

    # Tentative eșuate de autentificare
    failed_attempts=$(grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
    echo -e "${CYAN}║${NC} Tentative eșuate de autentificare: ${failed_attempts}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"

    echo -e "\nApăsați CTRL+C pentru a ieși..."
    sleep 2
done 