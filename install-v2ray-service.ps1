# Script de instalare V2Ray pentru Windows
$ErrorActionPreference = "Stop"

# Definire variabile
$v2rayPath = "C:\v2ray"
$configPath = "C:\usr\local\etc\v2ray"
$serviceName = "V2RayService"

# Creare directoare necesare
New-Item -ItemType Directory -Force -Path $v2rayPath
New-Item -ItemType Directory -Force -Path $configPath
New-Item -ItemType Directory -Force -Path "$configPath\logs"

# Descărcare V2Ray
$v2rayUrl = "https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-windows-64.zip"
$zipPath = "$v2rayPath\v2ray.zip"
Invoke-WebRequest -Uri $v2rayUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $v2rayPath -Force
Remove-Item $zipPath

# Configurare V2Ray
$configJson = @"
{
  "log": {
    "access": "$configPath\\logs\\access.log",
    "error": "$configPath\\logs\\error.log",
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [],
      "decryption": "none",
      "fallbacks": []
    },
    "streamSettings": {
      "network": "tcp",
      "security": "tls",
      "tlsSettings": {
        "alpn": ["http/1.1", "h2"],
        "certificates": [
          {
            "certificateFile": "$configPath\\v2ray.crt",
            "keyFile": "$configPath\\v2ray.key"
          }
        ],
        "minVersion": "1.2"
      }
    },
    "sniffing": {
      "enabled": true,
      "destOverride": ["http", "tls"]
    }
  }],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    }
  ]
}
"@

$configJson | Out-File "$configPath\config.json" -Encoding UTF8

# Generare certificate SSL folosind OpenSSL
Write-Host "Generare certificate SSL..."
$opensslCmd = @"
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 `
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" `
    -keyout $configPath\v2ray.key `
    -out $configPath\v2ray.crt
"@
Invoke-Expression $opensslCmd

# Setare permisiuni pentru certificate
icacls "$configPath\v2ray.key" /inheritance:r
icacls "$configPath\v2ray.key" /grant:r "SYSTEM:(R)" /grant:r "Administrators:(R)"

# Creare și pornire serviciu Windows
$servicePath = "$v2rayPath\v2ray.exe"
if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
    Stop-Service $serviceName
    Remove-Service $serviceName
}

New-Service -Name $serviceName `
    -BinaryPathName "$servicePath -config $configPath\config.json" `
    -DisplayName "V2Ray Service" `
    -Description "V2Ray Proxy Service" `
    -StartupType Automatic

# Pornire serviciu
Start-Service $serviceName

# Deschidere port în firewall
New-NetFirewallRule -DisplayName "V2Ray" `
    -Direction Inbound `
    -Action Allow `
    -Protocol TCP `
    -LocalPort 443

Write-Host "Instalare V2Ray completă!"
Write-Host "Serviciul rulează pe portul 443"
Write-Host "Verificați statusul serviciului cu: Get-Service $serviceName" 