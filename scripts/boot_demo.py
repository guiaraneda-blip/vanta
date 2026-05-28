import time
import sys
import os

CYAN  = "\033[96m"
DIM   = "\033[2m"
RESET = "\033[0m"
BOLD  = "\033[1m"
WHITE = "\033[97m"
GRAY  = "\033[90m"

def print_slow(text, delay=0.03, color=CYAN):
    for char in text:
        sys.stdout.write(color + char + RESET)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def ok(msg, delay=0.3):
    time.sleep(delay)
    print(f"  {CYAN}[ OK ]{RESET}  {WHITE}{msg}{RESET}")

def fail(msg, delay=0.3):
    time.sleep(delay)
    print(f"  {CYAN}[WARN]{RESET}  {GRAY}{msg}{RESET}")

def progress_bar(duration=2.5):
    width = 40
    steps = 40
    interval = duration / steps
    sys.stdout.write("  " + CYAN)
    for i in range(steps):
        sys.stdout.write("█")
        sys.stdout.flush()
        time.sleep(interval)
    sys.stdout.write(RESET + "\n")

def menu_exploitation():
    print()
    print(CYAN + BOLD + "  Exploitation Tools" + RESET)
    print(CYAN + "  " + "─" * 40 + RESET)
    print(f"  {CYAN}[1]{RESET}  {WHITE}Metasploit Framework{RESET}")
    print(f"  {CYAN}[2]{RESET}  {WHITE}SQLMap{RESET}")
    print(f"  {CYAN}[3]{RESET}  {WHITE}Dalfox (XSS){RESET}")
    print(f"  {CYAN}[4]{RESET}  {WHITE}Nuclei{RESET}")
    print()
    sub = input(f"  {CYAN}vanta{RESET} » ").strip()
    if sub == "1":
        os.system("msfconsole")
    elif sub == "2":
        url = input(f"  {CYAN}URL objetivo{RESET} » ").strip()
        cookie = input(f"  {CYAN}Cookie (ej: PHPSESSID=abc;security=low){RESET} » ").strip()
        from urllib.parse import urlparse
        import csv, glob
        target = urlparse(url).netloc or urlparse(url).path.split("/")[0]
        output_dir = f"/opt/vanta/reports/sqlmap_{target}"
        os.makedirs(output_dir, exist_ok=True)
        if cookie:
            os.system(f"sqlmap -u '{url}' --cookie='{cookie}' --dbs --dump-all --batch --output-dir='{output_dir}'")
        else:
            os.system(f"sqlmap -u '{url}' --dbs --dump-all --batch --output-dir='{output_dir}'")
        # Parsear credenciales
        print()
        print(f"\033[96m{'='*50}\033[0m")
        print(f"\033[96m  CREDENCIALES ENCONTRADAS\033[0m")
        print(f"\033[96m{'='*50}\033[0m")
        found = False
        sqlmap_default = f"/home/ignacio/.local/share/sqlmap/output/{target}/dump"
        for csv_file in glob.glob(f"{sqlmap_default}/**/*.csv", recursive=True):
            try:
                with open(csv_file) as f2:
                    reader = csv.DictReader(f2)
                    for row in reader:
                        user = row.get("user") or row.get("username") or row.get("login") or "?"
                        pwd = row.get("password") or row.get("pass") or "?"
                        print(f"  \033[92m[+]\033[0m {user} : {pwd}")
                        found = True
            except:
                pass
        if not found:
            print(f"  \033[93m[!] No se encontraron credenciales en los CSVs\033[0m")
        print(f"\033[96m{'='*50}\033[0m")
        print()
    elif sub == "3":
        url = input(f"  {CYAN}URL objetivo{RESET} » ").strip()
        os.system(f"dalfox url {url}")
    elif sub == "4":
        target = input(f"  {CYAN}Target{RESET} » ").strip()
        os.system(f"nuclei -u {target} -severity critical,high,medium")
    print()
    input(f"  {GRAY}Enter para volver al menú...{RESET}")

def menu_postexploit():
    print()
    print(CYAN + BOLD + "  Post-Exploitation Tools" + RESET)
    print(CYAN + "  " + "─" * 40 + RESET)
    print(f"  {CYAN}[1]{RESET}  {WHITE}LinPEAS{RESET}")
    print(f"  {CYAN}[2]{RESET}  {WHITE}Chisel (tunneling){RESET}")
    print(f"  {CYAN}[3]{RESET}  {WHITE}Ligolo-ng (pivoting){RESET}")
    print()
    sub = input(f"  {CYAN}vanta{RESET} » ").strip()
    if sub == "1":
        os.system("bash /opt/privesc/linpeas.sh")
    elif sub == "2":
        os.system("chisel --help")
    elif sub == "3":
        os.system("ligolo-ng --help 2>/dev/null || echo 'ligolo-ng no encontrado'")
    print()
    input(f"  {GRAY}Enter para volver al menú...{RESET}")

def menu_reports():
    print()
    print(CYAN + BOLD + "  Reports" + RESET)
    print(CYAN + "  " + "─" * 40 + RESET)
    reports_dir = "/opt/vanta/reports"
    if os.path.exists(reports_dir):
        reports = sorted(os.listdir(reports_dir))
        if reports:
            for i, r in enumerate(reports, 1):
                print(f"  {CYAN}[{i}]{RESET}  {WHITE}{r}{RESET}")
        else:
            print(f"  {GRAY}No hay reportes aún.{RESET}")
    else:
        print(f"  {GRAY}Directorio /opt/vanta/reports no encontrado.{RESET}")
    print()
    input(f"  {GRAY}Enter para volver...{RESET}")

def menu():
    while True:
        os.system('clear')
        print()
        print(CYAN + BOLD + "  VANTA OS — Main Menu" + RESET)
        print(CYAN + "  " + "─" * 40 + RESET)
        print()
        print(f"  {CYAN}[1]{RESET}  {WHITE}Launch SPECTR{RESET}")
        print(f"  {CYAN}[2]{RESET}  {WHITE}Network Recon{RESET}")
        print(f"  {CYAN}[3]{RESET}  {WHITE}Exploitation Tools{RESET}")
        print(f"  {CYAN}[4]{RESET}  {WHITE}Post-Exploitation{RESET}")
        print(f"  {CYAN}[5]{RESET}  {WHITE}Reports{RESET}")
        print(f"  {CYAN}[q]{RESET}  {GRAY}Exit{RESET}")
        print()
        print(CYAN + "  " + "─" * 40 + RESET)
        print()
        choice = input(f"  {CYAN}vanta{RESET} » ").strip().lower()

        if choice == "1":
            print()
            print_slow("  Launching SPECTR v1.2...", delay=0.04)
            time.sleep(0.5)
            os.system("spectr --help")
            print()
            input(f"  {GRAY}Enter para volver al menú...{RESET}")

        elif choice == "2":
            print()
            target = input(f"  {CYAN}Target (IP/dominio){RESET} » ").strip()
            if target:
                print_slow(f"  Launching vanta-recon against {target}...", delay=0.04)
                time.sleep(0.5)
                os.system(f"vanta-recon {target}")
                print()
                input(f"  {GRAY}Enter para volver al menú...{RESET}")

        elif choice == "3":
            menu_exploitation()

        elif choice == "4":
            menu_postexploit()

        elif choice == "5":
            menu_reports()

        elif choice == "q":
            print()
            print_slow("  Shutting down Vanta OS...", delay=0.04, color=GRAY)
            time.sleep(0.5)
            print()
            break

        else:
            print(f"  {GRAY}Opción inválida.{RESET}")
            time.sleep(1)

def boot():
    os.system('clear')
    time.sleep(0.3)
    print()
    print(CYAN + BOLD)
    print("  ██╗   ██╗ █████╗ ███╗   ██╗████████╗ █████╗ ")
    print("  ██║   ██║██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗")
    print("  ██║   ██║███████║██╔██╗ ██║   ██║   ███████║")
    print("  ╚██╗ ██╔╝██╔══██║██║╚██╗██║   ██║   ██╔══██║")
    print("   ╚████╔╝ ██║  ██║██║ ╚████║   ██║   ██║  ██║")
    print("    ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝")
    print(RESET)
    print(CYAN + DIM + "              O P E R A T I N G   S Y S T E M" + RESET)
    print(CYAN + DIM + "                    v0.1.0  —  by GA" + RESET)
    print()
    print(CYAN + "  " + "─" * 50 + RESET)
    print()
    time.sleep(1)
    progress_bar(duration=2)
    print()
    ok("Loading kernel modules...")
    ok("Mounting filesystems...")
    ok("Starting network services...")
    ok("Loading security modules...")
    ok("Loading encryption layer...")
    fail("Checking for updates... skipped (offline mode)")
    ok("Initializing SPECTR engine v1.2...")
    ok("Loading Vanta environment...")
    time.sleep(0.5)
    print()
    print(CYAN + "  " + "─" * 50 + RESET)
    print()
    print_slow("  Welcome to Vanta OS.", delay=0.05)
    time.sleep(0.3)
    print_slow("  Lo ve todo. No lo ve nadie.", delay=0.05, color=DIM+CYAN)
    print()
    time.sleep(1.5)
    menu()

if __name__ == "__main__":
    boot()
