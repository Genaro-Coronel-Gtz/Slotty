#!/bin/bash

# ==========================================
# SLOTTY - DESINSTALADOR (macOS/Linux)
# ==========================================

echo "🗑️  Desinstalando Slotty..."

# 1. Función para limpiar el archivo de configuración
clean_config() {
    local FILE=$1
    if [[ -f "$FILE" ]]; then
        if grep -q "SLOTTY - CONFIGURACIÓN" "$FILE"; then
            echo "📝 Limpiando configuración en $(basename "$FILE")..."
            
            # Crear backup de seguridad
            cp "$FILE" "${FILE}.slotty_bak"
            
            # macOS sed requiere un manejo especial para borrar bloques.
            # Esta versión borra todo entre los delimitadores que pusimos en el installer.
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # Versión macOS (BSD sed)
                sed -i '' '/# SLOTTY - CONFIGURACIÓN/,/# =========================================/d' "$FILE"
            else
                # Versión Linux (GNU sed)
                sed -i '/# SLOTTY - CONFIGURACIÓN/,/# =========================================/d' "$FILE"
            fi
            
            echo "✅ Configuración eliminada de $(basename "$FILE")"
            echo "💡 Backup creado en $(basename "$FILE").slotty_bak"
        fi
    fi
}

# 2. Ejecutar limpieza en los archivos comunes
clean_config "$HOME/.zshrc"
clean_config "$HOME/.bashrc"

# 3. Manejo de la carpeta ~/.slotty y el binario
echo ""
read -p "🗂️  ¿Deseas eliminar COMPLETAMENTE la carpeta ~/.slotty (incluye slots y comandos)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$HOME/.slotty" ]; then
        rm -rf "$HOME/.slotty"
        echo "✅ Carpeta ~/.slotty eliminada permanentemente."
    else
        echo "ℹ️  La carpeta ~/.slotty ya no existía."
    fi
else
    # Si decide no borrar todo, al menos quitamos el binario para que no ocupe espacio
    echo "📂 Conservando carpeta ~/.slotty (tus slots están a salvo)."
    if [ -f "$HOME/.slotty/slotty" ]; then
        rm "$HOME/.slotty/slotty"
        echo "✅ Binario eliminado de ~/.slotty/slotty para ahorrar espacio."
    fi
    echo "💡 Nota: Se conservan tus archivos .txt en ~/.slotty/slots/"
fi

echo ""
echo "🎉 ¡Slotty ha sido desinstalado!"
echo "🔄 IMPORTANTE: Para que los cambios surtan efecto en esta sesión, ejecuta:"
echo "   source ~/.zshrc  # (o tu archivo de configuración)"
echo ""
echo "Resumen:"
echo "✅ Hooks de shell eliminados."
echo "✅ Binario removido."
echo "✅ Backups creados con extensión .slotty_bak"