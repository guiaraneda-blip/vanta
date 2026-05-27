#!/bin/bash
# VANTA OS — Consolidated Report Generator
# Uso: generate_report.sh <directorio_reporte>
# by GA

CYAN='\033[96m'
GREEN='\033[92m'
RESET='\033[0m'
BOLD='\033[1m'

REPORT_DIR=$1

if [ -z "$REPORT_DIR" ] || [ ! -d "$REPORT_DIR" ]; then
    echo -e "${CYAN}Uso: generate_report.sh <directorio>${RESET}"
    exit 1
fi

TARGET=$(basename $REPORT_DIR | sed 's/_[0-9]*_[0-9]*$//')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
OUTPUT="$REPORT_DIR/VANTA_REPORT.md"

echo -e "${CYAN}[VANTA]${RESET} Generando reporte consolidado..."

cat > $OUTPUT << REPORT
# VANTA OS — Reporte de Seguridad
**Target:** $TARGET
**Fecha:** $TIMESTAMP
**Generado por:** VANTA OS — by GA

---

## Resumen Ejecutivo

REPORT

# Puertos abiertos desde nmap
if [ -f "$REPORT_DIR/nmap.txt" ]; then
    echo "## Puertos y Servicios" >> $OUTPUT
    echo '```' >> $OUTPUT
    grep -E "^[0-9]+/tcp|^[0-9]+/udp" $REPORT_DIR/nmap.txt >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# SPECTR report
if [ -f "$REPORT_DIR/spectr_report.txt" ]; then
    echo "## Análisis SPECTR — CVEs y Exploits" >> $OUTPUT
    echo '```' >> $OUTPUT
    cat $REPORT_DIR/spectr_report.txt >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# Nuclei findings
if [ -f "$REPORT_DIR/nuclei.txt" ] && [ -s "$REPORT_DIR/nuclei.txt" ]; then
    echo "## Vulnerabilidades — Nuclei" >> $OUTPUT
    echo '```' >> $OUTPUT
    cat $REPORT_DIR/nuclei.txt >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# ffuf paths
if [ -f "$REPORT_DIR/ffuf.json" ] && [ -s "$REPORT_DIR/ffuf.json" ]; then
    echo "## Directorios Descubiertos — ffuf" >> $OUTPUT
    echo '```' >> $OUTPUT
    cat $REPORT_DIR/ffuf.json | grep '"url"' | sed 's/.*"url": "\(.*\)".*/\1/' >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# Subdominios
if [ -f "$REPORT_DIR/subdomains.txt" ] && [ -s "$REPORT_DIR/subdomains.txt" ]; then
    echo "## Subdominios" >> $OUTPUT
    echo '```' >> $OUTPUT
    cat $REPORT_DIR/subdomains.txt >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# URLs históricas
if [ -f "$REPORT_DIR/urls.txt" ] && [ -s "$REPORT_DIR/urls.txt" ]; then
    echo "## URLs Históricas (top 50)" >> $OUTPUT
    echo '```' >> $OUTPUT
    head -50 $REPORT_DIR/urls.txt >> $OUTPUT
    echo '```' >> $OUTPUT
    echo "" >> $OUTPUT
fi

# Footer
cat >> $OUTPUT << FOOTER

---
*VANTA OS — Lo ve todo. No lo ve nadie.*
*by GA*
FOOTER

echo -e "${GREEN}[✓] Reporte generado: $OUTPUT${RESET}"
