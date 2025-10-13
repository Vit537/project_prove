#!/bin/bash
set -e

# Verificar si DATABASE_URL está configurado antes de intentar conectar
if [ -n "$DATABASE_URL" ]; then
    echo "🔄 Esperando a que la base de datos esté lista..."
    python << END
import sys
import time
import os
import psycopg2
from urllib.parse import urlparse

def wait_for_db():
    db_url = os.getenv("DATABASE_URL")
    result = urlparse(db_url)
    username = result.username
    password = result.password
    database = result.path[1:]
    hostname = result.hostname
    port = result.port
    print(db_url)

    max_retries = 30
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            conn = psycopg2.connect(
                dbname=database,
                user=username,
                password=password,
                host=hostname,
                port=port
            )
            conn.close()
            print("✅ Base de datos conectada!")
            return True
        except psycopg2.OperationalError:
            retry_count += 1
            print(f"⏳ Reintento {retry_count}/{max_retries}...")
            time.sleep(2)
    
    print("❌ No se pudo conectar a la base de datos")
    sys.exit(1)

wait_for_db()
END
else
    echo "ℹ️  DATABASE_URL no configurado, saltando verificación de base de datos"
fi

echo "🔄 Ejecutando migraciones..."
python manage.py migrate --noinput

echo "🔄 Creando superusuario (si no existe)..."
python manage.py shell << END
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("✅ Superusuario 'admin' creado")
else:
    print("ℹ️  Superusuario ya existe")
END

echo "🔄 Recolectando archivos estáticos..."
python manage.py collectstatic --noinput

echo "🚀 Iniciando Gunicorn..."
exec gunicorn myapp_conf.wsgi:application \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers ${GUNICORN_WORKERS:-4} \
    --threads ${GUNICORN_THREADS:-2} \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    --log-level info
