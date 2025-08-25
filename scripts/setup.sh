#!/bin/bash

# =================================================================
# SCRIPT DE INSTALAÇÃO DO GITEA
# =================================================================

set -e  # Para em caso de erro

echo "🚀 Iniciando instalação do Gitea..."

# Verifica se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instale o Docker primeiro."
    exit 1
fi

# Verifica se o Docker Compose está instalado
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado. Instale o Docker Compose primeiro."
    exit 1
fi

# Cria o arquivo .env se não existir
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env..."
    cp .env.example .env
    
    # Gera chaves secretas
    SECRET_KEY=$(openssl rand -hex 32)
    JWT_SECRET=$(openssl rand -hex 32)
    
    # Substitui as chaves no arquivo .env
    sed -i "s/SUBSTITUA-POR-UMA-CHAVE-SECRETA-REAL/$SECRET_KEY/" .env
    sed -i "s/SUBSTITUA-POR-UMA-CHAVE-JWT-REAL/$JWT_SECRET/" .env
    
    echo "✅ Arquivo .env criado com chaves secretas geradas automaticamente."
    echo "⚠️  IMPORTANTE: Edite o arquivo .env para ajustar as configurações do seu ambiente."
fi

# Cria as pastas necessárias
echo "📁 Criando estrutura de pastas..."
mkdir -p gitea-dados gitea-backups

# Define permissões corretas
USER_UID=$(id -u)
USER_GID=$(id -g)
sudo chown -R $USER_UID:$USER_GID gitea-dados gitea-backups

echo "🐳 Iniciando containers..."
docker compose up -d

echo "⏳ Aguardando o Gitea inicializar..."
sleep 30

# Verifica se o serviço está rodando
if docker compose ps | grep -q "Up"; then
    echo "✅ Gitea instalado com sucesso!"
    echo ""
    echo "🌐 Acesse: http://localhost:$(grep HOST_PORT_WEB .env | cut -d'=' -f2)"
    echo "🔧 Para configuração inicial, use o usuário administrador"
    echo "📊 Para ver logs: docker compose logs -f"
    echo "🛑 Para parar: docker compose down"
else
    echo "❌ Erro na instalação. Verifique os logs: docker compose logs"
    exit 1
fi