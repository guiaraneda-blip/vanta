#!/bin/bash
# VANTA OS — Automated Recon Pipeline v1.0
# Uso: vanta-recon <IP|dominio>
# by GA — Lo ve todo. No lo ve nadie.

CYAN='\033[96m'
GREEN='\033[92m'
RED='\033[91m'
DIM='\033[2m'
RESET='\033[0m'
BOLD='\033[1m'
YELLOW='\033[93m'

TARGET=$1
LANG_OPT=${2:-es}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="/opt/vanta/reports/${TARGET}_${TIMESTAMP}"

if [ -z "$TARGET" ]; then
    echo -e "${RED}[✗] Uso: vanta-recon <IP|dominio>${RESET}"
    exit 1
fi

mkdir -p $OUTPUT_DIR

echo -e "\n${BOLD}${CYAN}▓▒░ VANTA RECON v1.0 ░▒▓${RESET}"
echo -e "${DIM}Target: $TARGET | Output: $OUTPUT_DIR${RESET}\n"

if [[ $TARGET =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    MODE="ip"
else
    MODE="domain"
fi

echo -e "${CYAN}[*] Modo: $MODE${RESET}\n"

echo -e "${BOLD}[1/5] Port Scanning${RESET}"
sudo masscan $TARGET -p 1-65535 --rate 1000 -oG $OUTPUT_DIR/masscan.txt 2>/dev/null
PORTS=$(grep "open" $OUTPUT_DIR/masscan.txt 2>/dev/null | awk -F'[ /]' '{print $5}' | sort -u | tr '\n' ',' | sed 's/,$//')

if [ -z "$PORTS" ]; then
    echo -e "${YELLOW}  → masscan sin resultados, usando top 1000${RESET}"
    nmap -sV -sC $TARGET -oN $OUTPUT_DIR/nmap.txt 2>/dev/null
else
    echo -e "${DIM}  → nmap en puertos: $PORTS${RESET}"
    nmap -sV -sC -p $PORTS $TARGET -oN $OUTPUT_DIR/nmap.txt 2>/dev/null
fi
echo -e "${GREEN}  [✓] Port scan completo${RESET}"

echo -e "\n${BOLD}[2/5] SPECTR Analysis${RESET}"
spectr $OUTPUT_DIR/nmap.txt --lang $LANG_OPT --report --output $OUTPUT_DIR/spectr_report.txt
echo -e "${GREEN}  [✓] SPECTR completo${RESET}"

if [ "$MODE" == "domain" ]; then
    echo -e "\n${BOLD}[3/5] Domain Recon${RESET}"
    subfinder -d $TARGET -silent -o $OUTPUT_DIR/subdomains.txt 2>/dev/null
    SUBDOMAIN_COUNT=$(wc -l < $OUTPUT_DIR/subdomains.txt 2>/dev/null || echo 0)
    echo -e "${GREEN}  [✓] $SUBDOMAIN_COUNT subdominios${RESET}"

    httpx -l $OUTPUT_DIR/subdomains.txt -silent -o $OUTPUT_DIR/live_hosts.txt 2>/dev/null
    LIVE_COUNT=$(wc -l < $OUTPUT_DIR/live_hosts.txt 2>/dev/null || echo 0)
    echo -e "${GREEN}  [✓] $LIVE_COUNT hosts activos${RESET}"

    waybackurls $TARGET 2>/dev/null | anew $OUTPUT_DIR/urls.txt > /dev/null
    URL_COUNT=$(wc -l < $OUTPUT_DIR/urls.txt 2>/dev/null || echo 0)
    echo -e "${GREEN}  [✓] $URL_COUNT URLs históricas${RESET}"
else
    echo -e "\n${BOLD}[3/5] Domain Recon${RESET}"
    echo -e "${DIM}  → Saltado (target es IP)${RESET}"
fi

echo -e "\n${BOLD}[4/5] Vulnerability Scanning${RESET}"
if [ "$MODE" == "domain" ] && [ -f $OUTPUT_DIR/live_hosts.txt ]; then
    nuclei -l $OUTPUT_DIR/live_hosts.txt -severity critical,high,medium -silent -o $OUTPUT_DIR/nuclei.txt 2>/dev/null
else
    nuclei -u http://$TARGET -severity critical,high,medium -silent -o $OUTPUT_DIR/nuclei.txt 2>/dev/null
fi
VULN_COUNT=$(wc -l < $OUTPUT_DIR/nuclei.txt 2>/dev/null || echo 0)
echo -e "${GREEN}  [✓] $VULN_COUNT vulnerabilidades nuclei${RESET}"

echo -e "\n${BOLD}[5/5] Directory Fuzzing${RESET}"
WORDLIST="/usr/share/seclists/Discovery/Web-Content/common.txt"
[ ! -f "$WORDLIST" ] && WORDLIST="/usr/share/dirb/wordlists/common.txt"
ffuf -u http://$TARGET/FUZZ -w $WORDLIST -mc 200,301,302,403 -s -o $OUTPUT_DIR/ffuf.json -of json 2>/dev/null
FUZZ_COUNT=$(cat $OUTPUT_DIR/ffuf.json 2>/dev/null | grep -c '"status"' || echo 0)
echo -e "${GREEN}  [✓] $FUZZ_COUNT paths encontrados${RESET}"

echo -e "\n${BOLD}${CYAN}▓▒░ RESUMEN ░▒▓${RESET}"
echo -e "${CYAN}Target:${RESET}        $TARGET"
echo -e "${CYAN}Modo:${RESET}          $MODE"
[ -f $OUTPUT_DIR/subdomains.txt ] && echo -e "${CYAN}Subdominios:${RESET}   $SUBDOMAIN_COUNT"
[ -f $OUTPUT_DIR/live_hosts.txt ] && echo -e "${CYAN}Hosts activos:${RESET} $LIVE_COUNT"
echo -e "${CYAN}Vulns nuclei:${RESET}  $VULN_COUNT"
echo -e "${CYAN}Paths ffuf:${RESET}    $FUZZ_COUNT"
echo -e "${CYAN}Reportes en:${RESET}   $OUTPUT_DIR"
echo -e "\n${GREEN}✓ Recon completado.${RESET}"
echo -e "${DIM}by GA — Lo ve todo. No lo ve nadie.${RESET}\n"
