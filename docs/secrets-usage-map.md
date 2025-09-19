# Secrets Usage Map – Jaeger Infrastructure

## Repository Variables (`vars`)
- `AZURE_CLIENT_ID` – OIDC application identifier used by `azure/login@v2`.
- `AZURE_TENANT_ID` – Azure AD tenant leveraged during OIDC auth.
- `AZURE_SUBSCRIPTION_ID` – Subscription granted access to the Key Vault and resource group.
- `AZURE_KEYVAULT_NAME` – Logical Key Vault name consumed when secrets are required.
- `AZURE_KEYVAULT_ENDPOINT` – HTTPS endpoint for the same vault (kept for tooling compatibility).
- `MAX_VERSIONS_TO_KEEP` – Upper bound for retained GHCR image versions (defaults to 3).
- `MAX_AGE_DAYS` – Maximum age in days before an image becomes eligible for cleanup (defaults to 7).
- `PROTECTED_TAGS` – Comma separated list of GHCR tags never deleted (defaults to `latest,main,production`).
- `GHCR_CLEANUP_EXECUTE` – Controls dry-run versus execution for the cleanup helper (`true` executes deletions).

> All entries above must live as GitHub repository variables. No application secret is stored in GitHub.

## GitHub Secrets
- `GITHUB_TOKEN` – Default token with `packages:write` and `actions:write` permissions (auto-provided).

## Azure Key Vault Secrets
- None required for the Jaeger deployment today. Keep the vault reference for future expansion but do not fetch secrets unless explicitly listed in a job.

## Jobs × Secret Usage
| Job | Purpose | Secrets/Variables Needed | Notes |
| --- | --- | --- | --- |
| `inventory-and-validate` | Compose lint, Buildx build and artifact export | `AZURE_*` (OIDC), `GITHUB_TOKEN` | Key Vault is not queried; job documents that zero secrets are required.
| `deploy-selfhosted` | Deploy stack on Hostinger Swarm and perform health checks | `AZURE_*` (OIDC), `GITHUB_TOKEN` | Key Vault step runs only when an explicit allowlist is populated; default is an empty list.
| `ghcr-maintenance` | Prune stale GHCR images after deploy | `GITHUB_TOKEN`, `MAX_VERSIONS_TO_KEEP`, `MAX_AGE_DAYS`, `PROTECTED_TAGS`, `GHCR_CLEANUP_EXECUTE` | Operates via GitHub API; values come exclusively from repository variables.

## Operational Notes
- Extend the Key Vault allowlist only after documenting new secrets in this file.
- When additional runners are introduced, update the checklist to include their labels and validation steps.
- Mask any runtime values surfaced from Key Vault by emitting `::add-mask::` before writing to outputs.
- Docker image padrão no Swarm: `ghcr.io/wibson82/jaeger-infrastructure` (rootless). Atualize `JAEGER_IMAGE` ao promover novas tags.
