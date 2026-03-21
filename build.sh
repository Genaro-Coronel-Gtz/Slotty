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

# Esperar a que el binario esté disponible (verificación activa)
echo "⏳ Esperando a que termine la construcción..."
timeout=30
count=0
while [[ ! -f "dist/slotty" ]] && [[ $count -lt $timeout ]]; do
    sleep 1
    count=$((count + 1))
    echo -n "."
done
echo ""

# Verificar si se creó el binario
if [[ ! -f "dist/slotty" ]]; then
    echo "❌ Error: No se pudo crear el binario"
    echo "💡 Revisa los mensajes de error arriba para más detalles"
    exit 1
fi

# Hacer binario ejecutable
chmod +x dist/slotty

# Crear archivo tar.gz
crear_tar_gz() {
    echo "📦 Creando archivo tar.gz..."
    if [[ -d "dist/slotty" ]]; then
        cd dist/
        tar -czf slotty.tar.gz slotty/
        echo "✅ Archivo tar.gz creado: dist/slotty.tar.gz"
        echo "📊 Tamaño del paquete:"
        ls -lh slotty.tar.gz
        cd ..
    else
        echo "❌ Error: No se encontró el directorio dist/slotty"
        exit 1
    fi
}

# Llamar a la función
crear_tar_gz

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
