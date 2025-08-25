# 🔧 Guia de Solução de Problemas (Troubleshooting)

Encontrou um problema? Não se preocupe. Este guia foi criado para ajudar a diagnosticar e resolver os erros mais comuns que podem ocorrer durante a instalação ou uso do Gitea Stack.

## Diagnóstico Básico

Antes de procurar por uma solução específica, sempre comece com estes dois comandos. Eles fornecem 90% das informações que você precisa para identificar um problema.

#### 1. Verificar o Status dos Contêineres  
Este comando mostra se os seus serviços (gitea, db, etc.) estão em execução, reiniciando ou se pararam.  

```bash  
docker compose ps
```

Procure por qualquer status que não seja running ou healthy.

#### 2. Verificar os Logs

Os logs são o seu melhor amigo. Eles contêm as mensagens de erro detalhadas de cada serviço.

```bash

# Para ver os logs de todos os serviços em tempo real  
docker compose logs \-f

# Para ver os logs específicos do Gitea (mais comum)  
docker compose logs \-f gitea
```

---

## 🐛 Problemas Comuns e Soluções

### 1. Erro: port is already allocated ou address already in use

* **Sintoma:** Ao executar docker compose up, você recebe uma mensagem de erro indicando que uma porta (como a 3000 ou 2222\) já está em uso.
* **Causa:** Outro serviço na sua máquina host (fora do Docker) já está utilizando a porta que o Gitea precisa.
* **Solução:**
    1. **Identifique o processo:** Use o comando sudo lsof -i :<NUMERO_DA_PORTA> (ex: sudo lsof \-i :3000) para descobrir qual programa está usando a porta.
    2. **Altere a porta no Gitea Stack:** A solução mais fácil é escolher outra porta. Edite o seu arquivo .env e altere a variável HOST_PORT_WEB ou HOST_PORT_SSH para um número de porta diferente e que esteja livre.  
       Ini, TOML  
       # Exemplo no .env  
       HOST_PORT_WEB=3001  
       HOST_PORT_SSH=2223

    3. **Reinicie os serviços:** Aplique as novas configurações com docker compose up -d.

### 2. O contêiner do Gitea fica reiniciando (restarting) ou não inicia

* **Sintoma:** O comando docker compose ps mostra o contêiner gitea com o status restarting ou exited.
* **Causa:** Geralmente isso é causado por um erro de configuração ou de permissão.
* **Solução:**
    1. **Verifique os logs:** Este é o passo mais importante. Execute docker compose logs gitea e procure por mensagens de erro (geralmente nas últimas linhas).
    2. **Permissões de Diretório:** A causa mais comum é um problema de permissão no diretório gitea-dados. O contêiner do Gitea roda com o usuário git (ID 1000). Para corrigir, ajuste o proprietário do diretório:  
       Bash  
       # Este comando dá a propriedade ao usuário correto  
       sudo chown -R 1000:1000 gitea-dados

    3. **Configuração do .env:** Verifique se não há erros de digitação ou valores inválidos no seu arquivo .env.

### 3. Clone via SSH não funciona (Permission denied)

* **Sintoma:** Ao tentar clonar um repositório com SSH (git clone ssh://...), você recebe um erro de Permission denied (publickey) ou a conexão falha.
* **Causa:** Pode haver múltiplos motivos para isso.
* **Solução (Verifique em ordem):**
    1. **Chave SSH Adicionada:** Confirme se você adicionou a sua chave SSH **pública** (\~/.ssh/id_rsa.pub) às configurações da sua conta no Gitea.
    2. **Configuração do Domínio e Porta:** Verifique se as variáveis GITEA_DOMAIN and HOST_PORT_SSH no arquivo .env estão corretas. O URL que o Gitea mostra para o clone SSH depende diretamente delas.
    3. **URL de Clone Correto:** Se você alterou a HOST_PORT_SSH para algo diferente de 22 (ex: 2222), você **precisa** incluir a porta no seu comando git clone:  
       Bash  
       # Formato correto para portas não-padrão  
       git clone ssh://git@gitea.meudominio.com:2222/seu-usuario/seu-repo.git

    4. **Firewall:** Verifique se um firewall na sua máquina host ou na sua rede não está bloqueando a porta que você configurou para o SSH.

### 4. Alterações no arquivo .env não têm efeito

* **Sintoma:** Você altera uma variável no .env (como uma porta ou uma senha), mas o comportamento da aplicação não muda.
* **Causa:** O Docker Compose carrega as variáveis do .env apenas quando os contêineres são **criados**. Um simples restart não é suficiente.
* Solução:  
  Você precisa forçar a recriação dos contêineres. O comando up -d faz isso de forma inteligente, recriando apenas o que mudou.  
  Bash  
  # Este comando irá parar, remover e recriar os contêineres  
  # usando os novos valores do .env. Seus dados nos volumes serão preservados.  
  docker compose up -d --force-recreate  