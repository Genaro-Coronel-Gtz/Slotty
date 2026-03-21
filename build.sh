#!/bin/bash

# ==========================================
# SLOTTY - BUILD SCRIPT
# ==========================================

echo "🔨 Construyendo Slotty..."

# Verificar si estamos en el directorio correcto
if [[ ! -f "app.py" ]]; then
    echo "❌ Error: No se encuentra app.py"
    echo "💡 Asegúrate de ejecutar este script desde el directorio raíz de Slotty"
    exit 1
fi

# Verificar si el entorno virtual existe
if [[ ! -d "venv" ]]; then
    echo "❌ Error: No se encuentra el entorno virtual venv"
    echo "💡 Ejecuta primero: python3 -m venv venv && source venv/bin/activate"
    exit 1
fi

# Activar entorno virtual
echo "📦 Activando entorno virtual..."
source venv/bin/activate

# Verificar dependencias
echo "📋 Verificando dependencias..."
if [[ ! -f "requirements.txt" ]]; then
    echo "❌ Error: No se encuentra requirements.txt"
    exit 1
fi

# Instalar dependencias si es necesario
pip install -r requirements.txt

# Actualizar pip e instalar PyInstaller específico
echo "⬆️ Actualizando pip e instalando PyInstaller..."
pip install pyinstaller==6.19.0

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
rm -rf build/
rm -rf dist/

# Construir binario usando el .spec actualizado
echo "🏗️ Construyendo binario..."
pyinstaller slotty.spec

# Verificar si se creó el binario
if [[ ! -f "dist/slotty" ]]; then
    echo "❌ Error: No se pudo crear el binario"
    echo "💡 Revisa los mensajes de error arriba para más detalles"
    exit 1
fi

# Hacer binario ejecutable
chmod +x dist/slotty

# Mostrar información del binario
echo ""
echo "✅ ¡Binario creado exitosamente!"
echo ""
echo "� Información del binario:"
ls -lh dist/slotty
echo ""
echo "🧪 Para probar:"
echo "   ./dist/slotty --help"
echo ""
echo "� Para instalar:"
echo "   ./install.sh"
