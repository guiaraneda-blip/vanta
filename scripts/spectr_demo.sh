#!/bin/bash
# Vanta OS — SPECTR Live Demo
# by GA

CYAN='\033[96m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

clear

echo
echo -e "${CYAN}${BOLD}  VANTA OS — SPECTR Live Demo${RESET}"
echo -e "${CYAN}  ──────────────────────────────────────${RESET}"
echo
echo -e "${DIM}  Este demo ejecuta un scan real contra un target local.${RESET}"
echo -e "${DIM}  Solo usar en redes propias o con permiso explícito.${RESET}"
echo
echo -e "${CYAN}  ──────────────────────────────────────${RESET}"
echo

read -p "  Target IP o dominio: " TARGET

if [ -z "$TARGET" ]; then
    echo -e "${CYAN}  [ERROR]${RESET} No ingresaste un target."
    exit 1
fi

echo
echo -e "${CYAN}  [1/3]${RESET} Ejecutando nmap contra $TARGET..."
nmap -sV "$TARGET" -oN /tmp/vanta_scan.txt 2>/dev/null

echo
echo -e "${CYAN}  [2/3]${RESET} Analizando con SPECTR..."
cd ~/spectr && source venv/bin/activate && python spectr.py /tmp/vanta_scan.txt --lang es --report

echo
echo -e "${CYAN}  [3/3]${RESET} Reporte guardado."
echo
echo -e "${CYAN}  ──────────────────────────────────────${RESET}"
echo -e "${DIM}  Vanta OS — Lo ve todo. No lo ve nadie.${RESET}"
echo
