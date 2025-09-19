## ✅ Checklist de Conformidade – Pipeline Jaeger Infrastructure

- [x] Permissões globais reduzidas (`contents: read`, `id-token: write`) com elevação apenas nos jobs que precisam de `packages`/`actions`.
- [x] OIDC Azure configurado com `azure/login@v2` e permissões mínimas (`id-token: write`).
- [x] Identificadores AZURE_* + variáveis de limpeza definidos como **Repository Variables** (sem segredos no GitHub).
- [x] Build da imagem GHCR `jaeger-infrastructure` com cache multi-nível (GHA + local) e labels OCI.
- [x] Deploy utiliza `IMAGE_REFERENCE` imutável (digest) e mantém fallback seguro quando indisponível.
- [x] Limpeza inteligente do GHCR com `cleanup_ghcr_safe()` protegendo tags críticas e mantendo versões recentes.
- [x] Artefatos temporários com `retention-days: 1`, nomeados com `github.run_id` e limpeza automática via API após deploy.
- [x] Limpeza de recursos no runner (`container/image/builder prune` com filtros) somente após healthchecks passarem.
- [x] Runners de infraestrutura usam labels `[self-hosted, Linux, X64, srv649924, conexao-de-sorte-jaeger-infraestrutura]` conforme padrão.
- [x] Nenhum segredo de aplicação buscado sem necessidade; lista de segredos vazia por padrão (`required_secrets=()`).
- [ ] Validação funcional/staging em ambiente remoto com imagem GHCR (executar `docker stack deploy` em staging e capturar evidências).
- [ ] Monitorar métricas pós-limpeza (GHCR e host) e calibrar `MAX_*` conforme evolução do consumo.
