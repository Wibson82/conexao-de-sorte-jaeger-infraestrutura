## ✅ Checklist de Conformidade – Pipeline Jaeger Infrastructure

- [x] Permissões globais reduzidas (`contents: read`, `id-token: write`) com elevação apenas nos jobs que precisam de `packages`/`actions`.
- [x] `actionlint` validado com `.github/actionlint.yaml` (labels customizados).
- [x] Azure OIDC configurado com `azure/login@v2` e identificadores em `secrets.AZURE_*`.
- [x] Nenhum segredo de aplicação no repositório; inventário atualizado em `docs/secrets-usage-map.md`.
- [x] Build e deploy utilizam imagem GHCR rootless e health checks em produção.
- [x] Limpeza inteligente do GHCR com `cleanup_ghcr_safe()` protegendo tags críticas e mantendo versões recentes.
- [x] Artefatos temporários com `retention-days: 1`, nomeados com `github.run_id` e limpeza automática via API após deploy.
- [x] Limpeza de recursos no runner (`container/image/builder prune`) somente após healthchecks passarem.
- [x] Runners de infraestrutura usam labels `[self-hosted, Linux, X64, srv649924, conexao-de-sorte-jaeger-infraestrutura]` conforme padrão.
- [x] Nenhum segredo de aplicação buscado sem necessidade; lista de segredos vazia por padrão (`required_secrets=()`).
- [ ] Validação funcional/staging em ambiente remoto com imagem GHCR (executar `docker stack deploy` em staging e capturar evidências).
- [ ] Monitorar métricas pós-limpeza (GHCR e host) e calibrar `MAX_*` conforme evolução do consumo.
