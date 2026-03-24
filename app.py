import os
import sys
import argparse
import subprocess

SLOTS_DIR = os.path.expanduser("~/.slotty/slots/")

def clear_slotty_from_history():
    """Elimina el comando 'slotty' del historial de shell"""
    # Obtener la ruta del historial dinámicamente del sistema
    try:
        result = subprocess.run(['echo', '$HISTFILE'], shell=True, capture_output=True, text=True)
        histfile = result.stdout.strip() if result.stdout else ""
        
        # Si no está definido, intentar rutas comunes
        if not histfile or histfile == '$HISTFILE':
            home = os.path.expanduser("~")
            possible_paths = [
                os.path.join(home, ".zsh_history"),
                os.path.join(home, ".bash_history"),
                os.path.join(home, ".history")
            ]
            for path in possible_paths:
                if os.path.exists(path):
                    histfile = path
                    break
    except Exception:
        # Si falla la obtención, intentar rutas comunes
        home = os.path.expanduser("~")
        histfile = os.path.join(home, ".zsh_history")
    
    if histfile and os.path.exists(histfile):
        try:
            # Leer el historial
            with open(histfile, 'r') as f:
                lines = f.readlines()
            
            # Filtrar líneas que contengan 'slotty'
            filtered_lines = [line for line in lines if 'slotty' not in line]
            
            # Escribir el historial filtrado
            with open(histfile, 'w') as f:
                f.writelines(filtered_lines)
            
            # Recargar el historial en la sesión actual
            subprocess.run(['fc', '-R'], check=False, capture_output=True)
        except Exception:
            # Si falla, no hacer nada para no interrumpir el flujo
            pass

def list_slots():
    """Lista los slots disponibles con lazy loading"""
    from rich.console import Console  # Import local
    
    console = Console()
    slots = []
    
    if not os.path.exists(SLOTS_DIR):
        console.print(" No hay slots creados aún.", style="red")
        return
    
    console.print("Slots disponibles:", style="bold blue")
    for filename in os.listdir(SLOTS_DIR):
        if filename.endswith(".txt"):
            slot_name = filename[:-4]
            filepath = os.path.join(SLOTS_DIR, filename)
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                count = sum(1 for line in f if "|" in line)
            slots.append((slot_name, count))
    
    for slot_name, count in sorted(slots):
        console.print(f"  • {slot_name} ({count} comandos)", style="green")

def add_command(command, slot):
    """Agrega un comando a un slot específico con lazy loading"""
    from rich.console import Console  # Import local
    
    console = Console()
    if "|" not in command:
        console.print(" Error: El comando debe tener el formato 'comando | descripción'", style="red")
        return
    
    if not slot:
        console.print(" Error: Debes especificar un slot con --to", style="red")
        return
    
    slot_file = os.path.join(SLOTS_DIR, f"{slot}.txt")
    os.makedirs(SLOTS_DIR, exist_ok=True)
    
    with open(slot_file, "a", encoding="utf-8") as f:
        f.write(f"\n{command}")
    
    console.print(f" ✅ Comando agregado a '{slot}'", style="green")

def load_commands(console):
    """Carga comandos con lazy loading de InquirerPy"""
    from InquirerPy.base.control import Choice  # Import local
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
                        command, description = parts
                        display_text = f"{command[:terminal_width-20]:<20} | {description[:terminal_width-35]:<35}"
                        choices.append(Choice(value=command, name=display_text))
    return choices

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
            instruction="",
            keybindings={
                "interrupt": [
                    {"key": "c-c"},  # Mantiene Ctrl+C por defecto
                    {"key": "escape"}  # Agrega Escape como opción adicional
                ]
            }
        ).execute()

        if tmp_path and selected:
            with open(tmp_path, "w") as f:
                f.write(selected)
            for _ in range(3): sys.stdout.write("\033[A\033[K")
            sys.stdout.flush()
            
            # Limpiar 'slotty' del historial
            clear_slotty_from_history()
            
                
    except (KeyboardInterrupt, EOFError):
        sys.exit(0)

if __name__ == "__main__":
    main()