#!/bin/bash

# ==========================================
# SLOTTY - INSTALADOR
# ==========================================

echo "🚀 Instalando Slotty..."

# Verificar si estamos en el directorio correcto
if [[ ! -f "dist/slotty" ]]; then
    echo "❌ Error: No se encuentra el binario 'dist/slotty'"
    echo "💡 Asegúrate de ejecutar este script desde el directorio raíz de Slotty"
    exit 1
fi

# Crear directorios necesarios
echo "📁 Creando directorios..."
mkdir -p ~/.slotty/slots

# Copiar binario y funciones al directorio de Slotty del usuario
echo "� Instalando Slotty en ~/.slotty/..."


mkdir -p ~/.slotty

# Copiar binario
if cp dist/slotty ~/.slotty/slotty; then
    echo "✅ Binario instalado en ~/.slotty/slotty"
else
    echo "❌ Error al copiar binario"
    exit 1
fi

# Hacer binario ejecutable
chmod +x ~/.slotty/slotty

# Copiar funciones del shell
if cp slotty_core.sh ~/.slotty/slotty_core.sh; then
    echo "✅ Funciones del shell instaladas en ~/.slotty/"
else
    echo "❌ Error al copiar slotty_core.sh"
    exit 1
fi

# Detectar archivo de configuración según el shell
if [[ "$SHELL" == *"zsh"* ]]; then
    CONFIG_FILE="$HOME/.zshrc"
    # En ZSH es mejor usar 'precmd' o expansión de variables para el prompt
    PROMPT_LINE='PROMPT='\''$(slotty_prompt_info)'\''$PROMPT'
elif [[ "$SHELL" == *"bash"* ]]; then
    CONFIG_FILE="$HOME/.bashrc"
    PROMPT_LINE='PS1="$(slotty_prompt_info)$PS1"'
else
    # Fallback si no detecta bien el SHELL
    CONFIG_FILE="$HOME/.zshrc" 
    PROMPT_LINE='PROMPT='\''$(slotty_prompt_info)'\''$PROMPT'
fi

# Verificar si Slotty ya está configurado para evitar duplicados
if grep -q "SLOTTY - CONFIGURACIÓN" "$CONFIG_FILE" 2>/dev/null; then
    echo "⚠️  Slotty ya parece estar configurado en $CONFIG_FILE"
else
    echo "🔧 Añadiendo configuración a $CONFIG_FILE..."
    
    # Usamos un bloque cat para insertar todo de una vez limpiamente
    cat >> "$CONFIG_FILE" << EOF

# =========================================
# SLOTTY - CONFIGURACIÓN
# =========================================
# Carga las funciones principales (plug, slotty, etc.)
if [ -f ~/.slotty/slotty_core.sh ]; then
    source ~/.slotty/slotty_core.sh
    # Agrega el indicador de slots activos al inicio del prompt
    $PROMPT_LINE
fi
# =========================================
EOF

    echo "✅ Configuración añadida exitosamente."
fi

# Intentar recargar el shell actual para el usuario
echo ""
echo "🎉 ¡Slotty instalado exitosamente!"
echo "🔄 Para empezar a usarlo ahora mismo, ejecuta:"
echo "   source $CONFIG_FILE"