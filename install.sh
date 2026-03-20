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

# Crear directorio de slots
mkdir -p ~/.slotty/slots

# Crear slots de ejemplo si no existen
if [[ ! -f ~/.slotty/slots/docker.txt ]] && [[ ! -f ~/.slotty/slots/git.txt ]]; then
    echo "📝 Creando slots de ejemplo..."
    
    # Slot Docker
    cat > ~/.slotty/slots/docker.txt << 'EOF'
docker ps -a | grep -v 'Up' | awk '{print $1}' | xargs docker rm
docker images -f "dangling=true" -q | xargs docker rmi
docker-compose up -d
docker-compose down
docker logs -f
docker exec -it $(docker ps -q --latest) /bin/bash
docker build -t myapp .
docker run -it --rm myapp
docker system prune -f
EOF

    # Slot Git
    cat > ~/.slotty/slots/git.txt << 'EOF'
git status
git add .
git commit -m "update"
git push origin main
git pull origin main
git log --oneline -10
git diff --staged
git stash
git checkout -b feature/new-branch
git merge feature/new-branch
git rebase main
EOF

    echo "✅ Slots de ejemplo creados"
fi

# Detectar shell y configurar automáticamente
echo "🔧 Configurando shell..."

if [[ "$SHELL" == *"zsh"* ]]; then
    CONFIG_FILE="$HOME/.zshrc"
    SHELL_NAME="ZSH"
elif [[ "$SHELL" == *"bash"* ]]; then
    CONFIG_FILE="$HOME/.bashrc"
    SHELL_NAME="Bash"
else
    echo "⚠️ Shell no soportado: $SHELL"
    echo "💡 Slotty funciona mejor con ZSH o Bash"
    echo "📝 Añade manualmente a tu archivo de configuración:"
    echo "   source ~/.slotty/slotty_core.sh"
    exit 1
fi

# Verificar si Slotty ya está configurado
if grep -q "slotty_core.sh" "$CONFIG_FILE" 2>/dev/null; then
    echo "⚠️ Slotty ya está configurado en $CONFIG_FILE"
    echo "💡 Omitiendo configuración del shell"
else
    # Añadir configuración al shell (apuntando a ~/.slotty/)
    echo "" >> "$CONFIG_FILE"
    echo "# ==========================================" >> "$CONFIG_FILE"
    echo "# SLOTTY - CONFIGURACIÓN" >> "$CONFIG_FILE"
    echo "# ==========================================" >> "$CONFIG_FILE"
    echo "source ~/.slotty/slotty_core.sh" >> "$CONFIG_FILE"
    echo "PROMPT='$(slotty_prompt_info)'\$PROMPT'" >> "$CONFIG_FILE"
    
    echo "✅ Configuración añadida a $CONFIG_FILE"
    echo "🔄 Ejecuta: source $CONFIG_FILE"
fi

echo ""
echo "🎉 ¡Slotty instalado exitosamente!"
echo ""
echo "📖 Prueba rápida:"
echo "   plug git,docker  # Activar slots"
echo "   slotty         # Abrir buscador"
echo ""
echo "📚 Todo instalado en ~/.slotty/ - Sin requerir sudo"
echo "📚 Más información en README.md"
