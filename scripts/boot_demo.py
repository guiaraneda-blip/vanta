import time
import sys
import os

CYAN = "\033[96m"
DIM = "\033[2m"
RESET = "\033[0m"
BOLD = "\033[1m"
WHITE = "\033[97m"
GRAY = "\033[90m"

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

def menu():
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

    while True:
        choice = input(f"  {CYAN}vanta{RESET} » ").strip().lower()
        if choice == "1":
            print()
            print_slow("  Launching SPECTR v1.1...", delay=0.04)
            time.sleep(0.5)
            os.system("bash -c 'cd ~/spectr && source venv/bin/activate && python spectr.py --help'")
            break
        elif choice == "q":
            print()
            print_slow("  Shutting down Vanta OS...", delay=0.04, color=GRAY)
            time.sleep(0.5)
            print()
            break
        else:
            print(f"  {GRAY}Opción no disponible aún.{RESET}")

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
    ok("Initializing SPECTR engine v1.1...")
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
