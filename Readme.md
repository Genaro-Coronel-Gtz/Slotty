Agregar lo siguiente al .zshrc:

# ==========================================
# SLOTTY - CONFIGURACIÓN FINAL
# ==========================================

# Cargar el sistema de slots
source /Users/genaro_coronel/Lab/Slotty/slotty_core.sh

# Inyectar el indicador al inicio de tu PROMPT actual
PROMPT='$(slotty_prompt_info)'$PROMPT


Configuración en iTerm2

Para que F10 lance el comando sin importar lo que tengas escrito en la terminal (y sin que se guarde en el historial), haz esto:

Abre iTerm2 y ve a Settings (Cmd + ,).

Ve a Profiles > Keys > Key Bindings.

Haz clic en el botón + para añadir uno nuevo:

Keyboard Shortcut: Presiona F10.

Action: Selecciona Send Text.

Value: \x15 slotty\n

\x15 es el código hexadecimal para Ctrl + U (limpia la línea actual por si tenías algo escrito).

slotty (con un espacio inicial para reforzar que se ignore en el historial).

\n es el Enter.
