# 🦫 Gitea CI Self-hosted

> Git + CI auto-hospedados em um único `docker-compose`: Gitea, Gitea Actions e `act_runner` — zero minutos de CI em nuvem, com backup automático e configuração pronta para produção.

Este projeto oferece uma solução completa para auto-hospedar **controle de versão Git e integração contínua (CI)** com o Gitea. Além da instalação simplificada do servidor (backups automáticos, segurança reforçada, fácil atualização), o stack habilita o **Gitea Actions** e inclui um **runner self-hosted (`act_runner`)** opcional — seus workflows rodam na sua própria máquina, com sintaxe compatível com a do GitHub Actions e **sem consumir minutos de CI de plataformas em nuvem**.

Ideal para desenvolvedores solo e equipes pequenas que querem um fluxo completo — repositório privado, branch protegida, PR e pipeline de CI — rodando inteiro em hardware próprio.

## ✨ Principais Recursos

- **Git + CI no mesmo stack:** Gitea Actions habilitado por padrão e runner `act_runner` incluído como serviço opcional (profile `ci`).
- **Zero minutos de nuvem:** os workflows executam no runner local — útil inclusive como segundo destino de push de repositórios hospedados em outra plataforma.
- **Instalação Automatizada:** configure e inicie todo o ambiente com um único script (`setup.sh`).
- **Backups Automáticos:** backups diários e rotacionados (últimos 7 dias).
- **Segurança Reforçada:** chaves secretas geradas automaticamente, rede Docker isolada e limites de recursos pré-configurados.
- **Fácil Manutenção:** scripts dedicados para backup, restauração e atualização.
- **Configuração Flexível:** tudo centralizado no arquivo `.env`.
- **Pronto para Produção:** healthchecks e políticas de reinício.
- **Amigável a agentes de IA:** arquivo [`llms.txt`](./llms.txt) na raiz e [skills prontas para Claude Code](./docs/AGENTES-IA.md) que operam o fluxo de PR via API.

## 📋 Pré-requisitos

- Docker 20.10+
- Docker Compose 2.0+
- 2GB RAM disponível (runner de CI ativo: recomenda-se 4GB)
- 10GB espaço em disco

## 🚀 Instalação Rápida

### 1. Clone o projeto

```bash
git clone git@github.com:alexjesustech/gitea-ci-self-hosted.git
cd gitea-ci-self-hosted
```

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

### 5. (Opcional) Ative a CI self-hosted

Gere o token de registro do runner e suba o serviço com o profile `ci`:

```bash
docker compose exec gitea gitea actions generate-runner-token
# cole o token em RUNNER_REGISTRATION_TOKEN no .env
docker compose --profile ci up -d
```

Guia completo (labels, workflows, fluxo com branch protegida, segurança): [`docs/CI.md`](./docs/CI.md).

## ⚙️ Configuração

Todas as configurações são gerenciadas através do arquivo `.env`. As principais variáveis são:

- `GITEA_DOMAIN`: seu domínio (ex: `gitea.meudominio.com`).
- `HOST_PORT_WEB`: porta HTTP exposta no host (ex: `3000`).
- `TZ`: fuso horário dos contêineres (ex: `America/Porto_Velho`).
- `BACKUP_SCHEDULE`: horário do backup em formato cron (padrão: `0 3 * * *`).
- `GITEA_ACTIONS_ENABLED`: habilita o Gitea Actions no servidor (padrão: `true`).
- `RUNNER_REGISTRATION_TOKEN`: token de registro do runner de CI (ver [`docs/CI.md`](./docs/CI.md)).
- `RUNNER_LABELS`: labels que mapeiam o `runs-on` dos workflows para a imagem de execução.

## 🔁 Fluxo recomendado: branch protegida + PR + CI

A experiência de operar este stack no dia a dia consolidou um fluxo que vale adotar desde o início:

1. **Proteja a `main`** no Gitea (Configurações do repositório → Branches): nem o admin consegue push direto — o hook `pre-receive` rejeita.
2. **Trabalhe em feature branches** e integre via Pull Request.
3. **Deixe a CI ser o gate do merge:** o `act_runner` executa os workflows do PR; só mergeie com checks verdes.

> 💡 Com a `main` protegida, um `git push origin main` rejeitado com `pre-receive hook declined` **é o comportamento esperado**, não um erro de autenticação. Integre via PR.

Detalhes, armadilhas e dicas de operação em [`docs/CI.md`](./docs/CI.md).

## 🤖 Automação com agentes de IA

Este repositório é pensado para ser operado também por agentes LLM (Claude Code e similares):

- [`llms.txt`](./llms.txt) na raiz orienta LLMs sobre o projeto e sua documentação.
- [`AGENTS.md`](./AGENTS.md) define as convenções que agentes devem seguir ao contribuir.
- Skills públicas para Claude Code automatizam o fluxo de PR contra um Gitea self-hosted — destaque para a **`gitea-pr-merge`**, que revisa diff, commits e status de CI e só mergeia com checks verdes + confirmação humana. Ver [`docs/AGENTES-IA.md`](./docs/AGENTES-IA.md).

## 🛠️ Comandos Úteis (Docker)

Execute os comandos a partir do diretório raiz do projeto.

```bash
# Iniciar serviços em background (somente Gitea)
docker compose up -d

# Iniciar incluindo o runner de CI
docker compose --profile ci up -d

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
gitea-ci-self-hosted/
├── .env                   # Configurações locais (NÃO versionar)
├── .env.example           # Modelo para outros ambientes
├── docker-compose.yml     # Gitea + act_runner (profile ci)
├── .gitignore             # Arquivos a ignorar no Git
├── README.md              # Este documento
├── AGENTS.md              # Convenções para agentes de IA
├── llms.txt               # Orientação para LLMs (padrão llmstxt.org)
├── CHANGELOG.md           # Histórico de mudanças
├── scripts/               # Scripts de automação
│   ├── setup.sh           # Script de instalação
│   ├── backup.sh          # Backup manual
│   ├── restore.sh         # Restauração
│   └── update.sh          # Atualização
├── config/                # Configurações adicionais
│   └── app.ini.template   # Template de configuração
└── docs/                  # Documentação adicional
    ├── INSTALL.md         # Guia de instalação
    ├── CI.md              # Guia de CI self-hosted (Actions + act_runner)
    ├── AGENTES-IA.md      # Automação com agentes LLM (skills, llms.txt)
    ├── BACKUP.md          # Guia de backup
    └── TROUBLESHOOTING.md # Solução de problemas

# Dados Persistentes (volumes criados no host)
gitea-dados/               # Dados principais do Gitea (repos, db, etc.)
gitea-backups/             # Backups automáticos (últimos 7 dias)
runner-dados/              # Estado do act_runner (registro, cache)
```

## 🆘 Suporte

- 📖 [Guia de Instalação](./docs/INSTALL.md)
- ⚙️ [Guia de CI Self-hosted](./docs/CI.md)
- 🤖 [Automação com Agentes de IA](./docs/AGENTES-IA.md)
- 🔧 [Solução de Problemas](./docs/TROUBLESHOOTING.md)
- 💾 [Guia de Backup](./docs/BACKUP.md)

## 📄 Licença

Distribuído sob a Licença MIT. Veja `LICENSE` para mais detalhes.
