import os
import sys
from InquirerPy import inquirer
from InquirerPy.base.control import Choice
from rich.console import Console

console = Console()
SLOTS_DIR = os.path.expanduser("~/.slotty/slots/")

def load_commands():
    active_env = os.getenv("SLOTTY_ACTIVE", "")
    if not active_env: return []
    
    slots = active_env.split(",")
    choices = []
    terminal_width = console.width - 6

    for slot in slots:
        path = os.path.join(SLOTS_DIR, f"{slot}.txt")
        if os.path.exists(path):
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                for line in f:
                    line = line.replace('\r', '').strip()
                    if "|" in line:
                        parts = [x.strip() for x in line.split("|", 1)]
                        if len(parts) < 2: continue
                        cmd, desc = parts
                        left = f"{cmd}  -->  {desc}"
                        right = f"[{slot.upper()}]"
                        padding = terminal_width - len(left) - len(right)
                        full_line = f"{left}{' ' * max(2, padding)}{right}"
                        choices.append(Choice(value=cmd, name=full_line))
    return choices

def main():
    tmp_path = os.getenv("SLOTTY_TMP_FILE")
    commands = load_commands()
    
    if not commands:
        return

    try:
        selected = inquirer.fuzzy(
            message="Slotty Buscar:",
            choices=commands,
            border=True,
            vi_mode=False,
            instruction=""
        ).execute()

        if tmp_path:
            with open(tmp_path, "w") as f:
                if selected:
                    f.write(selected)
                else:
                    f.write("")
            

            for _ in range(3):
                sys.stdout.write("\033[A\033[K")
            sys.stdout.flush()
                
    except (KeyboardInterrupt, EOFError):
        if tmp_path and os.path.exists(tmp_path):
            with open(tmp_path, "w") as f: f.write("")
        sys.exit(0)

if __name__ == "__main__":
    main()