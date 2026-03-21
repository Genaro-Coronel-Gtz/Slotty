import os
import sys
import argparse

SLOTS_DIR = os.path.expanduser("~/.slotty/slots/")

def load_commands(console):
    from InquirerPy.base.control import Choice # Import local
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

def list_slots():
    from rich.console import Console
    console = Console()
    if not os.path.exists(SLOTS_DIR):
        console.print("❌ No hay slots creados aún.", style="red")
        return
    
    slots = []
    for file in os.listdir(SLOTS_DIR):
        if file.endswith('.txt'):
            slot_name = file[:-4]
            slot_path = os.path.join(SLOTS_DIR, file)
            with open(slot_path, 'r', encoding='utf-8', errors='ignore') as f:
                commands = len([line for line in f if '|' in line])
            slots.append((slot_name, commands))
    
    if not slots:
        console.print("❌ No hay slots creados aún.", style="red")
        return
    
    console.print("📋 Slots disponibles:", style="bold blue")
    for slot_name, count in sorted(slots):
        console.print(f"  • {slot_name} ({count} comandos)", style="green")

def add_command(command, slot_name):
    from rich.console import Console
    console = Console()
    if not command or "|" not in command:
        console.print("❌ Formato incorrecto. Usa: '<comando> | <descripción>'", style="red")
        return False
    
    os.makedirs(SLOTS_DIR, exist_ok=True)
    slot_path = os.path.join(SLOTS_DIR, f"{slot_name}.txt")
    
    if os.path.exists(slot_path):
        with open(slot_path, 'r', encoding='utf-8', errors='ignore') as f:
            existing_commands = [line.split('|', 1)[0].strip() for line in f if '|' in line]
        
        cmd_part = command.split('|', 1)[0].strip()
        if cmd_part in existing_commands:
            console.print(f"⚠️  El comando '{cmd_part}' ya existe en el slot '{slot_name}'", style="yellow")
            return False
    
    with open(slot_path, 'a', encoding='utf-8') as f:
        f.write(f"{command}\n")
    
    console.print(f"✅ Comando agregado al slot '{slot_name}'", style="green")
    return True

# ... (Misma lógica de importación local para delete_command_from_slot e interactive_delete)

def main():
    parser = argparse.ArgumentParser(description='Sistema de gestión de comandos Slotty')
    parser.add_argument('--list-slots', action='store_true')
    parser.add_argument('--add-command', type=str)
    parser.add_argument('--to', type=str)
    parser.add_argument('--delete', action='store_true')
    
    args = parser.parse_args()
    
    if args.list_slots:
        list_slots()
        return
    
    if args.add_command:
        add_command(args.add_command, args.to)
        return

    # Si llegamos aquí, cargamos lo pesado para el modo interactivo
    from rich.console import Console
    from InquirerPy import inquirer
    console = Console()

    if args.delete:
        # Mover la lógica de interactive_delete aquí o importar dentro
        return

    tmp_path = os.getenv("SLOTTY_TMP_FILE")
    commands = load_commands(console)
    
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

        if tmp_path and selected:
            with open(tmp_path, "w") as f:
                f.write(selected)
            for _ in range(3): sys.stdout.write("\033[A\033[K")
            sys.stdout.flush()
                
    except (KeyboardInterrupt, EOFError):
        sys.exit(0)

if __name__ == "__main__":
    main()