# 🚀 Slotty - Sistema de Gestión de Comandos

<div align="center">
  <img src="resources/banner.png" alt="Slotty Logo" width="100%" height="220" style=" object-fit: cover; border: 2px solid #2E3440; border-radius:5px;">
</div>
<br>

**Slotty** es un sistema de gestión de comandos con interfaz fuzzy search que te permite organizar, buscar y ejecutar comandos rápidamente desde tu terminal.

## Características Principales

- **Búsqueda Fuzzy** - Encuentra comandos al instante con InquirerPy
- **Slots Temáticos** - Organiza comandos por categorías (git, docker, python, etc.)
- **Acceso Rápido** - Configurable con atajos de teclado (F10)
- **Fácil Configuración** - Instalación automática sin dependencias
- **Multiplataforma** - macOS, Linux, WSL2 con soporte completo
- **Binario Nativo** - Ejecutable independiente sin requerir Python
- **Sin Sudo** - Instalación 100% en directorio de usuario
- **Indicador en el prompt** - Muestra los slots activos:

```
[ git | docker] $ 
```

## Requisitos Previos

### Sistema Operativo
- **macOS** (10.15+) - Totalmente compatible
- **Linux** (Ubuntu, Debian, Fedora, Arch, etc.) - Compatible
- **Windows** - A través de WSL2 con ZSH

### Shell Requerido
- **ZSH** (v5.0+) - Requerido (viene por defecto en macOS)
- **Bash** - Compatible
- **Oh My Zsh** - Opcional pero recomendado
- **Powerlevel10k** - Compatible con configuración especial

### Terminales Soportadas
- **iTerm2** (macOS) - Recomendado, mejor soporte de atajos
- **Terminal.app** (macOS nativa) - Compatible
- **GNOME Terminal** (Linux) - Compatible
- **Konsole** (KDE/Linux) - Compatible
- **Alacritty** (multiplataforma) - Compatible
- **WSL Terminal** (Windows) - Compatible

## Instalación

### Opción 1: Instalación Automática (Recomendada)

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/slotty.git
cd slotty

# Ejecutar instalador (sin requerir sudo)
./install.sh

source ~/.zshrc
```

El instalador automáticamente:
- Copia el binario a `~/.slotty/slotty`
- Copia `slotty_core.sh` a `~/.slotty/`
- Configura tu shell (`.zshrc` o `.bashrc`) para usar `~/.slotty/slotty_core.sh`
- Crea slots de ejemplo en `~/.slotty/slots/`
- **No requiere sudo** - Instalación 100% en directorio de usuario

### Opción 2: Instalación Manual

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/slotty.git
cd slotty

# 2. Copiar binario y funciones a ~/.slotty
mkdir -p ~/.slotty/slots
cp dist/slotty ~/.slotty/slotty
chmod +x ~/.slotty/slotty
cp slotty_core.sh ~/.slotty/slotty_core.sh

# 3. Configurar shell
echo 'source ~/.slotty/slotty_core.sh' >> ~/.zshrc
echo 'PROMPT="$(slotty_prompt_info)$PROMPT"' >> ~/.zshrc

# 4. Recargar configuración
source ~/.zshrc
```

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

## Atajo de Teclado (Opcional)

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

### Códigos de Tecla por Sistema

| Sistema | Ctrl+U | Formato |
|---------|---------|---------|
| iTerm2 | `\x15` | Hexadecimal |
| Terminal.app | `^U` | Caret notation |
| Linux | `Ctrl+U` | Texto plano |

> **Nota:** En todos los casos, el espacio antes de `slotty` es intencional para evitar que se guarde en el historial (con `HIST_IGNORE_SPACE`).


## 🏗️ Estructura de Archivos

### Después de la Instalación

```
~/.slotty/
├── slotty              # Binario ejecutable principal
├── slotty_core.sh      # Funciones del shell
└── slots/             # Directorio de comandos
    ├── docker.txt       # Comandos Docker
    ├── git.txt          # Comandos Git
    └── python.txt       # Comandos Python
```

### Directorio del Proyecto

```
slotty/
├── dist/slotty          # Binario compilado
├── slotty_core.sh      # Funciones del shell
├── install.sh         # Instalador automático
├── uninstall.sh       # Desinstalador completo
├── README.md          # Documentación principal
├── DISTRIBUTION.md    # Guía para mantenedores
├── requirements.txt    # Dependencias Python
├── app.py            # Código fuente
├── slotty.spec        # Configuración PyInstaller
└── create_slots.sh    # Slots de ejemplo
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

## 🌱 Script seed_slots.sh

### Propósito

El script `seed_slots.sh` es una utilidad que crea automáticamente slots preconfigurados con los comandos más populares para diferentes tecnologías y frameworks. Esto permite tener una base sólida de comandos listos para usar sin necesidad de agregarlos manualmente.

### Funcionalidad

El script crea cuatro slots temáticos en `~/.slotty/slots/`:

- **python.txt** - 20 comandos esenciales de Python y pip
- **docker.txt** - 20 comandos fundamentales de Docker y docker-compose  
- **laravel.txt** - 20 comandos populares del framework Laravel
- **rails.txt** - 20 comandos principales de Ruby on Rails

### Ejecución

```bash
# Ejecutar el script para crear los slots
./seed_slots.sh
```

### Slots Creados

#### Python
Incluye comandos para gestión de entornos virtuales, instalación de paquetes, servidores de desarrollo, frameworks (Flask, Django, FastAPI), testing y depuración.

#### Docker  
Contiene comandos para gestión de contenedores e imágenes, docker-compose, logs, inspección y limpieza de recursos.

#### Laravel
Cubre comandos artisan para desarrollo Laravel: servidor, migraciones, seeds, consola interactiva, generación de código y gestión de caché.

#### Rails
Incluye comandos Rails para servidor, consola, generación de scaffolds, migraciones, tests y gestión de assets.

### Resultado

Después de ejecutar el script, tendrás acceso inmediato a 80 comandos organizados por categorías, listos para ser buscados y ejecutados con Slotty.


## 🔧 Solución de Problemas

### Comandos No Aparecen
```bash
# Verifica que el slot esté activo
echo $SLOTTY_ACTIVE

# Lista los slots disponibles
slotty --list-slots
```

### Error de "Comando no encontrado"
```bash
# Verifica que ~/.slotty esté en tu PATH
echo $PATH | grep slotty

# Verifica que el binario sea ejecutable
ls -la ~/.slotty/slotty
```

### Atajo F10 No Funciona

**Para iTerm2:**
- Verifica Keyboard Shortcut en Settings → Keys → Key Bindings
- Asegúrate que Action sea "Send Text"
- Verifica que Value sea `\x15 slotty\n`

**Para Terminal.app:**
- Revisa Preferences → Profiles → Keyboard
- Confirma que el atajo esté configurado correctamente
- Usa `^U slotty\n` en lugar de `\x15 slotty\n`

**Para Linux:**
- Verifica que la terminal soporte atajos personalizados
- Prueba con Ctrl+Alt+F10 si F10 no funciona

### Problemas de Colores en el Prompt

Si los colores no se ven correctamente:

```bash
# Verifica tu configuración de terminal
echo $TERM

# Recarga la configuración de Slotty
source ~/.slotty/slotty_core.sh
```

### Error de Historial

Si `slotty` aparece en el historial a pesar del espacio inicial:

```bash
# Verifica las opciones de historial en tu .zshrc
grep -E "HIST_IGNORE|HIST_NO_STORE|HIST_VERIFY" ~/.zshrc

# Agrega las opciones si no existen
echo "setopt HIST_IGNORE_SPACE HIST_NO_STORE HIST_VERIFY" >> ~/.zshrc
```

## 🗑️ Desinstalación Completa

Para desinstalar Slotty completamente sin dejar rastros:

```bash
# Ejecutar desinstalador
./uninstall.sh

# Recargar terminal
source ~/.zshrc
```

El desinstalador:
- ✅ Elimina el binario de `~/.slotty/slotty`
- ✅ Remueve la configuración del shell
- ✅ Crea backup de tu archivo de configuración
- 🗂️ Opcional: elimina todos los datos de `~/.slotty`
- 🚀 **No requiere sudo** - Todo en directorio de usuario

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

### Para Reportar Issues

1. **Describe el problema** claramente
2. **Incluye tu sistema** (macOS, Linux, terminal)
3. **Proporciona logs** si hay errores
4. **Sugerencias de mejora** son apreciadas

### Para Enviar Pull Requests

1. **Haz fork del proyecto**
2. **Crea una feature branch**
3. **Haz commit de cambios**
4. **Push a tu fork**
5. **Abre Pull Request**

### Desarrollo Local

```bash
# Modificar app.py
vim app.py

# Regenerar binario
./build.sh

# Probar cambios
~/.slotty/slotty --help
```

## 📄 Licencia

MIT License - Libre para uso personal y comercial

## 👥 Créditos

Creado con ❤️ para la comunidad de desarrolladores con el objetivo de mejorar la productividad en la terminal
Desarrollado por Genaro Coronel
---




