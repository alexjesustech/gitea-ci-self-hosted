# 🤝 Contribuindo

Contribuições são bem-vindas! Este projeto empacota o [Gitea](https://github.com/go-gitea/gitea) como um stack Docker Compose de Git + CI self-hosted — melhorias de documentação, do compose, dos scripts e do troubleshooting são as mais valiosas.

## Como contribuir

### Issues

- Encontrou um bug, uma instrução desatualizada ou tem uma ideia? [Abra uma issue](../../issues) descrevendo o cenário (versão do Docker/Compose, trecho de log, passos para reproduzir).
- Dúvidas de uso também podem virar issue — se a resposta for útil a outros, ela vira documentação.

### Pull Requests

1. Faça um fork e crie uma branch a partir da `main`: `feature/<slug>` ou `fix/<slug>` (kebab-case).
2. Siga as convenções do repositório (detalhes em [`AGENTS.md`](./AGENTS.md), válidas para humanos e agentes):
   - Commits no padrão [Conventional Commits](https://www.conventionalcommits.org/) — `tipo(escopo): resumo`.
   - Documentação em **pt-BR**; código e identificadores na forma original.
   - Toda mudança notável ganha uma entrada no `CHANGELOG.md` em `[Unreleased]`.
3. Mudanças no `docker-compose.yml` devem manter o default funcional sem `.env` (`${VAR:-default}`) e serviços opcionais atrás de `profiles:`.
4. Abra o PR contra a `main` descrevendo o quê e o porquê.

### Revisão

Todo PR externo passa por **revisão manual do mantenedor** antes do merge — incluindo verificação de segurança do conteúdo (este é um projeto de infraestrutura; mudanças em scripts e compose são auditadas com atenção redobrada).

## O que evitar

- PRs que versionem dados locais (`.env`, `gitea-dados/`, `runner-dados/`) — ver `.gitignore`.
- Mudanças de comportamento sem atualizar a documentação correspondente (`README.md`, `docs/`).
- Adicionar dependências além de Docker + Compose — a simplicidade do stack é uma feature.

## Idioma

A documentação do projeto é em português (Brasil). Issues e PRs em inglês são bem-vindos; a doc resultante será mantida em pt-BR.
