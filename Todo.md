* Generar binario y hacer pruebas con binario
* Crear instalador para que agregue la configuración a .zshrc
  inyecte el código necesario en el archivo .zshrc y agregue slots de ejemplo
* Agregar más slots de ejemplo
* Mejorar la interfaz visual
* Cambiar icono de slotty en zshrc 
* El buscador debe de tener un placeholder mejor, y el indicador de comandos (4/4) debe estar alineado a la derecha
* Agregar mejores iconos para la app
* Que se pueda salir con Esc
* Que se pueda lanzar con un atajo, ejemplo: Ctrl + Space
* Manejar colores en .zshrc con variables para poder modificarlos fácilmente
* Igual manejar themas en el scirpt app.py, que vengan de un archivo de configuracion 
por ejemplo Dracula, y tome los colores de ese tema, para eso habra una carpeta
themes dentro de .slotty para almacenar los temas, la seleccion del tema
se puede hacer en el .zshrc 


* Verificar si en vez de inyectar todo el codigo en el .zshrc 
se puede llamar desde un script en bash, por ejemplo .slotty/slotty.sh:
Podria quedar asi:

# ==========================================
# SLOTTY - SISTEMA EXTERNO
# ==========================================

# Cargamos todas las funciones desde el archivo externo
source /Users/genaro_coronel/Lab/Slotty/slotty_core.sh

# Integramos el indicador visual en tu prompt de Dracula
# Esto debe ir después de cargar el core para que reconozca la función
PROMPT='$(slotty_prompt_info)'$PROMPT


* Que no deje el siguiente texto :

? Slotty Buscar: git commit -m ""  -->  Crear un nuevo commit
      [GIT]

En la terminal después de seleccionar un comando.