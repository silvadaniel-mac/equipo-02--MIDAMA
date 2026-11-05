# syntax=docker/dockerfile:1
# Los digest de las bases se pueden fijar por build-arg después de verificarlos.
ARG BUILD_IMAGE=node:24-trixie-slim
ARG RUNTIME_IMAGE=gcr.io/distroless/nodejs24-debian13:nonroot
ARG BASE_IMAGE=gcr.io/distroless/base-nossl-debian13:nonroot
FROM ${RUNTIME_IMAGE} AS node-runtime
FROM ${BUILD_IMAGE} AS build
WORKDIR /build
COPY services/api/ ./
RUN node --check server.mjs && node --test server.test.mjs

# Node oficial incorpora OpenSSL y zlib. Solo necesita glibc, libstdc++ y libgcc.
# Copiamos los binarios y su inventario real; no las bibliotecas SSL del sistema.
COPY --from=node-runtime /nodejs/bin/node /runtime-overlay/nodejs/bin/node
COPY --from=node-runtime /nodejs/LICENSE /runtime-overlay/nodejs/LICENSE
COPY --from=node-runtime /usr/lib/ /runtime-libs/
COPY --from=node-runtime /var/lib/dpkg/status.d/libstdc++6* /var/lib/dpkg/status.d/libgcc-s1* /var/lib/dpkg/status.d/gcc-14-base* /runtime-overlay/var/lib/dpkg/status.d/
COPY --from=node-runtime /usr/share/doc/gcc-14-base/ /runtime-overlay/usr/share/doc/gcc-14-base/
RUN set -eu; \
    mkdir -p /runtime-overlay/usr/lib; \
    cd /runtime-libs; \
    cp -a --parents *-linux-gnu/libstdc++.so.6* *-linux-gnu/libgcc_s.so.1 /runtime-overlay/usr/lib/; \
    cd /runtime-overlay/usr/share/doc; \
    ln -s gcc-14-base libstdc++6; \
    ln -s gcc-14-base libgcc-s1

FROM ${BASE_IMAGE} AS runtime
COPY --from=build /runtime-overlay/ /
WORKDIR /app
ARG RELEASE_SHA=local
ENV NODE_ENV=production PORT=8080 RELEASE_SHA=${RELEASE_SHA}
COPY --from=build --chown=65532:65532 /build/server.mjs ./server.mjs
USER 65532:65532
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ["/nodejs/bin/node", "-e", "fetch('http://127.0.0.1:8080/healthz').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"]
ENTRYPOINT ["/nodejs/bin/node"]
CMD ["server.mjs"]
