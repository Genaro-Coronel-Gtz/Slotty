#!/bin/zsh

# --- Configuración de Rutas ---
SLOTTY_PATH="/Users/genaro_coronel/Lab/Slotty"
SLOTTY_PY="$SLOTTY_PATH/app.py"
VENV_PYTHON="/Users/genaro_coronel/Lab/Slotty/venv/bin/python3"

# 1. Función Principal (Buscador y gestor de argumentos)
function slotty() {
    # Si hay argumentos, pasarlos al script Python
    if [[ $# -gt 0 ]]; then
        # Para comandos que necesitan interfaz interactiva (--delete), usar script
        if [[ "$1" == "--delete" ]]; then
            export SLOTTY_ACTIVE="$SLOTTY_ACTIVE"
            script -q /dev/null "$VENV_PYTHON" "$SLOTTY_PY" --delete
        else
            $VENV_PYTHON "$SLOTTY_PY" "$@"
        fi
        return $?
    fi
    
    # Modo normal: validación de slots activos
    if [[ -z "$SLOTTY_ACTIVE" ]]; then
        echo "⚠️  No hay slots activos. Usa 'plug <nombre>' primero."
        echo "💡 Slots disponibles: $(ls ~/.slotty/slots/ | sed 's/\.txt//g' | tr '\n' ' ')"
        return 1
    fi

    # Crear archivo temporal
    export SLOTTY_TMP_FILE=$(mktemp)
    
    # Ejecutar Python con script para evitar problemas de TTY
    export SLOTTY_ACTIVE="$SLOTTY_ACTIVE"
    export SLOTTY_TMP_FILE="$SLOTTY_TMP_FILE"
    script -q /dev/null "$VENV_PYTHON" "$SLOTTY_PY"
    
    # Procesar el resultado
    if [[ -f "$SLOTTY_TMP_FILE" ]]; then
        local selected_cmd=$(cat "$SLOTTY_TMP_FILE")
        
        # Limpieza de archivos
        rm -f "$SLOTTY_TMP_FILE"
        unset SLOTTY_TMP_FILE

        if [[ -n "$selected_cmd" ]]; then
            # 'print -z' pone el comando en el buffer
            print -z "$selected_cmd"
            
            # Redibujar el prompt para que aparezca al instante
            zle && zle redisplay
        fi
    fi
}

# 2. Función para Enchufar (Plug)
function plug() {
    if [[ -z "$1" ]]; then
        echo "❌ Uso: plug <nombre_del_slot>"
        return 1
    fi

    if [[ -z "$SLOTTY_ACTIVE" ]]; then
        export SLOTTY_ACTIVE="$1"
    else
        # Evita duplicados exactos
        if [[ ! "$SLOTTY_ACTIVE" =~ "(^|,)$1(,|$)" ]]; then
            export SLOTTY_ACTIVE="$SLOTTY_ACTIVE,$1"
        fi
    fi
    echo "🔌 Slot '$1' activado."
}

# 3. Función para Desenchufar (Unplug)
function unplug() {
    if [[ -z "$1" ]]; then
        unset SLOTTY_ACTIVE
        echo "🔌 Todos los slots desconectados."
    else
        # Remueve el slot de la lista y limpia comas
        export SLOTTY_ACTIVE=$(echo $SLOTTY_ACTIVE | sed -E "s/(^|,)$1(,|$)/,/g" | sed 's/^,//;s/,$//;s/,,/,/')
        [[ -z "$SLOTTY_ACTIVE" ]] && unset SLOTTY_ACTIVE
        echo "🔌 Slot '$1' desconectado."
    fi
}

# 4. Información para el Prompt (Integración Dracula)
function slotty_prompt_info() {
    if [[ -n "$SLOTTY_ACTIVE" ]]; then
        local formatted=$(echo $SLOTTY_ACTIVE | sed 's/,/ %F{white}|%f /g')
        echo -e "%F{117}[%f%F{159}🔌 $formatted%f%F{117}]%f "
    fi
}