#!/bin/bash

# Crear la carpeta si no existe
mkdir -p ~/.slotty/slots/

# Crear slot de Docker
cat <<EOF > ~/.slotty/slots/docker.txt
docker ps -a | Listar todos los contenedores
docker system prune -f | Borrar todo lo que no se use
docker-compose up -d | Levantar servicios (detrás)
docker exec -it | Entrar a un contenedor
EOF

# Crear slot de Git
cat <<EOF > ~/.slotty/slots/git.txt
git add . | Etiquetar todos los cambios
git commit -m "" | Crear un nuevo commit
git push origin | Subir al repositorio remoto
git log --oneline | Ver historial simplificado
EOF

echo "✅ Slots de ejemplo creados en ~/.slotty/slots/"