# Logging Standard

## Status

Structured, privacy-aware, correlatable logging is an **Established requirement**.
The concrete encoding, telemetry backend, and retention periods are **Unresolved**.

## Principles

Logs are operational records, not application state, memory, evidence payloads, or
complete model transcripts. Emit the minimum facts needed to operate, audit, and
diagnose a component.

- Use structured fields rather than parsing prose.
- Record UTC timestamps with explicit timezone.
- Correlate a workflow without logging sensitive content.
- Keep event names and field semantics stable.
- Make log levels actionable.
- Sanitize at the source; downstream filtering is defense in depth.
- Bound message and field sizes.

## Required common fields

Where applicable:

| Field | Meaning |
| --- | --- |
| `timestamp` | UTC event time |
| `severity` | normalized level |
| `event_name` | stable dotted identifier |
| `service` | component identity |
| `service_version` | deployed version |
| `environment` | deployment classification |
| `trace_id` / `span_id` | distributed trace correlation |
| `correlation_id` | workflow or request correlation |
| `event_id` | unique event identity |
| `operator_id` | opaque authenticated operator reference |
| `service_identity` | acting workload identity |
| `tenant_id` | opaque tenant reference when multi-tenant |
| `authorization_id` | grant reference, never the credential |
| `policy_decision_id` | decision record reference |
| `target_scope_id` | approved scope reference, not raw sensitive targets |
| `duration_ms` | measured elapsed duration |
| `outcome` | success, denied, cancelled, timeout, or error |
| `error_code` | stable error taxonomy code |

Omit fields that do not apply. Do not invent placeholder identity values.

## Levels

- **DEBUG:** development detail disabled by default in production; never bypasses
  redaction.
- **INFO:** meaningful lifecycle transitions and successful bounded operations.
- **WARNING:** degraded, recoverable, nearing limit, or policy-obligation state.
- **ERROR:** failed operation requiring attention; not every user input error.
- **CRITICAL:** systemic safety, integrity, or availability condition requiring
  immediate action.

Denials are usually INFO or WARNING with an audit decision, not ERROR. Repeated
denials may trigger a separate security signal.

## Prohibited content

Logs must not contain:

- passwords, tokens, private keys, session cookies, or authorization credentials;
- full prompts, model outputs, memory contents, or dataset records by default;
- raw credentials or exploit material;
- unrestricted target lists or sensitive network responses;
- personal or regulated data unless an approved logging purpose and controls exist;
- full checkpoint tensors or binary artifacts;
- environment dumps or arbitrary request headers; or
- stack traces returned to untrusted users.

Use approved hashes, opaque identifiers, classifications, lengths, counts, and
evidence references. Hashing low-entropy secrets is not redaction.

## AI-specific events

Inference logs may record model revision, tokenizer fingerprint, generation
configuration hash, input/output token counts, finish reason, duration, and
resource usage. Content capture requires explicit policy and a separate protected
data path.

Agent logs record agent revision, step number, budget remaining, proposed tool
identifier, policy decision reference, and terminal state. Hidden chain-of-thought
is not a logging requirement.

## Security and validation events

Before and after each side effect, record:

- operator and service identity references;
- authorization and normalized scope references;
- policy decision and obligations;
- tool/technique version;
- rate, concurrency, and deadline controls;
- target alias or protected reference;
- start, completion, cancellation, and cleanup outcome;
- result and evidence digests; and
- error code without sensitive payload.

Canonical audit evidence follows the [event contract](../specifications/event-contract.md)
and may have stronger integrity and retention controls than operational logs.

## Integrity, access, and retention

- Use append-oriented transport and restrict deletion.
- Separate operator, service, and audit-reader privileges.
- Encrypt in transit and at rest.
- Detect ingestion loss and clock skew.
- Preserve source event identifiers for deduplication.
- Apply retention by classification and legal policy.
- Support holds without silently extending unrelated data.

Retention durations and immutable-storage technology are unresolved.

## Failures

Logging failure must not silently authorize an operation. Policy determines whether
a high-risk action fails closed when required audit logging is unavailable.
Components expose health and backpressure rather than buffering without bounds.

## Testing

Tests verify required fields, stable event names, redaction, size bounds, correlation,
duplicate handling, unavailable sinks, and that error paths do not leak sensitive
values.

## Related documents

- [Error-handling standard](error-handling-standard.md)
- [Authorization model](../security/authorization-model.md)
- [Event contract](../specifications/event-contract.md)

## Unresolved decisions

- Encoding and transport.
- Retention by event classification.
- Audit integrity/signing mechanism.
- Standard telemetry semantic conventions and registry.
- Approved protected content-capture workflow.
