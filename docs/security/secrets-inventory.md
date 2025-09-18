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
- `GHCR_CLEANUP_EXECUTE` *(opcional)* – Controla modo dry-run/execução da limpeza inteligente (default `true`)

> Repositório deve usar **Repository Variables** para todos os identificadores acima. Nenhum segredo sensível permanece no GitHub.

## GitHub Secrets
- Não requer segredos de aplicação. `GITHUB_TOKEN` padrão é usado com permissões endurecidas para Buildx, GHCR e GitHub API.

## Azure Key Vault – Segredos Válidos
| Serviço/Job | Segredo | Uso | Observações |
|-------------|---------|-----|-------------|
| Deploy Jaeger | *(nenhum segrego necessário)* | Docker Swarm executado no runner self-hosted | Validado: stack usa imagem derivada no GHCR e não depende de credenciais adicionais.
| GHCR Cleanup | `ghcr-maintenance-token` *(opcional)* | Apenas se `GITHUB_TOKEN` não tiver `packages:write`; manter em Key Vault se necessário | Não exportar; ação utiliza token federado quando configurado.

## Mapa de Uso nos Jobs
| Job | Passo | Segredos/Variáveis | Observações |
|-----|-------|--------------------|-------------|
| `inventory-and-validate` | Checkout, validações, build de imagem | `AZURE_*` via OIDC, `GITHUB_TOKEN` para GHCR | Compila imagem `ghcr.io/<owner>/jaeger-infrastructure` com cache multi-nível (`hashFiles` de `Dockerfile` + `docker-compose.yml`).
| `deploy-selfhosted` | Deploy Swarm + healthchecks | (nenhum segredo por padrão) | Usa `IMAGE_REFERENCE` vindo do job anterior; Key Vault só é consultado quando `required_secrets` for configurado explicitamente.
| `ghcr-maintenance` | Limpeza GHCR | `MAX_*`, `PROTECTED_TAGS`, `GHCR_CLEANUP_EXECUTE` | Função `cleanup_ghcr_safe` protege tags críticas, respeita recência e gera relatório.

## Regras Gerais
- Passos que precisam de credenciais devem chamá-las diretamente do Azure Key Vault via OIDC com escopo mínimo; se não houver consumo, o passo termina imediatamente.
- Nunca exportar segredos para `env` global do job; usar `step.env` e arquivos temporários sob `RUNNER_TEMP`.
- Sempre habilitar `permissions` mínimos: `contents: read`, `id-token: write`, `packages: write`, `actions: write` (para limpeza de artefatos).
- Execução de `docker/login-action` utiliza apenas `GITHUB_TOKEN`, sem armazenar credenciais persistentes no runner.

## Itens de Ação
1. Confirmar que todas as Repository Variables listadas estão definidas (incluindo valores default das novas flags de limpeza).
2. Auditar Key Vault para garantir que somente segredos explicitamente utilizados pelos jobs existam.
3. Revisar runners `conexao`/`infra` para validar labels exigidos pelos jobs de infraestrutura.
4. Monitorar métricas de uso do GHCR e ajustar `MAX_*`/`PROTECTED_TAGS` conforme necessidade operacional.
