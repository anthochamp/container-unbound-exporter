FROM golang:alpine@sha256:70b46548e42db77e0966aaf3619fd068734dc6c77584d526b91126504fd95816 AS build

# renovate: datasource=github-releases depName=letsencrypt/unbound_exporter
ARG UNBOUND_EXPORTER_VERSION=0.6.0

# hadolint ignore=DL3018
RUN set -ex; \
	apk add --no-cache ca-certificates git; \
	CGO_ENABLED=0 go install -v github.com/letsencrypt/unbound_exporter@v${UNBOUND_EXPORTER_VERSION}

FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

COPY --from=build /go/bin/* /

COPY --chmod=775 /rootfs/docker-entrypoint.sh /

EXPOSE 9167

ENTRYPOINT [ "/docker-entrypoint.sh" ]
