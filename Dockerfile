# syntax=docker/dockerfile:1.6
FROM jaegertracing/all-in-one:1.60

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
