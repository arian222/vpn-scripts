# Scripturi pentru Gestionarea VPS și V2Ray

Acest repository conține o colecție de scripturi pentru configurarea, gestionarea și monitorizarea unui server VPS cu serviciile V2Ray.

## Conținut

- **setup-v2ray-vless.sh**: Script pentru instalarea și configurarea V2Ray cu protocol VLESS.
- **setup_monitoring.sh**: Script pentru configurarea sistemului de monitorizare.
- **install-v2ray-service.ps1**: Script PowerShell pentru instalarea serviciului V2Ray pe Windows.
- **vpn_manager.sh**: Script complex pentru gestionarea diverselor funcții VPN.
- **monitor_system.sh**: Script pentru monitorizarea resurselor sistemului.

## Cerințe

- Sistem de operare Linux (de preferință Ubuntu/Debian) pentru scripturile .sh
- Windows PowerShell pentru scripturile .ps1
- Acces root/sudo pentru instalarea pachetelor

## Instalare

1. Clonează repository-ul:
   ```bash
   git clone https://github.com/arian222/vps-v2ray-scripts.git
   cd vps-v2ray-scripts
   ```

2. Acordă permisiuni de execuție scripturilor:
   ```bash
   chmod +x *.sh
   ```

3. Rulează scriptul dorit:
   ```bash
   ./setup-v2ray-vless.sh
   ```

## Note

Asigură-te că ai back-up-uri înainte de a rula scripturile pe un sistem de producție.

## Licență

MIT 
