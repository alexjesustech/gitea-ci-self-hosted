# 💾 Guia de Backup e Restauração

A segurança dos seus dados é a principal prioridade deste projeto. Este guia detalha a estratégia de backup implementada e como você pode restaurar seus dados em caso de necessidade.

## Estratégia de Backup

O Gitea Stack utiliza uma estratégia dupla:  
1.  **Backups Automáticos:** Um contêiner dedicado (`gitea-backup`) executa backups diários de todos os dados críticos.  
2.  **Backups Manuais:** Um script (`backup.sh`) permite que você acione o processo de backup a qualquer momento.

### O Que é Incluído no Backup?  
Cada arquivo de backup (`.zip`) é um pacote completo que contém:  
- **Banco de Dados:** Todas as informações de usuários, issues, pull requests, etc.  
- **Repositórios:** Todos os repositórios Git.  
- **Arquivos de Configuração:** O `app.ini` gerado pelo Gitea.  
- **Dados do Usuário:** Avatares, anexos e objetos LFS (Large File Storage).

## ⚙️ Backup Automático

Por padrão, o sistema está configurado para executar um backup completo todos os dias às 3h da manhã.

#### Configuração  

A frequência dos backups é controlada pela variável `BACKUP_SCHEDULE` no seu arquivo `.env`.  

```ini  
# .env  
# Formato Cron: minuto hora dia mês dia-da-semana  
BACKUP_SCHEDULE='0 3 * * *'
```

#### Localização e Retenção

* Os arquivos de backup são salvos no diretório gitea-backups/ na raiz do projeto.
* O sistema mantém **os últimos 7 backups diários**. Arquivos mais antigos são excluídos automaticamente para economizar espaço.

## ✋ Backup Manual

É uma boa prática executar um backup manual antes de realizar qualquer alteração significativa, como uma atualização ou uma mudança de configuração.

Para executar um backup manual, simplesmente execute o seguinte comando na raiz do projeto:

```bash
./scripts/backup.sh
```

Um novo arquivo .zip com o timestamp atual será gerado no diretório gitea-backups/.

## 🔄 Processo de Restauração

Restaurar um backup é um processo delicado que substituirá **TODOS** os dados atuais do Gitea pelo conteúdo do arquivo de backup. Siga os passos com atenção.

⚠️ **Atenção:** A restauração é uma ação destrutiva. Todos os dados (repositórios, usuários, comentários) criados após a data do backup que você está restaurando serão **PERMANENTEMENTE perdidos**.

### Passo a Passo para Restaurar

1. Identifique o arquivo de backup  
Primeiro, liste os backups disponíveis para encontrar o que você deseja restaurar:

```bash
ls -l gitea-backups/
```

Anote o nome completo do arquivo (ex: gitea-backup-2025-08-24-18-30-00.zip).

2. Pare os serviços do Gitea  
Para evitar corrupção de dados, é essencial que os serviços estejam completamente parados antes de iniciar a restauração.

```bash
docker compose down
```

3. Execute o script de restauração  
Execute o script restore.sh, passando o nome do arquivo de backup como argumento.

```bash
# Substitua pelo nome do seu arquivo!  
./scripts/restore.sh gitea-backup-2025-08-24-18-30-00.zip
```

O script irá limpar os dados antigos, extrair o conteúdo do backup para os volumes corretos e redefinir as permissões.

4. Reinicie os serviços  
Após a conclusão do script, inicie os contêineres novamente.

```bash
docker compose up -d
```

5. Verifique a restauração  
Aguarde um ou dois minutos para os serviços iniciarem completamente. Acesse a interface web do Gitea e confirme que seus repositórios, usuários e configurações foram restaurados ao estado do backup.