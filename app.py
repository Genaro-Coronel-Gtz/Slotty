import os
import sys
import argparse
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

def list_slots():
    """Listar todos los slots disponibles"""
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
    """Agregar un comando a un slot específico"""
    if not command or "|" not in command:
        console.print("❌ Formato incorrecto. Usa: '<comando> | <descripción>'", style="red")
        return False
    
    # Crear directorio si no existe
    os.makedirs(SLOTS_DIR, exist_ok=True)
    
    slot_path = os.path.join(SLOTS_DIR, f"{slot_name}.txt")
    
    # Verificar si el comando ya existe
    if os.path.exists(slot_path):
        with open(slot_path, 'r', encoding='utf-8', errors='ignore') as f:
            existing_commands = []
            for line in f:
                if '|' in line:
                    cmd = line.split('|', 1)[0].strip()
                    existing_commands.append(cmd)
        
        cmd_part = command.split('|', 1)[0].strip()
        if cmd_part in existing_commands:
            console.print(f"⚠️  El comando '{cmd_part}' ya existe en el slot '{slot_name}'", style="yellow")
            return False
    
    # Agregar el comando
    with open(slot_path, 'a', encoding='utf-8') as f:
        f.write(f"{command}\n")
    
    console.print(f"✅ Comando agregado al slot '{slot_name}'", style="green")
    return True

def delete_command_from_slot(slot_name, command_index):
    """Eliminar un comando específico de un slot"""
    slot_path = os.path.join(SLOTS_DIR, f"{slot_name}.txt")
    
    if not os.path.exists(slot_path):
        console.print(f"❌ El slot '{slot_name}' no existe", style="red")
        return False
    
    with open(slot_path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    if command_index < 0 or command_index >= len(lines):
        console.print("❌ Índice de comando inválido", style="red")
        return False
    
    # Eliminar la línea
    del lines[command_index]
    
    # Reescribir el archivo
    with open(slot_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    console.print(f"✅ Comando eliminado del slot '{slot_name}'", style="green")
    return True

def interactive_delete():
    """Interfaz interactiva para eliminar comandos"""
    active_env = os.getenv("SLOTTY_ACTIVE", "")
    if not active_env:
        console.print("❌ No hay slots activos. Usa 'plug <nombre>' primero.", style="red")
        return
    
    slots = active_env.split(",")
    all_commands = []
    
    # Cargar todos los comandos con su información
    for slot in slots:
        path = os.path.join(SLOTS_DIR, f"{slot}.txt")
        if os.path.exists(path):
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                for line_num, line in enumerate(f):
                    line = line.replace('\r', '').strip()
                    if "|" in line:
                        parts = [x.strip() for x in line.split("|", 1)]
                        if len(parts) >= 2:
                            cmd, desc = parts
                            all_commands.append({
                                'slot': slot,
                                'line_num': line_num,
                                'cmd': cmd,
                                'desc': desc,
                                'display': f"{cmd}  -->  {desc} [{slot.upper()}]"
                            })
    
    if not all_commands:
        console.print("❌ No hay comandos para eliminar", style="red")
        return
    
    # Mostrar menú de eliminación
    console.print("🗑️  Eliminar comando:", style="bold red")
    
    choices = []
    for cmd_info in all_commands:
        choices.append(Choice(
            value=cmd_info, 
            name=cmd_info['display']
        ))
    
    try:
        selected = inquirer.fuzzy(
            message="Selecciona comando para eliminar (ESC para cancelar):",
            choices=choices,
            border=True,
            vi_mode=False,
            instruction=""
        ).execute()

        for _ in range(3):
            sys.stdout.write("\033[A\033[K")
            sys.stdout.flush()
                
        
        if selected:
            # Confirmar eliminación
            confirm = inquirer.confirm(
                f"¿Eliminar '{selected['cmd']}' del slot '{selected['slot']}'?",
                default=False
            ).execute()
            
            if confirm:
                if delete_command_from_slot(selected['slot'], selected['line_num']):
                    console.print("✅ Comando eliminado exitosamente", style="green")
                else:
                    console.print("❌ Error al eliminar comando", style="red")
            else:
                console.print("❌ Eliminación cancelada", style="yellow")
        else:
            console.print("❌ Operación cancelada", style="yellow")
            
    except (KeyboardInterrupt, EOFError):
        console.print("\n❌ Operación cancelada", style="yellow")

def main():
    parser = argparse.ArgumentParser(description='Sistema de gestión de comandos Slotty')
    parser.add_argument('--list-slots', action='store_true', help='Listar todos los slots disponibles')
    parser.add_argument('--add-command', type=str, help='Agregar comando: "<comando> | <descripción>"')
    parser.add_argument('--to', type=str, help='Nombre del slot donde agregar el comando')
    parser.add_argument('--delete', action='store_true', help='Modo interactivo para eliminar comandos')
    
    args = parser.parse_args()
    
    # Procesar argumentos
    if args.list_slots:
        list_slots()
        return
    
    if args.add_command:
        if not args.to:
            console.print("❌ Debes especificar un slot con --to <nombre>", style="red")
            return
        add_command(args.add_command, args.to)
        return
    
    if args.delete:
        interactive_delete()
        return
    
    # Modo normal (interfaz fuzzy)
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
        # Manejar ESC y Ctrl+C
        console.print("\n❌ Operación cancelada", style="yellow")
        if tmp_path and os.path.exists(tmp_path):
            with open(tmp_path, "w") as f: f.write("")
        sys.exit(0)
    except Exception as e:
        # Si hay otros errores (problemas de TTY), mostrar mensaje
        console.print(f"\n⚠️  Error en la interfaz: {e}", style="red")
        console.print("💡 Intenta ejecutar slotty directamente sin F10", style="yellow")
        if tmp_path and os.path.exists(tmp_path):
            with open(tmp_path, "w") as f: f.write("")
        sys.exit(1)

if __name__ == "__main__":
    main()