# 🦫 Gitea Stack - Sistema de Controle de Versão

> Sistema Git auto-hospedado, pronto para produção, com backup automático e configuração profissional.

Este projeto oferece uma solução completa para auto-hospedagem do Gitea utilizando Docker. O objetivo é simplificar drasticamente o processo de instalação, configuração e manutenção, incluindo recursos essenciais como backups automáticos, segurança aprimorada e fácil atualização. Ideal para equipes e desenvolvedores que buscam um controle de versão Git privado, robusto e de baixo custo.

## ✨ Principais Recursos
- **Instalação Automatizada:** Configure e inicie todo o ambiente com um único script (`setup.sh`).
- **Backups Automáticos:** Backups diários e rotacionados (últimos 7 dias) para garantir a segurança dos seus dados.
- **Segurança Reforçada:** Chaves secretas geradas automaticamente, rede Docker isolada e limites de recursos pré-configurados.
- **Fácil Manutenção:** Scripts dedicados para backup, restauração e atualização do sistema.
- **Configuração Flexível:** Todas as configurações importantes centralizadas no arquivo `.env`.
- **Pronto para Produção:** Inclui healthchecks e políticas de reinício para maior estabilidade.

## 📋 Pré-requisitos
- Docker 20.10+
- Docker Compose 2.0+
- 2GB RAM disponível
- 10GB espaço em disco

## 🚀 Instalação Rápida

### 1. Clone o projeto
```bash
git clone git@github.com:alexjesustech/gitea-stack.git
cd gitea-stack
````

### 2. Configure seu ambiente

Copie o arquivo de exemplo e edite-o com suas configurações (domínio, portas, etc.).

```bash
cp .env.example .env
nano .env
```

### 3. Execute a instalação

O script tornará os outros scripts executáveis e iniciará os serviços.

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 4. Acesse o Gitea

Aguarde um ou dois minutos para o serviço iniciar completamente e acesse `http://localhost:3000` (ou a porta que você configurou na variável `HOST_PORT_WEB`).

## ⚙️ Configuração

Todas as configurações são gerenciadas através do arquivo `.env`. As principais variáveis são:

- `GITEA_DOMAIN`: Seu domínio (ex: `gitea.meudominio.com`).
- `HOST_PORT_WEB`: Porta HTTP que será exposta no seu host (ex: `3000`).
- `TZ`: Fuso horário para os contêineres (ex: `America/Porto_Velho`).
- `BACKUP_SCHEDULE`: Horário do backup no formato cron (padrão: `0 3 * * *` - todo dia às 3h da manhã).

## 🛠️ Comandos Úteis (Docker)

Execute os comandos a partir do diretório raiz do projeto.

```bash
# Iniciar serviços em background
docker compose up -d

# Ver logs de todos os serviços em tempo real
docker compose logs -f

# Parar todos os serviços
docker compose down

# Reiniciar os serviços
docker compose restart
```

## 🔄 Manutenção e Rotinas

Os scripts a seguir automatizam as principais tarefas de manutenção.

```bash
# Executar um backup manual a qualquer momento
./scripts/backup.sh

# Restaurar o Gitea a partir de um arquivo de backup
./scripts/restore.sh nome-do-arquivo-de-backup.zip

# Atualizar a imagem do Gitea para a versão mais recente
./scripts/update.sh
```

## 📁 Estrutura de Diretórios

```
gitea-gitea-stack/
├── .env                   # Configurações locais (NÃO versionar)
├── .env.example           # Modelo para outros ambientes
├── docker-compose.yml     # Estrutura principal
├── .gitignore             # Arquivos a ignorar no Git
├── README.md              # Documentação completa
├── scripts/               # Scripts de automação
│   ├── setup.sh           # Script de instalação
│   ├── backup.sh          # Backup manual
│   ├── restore.sh         # Restauração
│   └── update.sh          # Atualização
├── config/                # Configurações adicionais
│   └── app.ini.template   # Template de configuração
└── docs/                  # Documentação adicional
    ├── INSTALL.md         # Guia de instalação
    ├── BACKUP.md          # Guia de backup
    └── TROUBLESHOOTING.md # Solução de problemas

# Dados Persistentes (Volumes criados no host)
gitea-dados/               # Dados principais do Gitea (repos, db, etc.)
gitea-backups/             # Backups automáticos (últimos 7 dias)
```

## 🆘 Suporte

- 📖 [Guia de Instalação](./docs/INSTALL.md)
- 🔧 [Solução de Problemas](./docs/TROUBLESHOOTING.md)
- 💾 [Guia de Backup](./docs/BACKUP.md)

## 📄 Licença

Distribuído sob a Licença MIT. Veja `LICENSE` para mais detalhes.

```
```


---

# 🦫 Gitea Stack - Sistema de Controle de Versão

> Sistema Git auto-hospedado com backup automático e configuração profissional.

## 📋 Pré-requisitos
- Docker 20.10+
- Docker Compose 2.0+
- 2GB RAM disponível
- 10GB espaço em disco

## 📁 Estrutura do Projeto
```
gitea-gitea-stack/
├── .env                   # Configurações locais (NÃO versionar)
├── .env.example           # Modelo para outros ambientes
├── docker-compose.yml     # Estrutura principal
├── .gitignore             # Arquivos a ignorar no Git
├── README.md              # Documentação completa
├── scripts/               # Scripts de automação
│   ├── setup.sh           # Script de instalação
│   ├── backup.sh          # Backup manual
│   ├── restore.sh         # Restauração
│   └── update.sh          # Atualização
├── config/                # Configurações adicionais
│   └── app.ini.template   # Template de configuração
└── docs/                  # Documentação adicional
    ├── INSTALL.md         # Guia de instalação
    ├── BACKUP.md          # Guia de backup
    └── TROUBLESHOOTING.md # Solução de problemas
```

## 🚀 Instalação Rápida

### 1. Clone o projeto
```bash
git clone git@github.com:alexjesustech/gitea-stack.git
cd gitea-stack
```

### 2. Execute a instalação
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 3. Acesse o Gitea
http://localhost:3000

## ⚙️ Configuração
### 1. Edite o arquivo .env com suas configurações:
```bash
cp .env.example .env
nano .env
```

### 2. Principais configurações:
- `GITEA_DOMAIN`: Seu domínio
- `HOST_PORT_WEB`: Porta de acesso
- `TZ`: Fuso horário
- `BACKUP_SCHEDULE`: Horário do backup

## 🛠️ Comandos Úteis
```bash
# Iniciar serviços
docker compose up -d

# Ver logs
docker compose logs -f

# Parar serviços
docker compose down

# Backup manual
./scripts/backup.sh

# Atualizar sistema
./scripts/update.sh

# Restaurar backup
./scripts/restore.sh backup-file.zip
```

## 🔒 Segurança
- ✅ Chaves secretas geradas automaticamente
- ✅ Backup automático diário
- ✅ Isolamento de rede Docker
- ✅ Healthcheck configurado
- ✅ Limites de recursos

## 📁 Estrutura de Dados
```
gitea-dados/     # Dados principais do Gitea
gitea-backups/   # Backups automáticos (7 dias)
```

## 🆘 Suporte
- 📖 Guia de Instalação
- 🔧 Solução de Problemas
- 💾 Guia de Backup

## 📄 Licença
MIT License - veja LICENSE para detalhes.
