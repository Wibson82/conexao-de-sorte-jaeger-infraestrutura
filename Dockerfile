# syntax=docker/dockerfile:1.6
ARG JAEGER_VERSION=1.60

FROM jaegertracing/all-in-one:${JAEGER_VERSION} AS base

FROM base AS runtime
ARG BUILD_SOURCE
ARG BUILD_REVISION
ARG BUILD_CREATED

LABEL org.opencontainers.image.title="Conexão de Sorte – Jaeger Infrastructure" \
      org.opencontainers.image.description="Jaeger all-in-one hardened image built via GitHub Actions." \
      org.opencontainers.image.source="${BUILD_SOURCE}" \
      org.opencontainers.image.revision="${BUILD_REVISION}" \
      org.opencontainers.image.created="${BUILD_CREATED}" \
      org.opencontainers.image.vendor="Conexão de Sorte" \
      org.opencontainers.image.licenses="Apache-2.0"

# Prepare writable directories for the non-root runtime user
RUN set -eux; \
    mkdir -p /var/lib/jaeger /var/log/jaeger; \
    chown -R 10001:10001 /var/lib/jaeger /var/log/jaeger

USER 10001:10001
WORKDIR /var/lib/jaeger



HEALTHCHECK --interval=30s --timeout=5s --start-period=200s --retries=5 \
  CMD curl -fsS http://127.0.0.1:16686/ || exit 1

