#!/bin/bash

# Culori pentru output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificare dacă scriptul rulează ca root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Acest script trebuie rulat ca root${NC}"
   exit 1
fi

# Funcție pentru animație în timpul instalării
loading_animation() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Funcție pentru instalarea dependințelor
install_dependencies() {
    echo -e "${BLUE}Instalare dependințe...${NC}"
    apt-get update &>/dev/null &
    loading_animation $!
    apt-get install -y curl wget jq uuid-runtime certbot nginx socat &>/dev/null &
    loading_animation $!
    echo -e "${GREEN}Dependințe instalate cu succes!${NC}"
}

# Funcție pentru instalarea V2Ray
install_v2ray() {
    echo -e "${BLUE}Instalare V2Ray...${NC}"
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) &>/dev/null &
    loading_animation $!
    
    # Creare directoare necesare
    mkdir -p /usr/local/etc/v2ray
    mkdir -p /etc/v2ray
    
    # Generare certificate SSL
    echo -e "${BLUE}Generare certificate SSL...${NC}"
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" \
        -keyout /etc/v2ray/v2ray.key \
        -out /etc/v2ray/v2ray.crt &>/dev/null &
    loading_animation $!
    
    chmod 644 /etc/v2ray/v2ray.crt
    chmod 644 /etc/v2ray/v2ray.key
    
    echo -e "${GREEN}V2Ray instalat cu succes!${NC}"
}

# Funcție pentru configurarea domeniului și SSL
configure_domain() {
    echo -e "${BLUE}Configurare domeniu și SSL...${NC}"
    read -p "Introduceți domeniul dvs. (ex: vpn.domain.com): " domain
    
    # Verificare IP server
    local server_ip=$(curl -s ifconfig.me)
    echo -e "\n${YELLOW}Pași pentru configurare Cloudflare:${NC}"
    echo -e "1. Accesați panoul de control Cloudflare"
    echo -e "2. Adăugați următoarea înregistrare DNS:"
    echo -e "   Tip: A"
    echo -e "   Nume: ${YELLOW}$(echo $domain | cut -d. -f1)${NC}"
    echo -e "   IP: ${YELLOW}$server_ip${NC}"
    echo -e "   Proxy status: ${YELLOW}DNS only (icon gri)${NC}"
    echo -e "3. În secțiunea SSL/TLS:"
    echo -e "   - Setați modul la: ${YELLOW}Full${NC}"
    
    read -p "Ați configurat domeniul în Cloudflare? (y/n): " confirm
    if [[ $confirm != "y" ]]; then
        echo -e "${RED}Configurarea domeniului este necesară pentru continuare.${NC}"
        exit 1
    fi
    
    # Oprire nginx temporar pentru certbot
    systemctl stop nginx
    
    # Obținere certificate SSL cu Let's Encrypt
    echo -e "${BLUE}Obținere certificate SSL...${NC}"
    certbot certonly --standalone --preferred-challenges http --agree-tos --email admin@$domain -d $domain
    
    # Copiere certificate pentru V2Ray
    cp /etc/letsencrypt/live/$domain/fullchain.pem /etc/v2ray/v2ray.crt
    cp /etc/letsencrypt/live/$domain/privkey.pem /etc/v2ray/v2ray.key
    
    # Setare permisiuni
    chmod 644 /etc/v2ray/v2ray.crt
    chmod 644 /etc/v2ray/v2ray.key
    
    # Salvare domeniu
    echo $domain > /etc/v2ray/domain.txt
    
    # Configurare reînnoire automată certificate
    echo "0 0 1 * * root certbot renew --quiet --pre-hook 'systemctl stop nginx' --post-hook 'systemctl start nginx && systemctl restart v2ray'" > /etc/cron.d/certbot-renew
    
    echo -e "${GREEN}Certificate SSL generate cu succes!${NC}"
}

# Funcție pentru configurarea V2Ray
configure_v2ray() {
    echo -e "${BLUE}Configurare V2Ray...${NC}"
    cat > /usr/local/etc/v2ray/config.json << EOF
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "debug"
  },
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [
        {
          "id": "$(uuidgen)",
          "level": 0,
          "email": "admin@v2ray.com"
        }
      ],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "tls",
      "tlsSettings": {
        "certificates": [
          {
            "certificateFile": "/etc/v2ray/v2ray.crt",
            "keyFile": "/etc/v2ray/v2ray.key"
          }
        ]
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF
    
    # Creare director pentru loguri și setare permisiuni
    mkdir -p /var/log/v2ray
    chown -R nobody:nogroup /var/log/v2ray
    chmod 755 /var/log/v2ray
    
    echo -e "${GREEN}Configurare completă!${NC}"
    
    # Afișare informații pentru primul utilizator
    echo -e "\n${GREEN}Primul utilizator creat:${NC}"
    echo -e "Nume utilizator: ${YELLOW}admin${NC}"
    echo -e "UUID: ${YELLOW}$(uuidgen)${NC}"
    echo -e "Data expirare: ${YELLOW}$(date -d "+30 days" '+%Y-%m-%d')${NC}"
    echo -e "Link conectare: ${YELLOW}vless://$uuid@$domain:443?security=tls&encryption=none&type=tcp&flow=xtls-rprx-direct&sni=$domain&fp=chrome&headerType=none#admin${NC}"
}

# Funcție pentru verificarea și repararea serviciului
check_and_fix_service() {
    echo -e "${BLUE}Verificare serviciu V2Ray...${NC}"
    
    # Verificare permisiuni fișiere
    chown -R nobody:nogroup /etc/v2ray
    chmod 644 /etc/v2ray/v2ray.crt
    chmod 644 /etc/v2ray/v2ray.key
    chmod 644 /usr/local/etc/v2ray/config.json
    
    # Verificare și creare director pentru loguri
    mkdir -p /var/log/v2ray
    chown -R nobody:nogroup /var/log/v2ray
    chmod 755 /var/log/v2ray
    
    # Restart serviciu
    systemctl daemon-reload
    systemctl restart v2ray
    
    # Verificare status
    if systemctl is-active --quiet v2ray; then
        echo -e "${GREEN}Serviciul V2Ray rulează corect!${NC}"
    else
        echo -e "${RED}Eroare la pornirea serviciului V2Ray. Verificați log-urile pentru detalii.${NC}"
        journalctl -u v2ray --no-pager -n 50
    fi
}

# Funcție pentru adăugarea unui utilizator nou
add_user() {
    local username=$1
    local days=$2
    local uuid=$(uuidgen)
    local config_file="/usr/local/etc/v2ray/config.json"
    local domain=$(cat /etc/v2ray/domain.txt)
    
    # Calculare dată expirare
    local expiry_time=$(date -d "+$days days" +%s)000
    
    # Adăugare utilizator în configurație
    local temp_file=$(mktemp)
    jq --arg uuid "$uuid" \
       --arg email "${username}@v2ray.com" \
       --arg expiry "$expiry_time" \
       '.inbounds[0].settings.clients += [{"id": $uuid, "flow": "xtls-rprx-direct", "email": $email, "expiryTime": ($expiry|tonumber)}]' \
       $config_file > $temp_file
    mv $temp_file $config_file
    
    echo -e "${GREEN}Utilizator creat cu succes!${NC}"
    echo -e "Nume utilizator: ${YELLOW}$username${NC}"
    echo -e "UUID: ${YELLOW}$uuid${NC}"
    echo -e "Data expirare: ${YELLOW}$(date -d @$(($expiry_time/1000)) '+%Y-%m-%d')${NC}"
    echo -e "Link conectare: ${YELLOW}vless://$uuid@$domain:443?security=tls&encryption=none&type=tcp&flow=xtls-rprx-direct&sni=$domain&fp=chrome&headerType=none#$username${NC}"
}

# Funcție pentru ștergerea unui utilizator
delete_user() {
    local username=$1
    local config_file="/usr/local/etc/v2ray/config.json"
    
    local temp_file=$(mktemp)
    jq --arg email "${username}@v2ray.com" \
       '.inbounds[0].settings.clients = [.inbounds[0].settings.clients[] | select(.email != $email)]' \
       $config_file > $temp_file
    mv $temp_file $config_file
    
    echo -e "${GREEN}Utilizator șters cu succes!${NC}"
}

# Funcție pentru listarea utilizatorilor
list_users() {
    local config_file="/usr/local/etc/v2ray/config.json"
    echo -e "${BLUE}Lista utilizatori:${NC}"
    jq -r '.inbounds[0].settings.clients[] | "Utilizator: \(.email | split("@")[0])\nUUID: \(.id)\nExpira la: \(.expiryTime/1000 | strftime("%Y-%m-%d"))\n"' $config_file
}

# Meniu principal
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         Manager V2Ray                  ║${NC}"
    echo -e "${BLUE}╠════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC} 1) Instalare V2Ray"
    echo -e "${BLUE}║${NC} 2) Adăugare utilizator nou"
    echo -e "${BLUE}║${NC} 3) Ștergere utilizator"
    echo -e "${BLUE}║${NC} 4) Lista utilizatori"
    echo -e "${BLUE}║${NC} 5) Restart serviciu"
    echo -e "${BLUE}║${NC} x) Ieșire"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
}

# Bucla principală
while true; do
    show_menu
    read -p "Alegeți o opțiune: " choice
    
    case $choice in
        1)
            install_dependencies
            install_v2ray
            configure_domain
            configure_v2ray
            systemctl enable v2ray
            systemctl restart v2ray
            echo -e "${GREEN}Instalare completă!${NC}"
            ;;
        2)
            read -p "Introduceți numele utilizatorului: " username
            read -p "Introduceți numărul de zile valabilitate: " days
            add_user "$username" "$days"
            systemctl restart v2ray
            ;;
        3)
            read -p "Introduceți numele utilizatorului de șters: " username
            delete_user "$username"
            systemctl restart v2ray
            ;;
        4)
            list_users
            ;;
        5)
            systemctl restart v2ray
            echo -e "${GREEN}Serviciul V2Ray a fost repornit!${NC}"
            ;;
        x|X)
            echo -e "${GREEN}La revedere!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opțiune invalidă!${NC}"
            ;;
    esac
    
    read -n 1 -s -r -p "Apăsați orice tastă pentru a continua..."
    clear
done 

chown -R nobody:nogroup /etc/v2ray/
chmod 644 /etc/v2ray/v2ray.crt
chmod 644 /etc/v2ray/v2ray.key
chmod 644 /usr/local/etc/v2ray/config.json
mkdir -p /var/log/v2ray
chown -R nobody:nogroup /var/log/v2ray
chmod 755 /var/log/v2ray 