# ==========================================
# SLOTTY - CONFIGURACIÓN FINAL
# ==========================================

# 1. Función para enchufar slots (plug <nombre>)
function plug() {
    if [[ -z "$SLOTTY_ACTIVE" ]]; then
        export SLOTTY_ACTIVE="$1"
    else
        # Evita duplicados en la variable
        if [[ ! "$SLOTTY_ACTIVE" =~ "(^|,)$1(,|$)" ]]; then
            export SLOTTY_ACTIVE="$SLOTTY_ACTIVE,$1"
        fi
    fi
}

# 2. Función para desenchufar (unplug <nombre> o unplug para todo)
function unplug() {
    if [[ -z "$1" ]]; then
        unset SLOTTY_ACTIVE
        echo "🔌 Todos los slots desconectados."
    else
        # Remueve el slot específico de la lista separada por comas
        export SLOTTY_ACTIVE=$(echo $SLOTTY_ACTIVE | sed -E "s/(^|,)$1(,|$)/,/g" | sed 's/^,//;s/,$//;s/,,/,/')
        [[ -z "$SLOTTY_ACTIVE" ]] && unset SLOTTY_ACTIVE
        echo "🔌 Slot '$1' desconectado."
    fi
}

# 3. Función principal de búsqueda
# ESTA ES LA QUE DEBES EJECUTAR ESCRIBIENDO 'slotty'
function slotty() {
    # 1. Crear el archivo temporal
    export SLOTTY_TMP_FILE=$(mktemp)
    
    # 2. Ejecutar el script (la interfaz se dibuja y se borra sola al salir)
    python3 /Users/genaro_coronel/Lab/Slotty/app.py
    
    # 3. Leer la selección del archivo
    local selected_cmd=$(cat "$SLOTTY_TMP_FILE")
    
    # 4. Limpiar rastro de archivos
    rm -f "$SLOTTY_TMP_FILE"
    unset SLOTTY_TMP_FILE
    
    # 5. Inyectar el comando en el prompt si existe
    if [[ -n "$selected_cmd" ]]; then
        # print -z pone el texto en el buffer de edición
        print -z "$selected_cmd"
    fi
}

# 4. Indicador visual para tu PROMPT de Dracula
function slotty_prompt_info() {
    if [[ -n "$SLOTTY_ACTIVE" ]]; then
        # Formateo visual: [🔌 slot1 | slot2]
        local formatted=$(echo $SLOTTY_ACTIVE | sed 's/,/ %F{white}|%f /g')
        echo -e "%F{117}[%f%F{159}🔌 $formatted%f%F{117}]%f "
    fi
}

# Inyectar el indicador al inicio de tu PROMPT actual
PROMPT='$(slotty_prompt_info)'$PROMPT