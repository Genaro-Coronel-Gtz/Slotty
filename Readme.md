# 🚀 Slotty - Guía de Instalación y Uso

## 📋 ¿Qué es Slotty?

Slotty es un sistema de gestión de comandos para terminal que te permite organizar y acceder rápidamente a tus comandos más utilizados a través de "slots" temáticos y una interfaz de búsqueda interactiva.

## ✨ Características Principales

- 🎯 **Búsqueda Fuzzy** - Encuentra comandos al instante
- 📁 **Slots Temáticos** - Organiza comandos por categorías (git, docker, etc.)
- ⚡ **Acceso Rápido** - Configurable con atajos de teclado
- 🎨 **Interfaz Amigable** - Colores y emojis para mejor experiencia
- 🔧 **Fácil Configuración** - Instalación simple en minutos

## 🛠️ Requisitos Previos

### Sistema Operativo
- **macOS** (10.15+) - Totalmente compatible
- **Linux** (Ubuntu, Debian, Fedora, Arch, etc.) - Compatible
- **Windows** - A través de WSL2 con ZSH

### Shell Requerido
- **ZSH** (v5.0+) - Requerido (viene por defecto en macOS)
- **Oh My Zsh** - Opcional pero recomendado
- **Powerlevel10k** - Compatible con configuración especial

### Dependencias
- **Python 3.8+**
- **pip** (gestor de paquetes Python)

### Terminales Soportadas
- **iTerm2** (macOS) - Recomendado, mejor soporte de atajos
- **Terminal.app** (macOS nativa) - Compatible
- **GNOME Terminal** (Linux) - Compatible
- **Konsole** (KDE/Linux) - Compatible
- **Alacritty** (multiplataforma) - Compatible
- **WSL Terminal** (Windows) - Compatible

## 📦 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/slotty.git
cd slotty
```

### 2. Crear Entorno Virtual

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Configurar en ZSH

Agrega esto al final de tu `~/.zshrc`:

```bash
# ==========================================
# SLOTTY - CONFIGURACIÓN
# ==========================================

# Configuración de historial para ignorar comandos con espacio inicial
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY

# Cargar el sistema de slots
source /ruta/a/slotty/slotty_core.sh

# Inyectar el indicador en tu prompt
PROMPT='$(slotty_prompt_info)'$PROMPT
```

> **Importante:** Reemplaza `/ruta/a/slotty/` con la ruta real donde clonaste el proyecto.  
> Las opciones `HIST_IGNORE_SPACE` y `HIST_NO_STORE` evitan que ` slotty` se guarde en el historial.

#### Para usuarios de Linux

Si estás en Linux, asegúrate de que ZSH sea tu shell por defecto:

```bash
# Verificar shell actual
echo $SHELL

# Cambiar a ZSH si no lo es
chsh -s $(which zsh)

# Reiniciar terminal
```

#### Para usuarios de Powerlevel10k

Si usas **Oh My Zsh + Powerlevel10k**, la configuración de historial es **crucial** porque Powerlevel10k tiene su propio manejo de historial que ignora el truco del espacio inicial unless las opciones `HIST_IGNORE_SPACE` estén configuradas.

### 4. Recargar Configuración

```bash
source ~/.zshrc
```

### 5. Crear Slots de Ejemplo

```bash
./create_slots.sh
```

## Uso Básico

### Activar Slots

```bash
# Activar un slot específico
plug git

# Activar múltiples slots
plug git,docker

# Ver slots activos (se muestra en el prompt)
```

### Usar Slotty

```bash
# Abrir buscador de comandos
slotty

# Busca y selecciona un comando con las flechas
# Presiona Enter para ejecutarlo
# Presiona ESC para cancelar
```

## 📚 Comandos Completos

### 1. Búsqueda Normal
```bash
slotty
```
Abre la interfaz fuzzy para buscar y ejecutar comandos.

### 2. Listar Slots Disponibles
```bash
slotty --list-slots
```
Muestra todos los slots con su número de comandos.

### 3. Agregar Comandos
```bash
slotty --add-command "<comando> | <descripción>" --to <slot>
```

**Ejemplos:**
```bash
slotty --add-command "git status | Ver estado del repositorio" --to git
slotty --add-command "docker ps -a | Listar todos los contenedores" --to docker
slotty --add-command "npm run build | Compilar proyecto" --to node
```

### 4. Eliminar Comandos
```bash
slotty --delete
```
Abre una interfaz para seleccionar y eliminar comandos con confirmación.

### 5. Gestión de Slots
```bash
# Activar slot
plug <nombre>

# Desactivar slot específico
unplug <nombre>

# Desactivar todos los slots
unplug
```

## ⌨️ Atajo de Teclado (Opcional)

### Para iTerm2 (macOS)

1. **Abre iTerm2** → Settings (Cmd + ,)
2. **Ve a** Profiles → Keys → Key Bindings
3. **Haz clic en** + para añadir nuevo binding
4. **Configura:**
   - **Keyboard Shortcut:** F10
   - **Action:** Send Text
   - **Value:** `\x15 slotty\n`

### Para Terminal.app (macOS Nativa)

1. **Abre Terminal** → Preferences → Profiles → Keyboard
2. **Haz clic en** + para añadir nuevo atajo
3. **Configura:**
   - **Keyboard Shortcut:** F10
   - **Action:** Send Text
   - **Value:** `^U slotty\n`

### Para Terminales Linux (GNOME, KDE, etc.)

1. **Abre Preferencias de Terminal**
2. **Busca** Atajos de Teclado o Key Bindings
3. **Añade nuevo atajo:**
   - **Tecla:** F10
   - **Comando:** `Ctrl+U` + ` slotty` + `Enter`

### Compatibilidad con Powerlevel10k

Si usas **Oh My Zsh + Powerlevel10k**, es **crucial** agregar estas opciones a tu `.zshrc`:

```bash
# Configuración de historial para Powerlevel10k
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
```

**¿Por qué?** Powerlevel10k tiene su propio sistema de historial que ignora el truco del espacio inicial unless estas opciones estén configuradas.

### Códigos de Tecla por Sistema

| Sistema | Ctrl+U | Formato |
|---------|--------|---------|
| iTerm2 | `\x15` | Hexadecimal |
| Terminal.app | `^U` | Caret notation |
| Linux | `Ctrl+U` | Texto plano |

> **Nota:** En todos los casos, el espacio antes de `slotty` es intencional para evitar que se guarde en el historial (con `HIST_IGNORE_SPACE`).

## 🏗️ Estructura de Archivos

```
slotty/
├── slotty_core.sh      # Funciones principales del shell
├── app.py              # Interfaz Python con InquirerPy
├── requirements.txt    # Dependencias Python
├── create_slots.sh    # Script para slots de ejemplo
└── ~/.slotty/slots/    # Directorio con archivos .txt de cada slot
```

## 💡 Ejemplos de Uso

### Flujo de Trabajo Típico

```bash
# 1. Ver qué slots tienes disponibles
slotty --list-slots

# 2. Activar el slot que necesitas
plug git

# 3. Agregar comandos personalizados
slotty --add-command "git log --oneline -10 | Ver últimos commits" --to git

# 4. Usar Slotty para buscar y ejecutar comandos
slotty

# 5. Cuando termines, desactiva el slot
unplug git
```

### Comandos Útiles

```bash
# Ver todos tus comandos de git
plug git && slotty

# Agregar rápidamente un nuevo comando
slotty --add-command "kubectl get pods | Ver pods de Kubernetes" --to k8s

# Limpiar slots que no usas
slotty --delete
```

## 🎨 Personalización

### Crear Nuevos Slots

```bash
# Crear un archivo para tu slot
mkdir -p ~/.slotty/slots
touch ~/.slotty/slots/mi-slot.txt

# Agregar comandos (formato: comando | descripción)
echo "ls -la | Listar archivos detallados" >> ~/.slotty/slots/mi-slot.txt
echo "df -h | Ver espacio en disco" >> ~/.slotty/slots/mi-slot.txt

# Activar y usar
plug mi-slot
slotty
```

### Indicador en el Prompt

El prompt mostrará los slots activos:
```
[🔌 git | docker] $ 
```

## 🔧 Solución de Problemas

### Problemas Comunes

#### Comandos No Aparecen
```bash
# Verifica que el slot esté activo
echo $SLOTTY_ACTIVE

# Lista los slots disponibles
slotty --list-slots
```

#### Error de Python
```bash
# Verifica el entorno virtual
source venv/bin/activate
python3 --version

# Reinstalar dependencias
pip install -r requirements.txt
```

#### Atajo F10 No Funciona

**Para iTerm2:**
- Verifica Keyboard Shortcut en Settings → Keys → Key Bindings
- Prueba con otra tecla (F9, F11)
- Asegúrate de que Action sea "Send Text"

**Para Terminal.app:**
- Revisa Preferences → Profiles → Keyboard
- Usa `^U slotty\n` en lugar de `\x15 slotty\n`

**Para Linux:**
- Verifica que la terminal soporte atajos personalizados
- Prueba con Ctrl+Alt+F10 si F10 no funciona

#### Problemas con Powerlevel10k

Si usas Powerlevel10k y los comandos siguen apareciendo en el historial:

```bash
# Verifica que las opciones estén configuradas
grep -E "HIST_IGNORE|HIST_NO_STORE|HIST_VERIFY" ~/.zshrc

# Si no aparecen, agrégalas manualmente
echo "setopt HIST_IGNORE_SPACE HIST_NO_STORE HIST_VERIFY" >> ~/.zshrc
source ~/.zshrc
```

#### Problemas Específicos de Linux

**ZSH no encontrado:**
```bash
# Instalar ZSH en Ubuntu/Debian
sudo apt update && sudo apt install zsh

# Instalar ZSH en Fedora
sudo dnf install zsh

# Instalar ZSH en Arch
sudo pacman -S zsh
```

**Permisos de ejecución:**
```bash
# Hacer ejecutable el script
chmod +x slotty_core.sh
chmod +x create_slots.sh
```

#### Problemas de Rutas

**Error "source: command not found":**
```bash
# Usa ruta absoluta en .zshrc
source /home/tu-usuario/slotty/slotty_core.sh

# O añade al PATH
export PATH="$PATH:/ruta/a/slotty"
```

#### Errores de TTY/Interfaz

Si la interfaz fuzzy no funciona:

```bash
# Verifica que estés en una terminal interactiva
echo $-

# Debe mostrar 'i' entre las opciones
# Si no, prueba en una terminal normal
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

1. Fork del proyecto
2. Crear una feature branch
3. Hacer commit de cambios
4. Push a la branch
5. Abrir Pull Request

## 📄 Licencia

MIT License - siéntete libre de usar y modificar.

## 🆘 Ayuda

Si tienes problemas o preguntas:

- 📖 Revisa esta guía
- 🐛 Abre un issue en GitHub
- 💬 Contacta al maintainers

---

**¡Disfruta de Slotty y haz tu terminal más productiva! 🚀**
