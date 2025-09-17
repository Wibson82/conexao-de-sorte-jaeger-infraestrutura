# 📊 Conexão de Sorte - Jaeger Infrastructure

Infraestrutura Jaeger standalone para Distributed Tracing com Docker Swarm.

## 📋 **Características**

- ✅ **Docker Swarm** deployment
- ✅ **All-in-one** Jaeger deployment
- ✅ **Overlay encrypted network** para segurança
- ✅ **Health checks** otimizados para produção
- ✅ **Workflows CI/CD** baseados no padrão Traefik
- ✅ **Zipkin compatibility** endpoint

## 🚀 **Deployment**

```bash
# Deploy automático via GitHub Actions
git push origin main

# Deploy manual
docker stack deploy -c docker-compose.yml conexao-jaeger
```

## 🔍 **Health Check**

```bash
# Verificar se Jaeger UI responde
docker exec CONTAINER_ID wget --quiet --tries=1 --timeout=5 --spider http://localhost:16686
```

## 📊 **Acesso**

- **Jaeger UI**: http://localhost:16686
- **Zipkin Endpoint**: http://localhost:9411
- **Collector HTTP**: http://localhost:14268
- **Collector gRPC**: http://localhost:14269

## 📈 **Monitoramento**

- **Network**: conexao-network-swarm
- **Memory Limit**: 512M
- **Max Traces**: 5000

## ⚙️ **Configuração**

- **COLLECTOR_OTLP_ENABLED**: true
- **MEMORY_MAX_TRACES**: 5000
- **QUERY_BASE_PATH**: /jaeger

---

**Data**: 17/09/2025 às 04:40 BRT
**Versão**: 1.0.0