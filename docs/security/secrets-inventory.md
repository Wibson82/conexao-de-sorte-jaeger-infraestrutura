# 📘 Inventário de Segredos & Variáveis – Jaeger Infrastructure CI/CD

## GitHub Repository Variables (obrigatórias)
- `AZURE_CLIENT_ID` – Identificador da aplicação federada para OIDC
- `AZURE_TENANT_ID` – Diretório Azure AD
- `AZURE_SUBSCRIPTION_ID` – Assinatura com acesso ao Key Vault
- `AZURE_KEYVAULT_NAME` – Nome lógico do Key Vault usado pelo pipeline
- `AZURE_KEYVAULT_ENDPOINT` – Endpoint completo do Key Vault
- `MAX_VERSIONS_TO_KEEP` – Quantidade de versões mais recentes do GHCR preservadas (default 3)
- `MAX_AGE_DAYS` – Idade máxima em dias para purga de imagens (default 7)
- `PROTECTED_TAGS` – Lista de tags imunes à limpeza (ex.: `latest,main,production`)

> Repositório deve usar **Repository Variables** para todos os identificadores acima. Nenhum segredo sensível permanece no GitHub.

## GitHub Secrets
- Não requer segredos de aplicação. `GITHUB_TOKEN` padrão é usado com permissões endurecidas.

## Azure Key Vault – Segredos Válidos
| Serviço/Job | Segredo | Uso | Observações |
|-------------|---------|-----|-------------|
| Deploy Jaeger | *(nenhum segrego necessário)* | Docker Swarm executado no runner self-hosted | Validado: stack usa imagem pública `jaegertracing/all-in-one` e não depende de credenciais.
| GHCR Cleanup | `ghcr-maintenance-token` *(opcional)* | Apenas se `GITHUB_TOKEN` não tiver pacote `write`; manter em Key Vault se necessário | Não exposto por padrão. Utilizar somente quando autorizado.

## Mapa de Uso nos Jobs
| Job | Passo | Segredos/Variáveis | Observações |
|-----|-------|--------------------|-------------|
| `inventory-and-validate` | Inventário/validação | Apenas variáveis AZURE_* via OIDC; nenhuma leitura de Key Vault | Uso federado de identificadores.
| `deploy-selfhosted` | Deploy Swarm | Pode consumir `swarm-admin-ssh-key` *(opcional, via Key Vault)* | Para este serviço, deploy local não requer segredo. Manter lógica para obter sob demanda.
| `ghcr-maintenance` | Limpeza GHCR | `MAX_*` vars + `PROTECTED_TAGS`; pode usar segredo `ghcr-maintenance-token` se configurado via Key Vault | Implementa modo simulação + relatório.

## Regras Gerais
- Passos que precisam de credenciais devem chamá-las diretamente do Azure Key Vault via `azure/keyvault-secrets` com escopo mínimo.
- Nunca exportar segredos para `env` global do job; usar `step.env` e `GITHUB_ENV` apenas quando inevitável.
- Sempre habilitar `permissions`: `id-token: write`, `secrets: read`, `packages: write`, `actions: write` conforme necessidade.

## Itens de Ação
1. Confirmar que todas as Repository Variables listadas estão definidas no repositório.
2. Auditar Key Vault para garantir que somente segredos explicitamente utilizados pelos jobs existam.
3. Revisar `mh-conexao/infra` runners para validar labels exigidos pelos jobs de infraestrutura.
