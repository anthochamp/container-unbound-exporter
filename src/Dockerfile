FROM golang:alpine@sha256:c2a1f7b2095d046ae14b286b18413a05bb82c9bca9b25fe7ff5efef0f0826166 AS build

# renovate: datasource=github-releases depName=letsencrypt/unbound_exporter
ARG UNBOUND_EXPORTER_VERSION=0.5.0

# hadolint ignore=DL3018
RUN set -ex; \
	apk add --no-cache ca-certificates git; \
	CGO_ENABLED=0 go install -v github.com/letsencrypt/unbound_exporter@v${UNBOUND_EXPORTER_VERSION}

FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

COPY --from=build /go/bin/* /

COPY --chmod=775 /rootfs/docker-entrypoint.sh /

EXPOSE 9167

ENTRYPOINT [ "/docker-entrypoint.sh" ]
