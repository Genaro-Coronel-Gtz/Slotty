# Nuevos Comandos de Slotty

## Comandos Disponibles

### 1. Listar Slots
```bash
slotty_list
# o
python3 /Users/genaro_coronel/Lab/Slotty/app.py --list-slots
```
Muestra todos los slots disponibles con el número de comandos en cada uno.

### 2. Agregar Comando
```bash
slotty_add '<comando> | <descripción>' <slot>
# o
python3 /Users/genaro_coronel/Lab/Slotty/app.py --add-command '<comando> | <descripción>' --to <slot>
```

Ejemplos:
```bash
slotty_add 'docker ps -a | Listar todos los contenedores' docker
slotty_add 'git status | Ver estado del repositorio' git
```

### 3. Eliminar Comando
```bash
slotty_delete
# o
python3 /Users/genaro_coronel/Lab/Slotty/app.py --delete
```
Abre una interfaz interactiva para seleccionar y eliminar comandos.

### 4. Salir con ESC
En la interfaz fuzzy normal, presiona `ESC` para cancelar y salir.

## Características

✅ **Validación automática** - No permite comandos duplicados
✅ **Confirmación de eliminación** - Pide confirmación antes de borrar
✅ **Interfaz amigable** - Usa colores y emojis para mejor UX
✅ **Manejo de errores** - Mensajes claros para errores comunes

## Ejemplos de Uso

```bash
# Ver slots disponibles
slotty_list

# Activar un slot
plug git

# Agregar nuevos comandos
slotty_add 'git log --oneline -10 | Ver últimos 10 commits' git
slotty_add 'git diff | Ver cambios sin commit' git

# Eliminar comandos
slotty_delete

# Usar Slotty normalmente
slotty
```
