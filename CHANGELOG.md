# Changelog

Todas as mudanças notáveis deste projeto são documentadas neste arquivo.

O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e o projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added

- README: seção `## 📊 Status` (maturidade SemVer).

- `docs/CI.md`: linha de troubleshooting para step `run` com `exitcode '127'` (`bash` ausente em imagens Alpine usadas como label do runner) — achado da validação de ponta a ponta do stack.

- **CI self-hosted:** Gitea Actions habilitado por padrão (`GITEA_ACTIONS_ENABLED`) e serviço `runner` (`act_runner`) no `docker-compose.yml`, opcional via profile `ci`, com variáveis documentadas no `.env.example`.
- `docs/CI.md` — guia completo de CI self-hosted: registro do runner, labels × `runs-on`, primeiro workflow, fluxo branch protegida + PR + CI como gate, segurança (runner só para repos privados/de confiança) e troubleshooting.
- `docs/AGENTES-IA.md` — automação com agentes LLM: skills públicas para Claude Code (`gitea-pr`, `gitea-pr-merge`, `gitea-claude-mention`), boas práticas de token de API e ideias de novas skills.
- `llms.txt` na raiz (padrão [llmstxt.org](https://llmstxt.org/)) — orientação para LLMs sobre o projeto e o mapa da documentação.
- `AGENTS.md` na raiz — convenções para agentes de IA que contribuem com o repositório.
- Este `CHANGELOG.md`.
- `CONTRIBUTING.md` — projeto aberto a colaboração: fluxo de issues e PRs (fork → `feature/<slug>` → Conventional Commits → revisão manual do mantenedor).
- `README.md`: seção "Contribuindo" e seção "Sobre o Gitea — o projeto original" creditando e divulgando o upstream [go-gitea/gitea](https://github.com/go-gitea/gitea) (site, docs, act_runner); links correspondentes no `llms.txt`.

### Changed

- Convenção de continuidade renomeada: docs/ESTADO.md → docs/HANDOFF.md (2026-06-11).

- **Projeto renomeado de `gitea-stack` para `gitea-ci-self-hosted`** e reposicionado: de "sistema de controle de versão" para **Git + CI auto-hospedados** (Gitea + Gitea Actions + act_runner, zero minutos de CI em nuvem).
- `README.md` reescrito para o novo posicionamento (seções de CI, fluxo branch protegida + PR e automação com agentes de IA); corrigida a estrutura de diretórios (`gitea-gitea-stack/` → `gitea-ci-self-hosted/`).
- URLs de clone atualizadas em `README.md` e `docs/INSTALL.md` para o novo nome do repositório.
- `.gitignore`: adicionado `runner-dados/` (estado do runner) e `docs/ESTADO.md` (planejamento local do mantenedor).
