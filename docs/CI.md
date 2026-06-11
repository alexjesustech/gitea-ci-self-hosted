# ⚙️ Guia de CI Self-hosted — Gitea Actions + act_runner

Este guia cobre a ativação e a operação da integração contínua deste stack: o **Gitea Actions** (lado servidor) e o **`act_runner`** (executor self-hosted), além das práticas que a experiência de operar esse arranjo no dia a dia consolidou.

## 1. Como funciona

- O **Gitea Actions** é o sistema de CI nativo do Gitea, com sintaxe de workflow **compatível com a do GitHub Actions** (`on:`, `jobs:`, `steps:`, `uses:`).
- Os workflows vivem em **`.gitea/workflows/*.yml`** no repositório (e não em `.github/workflows/`).
- O **`act_runner`** é o executor: registra-se no servidor, escuta jobs e os executa em containers Docker na sua máquina — por isso o serviço monta `/var/run/docker.sock`.

## 2. Ativando

O Actions já vem habilitado por padrão neste stack (`GITEA_ACTIONS_ENABLED=true`). Para subir o runner:

```bash
# 1. Gere o token de registro
docker compose exec gitea gitea actions generate-runner-token
# (alternativa pela UI: Administração do Site -> Actions -> Runners -> Criar token)

# 2. Cole o token no .env
#    RUNNER_REGISTRATION_TOKEN=<token>

# 3. Suba o runner (serviço fica atrás do profile "ci")
docker compose --profile ci up -d

# 4. Confirme o registro
docker compose logs -f runner
# UI: Administração do Site -> Actions -> Runners (runner deve aparecer como "idle")
```

Por fim, habilite o Actions **no repositório** desejado: Configurações do repositório → seção Repositório → marcar "Actions" (em instalações novas costuma vir habilitado).

## 3. Labels e `runs-on`

O job só é capturado pelo runner se o `runs-on` do workflow **casar com uma label registrada**. A variável `RUNNER_LABELS` define esse mapeamento:

```
RUNNER_LABELS=ubuntu-latest:docker://gitea/runner-images:ubuntu-latest
```

significa: jobs com `runs-on: ubuntu-latest` executam num container da imagem `gitea/runner-images:ubuntu-latest`. Você pode registrar várias labels separadas por vírgula.

> ⚠️ **Labels são fixadas no registro.** Mudar `RUNNER_LABELS` depois exige re-registrar o runner (apague `runner-dados/.runner` e recrie o serviço com um token novo).

## 4. Primeiro workflow

`.gitea/workflows/ci.yml`:

```yaml
name: CI
on:
  push:
    branches: [develop, "feature/**"]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "rodando na minha própria máquina 🎉"
```

## 5. Fluxo recomendado: branch protegida + PR + CI como gate

Práticas consolidadas pela operação contínua deste arranjo:

1. **Proteja a `main`** (Configurações do repositório → Branches → Proteger). O hook `pre-receive` do servidor passa a rejeitar push direto — **inclusive de administradores**.
2. **Integre sempre via Pull Request:** push da feature branch → PR → merge após CI verde.
3. **`pre-receive hook declined` na `main` é sucesso, não falha.** Quem opera (humano ou agente de IA) não deve interpretar a rejeição como erro de autenticação nem tentar desabilitar a proteção — é o desenho funcionando.
4. **CI `pending` sem runner ativo é estado esperado, não defeito.** Se o runner estiver propositalmente parado (ex.: para liberar recursos da máquina), os jobs ficam enfileirados e executam quando ele voltar. Antes de "consertar" religando um serviço parado, confirme que a parada não foi intencional.
5. **Espelho de CI para repositórios em outra plataforma:** adicione o Gitea como **segundo push URL do mesmo remote** (`git remote set-url --add --push origin <url-do-gitea>`). Cada `git push` gera um push event nativo no Gitea e dispara o pipeline local — zero minutos de CI em nuvem, sem migrar a hospedagem principal.

## 6. Segurança — leia antes de expor

- **Runner self-hosted só para repositórios privados/de confiança.** Em repositório público ou com colaboradores externos, um PR malicioso pode executar código arbitrário na sua máquina via workflow (vetor de RCE). Nesse cenário, mantenha a CI em runners de nuvem ou exija aprovação manual para workflows de terceiros.
- **O socket do Docker montado no runner equivale a root no host.** Trate o runner como componente privilegiado; não o exponha à internet.
- **Tokens de API:** para automações (ver [`AGENTES-IA.md`](./AGENTES-IA.md)), prefira **um token de longa vida com escopo mínimo** (`write:repository`), custodiado em um gerenciador de segredos e injetado por variável de ambiente — em vez de gerar tokens efêmeros a cada operação, que se acumulam órfãos (o Gitea não oferece revogação self-service via API em todas as versões).

## 7. Troubleshooting

| Sintoma | Causa provável | Ação |
|---|---|---|
| Job fica `pending` para sempre | Runner parado, ou `runs-on` não casa com nenhuma label | `docker compose --profile ci ps`; conferir labels na UI de Runners |
| Runner não registra | Token expirado/incorreto, ou URL inacessível de dentro da rede | Gerar token novo; conferir `RUNNER_INSTANCE_URL` (padrão `http://gitea:3000`, nome do serviço na rede Docker) |
| `pre-receive hook declined` no push da `main` | Branch protegida (esperado) | Integrar via PR |
| Workflow não dispara | Arquivo fora de `.gitea/workflows/`, ou Actions desabilitado no repo | Mover o YAML; habilitar Actions nas configurações do repositório |
| Job falha ao usar `uses:` de action externa | Sem acesso à internet ou mirror de actions não configurado | Conferir rede do container; o Gitea resolve actions de `gitea.com` e GitHub por padrão |
| Step `run` falha com `exitcode '127'` / `exec: "bash": executable file not found` | A imagem do label não tem `bash` (ex.: imagens Alpine) — os steps `run` executam com bash por padrão | Usar imagem base Debian/Ubuntu no label (ex.: `gitea/runner-images:ubuntu-latest`) ou definir `shell: sh` no step |
