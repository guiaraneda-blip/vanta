# Vanta OS — Documentación

## ¿Qué es Vanta?

Vanta OS es una distribución Linux basada en Debian, diseñada para estudiantes y profesionales de ciberseguridad que buscan un entorno guiado, minimalista y potente para hacer pentesting.

A diferencia de otras distros que abruman con cientos de herramientas, Vanta se enfoca en un workflow claro — con SPECTR como motor principal.

---

## Requisitos mínimos

| Componente | Mínimo |
|---|---|
| CPU | 64-bit dual core |
| RAM | 4GB |
| Almacenamiento | 30GB |
| Arquitectura | x86_64 |

---

## Instalación

> Próximamente — ISO en desarrollo.

Vanta OS será distribuido como imagen ISO booteable, compatible con:
- Instalación en máquina física
- Dual boot con Windows 10/11
- Máquina virtual (VirtualBox, VMware)
- USB live boot

---

## SPECTR — Motor principal

SPECTR es la herramienta central de Vanta OS. Disponible globalmente desde el terminal:

    spectr scan.txt --lang es --report
    spectr scan.txt --masscan --lang en

Más información: [github.com/guiaraneda-blip/spectr](https://github.com/guiaraneda-blip/spectr)

---

## Filosofía

- **Workflow first** — cada tool tiene un propósito claro
- **Bilingüe** — español e inglés nativos
- **Minimalista** — sin ruido, sin bloat
- **Para estudiantes** — construido por uno, para todos
