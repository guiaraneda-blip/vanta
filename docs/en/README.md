# Vanta OS — Documentation

## What is Vanta?

Vanta OS is a Debian-based Linux distribution designed for cybersecurity students and professionals looking for a guided, minimal, and powerful pentesting environment.

Unlike other distros that overwhelm users with hundreds of tools, Vanta focuses on a clear workflow — powered by SPECTR as its core engine.

---

## Minimum Requirements

| Component | Minimum |
|---|---|
| CPU | 64-bit dual core |
| RAM | 4GB |
| Storage | 30GB |
| Architecture | x86_64 |

---

## Installation

> Coming soon — ISO under development.

Vanta OS will be di
cat > tools/README.md << 'EOF'
# Vanta OS — Tools

Vanta incluye una selección curada de herramientas esenciales para pentesting.
Cada tool tiene un propósito claro dentro del workflow.

---

## Reconocimiento
| Tool | Propósito |
|---|---|
| nmap | Escaneo de puertos y detección de servicios |
| masscan | Escaneo rápido de puertos a gran escala |
| whois | Información de dominios |
| dig | Consultas DNS |
| theHarvester | OSINT — emails, subdominios, IPs |

## Análisis y explotación
| Tool | Propósito |
|---|---|
| searchsploit | Búsqueda de exploits en Exploit-DB |
| metasploit | Framework de explotación |
| burpsuite | Análisis de tráfico web |
| sqlmap | Detección de SQL injection |

## Post-explotación
| Tool | Propósito |
|---|---|
| netcat | Conexiones y shells reversas |
| john | Cracking de contraseñas |
| hashcat | Cracking de hashes por GPU |

## Core — SPECTR
| Tool | Propósito |
|---|---|
| spectr | Pipeline completo: recon → CVEs → exploits → reporte |

---

> Esta lista es parte del roadmap. Las tools se integran progresivamente.
