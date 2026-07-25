# Error-Handling Standard

## Status

Typed, stable, non-leaking boundary errors are an **Established requirement**.
Concrete language classes and protocol mappings are owned by implementations.

## Error model

Every public error exposes safe fields:

| Field | Meaning |
| --- | --- |
| `code` | stable machine-readable identifier |
| `message` | concise safe explanation |
| `category` | validation, authorization, policy, resource, dependency, conflict, integrity, internal |
| `retryable` | whether retry may succeed without changing the request |
| `correlation_id` | support/audit correlation |
| `details` | bounded, schema-defined, non-sensitive context |

Internal causes and stack traces remain in protected diagnostics correlated to the
safe error. They are not serialized to untrusted callers.

## Taxonomy

- **Validation:** malformed or unsupported input; not retryable without correction.
- **Authentication:** identity missing or invalid; do not reveal which credential
  detail failed.
- **Authorization:** authenticated identity lacks an applicable grant.
- **Policy denial:** a valid request is disallowed or has unmet obligations.
- **Scope violation:** target, method, time, or resource lies outside approved
  scope.
- **Conflict:** valid request conflicts with current state or idempotency record.
- **Not found:** resource absent; avoid existence leaks across authorization
  boundaries.
- **Resource exhausted:** bounded capacity, rate, quota, or memory limit.
- **Deadline/cancelled:** caller or system ended bounded execution.
- **Dependency unavailable:** a required local or configured optional dependency
  failed.
- **Integrity/compatibility:** hashes, signatures, versions, shapes, or provenance
  are invalid.
- **Internal:** unexpected invariant failure; safe message remains generic.

Security denials are not converted into generic internal errors.

## Domain and boundary separation

Domain logic raises typed domain errors and never prints or chooses HTTP/CLI
presentation. Boundaries map errors consistently:

- CLI uses documented exit codes and concise stderr;
- APIs use versioned protocol status and error envelopes;
- SDKs reconstruct typed client errors;
- events use stable failure codes and safe metadata; and
- tools return typed tool errors to agents.

Mappings are tested. A new public error code is a contract change.

## Retry rules

Retry only errors explicitly marked retryable and only when:

- the operation is idempotent or has an idempotency key;
- the original authorization and scope remain valid;
- the overall deadline and attempt budget remain;
- backoff includes bounded jitter; and
- rate-limit and server retry guidance is respected.

Never automatically retry authentication, authorization, policy, scope, schema,
integrity, or deterministic compatibility failures. Agents cannot reinterpret an
error as permission to choose a broader target.

## Partial failure and rollback

Side-effecting workflows define:

- committed and uncommitted state;
- idempotency boundary;
- compensation or rollback action;
- evidence created before failure;
- cleanup verification;
- safe resume point; and
- operator action when automated recovery is unsafe.

Rollback must not delete pre-existing user content or evidence. If rollback fails,
preserve recoverable state and emit a high-severity event with an operator-safe
recovery reference.

## Sensitive-data handling

Error messages must not contain secrets, credentials, raw prompts, model output,
memory content, unrestricted target data, internal paths unnecessary to the user,
SQL, environment dumps, or provider responses. Preserve sensitive diagnostic
material only in an access-controlled evidence channel with classification and
retention.

## AI and artifact errors

Model/tokenizer/checkpoint failures identify safe compatibility facts: expected and
observed format version, artifact digest prefix where policy permits, missing
capability, tensor name, expected/observed shape, and required resource class.
They do not dump tensor content or arbitrary manifests.

Generation termination distinguishes normal stop, length/budget limit,
cancellation, policy stop, and internal failure.

## Agent and tool errors

Tool errors state whether execution began and whether side effects may have
occurred. Agents receive a stable code, retryability, safe details, and evidence or
cleanup reference. A tool failure cannot be hidden as a successful observation.

Authorization, policy, and scope errors terminate or re-plan within the same grant;
they never trigger self-authorization.

## Logging

Log each error once at the boundary best able to act, with correlation and stable
code. Lower layers add structured context without repeatedly logging the same
stack. Follow the [logging standard](logging-standard.md).

## Testing

Tests cover mappings, redaction, retry flags, idempotency, cancellation, timeouts,
partial side effects, rollback, unknown internal failures, and serialization
compatibility.

## Unresolved decisions

- Organization-wide error-code registry.
- CLI exit-code ranges and protocol-specific mappings.
- Localization policy.
- Standard safe-detail schemas.
- Recovery-reference retention and access control.
