#!/bin/bash

# =================================================================
# SCRIPT DE BACKUP MANUAL DO GITEA
# =================================================================

set -e

echo "💾 Iniciando backup manual do Gitea..."

# Verifica se o container está rodando
if ! docker compose ps | grep -q "Up"; then
    echo "❌ Container do Gitea não está rodando!"
    exit 1
fi

# Cria backup
BACKUP_NAME="gitea-backup-manual-$(date +%Y%m%d_%H%M%S).zip"
echo "📦 Criando backup: $BACKUP_NAME"

docker compose exec gitea gitea dump -c /data/gitea/conf/app.ini -f "/backups/$BACKUP_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Backup criado com sucesso: ./gitea-backups/$BACKUP_NAME"
    echo "📊 Tamanho: $(du -h ./gitea-backups/$BACKUP_NAME | cut -f1)"
else
    echo "❌ Erro ao criar backup!"
    exit 1
fi