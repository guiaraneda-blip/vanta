# Vanta OS — Configuraciones

Vanta OS viene preconfigurado con ajustes de seguridad por defecto.
Cada configuración tiene un propósito claro dentro del workflow de pentesting.

---

## XFCE Desktop
- Tema oscuro por defecto
- Terminal con fuente monospace
- Wallpaper Vanta OS
- Panel minimalista

## Seguridad base (hardening)
- Firewall UFW activado por defecto
- SSH desactivado por defecto
- IPv6 desactivado
- Actualizaciones automáticas de seguridad

## Red
- NetworkManager configurado
- Modo monitor disponible para interfaces wireless
- MAC address randomization activado

## Terminal
- ZSH como shell por defecto
- Prompt personalizado con colores Vanta
- Aliases preconfigurados:
  - `scan` → lanza SPECTR
  - `recon` → pipeline masscan + nmap + SPECTR
  - `report` → abre último reporte generado

## SPECTR
- Instalado globalmente en /usr/local/bin/spectr
- Idioma por defecto: español
- Reportes guardados en ~/vanta/reports/
