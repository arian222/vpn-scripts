#!/bin/bash

# Instalare dependențe pentru monitorizare
apt-get update
apt-get install -y vnstat iftop net-tools sysstat

# Configurare vnstat
vnstat -u -i $(ip route | grep default | awk '{print $5}')
systemctl enable vnstat
systemctl start vnstat

# Configurare iptables pentru monitorizare bandwidth
iptables -N BANDWIDTH >/dev/null 2>&1
iptables -F BANDWIDTH
iptables -A BANDWIDTH -p tcp
iptables -A INPUT -j BANDWIDTH
iptables -A OUTPUT -j BANDWIDTH

# Salvare reguli iptables
iptables-save > /etc/iptables.ruless
# Creare script pentru restaurare reguli la boot
cat > /etc/network/if-pre-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.rules
EOF

chmod +x /etc/network/if-pre-up.d/iptables
chmod +x /root/monitor_system.sh

echo "Instalare completă. Rulați ./monitor_system.sh pentru a începe monitorizarea." 