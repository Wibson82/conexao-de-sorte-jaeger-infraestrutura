# 📊 Conexão de Sorte - Jaeger Infrastructure

Stack Jaeger standalone operada em Docker Swarm para observabilidade da Conexão de Sorte.

## 📋 Características Principais
- Deploy Swarm com rede overlay dedicada (`conexao-network-swarm`).
- Imagem endurecida `ghcr.io/wibson82/jaeger-infrastructure` (rootless, healthcheck embutido).
- Parametrização via `JAEGER_IMAGE` e runner self-hosted em Hostinger (`srv649924`).
- Health checks multi-método (logs, portas, curl) e limpeza pós-deploy.
- Pipeline GitHub Actions com OIDC Azure e consumo zero de segredos de aplicação.

## 🚀 Como Deployar
```bash
# Deploy automático (CI/CD)
git push origin main

# Deploy manual via runner
export JAEGER_IMAGE=ghcr.io/wibson82/jaeger-infrastructure:latest
docker stack deploy -c docker-compose.yml conexao-jaeger
```

## 🔍 Health Check Manual
```bash
# Validar Jaeger UI localmente (porta 16686)
curl -fsS http://localhost:16686/ >/dev/null
```

## 📈 Portas Expostas
- Jaeger UI: `16686`
- Collector HTTP: `14268`
- Collector gRPC: `14269`
- Zipkin compatível: `9411`

## 🛡️ CI/CD & Segurança
- Runner obrigatório: `[self-hosted, Linux, X64, srv649924, conexao-de-sorte-jaeger-infraestrutura]`.
- Permissões globais: `contents: read`, `id-token: write`; jobs elevam apenas `packages`/`actions` quando necessário.
- Azure Key Vault não é consumido neste serviço; inventário documentado em `docs/secrets-usage-map.md`.
- `actionlint` utiliza configuração dedicada em `.github/actionlint.yaml` para labels customizados.

## ✅ Validações Locais
```bash
# Lint dos workflows (sem shellcheck por heredocs complexos)
actionlint -config-file .github/actionlint.yaml --shellcheck=

# Validar sintaxe do compose
docker compose -f docker-compose.yml config -q
```
> `hadolint` e `docker build` não foram executados localmente – ferramentas/daemon indisponíveis no ambiente atual.

## 🔐 Pipeline Hardened
- Buildx multi-stage gera imagem rootless com labels OCI e healthcheck.
- Azure OIDC configurado com `azure/login@v2`; nenhum segredo de aplicação reside no GitHub.
- Deploy Swarm executado via runner self-hosted com validações e limpeza controlada.
- Manutenção automática do GHCR (`MAX_VERSIONS_TO_KEEP`, `MAX_AGE_DAYS`, `PROTECTED_TAGS`, `GHCR_CLEANUP_EXECUTE`).

**Versão:** 1.2.0 — Atualizado em 19/09/2025.
