# 🤖 Automação com Agentes de IA

Este stack foi desenhado para ser operado não só por humanos, mas também por **agentes LLM** (Claude Code e similares). Esta página documenta os pontos de integração.

## llms.txt

O arquivo [`llms.txt`](../llms.txt) na raiz segue o padrão [llmstxt.org](https://llmstxt.org/): um índice em Markdown que orienta LLMs sobre o que é o projeto e onde está cada documentação. Agentes que aterrissam no repositório devem começar por ele (e por [`AGENTS.md`](../AGENTS.md), que define as convenções de contribuição).

## Skills para Claude Code

O catálogo público [alexjesustech/skills](https://github.com/alexjesustech/skills) inclui skills nascidas da operação real de um Gitea self-hosted como este — a categoria `git/` cobre o ciclo completo de PR:

### `gitea-pr` — abrir o PR

Publica a feature branch e **abre o Pull Request via API do Gitea**, usando um token de longa vida injetado por variável de ambiente (`GITEA_API_TOKEN`). É o caminho obrigatório quando a `main` é protegida: o push direto é sempre rejeitado pelo `pre-receive`, e o agente precisa saber que isso é desenho, não erro.

### `gitea-pr-merge` — revisar e mergear com gates

A skill complementar fecha o ciclo: **revisa e mergeia o PR via API**, mas com gates explícitos —

1. Mostra **diff, commits e mergeabilidade** do PR;
2. Verifica o **status da CI** (Gitea Actions) e só prossegue com **checks verdes**;
3. Exige **confirmação humana explícita** antes do merge — o agente nunca mergeia por conta própria.

Esse desenho resolve o risco central de dar a um agente poder de merge: a decisão final continua humana, e a CI self-hosted (ver [`CI.md`](./CI.md)) é o gate objetivo. A skill também documenta armadilhas reais da API do Gitea (ex.: o erro `405` quando o campo de mensagem de merge não é aceito pelo método escolhido).

### `gitea-claude-mention` — @claude em issues e PRs

Equivalente caseiro do GitHub App da Anthropic: instala um workflow do Gitea Actions (`.gitea/workflows/claude.yml`) que detecta menções a `@claude` em comentários de issues/PRs e roda o Claude Code headless no runner self-hosted, respondendo como comentário. Com este stack (Actions + `act_runner`), funciona de ponta a ponta na sua máquina.

## Boas práticas para o token do agente

- **Um token de longa vida, escopo mínimo** (`write:repository`), custodiado em gerenciador de segredos (ex.: SOPS, Vault, Bitwarden) e lido por variável de ambiente no momento do uso.
- **Não gere tokens efêmeros por operação:** eles se acumulam órfãos, pois a revogação self-service via API não é garantida em todas as versões do Gitea.
- **O valor do token só vive na variável do processo** — nunca em arquivo plaintext versionado, nunca ecoado em logs.

## Ideias de novas skills

O ciclo de PR está coberto; a fronteira atual é a **provisão da CI em si**. Candidatas naturais (contribuições bem-vindas no [repositório de skills](https://github.com/alexjesustech/skills)):

- **`gitea-ci-bootstrap`** — dado um repositório novo, proteger a `main`, habilitar o Actions, criar `.gitea/workflows/ci.yml` inicial e conferir se há runner com label compatível.
- **`gitea-runner-doctor`** — diagnosticar runner/jobs (registro, labels × `runs-on`, fila `pending`, socket do Docker) sem mudar estado de serviço por conta própria.
- **`gitea-release`** — criar tag + release via API a partir do `CHANGELOG.md`.
