#!/bin/bash

# ==========================================
# SLOTTY - DESINSTALADOR
# ==========================================

echo "🗑️ Desinstalando Slotty..."

# Eliminar binario del directorio del usuario
echo "📦 Eliminando binario..."
if rm -f ~/.slotty/slotty; then
    echo "✅ Binario eliminado de ~/.slotty/"
else
    echo "❌ Error al eliminar binario de ~/.slotty/"
fi

# Eliminar configuración del shell
echo "🔧 Eliminando configuración del shell..."

if [[ -f "$HOME/.zshrc" ]]; then
    if grep -q "slotty_core.sh" "$HOME/.zshrc"; then
        echo "📝 Eliminando configuración de ZSH..."
        # Crear backup
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
        
        # Eliminar líneas de Slotty
        sed -i '' '/# SLOTTY - CONFIGURACIÓN/,/PROMPT.*slotty_prompt_info/d' "$HOME/.zshrc"
        sed -i '' '/source.*slotty_core.sh/d' "$HOME/.zshrc"
        
        echo "✅ Configuración eliminada de .zshrc"
        echo "💡 Backup creado en .zshrc.backup"
    fi
fi

if [[ -f "$HOME/.bashrc" ]]; then
    if grep -q "slotty_core.sh" "$HOME/.bashrc"; then
        echo "📝 Eliminando configuración de Bash..."
        # Crear backup
        cp "$HOME/.bashrc" "$HOME/.bashrc.backup"
        
        # Eliminar líneas de Slotty
        sed -i '/# SLOTTY - CONFIGURACIÓN/,/PROMPT.*slotty_prompt_info/d' "$HOME/.bashrc"
        sed -i '/source.*slotty_core.sh/d' "$HOME/.bashrc"
        
        echo "✅ Configuración eliminada de .bashrc"
        echo "💡 Backup creado en .bashrc.backup"
    fi
fi

# Preguntar si eliminar datos de usuario
echo ""
read -p "🗂️ ¿Eliminar también los datos de Slotty (~/.slotty)? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗂️ Eliminando datos de usuario..."
    rm -rf ~/.slotty
    echo "✅ Datos eliminados (incluyendo slotty_core.sh)"
else
    echo "📂 Datos conservados en ~/.slotty"
    echo "💡 Se conservó slotty_core.sh en ~/.slotty/"
fi

echo ""
echo "🎉 Slotty desinstalado completamente!"
echo ""
echo "🔄 Recarga tu terminal para aplicar los cambios:"
echo "   source ~/.zshrc  # o ~/.bashrc"
echo ""
echo "📋 Resumen de la desinstalación:"
echo "✅ Eliminado binario de ~/.slotty/slotty"
echo "✅ Removida configuración del shell"
echo "✅ Creado backup de configuración"
echo "🚀 No se requirió sudo - Todo en directorio de usuario"
