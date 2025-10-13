#!/bin/bash
set -e

echo "🚀 Iniciando aplicación Django..."

# Verificar si DATABASE_URL está configurado antes de intentar conectar
if [ -n "$DATABASE_URL" ]; then
    echo "🔄 DATABASE_URL configurado, esperando conexión..."
    
    # Usar Python para verificar la conexión
    python -c "
import os
import sys
import time
import psycopg

def wait_for_db():
    db_url = os.getenv('DATABASE_URL')
    max_retries = 30
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            conn = psycopg.connect(db_url)
            conn.close()
            print('✅ Base de datos conectada!')
            return True
        except Exception as e:
            retry_count += 1
            print(f'⏳ Reintento {retry_count}/{max_retries}... Error: {e}')
            time.sleep(2)
    
    print('❌ No se pudo conectar a la base de datos')
    sys.exit(1)

wait_for_db()
"
    echo "🔄 Ejecutando migraciones..."
    python manage.py migrate --noinput
else
    echo "ℹ️  DATABASE_URL no configurado, usando SQLite local"
fi

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
    --workers ${GUNICORN_WORKERS:-2} \
    --threads ${GUNICORN_THREADS:-2} \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    --log-level info
