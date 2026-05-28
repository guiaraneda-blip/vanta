#!/bin/bash
# VANTA OS — Full Installation Script
# Instala todas las herramientas necesarias para bug bounty hunting
# Compatible con Debian/Ubuntu
# by GA

set -e

CYAN='\033[96m'
GREEN='\033[92m'
RED='\033[91m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'

log()   { echo -e "${CYAN}[VANTA]${RESET} $1"; }
ok()    { echo -e "${GREEN}[✓]${RESET} $1"; }
err()   { echo -e "${RED}[✗]${RESET} $1"; }
title() { echo -e "\n${BOLD}${CYAN}▓▒░ $1 ░▒▓${RESET}\n"; }

# ── Root check ──────────────────────────────────────────────
if [ "$EUID" -ne 0 ]; then
    err "Ejecutar como root: sudo bash install.sh"
    exit 1
fi

title "VANTA OS — FULL INSTALL"
log "Iniciando instalación completa de herramientas bug bounty..."

# ── APT base ─────────────────────────────────────────────────
title "Sistema base"
apt update -y && apt upgrade -y
apt install -y \
    curl wget git python3 python3-pip python3-venv \
    nmap masscan nikto sqlmap whatweb wafw00f \
    whois dnsutils netcat-openbsd tmux jq \
    proxychains4 tor responder enum4linux \
    crackmapexec metasploit-framework \
    build-essential libpcap-dev ruby ruby-dev \
    golang-go unzip tar gzip \
    burpsuite \
    seclists
ok "Paquetes APT instalados"

# ── Go tools ─────────────────────────────────────────────────
title "Go tools"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

GO_TOOLS=(
    "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
    "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    "github.com/projectdiscovery/katana/cmd/katana@latest"
    "github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
    "github.com/projectdiscovery/notify/cmd/notify@latest"
    "github.com/projectdiscovery/gau/v2/cmd/gau@latest"
    "github.com/projectdiscovery/anew/cmd/anew@latest"
    "github.com/ffuf/ffuf/v2@latest"
    "github.com/epi052/feroxbuster@latest"
    "github.com/hakluke/hakrawler@latest"
    "github.com/tomnomnom/waybackurls@latest"
    "github.com/tomnomnom/gf@latest"
    "github.com/tomnomnom/getJS@latest"
    "github.com/lukasikic/subzy@latest"
    "github.com/hahwul/dalfox/v2@latest"
    "github.com/lc/gau/v2/cmd/gau@latest"
)

for tool in "${GO_TOOLS[@]}"; do
    name=$(basename ${tool%@*})
    log "Instalando $name..."
    go install $tool 2>/dev/null && ok "$name" || err "$name (fallo, continúa)"
done

# Symlinks Go tools a /usr/local/bin
ln -sf $GOPATH/bin/* /usr/local/bin/ 2>/dev/null
chmod 755 $GOPATH $GOPATH/bin $GOPATH/bin/* 2>/dev/null
ok "Go tools instaladas"

# ── Python tools ─────────────────────────────────────────────
title "Python tools"
pip3 install --break-system-packages \
    theHarvester \
    shodan \
    arjun \
    corsy \
    tplmap \
    ssrfmap \
    jwt_tool \
    impacket \
    trufflehog
ok "Python tools instaladas"

# ── Nuclei templates ─────────────────────────────────────────
title "Nuclei templates"
nuclei -update-templates 2>/dev/null
ok "Nuclei templates actualizados"

# ── GF patterns ──────────────────────────────────────────────
title "GF patterns"
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf/patterns 2>/dev/null || true
ok "GF patterns instalados"

# ── Wordlists ────────────────────────────────────────────────
title "Wordlists"
mkdir -p /opt/wordlists

# SecLists ya viene por APT, symlink
ln -sf /usr/share/seclists /opt/wordlists/seclists 2>/dev/null || true

# RockYou
if [ ! -f /opt/wordlists/rockyou.txt ]; then
    log "Descomprimiendo rockyou.txt..."
    gunzip -c /usr/share/wordlists/rockyou.txt.gz > /opt/wordlists/rockyou.txt 2>/dev/null || true
fi
ok "Wordlists listas en /opt/wordlists"

# ── LinPEAS / WinPEAS ────────────────────────────────────────
title "Post-exploitation tools"
mkdir -p /opt/privesc
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh \
    -o /opt/privesc/linpeas.sh && chmod +x /opt/privesc/linpeas.sh
curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe \
    -o /opt/privesc/winpeas.exe
ok "LinPEAS / WinPEAS en /opt/privesc"

# ── Chisel ───────────────────────────────────────────────────
title "Tunneling tools"
CHISEL_VERSION=$(curl -s https://api.github.com/repos/jpillora/chisel/releases/latest | jq -r .tag_name)
curl -sL "https://github.com/jpillora/chisel/releases/latest/download/chisel_${CHISEL_VERSION#v}_linux_amd64.gz" \
    | gunzip > /usr/local/bin/chisel && chmod +x /usr/local/bin/chisel
ok "Chisel instalado"

# ── Ligolo-ng ────────────────────────────────────────────────
curl -sL https://github.com/nicocha30/ligolo-ng/releases/latest/download/ligolo-ng_agent_linux_amd64.tar.gz \
    | tar -xz -C /usr/local/bin/ 2>/dev/null || true
ok "Ligolo-ng instalado"

# ── SPECTR ───────────────────────────────────────────────────
title "SPECTR"
if [ ! -d /opt/spectr ]; then
    git clone https://github.com/guiaraneda-blip/spectr /opt/spectr
fi
cd /opt/spectr
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Wrapper global
cat > /usr/local/bin/spectr << 'WRAPPER'
#!/bin/bash
source /opt/spectr/venv/bin/activate
python /opt/spectr/spectr.py "$@"
deactivate
WRAPPER
chmod +x /usr/local/bin/spectr
ok "SPECTR instalado globalmente"

# ── vanta-recon script ───────────────────────────────────────
title "vanta-recon pipeline"
cat > /usr/local/bin/vanta-recon << 'VANTA'
#!/bin/bash
# VANTA OS — Automated Recon Pipeline
# Uso: vanta-recon <IP|dominio> [--lang es|en] [--report]

CYAN='\033[96m'
GREEN='\033[92m'
RESET='\033[0m'
BOLD='\033[1m'

TARGET=$1
LANG=${2:-es}
REPORT=${3:-"--report"}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="/opt/vanta/reports/$TIMESTAMP"

mkdir -p $OUTPUT_DIR

echo -e "\n${BOLD}${CYAN}▓▒░ VANTA RECON ░▒▓${RESET}"
echo -e "${CYAN}Target: $TARGET${RESET}\n"

# masscan
echo -e "[1/3] masscan..."
masscan $TARGET -p 1-65535 --rate 1000 -oG $OUTPUT_DIR/masscan.txt 2>/dev/null

# nmap
PORTS=$(grep "open" $OUTPUT_DIR/masscan.txt | awk -F'[ /]' '{print $5}' | sort -u | tr '\n' ',' | sed 's/,$//')
if [ -z "$PORTS" ]; then
    echo "Sin puertos abiertos. Usando top 1000..."
    nmap -sV -sC $TARGET -oN $OUTPUT_DIR/nmap.txt
else
    echo -e "[2/3] nmap en puertos: $PORTS"
    nmap -sV -sC -p $PORTS $TARGET -oN $OUTPUT_DIR/nmap.txt
fi

# SPECTR
echo -e "[3/3] SPECTR..."
spectr $OUTPUT_DIR/nmap.txt --lang $LANG --report --output $OUTPUT_DIR/spectr_report.txt

echo -e "\n${GREEN}✓ Reporte guardado en: $OUTPUT_DIR${RESET}"
VANTA
chmod +x /usr/local/bin/vanta-recon
ok "vanta-recon instalado"

# ── Estructura de reportes ───────────────────────────────────
mkdir -p /opt/vanta/reports
ok "Directorio /opt/vanta/reports creado"

# ── Done ─────────────────────────────────────────────────────
title "INSTALACIÓN COMPLETA"
echo -e "${GREEN}Todas las herramientas instaladas correctamente.${RESET}"
echo -e "${CYAN}Uso: vanta-recon <target>${RESET}"
echo -e "${DIM}by GA — Lo ve todo. No lo ve nadie.${RESET}\n"
