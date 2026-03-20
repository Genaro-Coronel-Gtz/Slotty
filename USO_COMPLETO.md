# Uso Completo de Slotty

## Comandos Unificados

Todos los comandos ahora se ejecutan con `slotty`:

### 1. Modo Normal (búsqueda fuzzy)
```bash
slotty
```
Abre la interfaz de búsqueda para seleccionar comandos.

### 2. Listar Slots
```bash
slotty --list-slots
```
Muestra todos los slots disponibles con número de comandos.

### 3. Agregar Comando
```bash
slotty --add-command "<comando> | <descripción>" --to <slot>
```

Ejemplos:
```bash
slotty --add-command "git status | Ver estado del repositorio" --to git
slotty --add-command "docker ps -a | Listar todos los contenedores" --to docker
```

### 4. Eliminar Comando
```bash
slotty --delete
```
Abre interfaz interactiva para seleccionar y eliminar comandos.

### 5. Salir con ESC
En cualquier interfaz fuzzy, presiona `ESC` para cancelar.

## Flujo de Trabajo Típico

```bash
# 1. Ver slots disponibles
slotty --list-slots

# 2. Activar un slot
plug git

# 3. Agregar nuevos comandos
slotty --add-command "git log --oneline -10 | Ver últimos 10 commits" --to git

# 4. Usar Slotty normalmente
slotty

# 5. Eliminar comandos si es necesario
slotty --delete
```

## Características

✅ **Comandos unificados** - Todo con `slotty`
✅ **Manejo de TTY** - Usa `script` para evitar errores
✅ **Validación automática** - Evita duplicados
✅ **Confirmación de eliminación** - Pide confirmación
✅ **Soporte ESC** - Cancela operaciones con ESC
✅ **Mensajes claros** - Colores y emojis para mejor UX

## Variables de Entorno

- `SLOTTY_ACTIVE` - Slots activos (separados por comas)
- `SLOTTY_TMP_FILE` - Archivo temporal para comunicación

## Archivos

- `~/.slotty/slots/` - Directorio con archivos .txt de cada slot
- `slotty_core.sh` - Funciones principales del shell
- `app.py` - Interfaz Python con InquirerPy
