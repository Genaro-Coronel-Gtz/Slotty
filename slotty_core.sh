#!/bin/zsh

# ==========================================
# SLOTTY - CONFIGURACIÓN
# ==========================================

# Rutas del proyecto (ahora todo en ~/.slotty/)
SLOTTY_DIR="$HOME/.slotty"
SLOTTY_PY="$SLOTTY_DIR/slotty"

# 1. Función Principal (Buscador y gestor de argumentos)
function slotty() {
    # Si hay argumentos, pasarlos al binario
    if [[ $# -gt 0 ]]; then
        # Para comandos que necesitan interfaz interactiva (--delete), usar script
        if [[ "$1" == "--delete" ]]; then
            export SLOTTY_ACTIVE="$SLOTTY_ACTIVE"
            script -q /dev/null "$SLOTTY_PY" --delete
        else
            "$SLOTTY_PY" "$@"
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
    
    # Ejecutar binario con script para evitar problemas de TTY
    export SLOTTY_ACTIVE="$SLOTTY_ACTIVE"
    export SLOTTY_TMP_FILE="$SLOTTY_TMP_FILE"
    script -q /dev/null "$SLOTTY_PY"
    
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
    echo "Slot '$1' activado."
}

# 3. Función para Desenchufar (Unplug)
function unplug() {
    if [[ -z "$1" ]]; then
        unset SLOTTY_ACTIVE
        echo "Todos los slots desconectados."
    else
        # Remueve el slot de la lista y limpia comas
        export SLOTTY_ACTIVE=$(echo $SLOTTY_ACTIVE | sed -E "s/(^|,)$1(,|$)/,/g" | sed 's/^,//;s/,$//;s/,,/,/')
        [[ -z "$SLOTTY_ACTIVE" ]] && unset SLOTTY_ACTIVE
        echo "Slot '$1' desconectado."
    fi
}

# 4. Información para el Prompt (Integración Dracula)
function slotty_prompt_info() {
    if [[ -n "$SLOTTY_ACTIVE" ]]; then
        local formatted=""
        
        # Intentar obtener colores del tema actual
        local theme_colors=($(slotty_get_theme_colors))
        
        # Si no hay colores del tema, usar fallback
        if [[ ${#theme_colors[@]} -eq 0 ]]; then
            theme_colors=(46 47 48 49 50 51 75 81 87 93 99 105 111 117 123 129 135 141 147 153 159 165 171 177 183 189 195)
        fi
        
        # Separar slots y colorear cada uno
        local first=true
        for slot in $(echo $SLOTTY_ACTIVE | tr ',' ' '); do
            if [[ "$first" == true ]]; then
                first=false
            else
                formatted+="%F{white}|%f "
            fi
            
            # Color aleatorio para este slot (de la paleta del tema o fallback)
            local color_index=$((RANDOM % ${#theme_colors[@]}))
            local color=${theme_colors[$color_index]}
            formatted+="%F{$color}$slot%f "
        done
        
        echo -e "%F{117}[ %f$formatted%F{117} ]%f "
    fi
}

# Función para obtener colores del tema actual de ZSH
function slotty_get_theme_colors() {
    local colors=()
    
    # Intentar obtener colores reales del tema actual
    # Colores comunes de ZSH themes (solo tonos vibrantes para terminales oscuras)
    local common_colors=(
        "$fg[green]" "$fg[blue]" "$fg[cyan]" "$fg[magenta]" "$fg[yellow]"
        "$fg[red]" "$fg[white]"
        "$fg[032]" "$fg[034]" "$fg[036]" "$fg[045]" "$fg[046]"  # Verdes, azules, cyan claros
        "$fg[047]" "$fg[048]" "$fg[049]" "$fg[050]" "$fg[051]"  # Colores vibrantes
        "$fg[086]" "$fg[087]" "$fg[088]" "$fg[089]" "$fg[090]"  # Azules y cyan vibrantes
        "$fg[120]" "$fg[121]" "$fg[122]" "$fg[123]" "$fg[124]"  # Azules y morados vibrantes
        "$fg[226]" "$fg[227]" "$fg[228]" "$fg[229]"            # Amarillos brillantes
    )
    
    # Intentar extraer colores de variables de entorno del tema
    if [[ -n "$ZSH_THEME" ]]; then
        case "$ZSH_THEME" in
            "dracula")
                # Intentar usar colores reales de Dracula si están disponibles
                colors=(
                    ${fg[green]:-46} ${fg[cyan]:-51} ${fg[blue]:-87} 
                    ${fg[magenta]:-135} ${fg[yellow]:-226}
                    32 36 45 87 135 226
                )
                ;;
            "robbyrussell")
                # Colores más tradicionales
                colors=(
                    ${fg[green]:-46} ${fg[blue]:-81} ${fg[cyan]:-51}
                    ${fg[magenta]:-135} ${fg[yellow]:-226}
                    46 81 51 135 226
                )
                ;;
            "agnoster")
                # Colores modernos de Agnoster
                colors=(
                    ${fg[green]:-46} ${fg[blue]:-87} ${fg[cyan]:-93}
                    ${fg[magenta]:-165} ${fg[yellow]:-226}
                    46 87 93 165 226
                )
                ;;
        esac
    fi
    
    # Detectar Powerlevel10k colores reales si está configurado
    if [[ -f ~/.p10k.zsh ]]; then
        # Powerlevel10k usa variables específicas (colores vibrantes)
        colors=(
            ${POWERLEVEL9K_COLOR_FOREGROUND:-46}
            ${POWERLEVEL9K_COLOR_DIR_FOREGROUND:-87}
            ${POWERLEVEL9K_COLOR_GIT_CLEAN_FOREGROUND:-46}
            ${POWERLEVEL9K_COLOR_GIT_DIRTY_FOREGROUND:-196}
            ${POWERLEVEL9K_COLOR_EXEC_TIME_FOREGROUND:-226}
            ${POWERLEVEL9K_COLOR_VCS_FOREGROUND:-135}
            46 87 135 196 226 51 47 48 49 50 120 121 122 123 124
        )
    fi
    
    # Si hay variables de color personalizadas en el entorno
    if [[ -n "$SLOTTY_THEME_COLORS" ]]; then
        colors=($(echo $SLOTTY_THEME_COLORS | tr ',' ' '))
    fi
    
    # Fallback: si no se detectaron colores reales, usar paleta vibrante predefinida
    if [[ ${#colors[@]} -eq 0 ]]; then
        colors=(46 47 48 49 50 51 86 87 88 89 90 120 121 122 123 124 135 141 147 153 159 165 171 177 183 189 195 226 227 228 229)
    fi
    
    echo "${colors[@]}"
}