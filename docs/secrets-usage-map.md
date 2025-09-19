# Secrets Usage Map – Jaeger Infrastructure

## GitHub Secrets
- `AZURE_CLIENT_ID` – Identificador OIDC usado por `azure/login@v2`.
- `AZURE_TENANT_ID` – Tenant Azure AD utilizado durante a autenticação.
- `AZURE_SUBSCRIPTION_ID` – Assinatura com permissão de leitura no Key Vault e resource group.
- `AZURE_KEYVAULT_NAME` – Nome lógico do Key Vault (permite futuras consultas seletivas).
- `AZURE_KEYVAULT_ENDPOINT` *(opcional)* – Endpoint completo, caso tooling exija.
- `GITHUB_TOKEN` – Token padrão do Actions (permite GHCR e API GitHub quando necessário).

## Azure Key Vault
- Nenhum segredo é consumido atualmente. Caso venha a ser necessário, documente aqui antes de habilitar no workflow.

## Jobs × Consumo de Segredos
| Job | Propósito | Segredos usados | Observações |
| --- | --- | --- | --- |
| `inventory-and-validate` | Validações, build e export de artefatos | `AZURE_*`, `GITHUB_TOKEN` | Apenas autentica via OIDC; não consulta Key Vault. |
| `deploy-selfhosted` | Deploy Swarm no Hostinger e health checks | `AZURE_*`, `GITHUB_TOKEN` | Confirma lista vazia do Key Vault; sem busca de segredos. |
| `ghcr-maintenance` | Limpeza opcional de imagens GHCR | `GITHUB_TOKEN` (+ `MAX_*`, `PROTECTED_TAGS` se configurados) | Executa via API GitHub; parâmetros podem ser definidos como variáveis se a limpeza for habilitada. |

## Observações Operacionais
- Atualize este arquivo antes de incluir novos segredos ou variáveis no workflow.
- Utilize `::add-mask::` sempre que manipular valores sensíveis (quando futuros segredos forem adicionados).
- Parâmetros de limpeza de imagens (`MAX_VERSIONS_TO_KEEP`, etc.) podem ser adicionados como variáveis do repositório quando a rotina de GHCR estiver habilitada.
- Imagem padrão utilizada no Swarm: `ghcr.io/wibson82/jaeger-infrastructure` (rootless).
