FROM golang:alpine@sha256:8a5910f31396cd4d89662f56c68b3ae31d374308270a1c3bd96672ee5ed43414 AS build

# renovate: datasource=github-releases depName=letsencrypt/unbound_exporter
ARG UNBOUND_EXPORTER_VERSION=0.6.0

# hadolint ignore=DL3018
RUN set -ex; \
	apk add --no-cache ca-certificates git; \
	CGO_ENABLED=0 go install -v github.com/letsencrypt/unbound_exporter@v${UNBOUND_EXPORTER_VERSION}

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

COPY --from=build /go/bin/* /

COPY --chmod=775 /rootfs/docker-entrypoint.sh /

EXPOSE 9167

ENTRYPOINT [ "/docker-entrypoint.sh" ]
