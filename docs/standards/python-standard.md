# Python Standard

## Status

This standard is **Proposed**. The observed bootstrap repositories target Python
3.11, but that does not establish an organization-wide language decision.
Python 3.11 is the proposed minimum until an ADR approves a support matrix.

## Runtime and packaging

- Declare `requires-python` and test every supported minor version.
- Use `pyproject.toml` as the authoritative build and tool configuration.
- Use a `src/` layout for distributable packages.
- Build standards-compliant wheels and source distributions.
- Keep runtime dependencies separate from development and optional adapter extras.
- Do not import optional provider adapters during core package import.
- Include type information in distributed libraries.
- Avoid import-time network access, model loading, filesystem mutation, or
  environment validation.

Lock application and service deployments reproducibly. Library packages declare
compatible ranges and validate against lower and upper supported bounds.

## Formatting, linting, and typing

Proposed baseline:

- Black for formatting;
- Ruff for linting and import ordering;
- MyPy for static type checking;
- Pytest for testing; and
- `python -m build` for package validation.

New public functions, methods, dataclasses, protocols, and exceptions must be
typed. Avoid `Any` at public boundaries; validate untyped JSON, YAML, environment,
subprocess, plugin, and network data before converting it to domain types.

Do not weaken project-wide checks to land a feature. Narrow suppressions require a
comment explaining the false positive or compatibility reason.

## API design

- Prefer small immutable value objects at contract boundaries.
- Use `Protocol` or abstract interfaces for replaceable backends.
- Keep domain logic independent of CLI, HTTP, database, and provider frameworks.
- Use keyword-only arguments when positional ambiguity would be unsafe.
- Return explicit result types; do not overload `None` with multiple meanings.
- Use timezone-aware UTC timestamps.
- Represent identifiers as opaque validated types rather than path fragments.
- Use `pathlib.Path` internally for filesystem paths.
- Use `Enum` or constrained literals only where unknown future values can be
  handled deliberately.

Public APIs document thread, process, async, cancellation, and resource semantics.

## Async and concurrency

Use async code for concurrent I/O, not as a default style. Never call blocking
subprocess, filesystem, model, or network operations directly on an event loop.
Bound queues, tasks, retries, and fan-out. Propagate deadlines and cancellation.

Shared mutable state requires an explicit synchronization and ownership model.
Cancellation must leave persistent and external state valid or initiate documented
rollback.

## Boundary validation

Validate before side effects:

- configuration and environment variables;
- paths after canonical resolution;
- URLs, hosts, and target scope;
- subprocess arguments;
- archive members and template-generated names;
- serialized schemas and contract versions;
- checkpoint hashes, shapes, and resource estimates; and
- authorization and operator identity.

Use argument arrays for subprocesses. Do not build shell commands from untrusted
text. Temporary content is created with restricted permissions and cleaned only
within invocation-owned paths.

## Security and secrets

- Secrets are obtained from an approved secret provider, never source or defaults.
- Secret values must not appear in logs, exceptions, telemetry, test snapshots, or
  object representations.
- Compare security tokens with appropriate constant-time functions.
- Use maintained cryptographic libraries; do not invent primitives.
- Default network clients to certificate verification and bounded timeouts.
- Deserialize only explicit formats with safe loaders.
- Treat pickle and executable model formats as untrusted code; they are not
  accepted checkpoint interchange formats by default.

## Errors and logging

Follow the [error-handling standard](error-handling-standard.md) and
[logging standard](logging-standard.md). Domain code raises typed errors without
printing. CLI and service boundaries translate them into stable user or protocol
errors. Expected errors do not produce user-facing tracebacks.

## Testing

Tests follow the [testing standard](testing-standard.md). Use temporary directories,
fake clocks, deterministic random seeds, and local fakes. Unit tests must not
depend on the network, global Git identity, user credentials, provider accounts, or
production targets.

## Documentation

Docstrings explain public semantics, invariants, units, side effects, security
requirements, and raised errors. They do not restate obvious implementation.
Examples must be inert and must not contain live secrets or unauthorized security
procedures.

## Unresolved decisions

- Final supported Python minor versions and deprecation window.
- Standard dependency locking tool.
- Whether strict MyPy is required from repository inception or introduced by
  ratchet.
- Native-extension languages and supported build platforms.
- Approved cryptographic, serialization, and GPU libraries.
