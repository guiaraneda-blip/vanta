import time
import sys

CYAN = "\033[96m"
DIM = "\033[2m"
RESET = "\033[0m"
BOLD = "\033[1m"

def print_slow(text, delay=0.03, color=CYAN):
    for char in text:
        sys.stdout.write(color + char + RESET)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def ok(msg, delay=0.4):
    time.sleep(delay)
    print(f"{CYAN}[ OK ]{RESET} {msg}")

def boot():
    import os
    os.system('clear')
    
    time.sleep(0.5)
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

    ok("Loading kernel...")
    ok("Mounting filesystems...")
    ok("Starting network services...")
    ok("Loading security modules...")
    ok("Initializing SPECTR engine...")
    ok("Loading Vanta environment...")
    
    time.sleep(0.5)
    print()
    print(CYAN + "  " + "─" * 50 + RESET)
    print()
    print_slow("  Welcome to Vanta OS.", delay=0.05)
    time.sleep(0.3)
    print_slow("  Lo ve todo. No lo ve nadie.", delay=0.05, color=DIM+CYAN)
    print()
    time.sleep(1)

if __name__ == "__main__":
    boot()
