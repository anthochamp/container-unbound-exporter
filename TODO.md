# TODO — container-unbound-exporter

## Security: Shell Injection in Entrypoint

- [x] **Fixed** — Replaced `eval "exec /unbound_exporter$args"` with an array-based `set --` + `exec "$@"` pattern. Each argument is now passed as a separate word, eliminating the shell injection risk from env var values containing spaces or metacharacters.

## Tests

- [ ] `tests/index.ts` is empty — there are **no tests**.
  - Add an integration test that starts Unbound alongside this exporter (via `testcontainers`), then queries `GET /metrics` and asserts that Unbound-specific metric names are present (e.g., `unbound_up`).
  - Add a test verifying that the container exits if it cannot connect to the Unbound control socket.

## Health Check

- [ ] Add a HEALTHCHECK — e.g.:

  ```dockerfile
  HEALTHCHECK CMD wget -qO- http://localhost:9167/metrics | grep unbound_up || exit 1
  ```

## Documentation

- [ ] `CONTAINER.md`: document `UNBOUND_ADDRESS` and any other supported env vars, and the expected Unix socket path.

## Maintainability

- [ ] See [COMMON-TODO.md](../COMMON-TODO.md) for `.github/workflows/`, OCI labels, `.dockerignore`, `replaceEnvSecrets` extraction, and dep version alignment.
