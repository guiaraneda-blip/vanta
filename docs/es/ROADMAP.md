# VANTA OS — Roadmap Completo

## Visión
Bootear Vanta OS, abrir terminal, ingresar un scope (dominio o IP),
y que el sistema ejecute automáticamente el pipeline completo de
recon → análisis → reporte, sin intervención manual.

## Stack técnico
- OS base: Debian + XFCE
- Shell: bash/zsh
- Lenguaje principal: Python 3
- Recon tools: masscan, nmap, (Fase 2)
- Pipeline: masscan → nmap → SPECTR → reporte
- Dev environment: Kali WSL en Windows 11

## Fases

### Fase 1 — Base ✅
- Repo estructurado
- Branding definido (#000000 + #00FFFF)
- boot_demo.py funcional
- spectr_demo.sh funcional

### Fase 2 — Tools curadas (ACTUAL)
- Lista de herramientas esenciales para bug bounty
- Script install.sh automatizado para Debian
- Sin bloat — solo lo que se usa en bug bounty real

### Fase 3 — SPECTR integrado globalmente
- SPECTR disponible como /usr/local/bin/spectr
- Accesible desde cualquier terminal

### Fase 3.5 — Pipeline de automatización
- Script vanta-recon <scope>
- Ejecuta: masscan → nmap → SPECTR automáticamente
- Output a reporte bilingüe ES/EN
- Configurable: puertos, intensidad, formato

### Fase 4 — ISO booteable
- Debian + XFCE base
- Branding en GRUB, login screen, wallpaper
- Dual boot Windows 11
- Tools y pipeline preinstalados

### Fase 5 — Lanzamiento público
- DistroWatch submission
- Reddit r/linux y r/netsec
- LinkedIn demo del pipeline funcionando
