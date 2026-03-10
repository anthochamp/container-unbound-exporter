# Unbound Exporter Container

![GitHub License](https://img.shields.io/github/license/anthochamp/container-unbound-exporter?style=for-the-badge)
![GitHub Release](https://img.shields.io/github/v/release/anthochamp/container-unbound-exporter?style=for-the-badge&color=457EC4)
![GitHub Release Date](https://img.shields.io/github/release-date/anthochamp/container-unbound-exporter?style=for-the-badge&display_date=published_at&color=457EC4)

Container images based on [unbound_exporter](https://github.com/letsencrypt/unbound_exporter) (Let's Encrypt), a Prometheus exporter for Unbound DNS resolver statistics.

## Prerequisites

- A running Unbound instance with `remote-control` enabled (via Unix socket or TCP).
- The Unbound container exposes the control socket at `/run/unbound-control.sock`.
- The Unbound container should have `UNBOUND_SERVER_EXTENDED_STATISTICS=yes` for complete metrics.

## How to use this image

```shell
docker run -d \
  -p 9167:9167 \
  -e UNBOUND_EXPORTER_HOST=unix:///run/unbound-control.sock \
  -v unbound-run:/run \
  anthochamp/unbound-exporter
```

## Ports

| Port | Protocol | Description              |
|------|----------|--------------------------|
| 9167 | TCP      | Prometheus metrics       |

## Configuration

Sensitive values may be loaded from files by appending `__FILE` to any supported `UNBOUND_EXPORTER_`-prefixed variable.

### UNBOUND_EXPORTER_HOST

**Default**: *empty* (unbound_exporter default: `unix:///run/unbound-control.sock`)

Address of the Unbound control interface. Can be a Unix socket path (`unix:///path/to/socket`) or a TCP address (`host:port`).

### UNBOUND_EXPORTER_CA_FILE

**Default**: *empty*

Path to the CA certificate file for TLS authentication to the Unbound control interface. Required when using TCP control with TLS.

### UNBOUND_EXPORTER_CERT_FILE

**Default**: *empty*

Path to the client certificate file for TLS authentication to the Unbound control interface.

### UNBOUND_EXPORTER_CERT_KEY_FILE

**Default**: *empty*

Path to the client certificate private key file for TLS authentication to the Unbound control interface.

## Example Docker Compose

```yaml
services:
  unbound:
    image: anthochamp/unbound
    ports:
      - "53:53/udp"
      - "53:53/tcp"
    volumes:
      - unbound-run:/run
    environment:
      UNBOUND_SERVER_EXTENDED_STATISTICS: "yes"
      UNBOUND_PRIVACY: "yes"

  unbound-exporter:
    image: anthochamp/unbound-exporter
    ports:
      - "9167:9167"
    volumes:
      - unbound-run:/run:ro
    environment:
      UNBOUND_EXPORTER_HOST: unix:///run/unbound-control.sock

volumes:
  unbound-run:
```

## References

- [unbound_exporter on GitHub](https://github.com/letsencrypt/unbound_exporter)
- [Unbound remote-control documentation](https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html#remote-control-options)
