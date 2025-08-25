#!/bin/bash

# =================================================================
# SCRIPT DE ATUALIZAÇÃO DO GITEA
# =================================================================

set -e

echo "🔄 Iniciando atualização do Gitea..."

# Backup antes da atualização
echo "💾 Criando backup de segurança..."
./scripts/backup.sh

# Para o serviço
echo "🛑 Parando serviços..."
docker compose down

# Atualiza as imagens
echo "📥 Baixando novas imagens..."
docker compose pull

# Reinicia os serviços
echo "🚀 Reiniciando serviços..."
docker compose up -d

echo "⏳ Aguardando inicialização..."
sleep 30

# Verifica se está funcionando
if docker compose ps | grep -q "Up"; then
    echo "✅ Atualização concluída com sucesso!"
    echo "🌐 Acesse: http://localhost:$(grep HOST_PORT_WEB .env | cut -d'=' -f2)"
else
    echo "❌ Erro na atualização. Verifique os logs: docker compose logs"
    exit 1
fi