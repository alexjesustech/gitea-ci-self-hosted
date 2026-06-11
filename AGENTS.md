# Convenções para agentes de IA — Gitea CI Self-hosted

Regras para qualquer agente LLM (Claude Code, etc.) que trabalhe neste repositório. Comece pelo [`llms.txt`](./llms.txt) para o mapa da documentação.

## O que é este projeto

Stack Docker Compose para Git + CI auto-hospedados (Gitea + Gitea Actions + `act_runner`). Infraestrutura declarativa + scripts shell + documentação em português (Brasil).

## Convenções

- **Idioma:** documentação e comentários em **pt-BR**; código e identificadores na forma original.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) — `tipo(escopo): resumo` (imperativo, ≤ ~72 chars). Tipos usuais: `feat`, `fix`, `docs`, `chore`, `refactor`.
- **Changelog:** toda mudança notável entra em `CHANGELOG.md` na seção `[Unreleased]` (formato [Keep a Changelog](https://keepachangelog.com/pt-BR/) + SemVer). Mudança sem changelog é trabalho incompleto.
- **Branches:** trabalho em `feature/<slug>` / `fix/<slug>` (kebab-case) a partir da `main`; integração via Pull Request.
- **Staging:** `git add` por caminho específico — nunca `git add -A` / `git add .`.

## O que NÃO fazer

- **Nunca** versionar ou ler `.env` (use `.env.example` como referência).
- **Nunca** tocar em `gitea-dados/`, `gitea-backups/`, `runner-dados/` (dados persistentes do usuário).
- **Nunca** ecoar valores de tokens/segredos em saídas, logs ou commits.
- **Não** religar serviços parados (ex.: o runner) sem confirmar que a parada não foi intencional — job de CI `pending` sem runner é estado esperado.
- **Não** interpretar `pre-receive hook declined` em push para `main` protegida como erro: é o desenho do fluxo (integre via PR).

## Mudanças no docker-compose.yml

- Manter compatibilidade com `docker compose` v2 e os defaults `${VAR:-default}` funcionais sem `.env`.
- Novo serviço opcional → usar `profiles:` (o default `docker compose up -d` deve continuar subindo só o Gitea).
- Toda variável nova deve aparecer documentada no `.env.example`.
