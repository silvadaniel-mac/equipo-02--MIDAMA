# syntax=docker/dockerfile:1
# Los digest de las bases se pueden fijar por build-arg después de verificarlos.
ARG BUILD_IMAGE=node:24-trixie-slim
ARG RUNTIME_IMAGE=gcr.io/distroless/nodejs24-debian13:nonroot
FROM ${BUILD_IMAGE} AS build
WORKDIR /build
COPY services/api/ ./
RUN node --check server.mjs && node --test server.test.mjs

FROM ${RUNTIME_IMAGE} AS runtime
WORKDIR /app
ENV NODE_ENV=production PORT=8080
COPY --from=build --chown=65532:65532 /build/server.mjs ./server.mjs
USER 65532:65532
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ["/nodejs/bin/node", "-e", "fetch('http://127.0.0.1:8080/healthz').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"]
CMD ["server.mjs"]
