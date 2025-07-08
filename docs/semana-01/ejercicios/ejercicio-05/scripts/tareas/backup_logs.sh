#!/bin/bash

USUARIO="$(whoami)"
BACKUP_DIR="/home/$USUARIO/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVO_BACKUP="logs_backup_$TIMESTAMP.tar.gz"
ORIGEN="/var/log"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/$ARCHIVO_BACKUP" "$ORIGEN"

if [ $? -eq 0 ]; then
    echo "✅ Backup creado: $BACKUP_DIR/$ARCHIVO_BACKUP"
else
    echo "❌ Error al crear el backup."
    exit 1
fi

find "$BACKUP_DIR" -type f -name "logs_backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "🧹 Backups mayores a 7 días eliminados."
