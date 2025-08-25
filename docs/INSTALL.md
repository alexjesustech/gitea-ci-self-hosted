# 📖 Guia de Instalação Detalhado - Gitea Stack

Este documento fornece instruções detalhadas para a instalação e configuração do Gitea Stack. Ele é um complemento ao guia de "Instalação Rápida" presente no `README.md` principal.

## 1. Pré-requisitos

Antes de começar, garanta que seu sistema atende aos seguintes requisitos.

| Requisito             | Versão Mínima | Instruções                                                                        |  
|:----------------------|:--------------|:----------------------------------------------------------------------------------|  
| **Docker Engine**     | `20.10+`      | [Guia de Instalação Oficial do Docker](https://docs.docker.com/engine/install/)   |  
| **Docker Compose**    | `2.0+`        | [Guia de Instalação Oficial do Compose](https://docs.docker.com/compose/install/) |  
| **RAM**               | `2GB`         | Recomendado para um desempenho estável.                                           |  
| **Disco**             | `10GB`        | Espaço livre para os dados do Gitea e backups.                                    |

## 2. Obtendo o Projeto

Clone o repositório para sua máquina local usando Git.

```bash  
# Usando HTTPS  
git clone [https://github.com/alexjesustech/gitea-stack.git](https://github.com/alexjesustech/gitea-stack.git)
```

```bash
# Ou usando SSH  
git clone git@github.com:alexjesustech/gitea-stack.git
```

### Navegue para o diretório do projeto  
cd gitea-stack

## 3. Configurando o Ambiente (.env)

A configuração do ambiente é o passo mais crucial. Todas as personalizações são feitas no arquivo .env.

#### a. Crie o arquivo de configuração

Copie o arquivo de exemplo para criar seu próprio arquivo de configuração local. Este arquivo **não é versionado** pelo Git, então suas chaves e senhas estarão seguras.

```bash
cp .env.example .env
```

#### b. Edite as variáveis

Abra o arquivo .env com seu editor de texto preferido (como nano ou vim) e ajuste as variáveis conforme sua necessidade.

```bash
nano .env
```

**Principais Variáveis a Configurar:**

| Variável        | Descrição                                                                                                  | Exemplo                  |
|:----------------|:-----------------------------------------------------------------------------------------------------------|:-------------------------|
| GITEA_DOMAIN    | O domínio que será usado para acessar o Gitea. Essencial para os URLs de clone (HTTP/SSH).                 | gitea.meudominio.com     |
| HOST_PORT_WEB   | A porta na máquina **host** que redirecionará para a porta 3000 do contêiner Gitea.                        | 3000                     |
| HOST_PORT_SSH   | A porta na máquina **host** para o serviço SSH do Gitea. **Não pode ser a porta 22** se já estiver em uso. | 2222                     |
| TZ              | Fuso horário para garantir que os logs e os timestamps de commits estejam corretos.                        | America/Porto_Velho      |
| BACKUP_SCHEDULE | A frequência dos backups automáticos, no formato Cron. O padrão é "todo dia às 3h da manhã".               | 0 3 * * *                |
| DB_PASSWORD     | Senha para o banco de dados. **Recomenda-se fortemente alterar** o valor padrão.                           | uma-senha-forte-e-segura |

Chaves Secretas:  
As variáveis como SECRET_KEY, INTERNAL_TOKEN, LFS_JWT_SECRET, etc., já vêm com valores padrão no .env.example. Para um ambiente de produção, é altamente recomendável gerar novos valores aleatórios para cada uma delas.

## 4. Executando a Instalação Automatizada

O script setup.sh foi criado para simplificar todo o processo.

#### a. Dê permissão de execução ao script

```bash
chmod +x scripts/setup.sh
```

#### b. Execute o script

```bash
./scripts/setup.sh
```

**O que este script faz?**

1. Verifica se o arquivo .env existe.
2. Torna todos os outros scripts (backup.sh, restore.sh, etc.) executáveis.
3. Cria os diretórios gitea-dados e gitea-backups no host, se não existirem.
4. Executa docker compose up -d para baixar as imagens e iniciar os contêineres em background.

## 5. Verificação Pós-Instalação

Após executar o script, verifique se tudo está funcionando corretamente.

#### a. Verifique o status dos contêineres

```bash
docker compose ps
```

Você deverá ver os contêineres do Gitea e do banco de dados com o status running ou healthy.

#### b. Verifique os logs

Se algo parecer errado, os logs são o primeiro lugar para procurar por erros.

```bash
# Ver logs de todos os serviços  
docker compose logs -f
```

```bash
# Ver logs apenas do serviço gitea
docker compose logs -f gitea
```

#### c. Primeiro Acesso

Abra seu navegador e acesse o endereço configurado (ex: http://localhost:3000 ou http://seu-dominio.com). A primeira página permitirá que você crie a conta do administrador. Preencha os dados para finalizar a instalação.

Parabéns, seu Gitea Stack está instalado e funcionando!