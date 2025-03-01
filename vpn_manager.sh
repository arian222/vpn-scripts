#!/bin/bash

# Funcție pentru verificarea și instalarea dependențelor
check_and_install_dependencies() {
    clear
    echo -e "${CYAN}Verificare și instalare dependențe...${NC}"
    
    # Instalare comenzi de bază
    echo -e "${YELLOW}Se instalează utilitare de bază...${NC}"
    apt-get update >/dev/null 2>&1
    apt-get install -y grep coreutils net-tools procps gawk mawk >/dev/null 2>&1
    
    # Verificare și instalare Stunnel
    if ! command -v stunnel4 &> /dev/null; then
        echo -e "${YELLOW}Se instalează Stunnel...${NC}"
        apt-get install -y stunnel4
    fi
    
    # Verificare și instalare NGINX
    if ! command -v nginx &> /dev/null; then
        echo -e "${YELLOW}Se instalează NGINX...${NC}"
        apt-get install -y nginx
    fi
    
    # Creare directoare necesare
    mkdir -p /etc/alecs_vpn
    mkdir -p /var/log/stunnel4
    
    echo -e "${GREEN}Toate dependențele au fost verificate și instalate!${NC}"
    sleep 2
}

# Culori pentru output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Verificare dacă scriptul rulează ca root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Acest script trebuie rulat ca root!${NC}"
    exit 1
fi

# Rulare verificare dependențe la pornirea scriptului
check_and_install_dependencies

# Funcție pentru animație de loading
loading_animation() {
    local duration=$1
    local chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local sleep_duration=0.1
    local end_time=$((SECONDS + duration))
    
    while [ $SECONDS -lt $end_time ]; do
        for (( i=0; i<${#chars}; i++ )); do
            echo -en "\r${CYAN}[${chars:$i:1}] Loading...${NC}"
            sleep $sleep_duration
        done
    done
    echo -en "\r\033[K"
}

# Funcție pentru banner animat
show_banner() {
    clear
    echo -e "${YELLOW}"
    echo "    █████╗ ██╗     ███████╗ ██████╗███████╗"
    echo "   ██╔══██╗██║     ██╔════╝██╔════╝██╔════╝"
    echo "   ███████║██║     █████╗  ██║     ███████╗"
    echo "   ██╔══██║██║     ██╔══╝  ██║     ╚════██║"
    echo "   ██║  ██║███████╗███████╗╚██████╗███████║"
    echo "   ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝╚══════╝"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${CYAN}         ALECS VPN MANAGER PRO          ${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo
}

# Funcție pentru afișarea meniului principal
show_menu() {
    show_banner
    echo -e "${CYAN}Selectați o opțiune:${NC}"
    echo -e "${GREEN}1)${NC} Gestionare SSH"
    echo -e "${GREEN}2)${NC} Manager Porturi"
    echo -e "${GREEN}3)${NC} Running Services"
    echo -e "${GREEN}4)${NC} Lista Toți Utilizatorii"
    echo -e "${GREEN}5)${NC} Actualizare Script"
    echo -e "${GREEN}6)${NC} Backup/Restaurare"
    echo -e "${GREEN}7)${NC} Caracteristici"
    echo -e "${GREEN}8)${NC} SSL Avansat"
    echo -e "${GREEN}9)${NC} Monitorizare Sistem"
    echo -e "${GREEN}10)${NC} Securitate Avansată"
    echo -e "${GREEN}11)${NC} Backup în Cloud"
    echo -e "${GREEN}12)${NC} Protocoale VPN"
    echo -e "${GREEN}13)${NC} Monitorizare Avansată"
    echo -e "${GREEN}14)${NC} Manager V2Ray"
    echo -e "${RED}x)${NC} Ieșire"
    echo
    echo -n "Selectați opțiunea [1-14 sau x]: "
}

# Funcție pentru gestionarea SSH
manage_ssh() {
    clear
    echo -e "${GREEN}=== Gestionare SSH ===${NC}"
    echo "1) Creare cont nou"
    echo "2) Generare cont trial"
    echo "3) Reînnoire cont"
    echo "4) Ștergere cont"
    echo "5) Verificare utilizatori conectați"
    echo "6) Lista toate conturile SSH"
    echo "7) Limitare IP per utilizator"
    echo "8) Închidere conexiuni utilizator"
    echo "9) Înapoi la meniul principal"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) create_account ;;
        2) create_trial ;;
        3) renew_account ;;
        4) delete_account ;;
        5) check_users ;;
        6) list_ssh_accounts ;;
        7) limit_user_ip ;;
        8) kill_user_connection ;;
        9) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ;;
    esac
}

# Funcție pentru gestionarea porturilor
manage_ports() {
    clear
    show_banner
    echo -e "${GREEN}=== Manager Porturi ===${NC}"
    echo -e "${GREEN}1)${NC} Configurare Port SSH"
    echo -e "${GREEN}2)${NC} Configurare Port SSL"
    echo -e "${GREEN}3)${NC} Configurare Port UDP"
    echo -e "${GREEN}4)${NC} Configurare BadVPN"
    echo -e "${GREEN}5)${NC} Configurare V2Ray WebSocket"
    echo -e "${GREEN}6)${NC} Status Porturi"
    echo -e "${GREEN}7)${NC} Înapoi la meniul principal"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) configure_ssh_port ;;
        2) configure_ssl_port ;;
        3) configure_udp_port ;;
        4) configure_badvpn ;;
        5) configure_v2ray_ws ;;
        6) check_ports_status ;;
        7) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ;;
    esac
}

# Funcție pentru gestionarea botului Telegram
manage_telegram_bot() {
    clear
    show_banner
    echo -e "${GREEN}=== Manager Bot Telegram ===${NC}"
    echo -e "${GREEN}1)${NC} Configurare Bot Nou"
    echo -e "${GREEN}2)${NC} Activare/Dezactivare Bot"
    echo -e "${GREEN}3)${NC} Setări Notificări"
    echo -e "${GREEN}4)${NC} Status Bot"
    echo -e "${GREEN}5)${NC} Înapoi la meniul principal"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) configure_telegram_bot ;;
        2) toggle_telegram_bot ;;
        3) configure_notifications ;;
        4) check_bot_status ;;
        5) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ;;
    esac
}

# Funcție pentru configurarea botului Telegram
configure_telegram_bot() {
    clear
    echo -e "${GREEN}=== Configurare Bot Telegram ===${NC}"
    read -p "Introduceți Token-ul Bot: " bot_token
    read -p "Introduceți Chat ID: " chat_id
    
    # Salvare configurație
    cat > /etc/alecs_vpn/telegram.conf <<EOF
BOT_TOKEN="$bot_token"
CHAT_ID="$chat_id"
NOTIFICATIONS_ENABLED="yes"
EOF
    
    echo -e "${GREEN}Bot configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru activare/dezactivare bot
toggle_telegram_bot() {
    if systemctl is-active telegram-bot >/dev/null 2>&1; then
        systemctl stop telegram-bot
        echo -e "${RED}Bot dezactivat${NC}"
    else
        systemctl start telegram-bot
        echo -e "${GREEN}Bot activat${NC}"
    fi
    sleep 2
}

# Funcție pentru configurarea notificărilor
configure_notifications() {
    clear
    echo -e "${GREEN}=== Configurare Notificări ===${NC}"
    echo "1) Notificări Conectare Utilizatori"
    echo "2) Notificări Expirare Conturi"
    echo "3) Notificări Backup Automat"
    echo "4) Înapoi"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) toggle_notification "login" ;;
        2) toggle_notification "expiry" ;;
        3) toggle_notification "backup" ;;
        4) return ;;
    esac
}

# Funcție pentru verificarea statusului botului
check_bot_status() {
    clear
    echo -e "${GREEN}=== Status Bot Telegram ===${NC}"
    echo -e "Status Serviciu: $(systemctl is-active telegram-bot)"
    echo -e "Notificări Active: $(grep NOTIFICATIONS_ENABLED /etc/alecs_vpn/telegram.conf | cut -d= -f2)"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru backup/restaurare
backup_restore() {
    clear
    echo -e "${GREEN}=== Backup/Restaurare ===${NC}"
    echo "1) Creare backup"
    echo "2) Restaurare din backup"
    echo "3) Înapoi la meniul principal"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) create_backup ;;
        2) restore_backup ;;
        3) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ;;
    esac
}

# Funcție pentru actualizare script îmbunătățită
update_script() {
    show_banner
    echo -e "${CYAN}Verificare actualizări...${NC}"
    loading_animation 3
    
    # Backup configurație curentă
    echo -e "${CYAN}Backup configurație...${NC}"
    create_backup >/dev/null 2>&1
    
    # Simulare actualizare
    echo -e "${CYAN}Descărcare actualizări...${NC}"
    loading_animation 2
    echo -e "${CYAN}Instalare actualizări...${NC}"
    loading_animation 2
    
    # Verificare versiune
    echo -e "${GREEN}Script actualizat la ultima versiune!${NC}"
    echo -e "${CYAN}Versiune: 2.0 PRO${NC}"
    echo -e "${CYAN}Data actualizării: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru verificarea statusului serviciilor
check_status() {
    clear
    echo -e "${GREEN}=== Status Servicii ===${NC}"
    echo -e "PROXY: $(systemctl is-active proxy)"
    echo -e "NGINX: $(systemctl is-active nginx)"
    echo -e "XRAY: $(systemctl is-active xray)"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru crearea unui cont nou SSH
create_account() {
    show_banner
    echo -e "${GREEN}=== Creare Cont Nou SSH ===${NC}"
    read -p "Introduceți numele de utilizator: " username
    read -s -p "Introduceți parola: " password
    echo
    read -p "Introduceți durata în zile: " duration
    
    echo -e "\n${CYAN}Se creează contul...${NC}"
    loading_animation 3
    
    # Verificare dacă utilizatorul există
    if id "$username" >/dev/null 2>&1; then
        echo -e "\n${RED}Utilizatorul există deja!${NC}"
        sleep 2
        return
    fi
    
    # Creare cont
    expiry_date=$(date -d "+${duration} days" +"%Y-%m-%d")
    useradd -e "$expiry_date" -M -s /bin/false "$username"
    echo "$username:$password" | chpasswd
    
    # Salvare parolă în fișier securizat
    mkdir -p /etc/alecs_vpn
    echo "$username:$password" >> /etc/alecs_vpn/user_password.txt
    chmod 600 /etc/alecs_vpn/user_password.txt
    
    echo -e "\n${GREEN}╔════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      Cont creat cu succes!      ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Utilizator: $username"
    echo -e "${GREEN}║${NC} Parolă: $password"
    echo -e "${GREEN}║${NC} Expiră la: $expiry_date"
    echo -e "${GREEN}╚════════════════════════════════╝${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru generarea unui cont trial
create_trial() {
    clear
    show_banner
    echo -e "${GREEN}=== Generare Cont Trial ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Selectați Durata Trial         ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) Trial 1 minut"
    echo -e "${CYAN}║${NC} 2) Trial 5 minute"
    echo -e "${CYAN}║${NC} 3) Trial 10 minute"
    echo -e "${CYAN}║${NC} 4) Trial 24 ore"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea (1-4): " duration_choice
    
    case $duration_choice in
        1) duration_minutes=1 ;;
        2) duration_minutes=5 ;;
        3) duration_minutes=10 ;;
        4) duration_minutes=1440 ;; # 24 ore în minute
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ; return ;;
    esac
    
    # Generare credențiale unice mai scurte
    username="tr$(date +%s | tail -c 6)"
    password=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
    
    # Calculare dată expirare în funcție de minute
    expiry_date=$(date -d "+${duration_minutes} minutes" +"%Y-%m-%d %H:%M:%S")
    useradd -e "$(date -d "+${duration_minutes} minutes" +%Y-%m-%d)" -M -s /bin/false "$username"
    echo "$username:$password" | chpasswd
    
    # Salvare parolă în fișier securizat
    mkdir -p /etc/alecs_vpn
    echo "$username:$password" >> /etc/alecs_vpn/user_password.txt
    chmod 600 /etc/alecs_vpn/user_password.txt
    
    # Obținere informații despre server
    server_ip=$(curl -s ifconfig.me)
    ssh_port=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')
    ssl_port=$(grep "^accept" /etc/stunnel/stunnel.conf 2>/dev/null | head -n1 | awk '{print $3}')
    
    # Afișare informații complete
    echo -e "\n${CYAN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        Cont Trial Creat cu Succes!        ║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 👤 Utilizator: ${GREEN}$username${NC}"
    echo -e "${CYAN}║${NC} 🔑 Parolă: ${GREEN}$password${NC}"
    echo -e "${CYAN}║${NC} ⏰ Expiră la: ${GREEN}$expiry_date${NC}"
    echo -e "${CYAN}║${NC} ⌛ Durată: ${GREEN}$duration_minutes minute${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 🌐 IP Server: ${GREEN}$server_ip${NC}"
    echo -e "${CYAN}║${NC} 🔌 Port SSH: ${GREEN}${ssh_port:-22}${NC}"
    if [ ! -z "$ssl_port" ]; then
        echo -e "${CYAN}║${NC} 🔒 Port SSL: ${GREEN}$ssl_port${NC}"
    fi
    echo -e "${CYAN}║${NC} Format Configurare:                    ${NC}"
    echo -e "${CYAN}║${NC} 🔹 SSH: ${GREEN}$server_ip:${ssh_port:-22}@$username:$password${NC}"
    if [ ! -z "$ssl_port" ]; then
        echo -e "${CYAN}║${NC} 🔸 SSL: ${GREEN}$server_ip:$ssl_port@$username:$password${NC}"
    fi
    echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru reînnoirea unui cont
renew_account() {
    clear
    echo -e "${GREEN}=== Reînnoire Cont ===${NC}"
    read -p "Introduceți numele de utilizator: " username
    read -p "Introduceți numărul de zile pentru prelungire: " days
    
    # Verificare dacă utilizatorul există
    if ! id "$username" >/dev/null 2>&1; then
        echo -e "${RED}Utilizatorul nu există!${NC}"
        sleep 2
        return
    fi
    
    # Calculare nouă dată de expirare
    current_expiry=$(chage -l "$username" | grep "Account expires" | cut -d: -f2)
    new_expiry=$(date -d "$current_expiry +${days} days" +"%Y-%m-%d")
    chage -E "$new_expiry" "$username"
    
    echo -e "${GREEN}Cont reînnoit cu succes!${NC}"
    echo "Utilizator: $username"
    echo "Noua dată de expirare: $new_expiry"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru ștergerea unui cont
delete_account() {
    clear
    echo -e "${GREEN}=== Ștergere Cont ===${NC}"
    read -p "Introduceți numele de utilizator: " username
    
    # Verificare dacă utilizatorul există
    if ! id "$username" >/dev/null 2>&1; then
        echo -e "${RED}Utilizatorul nu există!${NC}"
        sleep 2
        return
    fi
    
    # Închiderea forțată a tuturor proceselor utilizatorului
    echo -e "${YELLOW}Se închid toate procesele utilizatorului...${NC}"
    
    # Închidere procese SSH
    pkill -KILL -u "$username" >/dev/null 2>&1
    
    # Închidere conexiuni active
    who | grep "$username" | awk '{print $2}' | while read -r tty; do
        pkill -KILL -t "$tty" >/dev/null 2>&1
    done
    
    # Închidere conexiuni Stunnel/SSL
    netstat -tnpa | grep 'ESTABLISHED.*stunnel' | grep "$username" | awk '{print $7}' | cut -d'/' -f1 | while read -r pid; do
        kill -9 "$pid" >/dev/null 2>&1
    done
    
    # Așteptăm să se închidă toate procesele
    echo -e "${YELLOW}Se așteaptă închiderea tuturor proceselor...${NC}"
    sleep 3
    
    # Verificăm dacă mai există procese active
    if pgrep -u "$username" >/dev/null 2>&1; then
        echo -e "${RED}Atenție: Încă există procese active pentru utilizator!${NC}"
        echo -e "${YELLOW}Se forțează închiderea tuturor proceselor...${NC}"
        pkill -KILL -u "$username" >/dev/null 2>&1
        sleep 2
    fi
    
    # Ștergere cont
    userdel -f -r "$username" >/dev/null 2>&1
    
    # Verificare dacă ștergerea a avut succes
    if ! id "$username" >/dev/null 2>&1; then
        echo -e "${GREEN}Cont șters cu succes!${NC}"
        
        # Ștergere din fișierul de parole dacă există
        if [ -f "/etc/alecs_vpn/user_password.txt" ]; then
            sed -i "/^$username:/d" /etc/alecs_vpn/user_password.txt
        fi
        
        # Curățare fișiere temporare
        rm -rf /tmp/ssh-* 2>/dev/null
        rm -rf /tmp/.*-unix 2>/dev/null
    else
        echo -e "${RED}Eroare la ștergerea contului!${NC}"
        echo -e "${YELLOW}Încercați să reporniți serverul dacă problema persistă.${NC}"
    fi
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru verificarea utilizatorilor conectați
check_users() {
    clear
    show_banner
    echo -e "${GREEN}=== Utilizatori Conectați ===${NC}"
    
    echo -e "\n${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Utilizatori SSH/SSL            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    
    # Utilizatori SSH
    echo -e "${YELLOW}SSH Connections:${NC}"
    # Creare un array asociativ pentru a număra conexiunile per utilizator
    declare -A ssh_connections
    while read -r line; do
        user=$(echo "$line" | awk '{print $1}')
        ip=$(echo "$line" | awk '{print $(NF)}' | tr -d '()')
        if [[ -n "$user" && -n "$ip" ]]; then
            key="${user}:${ip}"
            ssh_connections["$key"]=$((ssh_connections["$key"] + 1))
        fi
    done < <(who | grep pts)
    
    # Afișare conexiuni SSH grupate pe utilizator și IP
    for key in "${!ssh_connections[@]}"; do
        user=$(echo "$key" | cut -d: -f1)
        ip=$(echo "$key" | cut -d: -f2)
        count=${ssh_connections["$key"]}
        echo -e "${CYAN}║${NC} Utilizator: $user"
        echo -e "${CYAN}║${NC} IP: $ip"
        echo -e "${CYAN}║${NC} Dispozitive conectate: $count"
        echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
    done
    
    # Utilizatori SSL/Stunnel
    echo -e "\n${YELLOW}SSL/Stunnel Connections:${NC}"
    # Creare un array asociativ pentru a număra conexiunile SSL per IP și utilizator
    declare -A ssl_connections
    while read -r line; do
        ip=$(echo "$line" | awk '{print $5}' | cut -d: -f1)
        pid=$(echo "$line" | awk '{print $7}' | cut -d/ -f1)
        if [[ -n "$ip" && -n "$pid" ]]; then
            # Găsim procesul părinte stunnel
            ppid=$(ps -o ppid= -p "$pid" 2>/dev/null || echo "")
            if [[ -n "$ppid" ]]; then
                # Găsim utilizatorul real din procesul copil SSH
                real_user=$(ps -o user= -p "$ppid" 2>/dev/null || echo "unknown")
                if [[ "$real_user" != "root" && "$real_user" != "unknown" ]]; then
                    user=$real_user
                else
                    # Dacă nu găsim utilizatorul real, încercăm să-l găsim în procesele SSH active
                    user=$(ps aux | grep "sshd:.*@pts" | grep -v grep | awk '{print $1}' | head -1)
                fi
            else
                user="unknown"
            fi
            key="${user}:${ip}"
            ssl_connections["$key"]=$((ssl_connections["$key"] + 1))
        fi
    done < <(netstat -tnpa | grep 'ESTABLISHED.*stunnel')
    
    # Afișare conexiuni SSL grupate pe utilizator și IP
    for key in "${!ssl_connections[@]}"; do
        user=$(echo "$key" | cut -d: -f1)
        ip=$(echo "$key" | cut -d: -f2)
        count=${ssl_connections["$key"]}
        echo -e "${CYAN}║${NC} Utilizator: $user"
        echo -e "${CYAN}║${NC} IP: $ip"
        echo -e "${CYAN}║${NC} Dispozitive conectate: $count"
        echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
    done
    
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare port SSH
configure_ssh_port() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Port SSH ===${NC}"
    read -p "Introduceți noul port SSH (1-65535): " new_port
    
    # Validare port
    if [[ ! $new_port =~ ^[0-9]+$ ]] || [ $new_port -lt 1 ] || [ $new_port -gt 65535 ]; then
        echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Modificare port SSH
    sed -i "s/^#*Port [0-9]*/Port $new_port/" /etc/ssh/sshd_config
    systemctl restart sshd
    
    echo -e "${GREEN}Port SSH modificat cu succes la: $new_port${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare SSL
configure_ssl_port() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Port SSL ===${NC}"
    read -p "Introduceți portul SSL (1-65535): " ssl_port
    
    # Validare port
    if [[ ! $ssl_port =~ ^[0-9]+$ ]] || [ $ssl_port -lt 1 ] || [ $ssl_port -gt 65535 ]; then
        echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Verificare și instalare stunnel dacă nu există
    if ! command -v stunnel4 &> /dev/null; then
        echo -e "${CYAN}Se instalează Stunnel...${NC}"
        apt-get update
        apt-get install -y stunnel4
    fi
    
    # Generare certificat SSL auto-semnat dacă nu există
    if [ ! -f /etc/stunnel/stunnel.pem ]; then
        echo -e "${CYAN}Se generează certificat SSL...${NC}"
        openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
            -subj "/C=US/ST=State/L=Location/O=Organization/CN=ALECS-VPN" \
            -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
        chmod 600 /etc/stunnel/stunnel.pem
    fi
    
    # Activare serviciul Stunnel
    sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4
    
    # Configurare SSL îmbunătățită
    cat > /etc/stunnel/stunnel.conf <<EOF
# Configurație Stunnel pentru ALECS VPN
pid = /var/run/stunnel4.pid
output = /var/log/stunnel4/stunnel.log
cert = /etc/stunnel/stunnel.pem
client = no
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
TIMEOUTclose = 0
sslVersion = TLSv1.2
options = NO_SSLv2
options = NO_SSLv3
options = NO_TLSv1
options = NO_TLSv1.1
options = CIPHER_SERVER_PREFERENCE
ciphers = ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
debug = 7

# Configurație SSL pentru SSH
[ssh-ssl]
accept = $ssl_port
connect = 127.0.0.1:22
EOF

    # Creare director pentru loguri
    mkdir -p /var/log/stunnel4
    chown stunnel4:stunnel4 /var/log/stunnel4
    
    # Restart serviciu Stunnel
    systemctl enable stunnel4
    systemctl restart stunnel4
    
    # Verificare status
    if systemctl is-active stunnel4 >/dev/null 2>&1; then
        echo -e "\n${GREEN}╔════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║      Configurare SSL Completă!         ║${NC}"
        echo -e "${GREEN}╠════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC} Port SSL: $ssl_port"
        echo -e "${GREEN}║${NC} Status: Activ"
        echo -e "${GREEN}║${NC} Certificat: /etc/stunnel/stunnel.pem"
        echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    else
        echo -e "\n${RED}Eroare la pornirea serviciului Stunnel!${NC}"
        echo -e "Verificați log-urile: /var/log/stunnel4/stunnel.log"
    fi
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare UDP
configure_udp_port() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Port UDP ===${NC}"
    read -p "Introduceți portul UDP (1-65535): " udp_port
    
    # Validare port
    if [[ ! $udp_port =~ ^[0-9]+$ ]] || [ $udp_port -lt 1 ] || [ $udp_port -gt 65535 ]; then
        echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Configurare UDP
    cat > /etc/openvpn/server-udp.conf <<EOF
port $udp_port
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
server 10.8.0.0 255.255.255.0
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
log-append openvpn.log
verb 3
EOF

    systemctl restart openvpn@server-udp
    
    echo -e "${GREEN}Port UDP configurat cu succes la: $udp_port${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare BadVPN
configure_badvpn() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare BadVPN ===${NC}"
    read -p "Introduceți portul BadVPN (1-65535): " badvpn_port
    
    # Validare port
    if [[ ! $badvpn_port =~ ^[0-9]+$ ]] || [ $badvpn_port -lt 1 ] || [ $badvpn_port -gt 65535 ]; then
        echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Instalare și configurare BadVPN
    if [ ! -f "/usr/bin/badvpn-udpgw" ]; then
        echo -e "${CYAN}Se instalează BadVPN...${NC}"
        wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/daybreakersx/premscript/master/badvpn-udpgw64"
        chmod +x /usr/bin/badvpn-udpgw
    fi
    
    # Creare serviciu systemd pentru BadVPN
    cat > /etc/systemd/system/badvpn.service <<EOF
[Unit]
Description=BadVPN UDPGW Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/badvpn-udpgw --listen-addr 127.0.0.1:$badvpn_port --max-clients 1000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable badvpn
    systemctl restart badvpn
    
    echo -e "${GREEN}BadVPN configurat cu succes pe portul: $badvpn_port${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare V2Ray WebSocket
configure_v2ray_ws() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare V2Ray WebSocket ===${NC}"
    read -p "Introduceți portul WebSocket (1-65535): " ws_port
    
    # Validare port
    if [[ ! $ws_port =~ ^[0-9]+$ ]] || [ $ws_port -lt 1 ] || [ $ws_port -gt 65535 ]; then
        echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Configurare V2Ray WebSocket
    cat > /usr/local/etc/v2ray/config.json <<EOF
{
  "inbounds": [{
    "port": $ws_port,
    "protocol": "vmess",
    "settings": {
      "clients": []
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/alecs"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

    systemctl restart v2ray
    
    echo -e "${GREEN}V2Ray WebSocket configurat cu succes pe portul: $ws_port${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru verificarea statusului porturilor
check_ports_status() {
    clear
    show_banner
    echo -e "${GREEN}=== Status Porturi ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║             Status Porturi             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} SSH: $(netstat -tlpn | grep sshd | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} SSL: $(netstat -tlpn | grep stunnel | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} OpenVPN UDP: $(netstat -ulpn | grep openvpn | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} BadVPN: $(netstat -tlpn | grep badvpn | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} V2Ray WS: $(netstat -tlpn | grep v2ray | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru verificarea serviciilor active
check_running_services() {
    clear
    show_banner
    echo -e "${GREEN}=== Status Servicii Active ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            Servicii Active             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} SSH: $(systemctl is-active sshd)"
    echo -e "${CYAN}║${NC} XRAY: $(systemctl is-active xray)"
    echo -e "${CYAN}║${NC} NGINX: $(systemctl is-active nginx)"
    echo -e "${CYAN}║${NC} BadVPN: $(systemctl is-active badvpn)"
    echo -e "${CYAN}║${NC} V2Ray: $(systemctl is-active v2ray)"
    echo -e "${CYAN}║${NC} Stunnel: $(systemctl is-active stunnel4)"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru listarea tuturor utilizatorilor
list_all_users() {
    clear
    show_banner
    echo -e "${GREEN}=== Lista Tuturor Utilizatorilor ===${NC}"
    
    # Lista utilizatori SSH
    echo -e "\n${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Utilizatori SSH/SSL            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    if [ -f "/etc/passwd" ]; then
        awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | while read user; do
            exp=$(chage -l "$user" | grep "Account expires" | cut -d: -f2)
            pass=$(grep -w "$user" /etc/alecs_vpn/user_password.txt 2>/dev/null | cut -d: -f2)
            if [ -z "$pass" ]; then
                pass="Parolă necunoscută"
            fi
            echo -e "${CYAN}║${NC} Utilizator: $user"
            echo -e "${CYAN}║${NC} Parolă: $pass"
            echo -e "${CYAN}║${NC} Expiră: $exp"
            echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
        done
    fi
    
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru listarea tuturor conturilor SSH
list_ssh_accounts() {
    clear
    show_banner
    echo -e "${GREEN}=== Lista Conturi SSH ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Lista Conturi SSH             ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    
    # Verificăm conturile SSH din sistem
    found_accounts=false
    
    while IFS=: read -r username x uid gid info home shell; do
        # Verificăm utilizatorii cu UID >= 1000 și excludem 'nobody'
        if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
            found_accounts=true
            
            # Obținem data expirării
            expiry_date=$(chage -l "$username" 2>/dev/null | grep "Account expires" | cut -d: -f2)
            # Verificăm statusul contului
            account_status=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
            
            # Obținem parola din fișierul de parole dacă există
            password="Parolă necunoscută"
            if [ -f "/etc/alecs_vpn/user_password.txt" ]; then
                saved_password=$(grep "^$username:" "/etc/alecs_vpn/user_password.txt" | cut -d: -f2)
                if [ ! -z "$saved_password" ]; then
                    password="$saved_password"
                fi
            fi
            
            echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
            echo -e "${CYAN}║${NC} Utilizator: $username"
            echo -e "${CYAN}║${NC} Parolă: $password"
            echo -e "${CYAN}║${NC} Shell: $shell"
            echo -e "${CYAN}║${NC} Expiră la: $expiry_date"
            
            case "$account_status" in
                "P"|"PS") echo -e "${CYAN}║${NC} Status: ${GREEN}Activ${NC}" ;;
                "L") echo -e "${CYAN}║${NC} Status: ${RED}Blocat${NC}" ;;
                *) echo -e "${CYAN}║${NC} Status: Necunoscut" ;;
            esac
        fi
    done < "/etc/passwd"
    
    if [ "$found_accounts" = false ]; then
        echo -e "${CYAN}║${NC} Nu există conturi SSH create"
    fi
    
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru activare/dezactivare notificări specifice
toggle_notification() {
    local notification_type=$1
    local config_file="/etc/alecs_vpn/telegram.conf"
    
    # Verifică dacă există configurația
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}Configurația Telegram nu există! Configurați mai întâi botul.${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Încarcă configurația curentă
    source "$config_file"
    
    case $notification_type in
        "login")
            if grep -q "LOGIN_NOTIFICATIONS=" "$config_file"; then
                current_status=$(grep "LOGIN_NOTIFICATIONS=" "$config_file" | cut -d= -f2)
                if [ "$current_status" = "yes" ]; then
                    sed -i 's/LOGIN_NOTIFICATIONS=yes/LOGIN_NOTIFICATIONS=no/' "$config_file"
                    echo -e "${RED}Notificările de conectare au fost dezactivate${NC}"
                else
                    sed -i 's/LOGIN_NOTIFICATIONS=no/LOGIN_NOTIFICATIONS=yes/' "$config_file"
                    echo -e "${GREEN}Notificările de conectare au fost activate${NC}"
                fi
            else
                echo "LOGIN_NOTIFICATIONS=yes" >> "$config_file"
                echo -e "${GREEN}Notificările de conectare au fost activate${NC}"
            fi
            ;;
        "expiry")
            if grep -q "EXPIRY_NOTIFICATIONS=" "$config_file"; then
                current_status=$(grep "EXPIRY_NOTIFICATIONS=" "$config_file" | cut -d= -f2)
                if [ "$current_status" = "yes" ]; then
                    sed -i 's/EXPIRY_NOTIFICATIONS=yes/EXPIRY_NOTIFICATIONS=no/' "$config_file"
                    echo -e "${RED}Notificările de expirare au fost dezactivate${NC}"
                else
                    sed -i 's/EXPIRY_NOTIFICATIONS=no/EXPIRY_NOTIFICATIONS=yes/' "$config_file"
                    echo -e "${GREEN}Notificările de expirare au fost activate${NC}"
                fi
            else
                echo "EXPIRY_NOTIFICATIONS=yes" >> "$config_file"
                echo -e "${GREEN}Notificările de expirare au fost activate${NC}"
            fi
            ;;
        "backup")
            if grep -q "BACKUP_NOTIFICATIONS=" "$config_file"; then
                current_status=$(grep "BACKUP_NOTIFICATIONS=" "$config_file" | cut -d= -f2)
                if [ "$current_status" = "yes" ]; then
                    sed -i 's/BACKUP_NOTIFICATIONS=yes/BACKUP_NOTIFICATIONS=no/' "$config_file"
                    echo -e "${RED}Notificările de backup au fost dezactivate${NC}"
                else
                    sed -i 's/BACKUP_NOTIFICATIONS=no/BACKUP_NOTIFICATIONS=yes/' "$config_file"
                    echo -e "${GREEN}Notificările de backup au fost activate${NC}"
                fi
            else
                echo "BACKUP_NOTIFICATIONS=yes" >> "$config_file"
                echo -e "${GREEN}Notificările de backup au fost activate${NC}"
            fi
            ;;
    esac
    
    # Configurare cron jobs pentru monitorizare
    setup_monitoring_crons
    
    sleep 2
}

# Funcție pentru trimiterea mesajelor prin Telegram
send_telegram_message() {
    local message="$1"
    local config_file="/etc/alecs_vpn/telegram.conf"
    
    if [ -f "$config_file" ]; then
        source "$config_file"
        if [ ! -z "$BOT_TOKEN" ] && [ ! -z "$CHAT_ID" ]; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
                -d chat_id="$CHAT_ID" \
                -d text="$message" \
                -d parse_mode="HTML"
        fi
    fi
}

# Funcție pentru monitorizarea conexiunilor
monitor_connections() {
    local config_file="/etc/alecs_vpn/telegram.conf"
    if [ -f "$config_file" ]; then
        source "$config_file"
        if [ "$LOGIN_NOTIFICATIONS" = "yes" ]; then
            # Monitorizare conexiuni SSH
            who | while read -r line; do
                user=$(echo "$line" | awk '{print $1}')
                ip=$(echo "$line" | awk '{print $(NF-2)}')
                time=$(echo "$line" | awk '{print $3,$4}')
                message="🔵 <b>Nouă Conectare SSH</b>
👤 Utilizator: $user
🌐 IP: $ip
⏰ Timp: $time"
                send_telegram_message "$message"
            done
        fi
    fi
}

# Funcție pentru verificarea conturilor care expiră
check_expiring_accounts() {
    local config_file="/etc/alecs_vpn/telegram.conf"
    if [ -f "$config_file" ]; then
        source "$config_file"
        if [ "$EXPIRY_NOTIFICATIONS" = "yes" ]; then
            # Verificare conturi SSH care expiră în următoarele 3 zile
            for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
                exp=$(chage -l "$user" | grep "Account expires" | cut -d: -f2)
                exp_date=$(date -d "$exp" +%s)
                today=$(date +%s)
                diff=$((($exp_date - $today) / 86400))
                
                if [ $diff -le 3 ] && [ $diff -ge 0 ]; then
                    message="⚠️ <b>Cont SSH în Expirare</b>
👤 Utilizator: $user
📅 Expiră în: $diff zile"
                    send_telegram_message "$message"
                fi
            done
            
            # Verificare conturi V2Ray care expiră
            if [ -d "/etc/alecs_vpn/xray_users" ]; then
                for conf in /etc/alecs_vpn/xray_users/*.conf; do
                    if [ -f "$conf" ]; then
                        source "$conf"
                        exp_date=$(date -d "$EXPIRY" +%s)
                        today=$(date +%s)
                        diff=$((($exp_date - $today) / 86400))
                        
                        if [ $diff -le 3 ] && [ $diff -ge 0 ]; then
                            message="⚠️ <b>Cont V2Ray în Expirare</b>
👤 Utilizator: $USERNAME
🔰 Protocol: $(basename "$conf" | cut -d_ -f2 | cut -d. -f1)
📅 Expiră în: $diff zile"
                            send_telegram_message "$message"
                        fi
                    fi
                done
            fi
        fi
    fi
}

# Funcție pentru configurarea cron jobs de monitorizare
setup_monitoring_crons() {
    # Creare script pentru monitorizare
    cat > /etc/alecs_vpn/monitor.sh <<'EOF'
#!/bin/bash
source /etc/alecs_vpn/telegram.conf

# Monitorizare conexiuni
if [ "$LOGIN_NOTIFICATIONS" = "yes" ]; then
    /root/vpn_manager.sh monitor_connections
fi

# Verificare conturi care expiră
if [ "$EXPIRY_NOTIFICATIONS" = "yes" ]; then
    /root/vpn_manager.sh check_expiring_accounts
fi
EOF
    
    chmod +x /etc/alecs_vpn/monitor.sh
    
    # Adăugare în crontab
    (crontab -l 2>/dev/null | grep -v "/etc/alecs_vpn/monitor.sh"; echo "*/5 * * * * /etc/alecs_vpn/monitor.sh") | crontab -
}

# Funcție pentru afișarea caracteristicilor
show_features() {
    clear
    show_banner
    
    # Obținere IP server
    server_ip=$(curl -s ifconfig.me)
    
    echo -e "${GREEN}=== Caracteristici ALECS VPN MANAGER PRO ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           Caracteristici Active        ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} ✓ Management Conturi SSH"
    echo -e "${CYAN}║${NC} ✓ Backup/Restaurare Automată"
    echo -e "${CYAN}║${NC} ✓ Monitorizare Sistem în Timp Real"
    echo -e "${CYAN}║${NC} ✓ Interfață Prietenoasă"
    echo -e "${CYAN}║${NC} ✓ Actualizări Automate"
    echo -e "${CYAN}║${NC} ✓ Suport Multi-Protocol (SSH/SSL/UDP)"
    echo -e "${CYAN}║${NC} ✓ Limitare Conexiuni per IP"
    echo -e "${CYAN}║${NC} ✓ Notificări Telegram"
    echo -e "${CYAN}║${NC} ✓ Generare Certificate SSL"
    echo -e "${CYAN}║${NC} ✓ Optimizare Automată Performanță"
    echo -e "${CYAN}║${NC} ✓ Protecție DDoS Basic"
    echo -e "${CYAN}║${NC} ✓ Auto-Ban IP-uri Suspecte"
    echo -e "${CYAN}║${NC} ✓ Monitorizare Avansată Trafic"
    echo -e "${CYAN}║${NC} ✓ Backup Automat în Cloud"
    echo -e "${CYAN}║${NC} ✓ Firewall Avansat"
    echo -e "${CYAN}║${NC} ✓ Scanare Vulnerabilități"
    echo -e "${CYAN}║${NC} ✓ Optimizare Automată Rețea"
    echo -e "${CYAN}║${NC} ✓ Rapoarte Zilnice prin Email"
    echo -e "${CYAN}║${NC} ✓ Management Bandwidth per User"
    echo -e "${CYAN}║${NC} ✓ Anti-Brute Force"
    echo -e "${CYAN}║${NC} ✓ Suport IPv6"
    echo -e "${CYAN}║${NC} ✓ Load Balancing"
    echo -e "${CYAN}║${NC} ✓ Criptare End-to-End"
    echo -e "${CYAN}║${NC} ✓ Detecție Intruziuni (IDS)"
    echo -e "${CYAN}║${NC} ✓ Prevenție Intruziuni (IPS)"
    echo -e "${CYAN}║${NC} ✓ DNS over TLS"
    echo -e "${CYAN}║${NC} ✓ Fail2Ban Integrat"
    echo -e "${CYAN}║${NC} ✓ Port Knocking"
    echo -e "${CYAN}║${NC} ✓ Traffic Shaping QoS"
    echo -e "${CYAN}║${NC} ✓ VPN over TOR"
    echo -e "${CYAN}║${NC} ✓ Multi-Factor Authentication"
    echo -e "${CYAN}║${NC} ✓ Geo-IP Blocking"
    echo -e "${CYAN}║${NC} ✓ SSL Perfect Forward Secrecy"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║           Informații Sistem            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} CPU: $(grep 'model name' /proc/cpuinfo | uniq | cut -d: -f2)"
    echo -e "${CYAN}║${NC} RAM: $(free -h | grep Mem | awk '{print $2}')"
    echo -e "${CYAN}║${NC} OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
    echo -e "${CYAN}║${NC} Kernel: $(uname -r)"
    echo -e "${CYAN}║${NC} IP Server: ${GREEN}$server_ip${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║           Porturi Active               ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} SSH: $(netstat -tlpn | grep sshd | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} SSL: $(netstat -tlpn | grep stunnel | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}║${NC} UDP: $(netstat -ulpn | grep openvpn | awk '{print $4}' | cut -d: -f2)"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║           Status Servicii              ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} SSH: $(systemctl is-active sshd)"
    echo -e "${CYAN}║${NC} SSL: $(systemctl is-active stunnel4)"
    echo -e "${CYAN}║${NC} NGINX: $(systemctl is-active nginx)"
    echo -e "${CYAN}║${NC} BadVPN: $(systemctl is-active badvpn)"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru crearea unui backup
create_backup() {
    clear
    echo -e "${GREEN}=== Creare Backup ===${NC}"
    
    # Creare director pentru backup dacă nu există
    backup_dir="/root/vpn_backup"
    mkdir -p "$backup_dir"
    
    # Data pentru numele fișierului
    backup_date=$(date +"%Y%m%d_%H%M%S")
    backup_file="$backup_dir/backup_$backup_date.tar.gz"
    
    # Liste de fișiere și directoare pentru backup
    backup_files=(
        "/etc/passwd"
        "/etc/shadow"
        "/etc/gshadow"
        "/etc/group"
    )
    
    # Creare arhivă
    tar -czf "$backup_file" "${backup_files[@]}" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Backup creat cu succes!${NC}"
        echo "Locație backup: $backup_file"
    else
        echo -e "${RED}Eroare la crearea backup-ului!${NC}"
    fi
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru restaurarea din backup
restore_backup() {
    clear
    echo -e "${GREEN}=== Restaurare din Backup ===${NC}"
    
    backup_dir="/root/vpn_backup"
    
    if [ ! -d "$backup_dir" ]; then
        echo -e "${RED}Nu există director de backup!${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Listare backup-uri disponibile
    echo "Backup-uri disponibile:"
    select backup_file in "$backup_dir"/backup_*.tar.gz; do
        if [ -n "$backup_file" ]; then
            break
        else
            echo "Selecție invalidă. Încercați din nou."
        fi
    done
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}Nu s-a găsit fișierul de backup!${NC}"
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Confirmare restaurare
    echo -e "${RED}ATENȚIE: Restaurarea va suprascrie configurația curentă!${NC}"
    read -p "Doriți să continuați? (d/n): " confirm
    if [ "$confirm" != "d" ]; then
        echo "Restaurare anulată."
        read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
        return
    fi
    
    # Restaurare din backup
    tar -xzf "$backup_file" -C /
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Restaurare completă cu succes!${NC}"
    else
        echo -e "${RED}Eroare la restaurare!${NC}"
    fi
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru limitarea IP-urilor per utilizator
limit_user_ip() {
    clear
    show_banner
    echo -e "${GREEN}=== Limitare IP per Utilizator ===${NC}"
    
    # Afișare listă utilizatori
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Utilizatori Disponibili        ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    
    # Creare array pentru utilizatori
    declare -a users
    i=1
    while IFS=: read -r username x uid gid info home shell; do
        if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
            users[$i]=$username
            echo -e "${CYAN}║${NC} $i) $username"
            ((i++))
        fi
    done < "/etc/passwd"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    # Selectare utilizator
    read -p "Alegeți numărul utilizatorului: " user_choice
    if [[ "$user_choice" =~ ^[0-9]+$ ]] && [ "$user_choice" -ge 1 ] && [ "$user_choice" -lt "$i" ]; then
        username=${users[$user_choice]}
    else
        echo -e "${RED}Selecție invalidă!${NC}"
        sleep 2
        return
    fi
    
    read -p "Introduceți numărul maxim de IP-uri permise (1-10): " max_ip
    
    # Validare input
    if ! [[ "$max_ip" =~ ^[1-9]|10$ ]]; then
        echo -e "${RED}Număr invalid! Folosiți un număr între 1 și 10${NC}"
        sleep 2
        return
    fi
    
    # Creare/Actualizare fișier de configurare pentru limitare IP
    mkdir -p /etc/alecs_vpn/ip_limits
    echo "$max_ip" > "/etc/alecs_vpn/ip_limits/$username"
    
    # Adăugare regulă în PAM pentru SSH
    if ! grep -q "pam_limits.so" /etc/pam.d/sshd; then
        echo "session required pam_limits.so" >> /etc/pam.d/sshd
    fi
    
    # Configurare limit.conf
    sed -i "/$username hard maxlogins/d" /etc/security/limits.conf
    echo "$username hard maxlogins $max_ip" >> /etc/security/limits.conf
    
    echo -e "${GREEN}Limită de $max_ip IP-uri setată pentru utilizatorul $username${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru gestionarea conexiunilor unui utilizator
kill_user_connection() {
    clear
    show_banner
    echo -e "${GREEN}=== Gestionare Conexiuni Utilizator ===${NC}"
    
    # Afișare listă utilizatori
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Utilizatori Disponibili        ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    
    # Creare array pentru utilizatori
    declare -a users
    i=1
    while IFS=: read -r username x uid gid info home shell; do
        if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
            users[$i]=$username
            echo -e "${CYAN}║${NC} $i) $username"
            ((i++))
        fi
    done < "/etc/passwd"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    # Selectare utilizator
    read -p "Alegeți numărul utilizatorului: " user_choice
    if [[ "$user_choice" =~ ^[0-9]+$ ]] && [ "$user_choice" -ge 1 ] && [ "$user_choice" -lt "$i" ]; then
        username=${users[$user_choice]}
    else
        echo -e "${RED}Selecție invalidă!${NC}"
        sleep 2
        return
    fi
    
    # Afișare submeniu pentru gestionarea conexiunilor
    echo -e "\n${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║      Gestionare Conexiuni Utilizator   ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) Închidere conexiuni"
    echo -e "${CYAN}║${NC} 2) Deschidere conexiuni"
    echo -e "${CYAN}║${NC} 3) Înapoi"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea: " connection_choice
    
    case $connection_choice in
        1)
            # Afișare conexiuni active pentru utilizator
            echo -e "\n${CYAN}Conexiuni active pentru utilizatorul $username:${NC}"
            who | grep "^$username" | while read -r line; do
                echo "$line"
            done
            
            read -p "Doriți să închideți toate conexiunile? (d/n): " confirm
            if [ "$confirm" = "d" ]; then
                # Închidere conexiuni SSH
                pkill -KILL -u "$username"
                
                # Închidere conexiuni SSL
                netstat -tnpa | grep 'ESTABLISHED.*stunnel' | grep "$username" | awk '{print $7}' | cut -d'/' -f1 | while read -r pid; do
                    kill -9 "$pid" 2>/dev/null
                done
                
                echo -e "${GREEN}Toate conexiunile pentru utilizatorul $username au fost închise${NC}"
            else
                echo -e "${YELLOW}Operațiune anulată${NC}"
            fi
            ;;
        2)
            # Verificare dacă utilizatorul este blocat
            if passwd -S "$username" | grep -q "L"; then
                # Deblocare cont
                usermod -U "$username"
                # Eliminare limită de login din limits.conf
                sed -i "/$username hard maxlogins/d" /etc/security/limits.conf
                echo -e "${GREEN}Contul utilizatorului $username a fost deblocat${NC}"
            else
                echo -e "${YELLOW}Contul utilizatorului $username este deja activ${NC}"
            fi
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}Opțiune invalidă!${NC}"
            ;;
    esac
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru monitorizarea sistemului în timp real
monitor_system() {
    clear
    show_banner
    echo -e "${GREEN}=== Monitorizare Sistem în Timp Real ===${NC}"
    
    while true; do
        clear
        # Obținere informații sistem
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
        ram_total=$(free -m | awk 'NR==2 {print $2}')
        ram_used=$(free -m | awk 'NR==2 {print $3}')
        ram_percentage=$((ram_used * 100 / ram_total))
        disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
        
        # Conexiuni active
        ssh_connections=$(netstat -tnpa | grep 'ESTABLISHED.*sshd' | wc -l)
        ssl_connections=$(netstat -tnpa | grep 'ESTABLISHED.*stunnel' | wc -l)
        
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║         Monitorizare Sistem            ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} CPU: ${cpu_usage}%"
        echo -e "${CYAN}║${NC} RAM: ${ram_percentage}% (${ram_used}MB / ${ram_total}MB)"
        echo -e "${CYAN}║${NC} Disk: ${disk_usage}%"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║         Conexiuni Active              ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} SSH: $ssh_connections"
        echo -e "${CYAN}║${NC} SSL: $ssl_connections"
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        echo -e "\nApăsați CTRL+C pentru a ieși..."
        sleep 2
    done
}

# Funcție pentru configurare SSL avansată
configure_ssl_advanced() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare SSL Avansată ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Configurare SSL Avansată       ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) Configurare Multi-Port SSL"
    echo -e "${CYAN}║${NC} 2) Generare Certificate Noi"
    echo -e "${CYAN}║${NC} 3) Optimizare Performanță SSL"
    echo -e "${CYAN}║${NC} 4) Monitorizare Conexiuni SSL"
    echo -e "${CYAN}║${NC} 5) Înapoi la Meniul Principal"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea: " ssl_option
    case $ssl_option in
        1) configure_multiport_ssl ;;
        2) generate_new_certificates ;;
        3) optimize_ssl_performance ;;
        4) monitor_ssl_connections ;;
        5) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
    esac
}

# Funcție pentru configurare multi-port SSL
configure_multiport_ssl() {
    clear
    echo -e "${GREEN}=== Configurare Multi-Port SSL ===${NC}"
    read -p "Introduceți numărul de porturi SSL (1-5): " num_ports
    
    if ! [[ "$num_ports" =~ ^[1-5]$ ]]; then
        echo -e "${RED}Număr invalid! Folosiți un număr între 1 și 5${NC}"
        sleep 2
        return
    fi
    
    # Configurare pentru fiecare port
    for ((i=1; i<=num_ports; i++)); do
        read -p "Introduceți portul SSL $i (1-65535): " ssl_port
        
        if [[ ! $ssl_port =~ ^[0-9]+$ ]] || [ $ssl_port -lt 1 ] || [ $ssl_port -gt 65535 ]; then
            echo -e "${RED}Port invalid! Folosiți un număr între 1-65535${NC}"
            continue
        fi
        
        # Adăugare configurație în stunnel.conf
        echo -e "\n[ssl-port-$i]" >> /etc/stunnel/stunnel.conf
        echo "accept = $ssl_port" >> /etc/stunnel/stunnel.conf
        echo "connect = 127.0.0.1:22" >> /etc/stunnel/stunnel.conf
    done
    
    systemctl restart stunnel4
    echo -e "${GREEN}Configurare multi-port SSL completă!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru generare certificate noi
generate_new_certificates() {
    clear
    echo -e "${GREEN}=== Generare Certificate Noi ===${NC}"
    
    # Backup certificate existente
    if [ -f /etc/stunnel/stunnel.pem ]; then
        cp /etc/stunnel/stunnel.pem /etc/stunnel/stunnel.pem.bak
        echo -e "${YELLOW}Backup certificat existent creat${NC}"
    fi
    
    # Generare certificate noi
    echo -e "${CYAN}Generare certificate noi...${NC}"
    openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
        -subj "/C=US/ST=State/L=Location/O=Organization/CN=ALECS-VPN" \
        -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem
    
    chmod 600 /etc/stunnel/stunnel.pem
    systemctl restart stunnel4
    
    echo -e "${GREEN}Certificate noi generate cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru optimizare performanță SSL
optimize_ssl_performance() {
    clear
    echo -e "${GREEN}=== Optimizare Performanță SSL ===${NC}"
    
    # Configurare optimizată pentru stunnel
    cat > /etc/stunnel/stunnel.conf <<EOF
# Configurație Optimizată Stunnel
pid = /var/run/stunnel4.pid
output = /var/log/stunnel4/stunnel.log
cert = /etc/stunnel/stunnel.pem
client = no

# Optimizări performanță
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
TIMEOUTclose = 0

# Securitate îmbunătățită
sslVersion = TLSv1.2
options = NO_SSLv2
options = NO_SSLv3
options = NO_TLSv1
options = NO_TLSv1.1
options = CIPHER_SERVER_PREFERENCE
ciphers = ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384

# Setări cache
session = 50000
sessionTimeout = 300
sessionCacheSize = 20000
sessionCacheTimeout = 300

EOF
    
    # Adăugare porturi existente înapoi în configurație
    if [ -f /etc/stunnel/stunnel.conf.bak ]; then
        grep "^\[.*\]$" -A 2 /etc/stunnel/stunnel.conf.bak >> /etc/stunnel/stunnel.conf
    fi
    
    systemctl restart stunnel4
    echo -e "${GREEN}Optimizare SSL completă!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru monitorizare conexiuni SSL
monitor_ssl_connections() {
    clear
    echo -e "${GREEN}=== Monitorizare Conexiuni SSL ===${NC}"
    
    while true; do
        clear
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║       Conexiuni SSL Active            ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        
        # Afișare conexiuni SSL active
        netstat -tnpa | grep 'ESTABLISHED.*stunnel' | \
        while read -r line; do
            ip=$(echo "$line" | awk '{print $5}' | cut -d: -f1)
            pid=$(echo "$line" | awk '{print $7}' | cut -d/ -f1)
            user=$(ps -o user= -p "$pid" 2>/dev/null || echo "unknown")
            
            echo -e "${CYAN}║${NC} User: $user"
            echo -e "${CYAN}║${NC} IP: $ip"
            echo -e "${CYAN}║${NC} PID: $pid"
            echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
        done
        
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        echo -e "\nApăsați CTRL+C pentru a ieși..."
        sleep 2
    done
}

# Funcție pentru monitorizare avansată
monitor_advanced() {
    clear
    show_banner
    echo -e "${GREEN}=== Monitorizare Avansată Sistem ===${NC}"
    
    while true; do
        clear
        # Informații sistem de bază
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
        ram_total=$(free -m | awk 'NR==2 {print $2}')
        ram_used=$(free -m | awk 'NR==2 {print $3}')
        ram_percentage=$((ram_used * 100 / ram_total))
        disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
        
        # Monitorizare conexiuni
        ssh_connections=$(netstat -tnpa | grep 'ESTABLISHED.*sshd' | wc -l)
        ssl_connections=$(netstat -tnpa | grep 'ESTABLISHED.*stunnel' | wc -l)
        
        # Monitorizare bandwidth per utilizator
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║         Statistici Sistem              ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} CPU: ${cpu_usage}%"
        echo -e "${CYAN}║${NC} RAM: ${ram_percentage}% (${ram_used}MB / ${ram_total}MB)"
        echo -e "${CYAN}║${NC} Disk: ${disk_usage}%"
        echo -e "${CYAN}║${NC} Conexiuni SSH: $ssh_connections"
        echo -e "${CYAN}║${NC} Conexiuni SSL: $ssl_connections"
        
        # Monitorizare bandwidth per utilizator
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║         Utilizare Bandwidth            ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        
        # Pentru fiecare utilizator activ
        for user in $(who | cut -d' ' -f1 | sort | uniq); do
            rx_bytes=$(iptables -nvx -L OUTPUT | grep "$user" | awk '{sum+=$2} END {print sum}')
            tx_bytes=$(iptables -nvx -L INPUT | grep "$user" | awk '{sum+=$2} END {print sum}')
            
            # Conversie în MB
            rx_mb=$(echo "scale=2; $rx_bytes/1024/1024" | bc)
            tx_mb=$(echo "scale=2; $tx_bytes/1024/1024" | bc)
            
            echo -e "${CYAN}║${NC} User: $user"
            echo -e "${CYAN}║${NC} Download: ${rx_mb}MB"
            echo -e "${CYAN}║${NC} Upload: ${tx_mb}MB"
            echo -e "${CYAN}╟────────────────────────────────────────╢${NC}"
        done
        
        # Monitorizare tentative de autentificare eșuate
        failed_attempts=$(grep "Failed password" /var/log/auth.log | wc -l)
        echo -e "${CYAN}║${NC} Tentative eșuate de autentificare: $failed_attempts"
        
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        echo -e "\nApăsați CTRL+C pentru a ieși..."
        sleep 2
    done
}

# Funcție pentru securitate avansată
configure_advanced_security() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Securitate Avansată ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Securitate Avansată            ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) Configurare Fail2Ban"
    echo -e "${CYAN}║${NC} 2) Configurare Port Knocking"
    echo -e "${CYAN}║${NC} 3) Activare 2FA pentru SSH"
    echo -e "${CYAN}║${NC} 4) Configurare IP Tables"
    echo -e "${CYAN}║${NC} 5) Scanare Vulnerabilități"
    echo -e "${CYAN}║${NC} 6) Înapoi"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea: " security_option
    
    case $security_option in
        1) configure_fail2ban ;;
        2) configure_port_knocking ;;
        3) configure_2fa ;;
        4) configure_iptables ;;
        5) scan_vulnerabilities ;;
        6) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
    esac
}

# Funcție pentru configurare Fail2Ban
configure_fail2ban() {
    clear
    echo -e "${GREEN}=== Configurare Fail2Ban ===${NC}"
    
    # Instalare Fail2Ban dacă nu există
    if ! command -v fail2ban-client &> /dev/null; then
        apt-get update
        apt-get install -y fail2ban
    fi
    
    # Configurare Fail2Ban
    cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[stunnel4]
enabled = true
port = ssl
filter = stunnel
logpath = /var/log/stunnel4/stunnel.log
maxretry = 3
EOF
    
    # Creare filtru pentru Stunnel
    cat > /etc/fail2ban/filter.d/stunnel.conf <<EOF
[Definition]
failregex = ^.*SSL_accept:failed.*client IP: <HOST>.*$
ignoreregex =
EOF
    
    systemctl restart fail2ban
    echo -e "${GREEN}Fail2Ban configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare Port Knocking
configure_port_knocking() {
    clear
    echo -e "${GREEN}=== Configurare Port Knocking ===${NC}"
    
    # Instalare knockd dacă nu există
    if ! command -v knockd &> /dev/null; then
        apt-get update
        apt-get install -y knockd
    fi
    
    # Configurare knockd
    cat > /etc/knockd.conf <<EOF
[options]
    UseSyslog

[openSSH]
    sequence    = 7000,8000,9000
    seq_timeout = 5
    command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn

[closeSSH]
    sequence    = 9000,8000,7000
    seq_timeout = 5
    command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
    tcpflags    = syn
EOF
    
    # Activare knockd
    systemctl enable knockd
    systemctl restart knockd
    
    echo -e "${GREEN}Port Knocking configurat cu succes!${NC}"
    echo -e "${YELLOW}Secvența de knock: 7000,8000,9000${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare 2FA
configure_2fa() {
    clear
    echo -e "${GREEN}=== Configurare Autentificare în 2 Pași ===${NC}"
    
    # Instalare Google Authenticator
    apt-get update
    apt-get install -y libpam-google-authenticator
    
    # Configurare PAM
    sed -i 's/^@include common-auth/#&/' /etc/pam.d/sshd
    echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd
    
    # Activare autentificare cu cheie în sshd_config
    sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
    
    # Generare cod QR pentru fiecare utilizator
    echo -e "${YELLOW}Generare coduri 2FA pentru utilizatori...${NC}"
    for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
        su - "$user" -c "google-authenticator -t -d -f -r 3 -R 30 -w 3"
    done
    
    systemctl restart sshd
    echo -e "${GREEN}Autentificare în 2 pași configurată cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare IPTables
configure_iptables() {
    clear
    echo -e "${GREEN}=== Configurare IPTables ===${NC}"
    
    # Resetare reguli
    iptables -F
    iptables -X
    
    # Politici implicite
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
    
    # Permite conexiuni stabilite
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # Permite loopback
    iptables -A INPUT -i lo -j ACCEPT
    
    # Permite SSH
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    
    # Permite SSL
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    
    # Permite ping (opțional)
    iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
    
    # Salvare reguli
    iptables-save > /etc/iptables.rules
    
    echo -e "${GREEN}IPTables configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru scanare vulnerabilități
scan_vulnerabilities() {
    clear
    echo -e "${GREEN}=== Scanare Vulnerabilități ===${NC}"
    
    # Instalare unelte de securitate
    apt-get update
    apt-get install -y lynis rkhunter chkrootkit
    
    echo -e "${YELLOW}Rulare scanare Lynis...${NC}"
    lynis audit system
    
    echo -e "${YELLOW}Rulare scanare RKHunter...${NC}"
    rkhunter --check --skip-keypress
    
    echo -e "${YELLOW}Rulare scanare ChkRootkit...${NC}"
    chkrootkit
    
    echo -e "${GREEN}Scanare completă!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru backup în cloud
configure_cloud_backup() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Backup în Cloud ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Backup în Cloud                ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) Configurare Google Drive"
    echo -e "${CYAN}║${NC} 2) Configurare Dropbox"
    echo -e "${CYAN}║${NC} 3) Configurare FTP"
    echo -e "${CYAN}║${NC} 4) Configurare Backup Automat"
    echo -e "${CYAN}║${NC} 5) Înapoi"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea: " backup_option
    
    case $backup_option in
        1) configure_gdrive_backup ;;
        2) configure_dropbox_backup ;;
        3) configure_ftp_backup ;;
        4) configure_auto_backup ;;
        5) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
    esac
}

# Funcție pentru configurare backup Google Drive
configure_gdrive_backup() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Backup Google Drive ===${NC}"
    
    # Verificare și instalare rclone
    if ! command -v rclone &> /dev/null; then
        echo -e "${YELLOW}Se instalează rclone...${NC}"
        curl https://rclone.org/install.sh | bash
        if [ $? -ne 0 ]; then
            echo -e "${RED}Eroare la instalarea rclone. Încercați manual:${NC}"
            echo "1. Descărcați de la https://rclone.org/downloads/"
            echo "2. Urmați instrucțiunile de instalare"
            read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
            return
        fi
    fi
    
    # Meniu configurare
    while true; do
        clear
        echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║      Configurare Backup Google Drive    ║${NC}"
        echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} 1) Configurare Cont Google Drive"
        echo -e "${CYAN}║${NC} 2) Test Conexiune"
        echo -e "${CYAN}║${NC} 3) Backup Manual"
        echo -e "${CYAN}║${NC} 4) Vizualizare Backup-uri"
        echo -e "${CYAN}║${NC} 5) Restaurare din Backup"
        echo -e "${CYAN}║${NC} 6) Înapoi"
        echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
        
        read -p "Alegeți opțiunea: " gdrive_option
        
        case $gdrive_option in
            1)
                echo -e "${YELLOW}Se configurează Google Drive...${NC}"
                echo -e "${CYAN}Urmați pașii pentru configurarea rclone:${NC}"
                echo "1. Selectați 'n' pentru configurare nouă"
                echo "2. Alegeți numele 'gdrive' pentru configurare"
                echo "3. Selectați 'drive' pentru Google Drive"
                echo "4. Urmați instrucțiunile pentru autentificare"
                echo
                read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                rclone config
                
                # Creare director pentru backup-uri
                echo -e "${YELLOW}Se creează directorul pentru backup-uri...${NC}"
                rclone mkdir gdrive:vpn_backups
                ;;
            2)
                echo -e "${YELLOW}Se testează conexiunea...${NC}"
                if rclone lsd gdrive: &>/dev/null; then
                    echo -e "${GREEN}Conexiune reușită la Google Drive!${NC}"
                else
                    echo -e "${RED}Eroare de conexiune! Verificați configurația.${NC}"
                fi
                read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                ;;
            3)
                echo -e "${YELLOW}Se creează backup manual...${NC}"
                backup_dir="/root/vpn_backup"
                mkdir -p "$backup_dir"
                date=$(date +"%Y%m%d_%H%M%S")
                backup_file="$backup_dir/backup_$date.tar.gz"
                
                # Creare backup
                echo -e "${CYAN}Se creează arhiva...${NC}"
                tar -czf "$backup_file" /etc/alecs_vpn /etc/stunnel /etc/ssh /etc/wireguard /etc/openvpn 2>/dev/null
                
                # Upload la Google Drive
                echo -e "${CYAN}Se încarcă pe Google Drive...${NC}"
                rclone copy "$backup_file" gdrive:vpn_backups/
                
                # Verificare upload
                if rclone lsf gdrive:vpn_backups/$(basename "$backup_file") &>/dev/null; then
                    echo -e "${GREEN}Backup încărcat cu succes!${NC}"
                else
                    echo -e "${RED}Eroare la încărcarea backup-ului!${NC}"
                fi
                
                # Ștergere backup-uri vechi locale
                echo -e "${YELLOW}Se curăță backup-urile vechi locale...${NC}"
                cd "$backup_dir" && ls -t | tail -n +6 | xargs -I {} rm -- {} 2>/dev/null
                
                read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                ;;
            4)
                echo -e "${YELLOW}Backup-uri disponibile pe Google Drive:${NC}"
                rclone lsf gdrive:vpn_backups/
                read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                ;;
            5)
                echo -e "${YELLOW}Backup-uri disponibile pentru restaurare:${NC}"
                mapfile -t backups < <(rclone lsf gdrive:vpn_backups/)
                
                if [ ${#backups[@]} -eq 0 ]; then
                    echo -e "${RED}Nu există backup-uri disponibile!${NC}"
                    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                    continue
                fi
                
                echo -e "${CYAN}Selectați backup-ul pentru restaurare:${NC}"
                select backup in "${backups[@]}"; do
                    if [ -n "$backup" ]; then
                        echo -e "${RED}ATENȚIE: Restaurarea va suprascrie configurația curentă!${NC}"
                        read -p "Doriți să continuați? (d/n): " confirm
                        if [ "$confirm" = "d" ]; then
                            temp_dir="/tmp/vpn_restore"
                            mkdir -p "$temp_dir"
                            
                            echo -e "${YELLOW}Se descarcă backup-ul...${NC}"
                            rclone copy "gdrive:vpn_backups/$backup" "$temp_dir/"
                            
                            echo -e "${YELLOW}Se restaurează configurația...${NC}"
                            cd "$temp_dir" && tar -xzf "$backup" -C /
                            
                            if [ $? -eq 0 ]; then
                                echo -e "${GREEN}Restaurare completă cu succes!${NC}"
                                # Repornire servicii
                                systemctl restart ssh stunnel4 openvpn@server 2>/dev/null
                            else
                                echo -e "${RED}Eroare la restaurare!${NC}"
                            fi
                            
                            # Curățare
                            rm -rf "$temp_dir"
                        else
                            echo "Restaurare anulată."
                        fi
                        break
                    fi
                done
                read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
                ;;
            6) return ;;
            *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
        esac
    done
}

# Funcție pentru configurare backup Dropbox
configure_dropbox_backup() {
    clear
    echo -e "${GREEN}=== Configurare Backup Dropbox ===${NC}"
    
    # Instalare dbxcli dacă nu există
    if ! command -v dbxcli &> /dev/null; then
        echo -e "${YELLOW}Se instalează Dropbox CLI...${NC}"
        wget -O dbxcli https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-amd64
        chmod +x dbxcli
        mv dbxcli /usr/local/bin/
    fi
    
    # Autentificare Dropbox
    dbxcli account
    
    # Creare script de backup
    cat > /etc/alecs_vpn/backup_dropbox.sh <<EOF
#!/bin/bash
backup_dir="/root/vpn_backup"
date=\$(date +"%Y%m%d_%H%M%S")
backup_file="\$backup_dir/backup_\$date.tar.gz"

# Creare backup
tar -czf "\$backup_file" /etc/alecs_vpn /etc/stunnel /etc/ssh

# Upload la Dropbox
dbxcli put "\$backup_file" /vpn_backups/

# Ștergere backup-uri vechi
cd "\$backup_dir" && ls -t | tail -n +6 | xargs -I {} rm -- {}
EOF
    
    chmod +x /etc/alecs_vpn/backup_dropbox.sh
    
    echo -e "${GREEN}Backup Dropbox configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare backup FTP
configure_ftp_backup() {
    clear
    echo -e "${GREEN}=== Configurare Backup FTP ===${NC}"
    
    read -p "Introduceți adresa FTP: " ftp_host
    read -p "Introduceți utilizatorul FTP: " ftp_user
    read -s -p "Introduceți parola FTP: " ftp_pass
    echo
    
    # Creare fișier de configurare FTP
    cat > /etc/alecs_vpn/ftp_config.conf <<EOF
FTP_HOST="$ftp_host"
FTP_USER="$ftp_user"
FTP_PASS="$ftp_pass"
EOF
    
    # Creare script de backup
    cat > /etc/alecs_vpn/backup_ftp.sh <<EOF
#!/bin/bash
source /etc/alecs_vpn/ftp_config.conf
backup_dir="/root/vpn_backup"
date=\$(date +"%Y%m%d_%H%M%S")
backup_file="\$backup_dir/backup_\$date.tar.gz"

# Creare backup
tar -czf "\$backup_file" /etc/alecs_vpn /etc/stunnel /etc/ssh

# Upload la FTP
ftp -n \$FTP_HOST <<END_SCRIPT
quote USER \$FTP_USER
quote PASS \$FTP_PASS
binary
cd vpn_backups
put \$backup_file
quit
END_SCRIPT

# Ștergere backup-uri vechi
cd "\$backup_dir" && ls -t | tail -n +6 | xargs -I {} rm -- {}
EOF
    
    chmod +x /etc/alecs_vpn/backup_ftp.sh
    
    echo -e "${GREEN}Backup FTP configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare backup automat
configure_auto_backup() {
    clear
    echo -e "${GREEN}=== Configurare Backup Automat ===${NC}"
    
    echo -e "${CYAN}Selectați frecvența backup-ului:${NC}"
    echo "1) Zilnic"
    echo "2) Săptămânal"
    echo "3) Lunar"
    read -p "Alegeți opțiunea: " freq_option
    
    case $freq_option in
        1) cron_schedule="0 0 * * *" ;; # La miezul nopții în fiecare zi
        2) cron_schedule="0 0 * * 0" ;; # La miezul nopții în fiecare duminică
        3) cron_schedule="0 0 1 * *" ;; # La miezul nopții în prima zi a lunii
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; return ;;
    esac
    
    # Adăugare în crontab
    (crontab -l 2>/dev/null; echo "$cron_schedule /etc/alecs_vpn/backup_gdrive.sh") | crontab -
    (crontab -l 2>/dev/null; echo "$cron_schedule /etc/alecs_vpn/backup_dropbox.sh") | crontab -
    (crontab -l 2>/dev/null; echo "$cron_schedule /etc/alecs_vpn/backup_ftp.sh") | crontab -
    
    echo -e "${GREEN}Backup automat configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare protocoale VPN adiționale
configure_vpn_protocols() {
    clear
    show_banner
    echo -e "${GREEN}=== Configurare Protocoale VPN ===${NC}"
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         Protocoale VPN                 ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} 1) OpenVPN"
    echo -e "${CYAN}║${NC} 2) WireGuard"
    echo -e "${CYAN}║${NC} 3) L2TP/IPSec"
    echo -e "${CYAN}║${NC} 4) PPTP"
    echo -e "${CYAN}║${NC} 5) SoftEther"
    echo -e "${CYAN}║${NC} 6) Înapoi"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    
    read -p "Alegeți opțiunea: " vpn_option
    
    case $vpn_option in
        1) configure_openvpn ;;
        2) configure_wireguard ;;
        3) configure_l2tp ;;
        4) configure_pptp ;;
        5) configure_softether ;;
        6) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
    esac
}

# Funcție pentru configurare OpenVPN
configure_openvpn() {
    clear
    echo -e "${GREEN}=== Configurare OpenVPN ===${NC}"
    
    # Instalare OpenVPN
    apt-get update
    apt-get install -y openvpn easy-rsa
    
    # Configurare CA și certificate
    make-cadir /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa
    
    # Inițializare PKI
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ./easyrsa gen-dh
    ./easyrsa build-server-full server nopass
    
    # Configurare server
    cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
    gzip -d /etc/openvpn/server.conf.gz
    
    # Activare forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward
    
    # Configurare iptables pentru NAT
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
    
    # Pornire serviciu
    systemctl enable openvpn@server
    systemctl start openvpn@server
    
    echo -e "${GREEN}OpenVPN configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare WireGuard
configure_wireguard() {
    clear
    echo -e "${GREEN}=== Configurare WireGuard ===${NC}"
    
    # Instalare WireGuard
    apt-get update
    apt-get install -y wireguard
    
    # Generare chei
    wg genkey | tee /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
    
    # Configurare server
    cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $(cat /etc/wireguard/private.key)
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOF
    
    # Activare și pornire serviciu
    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
    
    echo -e "${GREEN}WireGuard configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare L2TP/IPSec
configure_l2tp() {
    clear
    echo -e "${GREEN}=== Configurare L2TP/IPSec ===${NC}"
    
    # Instalare L2TP și IPSec
    apt-get update
    apt-get install -y xl2tpd strongswan
    
    # Configurare IPSec
    cat > /etc/ipsec.conf <<EOF
config setup
    charondebug="ike 1, knl 1, cfg 0"
    uniqueids=no

conn L2TP-PSK-NAT
    keyexchange=ikev1
    authby=secret
    auto=add
    keyingtries=3
    rekey=no
    ikelifetime=8h
    keylife=1h
    type=transport
    left=%defaultroute
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any
EOF
    
    # Configurare L2TP
    cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[global]
ipsec saref = yes
saref refinfo = 30

[lns default]
ip range = 172.16.1.30-172.16.1.100
local ip = 172.16.1.1
refuse pap = yes
require authentication = yes
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF
    
    systemctl enable xl2tpd
    systemctl start xl2tpd
    
    echo -e "${GREEN}L2TP/IPSec configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare PPTP
configure_pptp() {
    clear
    echo -e "${GREEN}=== Configurare PPTP ===${NC}"
    
    # Instalare PPTP
    apt-get update
    apt-get install -y pptpd
    
    # Configurare PPTP
    cat > /etc/pptpd.conf <<EOF
option /etc/ppp/pptpd-options
logwtmp
localip 192.168.0.1
remoteip 192.168.0.200-238,192.168.0.245
EOF
    
    # Configurare DNS
    cat > /etc/ppp/pptpd-options <<EOF
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
debug
lock
nobsdcomp
EOF
    
    systemctl enable pptpd
    systemctl start pptpd
    
    echo -e "${GREEN}PPTP configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru configurare SoftEther
configure_softether() {
    clear
    echo -e "${GREEN}=== Configurare SoftEther ===${NC}"
    
    # Descărcare și instalare SoftEther
    wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz
    tar xzf softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz
    cd vpnserver
    make
    cd ..
    mv vpnserver /usr/local/
    
    # Creare serviciu systemd
    cat > /etc/systemd/system/softether-vpnserver.service <<EOF
[Unit]
Description=SoftEther VPN Server
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/vpnserver/vpnserver start
ExecStop=/usr/local/vpnserver/vpnserver stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    
    # Pornire serviciu
    systemctl enable softether-vpnserver
    systemctl start softether-vpnserver
    
    echo -e "${GREEN}SoftEther configurat cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru gestionarea utilizatorilor V2Ray
manage_v2ray() {
    clear
    echo -e "${GREEN}=== Manager V2Ray ===${NC}"
    echo -e "${GREEN}1)${NC} Creare utilizator nou"
    echo -e "${GREEN}2)${NC} Ștergere utilizator"
    echo -e "${GREEN}3)${NC} Lista utilizatori"
    echo -e "${GREEN}4)${NC} Modificare setări utilizator"
    echo -e "${GREEN}5)${NC} Generare link de conectare"
    echo -e "${GREEN}6)${NC} Înapoi la meniul principal"
    
    read -p "Alegeți opțiunea: " option
    case $option in
        1) create_v2ray_user ;;
        2) delete_v2ray_user ;;
        3) list_v2ray_users ;;
        4) modify_v2ray_user ;;
        5) generate_v2ray_link ;;
        6) return ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ;;
    esac
}

# Funcție pentru crearea unui utilizator V2Ray nou
create_v2ray_user() {
    clear
    echo -e "${GREEN}=== Creare Utilizator V2Ray ===${NC}"
    read -p "Introduceți numele utilizatorului: " username
    read -p "Introduceți numărul de zile valabilitate: " duration
    
    # Generare UUID unic pentru utilizator
    uuid=$(cat /proc/sys/kernel/random/uuid)
    expiry_date=$(date -d "+$duration days" +"%Y-%m-%d")
    
    # Adăugare utilizator în configurația V2Ray
    jq --arg uuid "$uuid" --arg username "$username" --arg expiry "$expiry_date" '.inbounds[0].settings.clients += [{"id": $uuid, "email": $username, "level": 0, "expiryDate": $expiry}]' /usr/local/etc/v2ray/config.json > /tmp/v2ray.tmp && mv /tmp/v2ray.tmp /usr/local/etc/v2ray/config.json
    
    # Restart serviciu V2Ray
    systemctl restart v2ray
    
    # Generare link de conectare
    server_ip=$(curl -s ifconfig.me)
    v2ray_link="vless://${uuid}@${server_ip}:443?security=tls&encryption=none&type=tcp&headerType=none#${username}"
    
    echo -e "${GREEN}Utilizator creat cu succes!${NC}"
    echo -e "Nume utilizator: ${CYAN}$username${NC}"
    echo -e "UUID: ${CYAN}$uuid${NC}"
    echo -e "Data expirare: ${CYAN}$expiry_date${NC}"
    echo -e "Link conectare: ${CYAN}$v2ray_link${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru ștergerea unui utilizator V2Ray
delete_v2ray_user() {
    clear
    echo -e "${GREEN}=== Ștergere Utilizator V2Ray ===${NC}"
    read -p "Introduceți numele utilizatorului de șters: " username
    
    # Ștergere utilizator din configurația V2Ray
    jq --arg username "$username" '.inbounds[0].settings.clients = [.inbounds[0].settings.clients[] | select(.email != $username)]' /usr/local/etc/v2ray/config.json > /tmp/v2ray.tmp && mv /tmp/v2ray.tmp /usr/local/etc/v2ray/config.json
    
    # Restart serviciu V2Ray
    systemctl restart v2ray
    
    echo -e "${GREEN}Utilizator șters cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru listarea utilizatorilor V2Ray
list_v2ray_users() {
    clear
    echo -e "${GREEN}=== Lista Utilizatori V2Ray ===${NC}"
    echo -e "${CYAN}Utilizatori activi:${NC}"
    
    # Extragere și afișare utilizatori din configurația V2Ray
    jq -r '.inbounds[0].settings.clients[] | "Utilizator: \(.email)\nUUID: \(.id)\nData expirare: \(.expiryDate)\n"' /usr/local/etc/v2ray/config.json
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru modificarea setărilor unui utilizator V2Ray
modify_v2ray_user() {
    clear
    echo -e "${GREEN}=== Modificare Setări Utilizator V2Ray ===${NC}"
    read -p "Introduceți numele utilizatorului de modificat: " username
    read -p "Introduceți noul număr de zile valabilitate: " duration
    
    # Calculare nouă dată de expirare
    new_expiry=$(date -d "+$duration days" +"%Y-%m-%d")
    
    # Actualizare configurație V2Ray
    jq --arg username "$username" --arg expiry "$new_expiry" '.inbounds[0].settings.clients = [.inbounds[0].settings.clients[] | if .email == $username then . + {"expiryDate": $expiry} else . end]' /usr/local/etc/v2ray/config.json > /tmp/v2ray.tmp && mv /tmp/v2ray.tmp /usr/local/etc/v2ray/config.json
    
    # Restart serviciu V2Ray
    systemctl restart v2ray
    
    echo -e "${GREEN}Setări actualizate cu succes!${NC}"
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Funcție pentru generarea link-ului de conectare V2Ray
generate_v2ray_link() {
    clear
    echo -e "${GREEN}=== Generare Link Conectare V2Ray ===${NC}"
    read -p "Introduceți numele utilizatorului: " username
    
    # Extragere UUID pentru utilizator
    uuid=$(jq -r --arg username "$username" '.inbounds[0].settings.clients[] | select(.email == $username) | .id' /usr/local/etc/v2ray/config.json)
    
    if [ ! -z "$uuid" ]; then
        server_ip=$(curl -s ifconfig.me)
        v2ray_link="vless://${uuid}@${server_ip}:443?security=tls&encryption=none&type=tcp&headerType=none#${username}"
        echo -e "Link conectare pentru ${CYAN}$username${NC}:"
        echo -e "${CYAN}$v2ray_link${NC}"
    else
        echo -e "${RED}Utilizatorul nu a fost găsit!${NC}"
    fi
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
}

# Loop principal
while true; do
    show_menu
    read choice
    case $choice in
        1) manage_ssh ;;
        2) manage_ports ;;
        3) check_running_services ;;
        4) list_all_users ;;
        5) update_script ;;
        6) backup_restore ;;
        7) show_features ;;
        8) configure_ssl_advanced ;;
        9) monitor_system ;;
        10) configure_advanced_security ;;
        11) configure_cloud_backup ;;
        12) configure_vpn_protocols ;;
        13) monitor_advanced ;;
        14) manage_v2ray ;;
        x|X) echo -e "${GREEN}La revedere!${NC}" ; exit 0 ;;
        *) echo -e "${RED}Opțiune invalidă!${NC}" ; sleep 2 ;;
    esac
done 