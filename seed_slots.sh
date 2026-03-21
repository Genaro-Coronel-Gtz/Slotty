#!/bin/bash

# ==========================================
# SLOTTY - SEED SLOTS (COMANDOS POPULARES)
# ==========================================

echo "🌱 Creando slots con comandos populares..."

# Crear directorio de slots
mkdir -p ~/.slotty/slots
# Slot Python (20 comandos más populares)
cat > ~/.slotty/slots/python.txt << 'EOF'
python --version | Ver versión de Python
python -m venv venv | Crear entorno virtual
source venv/bin/activate | Activar entorno virtual
pip install package | Instalar paquete
pip list | Listar paquetes instalados
pip freeze | Ver dependencias del proyecto
python -m pip install --upgrade pip | Actualizar pip
python -m pytest | Ejecutar tests
python -m http.server 8000 | Servidor web local
python -m jupyter notebook | Iniciar Jupyter Notebook
python -m flask run | Iniciar servidor Flask
python -m django runserver | Iniciar servidor Django
python manage.py migrate | Migraciones Django
python manage.py runserver | Servidor de desarrollo Django
python -m uvicorn main:app | Servidor FastAPI con Uvicorn
python -m pip install -r requirements.txt | Instalar desde requirements.txt
python -m pip uninstall package | Desinstalar paquete
python -m pip show package | Ver detalles de paquete
python -m pip cache purge | Limpiar caché de pip
python -m pdb script.py | Depurar con pdb
EOF

# Slot Docker (20 comandos más populares)
cat > ~/.slotty/slots/docker.txt << 'EOF'
docker ps | Listar contenedores en ejecución
docker ps -a | Listar todos los contenedores
docker images | Listar imágenes disponibles
docker run -it ubuntu bash | Iniciar contenedor interactivo Ubuntu
docker run -d nginx | Iniciar Nginx en background
docker run -p 8080:80 nginx | Mapear puerto 8080 a 80
docker build -t myapp . | Construir imagen desde Dockerfile
docker-compose up | Iniciar servicios con docker-compose
docker-compose down | Detener servicios docker-compose
docker logs container_name | Ver logs de contenedor específico
docker exec -it container_name bash | Acceder a contenedor
docker stop container_name | Detener contenedor
docker start container_name | Iniciar contenedor detenido
docker rm container_name | Eliminar contenedor
docker rmi image_name | Eliminar imagen
docker volume ls | Listar volúmenes
docker network ls | Listar redes
docker system prune | Limpiar recursos no usados
docker inspect container_name | Inspeccionar contenedor
docker stats | Estadísticas de contenedores
EOF

# Slot Laravel (20 comandos más populares)
cat > ~/.slotty/slots/laravel.txt << 'EOF'
php artisan serve | Iniciar servidor de desarrollo Laravel
php artisan make:controller ControllerName | Crear nuevo controlador
php artisan make:model ModelName | Crear nuevo modelo
php artisan make:migration create_table_name | Crear nueva migración
php artisan migrate | Ejecutar migraciones
php artisan db:seed | Ejecutar seeds
php artisan migrate:rollback | Revertir última migración
php artisan tinker | Iniciar consola interactiva (PsySH)
php artisan make:seeder SeederName | Crear nuevo seeder
php artisan make:factory FactoryName | Crear factory
php artisan make:policy PolicyName | Crear policy
php artisan make:middleware MiddlewareName | Crear middleware
php artisan make:request FormRequestName | Crear request de validación
php artisan make:resource ResourceName | Crear recurso API
php artisan route:list | Listar todas las rutas
php artisan config:cache | Cachear configuración
php artisan route:cache | Cachear rutas
php artisan view:clear | Limpiar vistas compiladas
php artisan cache:clear | Limpiar caché
php artisan optimize:clear | Limpiar todo el caché
EOF

# Slot Rails (20 comandos más populares)
cat > ~/.slotty/slots/rails.txt << 'EOF'
rails server | Iniciar servidor Rails
rails console | Consola interactiva Rails
rails generate scaffold Model name field1:string field2:text | Generar scaffold para modelo
rails generate controller ControllerName action1 action2 | Generar controlador
rails generate migration AddFieldToModel | Generar migración
rails db:migrate | Ejecutar migraciones pendientes
rails db:seed | Ejecutar seeds (datos iniciales)
rails db:rollback | Revertir última migración
rails routes | Listar rutas de la aplicación
rails test | Ejecutar suite de tests
rails test:models | Tests de modelos específicos
rails test:controllers | Tests de controladores
rails console --sandbox | Consola en modo sandbox
rails runner | Ejecutar tarea específica
rails tmp:clear | Limpiar temporales
rails log:clear | Limpiar logs
rails assets:precompile | Precompilar assets
rails assets:clobber | Eliminar assets compilados
rails db:reset | Resetear base de datos
rails new app_name | Crear nueva aplicación Rails
EOF
