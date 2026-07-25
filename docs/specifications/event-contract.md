# Event Contract

## Status

This is a **stable conceptual event contract proposal**. It does not select a
broker, encoding, schema registry, storage system, or delivery guarantee. No event
infrastructure is currently claimed production-ready.

## Goals

- Stable cross-repository facts without shared database coupling.
- Correlation and causation across model, agent, tool, security, and platform
  workflows.
- Privacy-aware audit and operational observability.
- Versioned evolution and duplicate-safe consumption.
- Integrity and reproducibility references.
- Transport-neutral semantics.

## Non-goals

- Using events as authorization credentials.
- Storing full prompts, model outputs, secrets, tensors, or evidence payloads in
  ordinary events.
- Replacing transactional state stores.
- Guaranteeing global ordering.

## Event envelope

Required conceptual fields:

| Field | Meaning |
| --- | --- |
| `event_id` | globally unique immutable event identifier |
| `event_type` | stable namespaced fact name |
| `schema_version` | event payload contract version |
| `occurred_at` | source-observed UTC time |
| `recorded_at` | producer or ingress UTC time |
| `producer` | service/component and version |
| `subject` | opaque primary entity reference |
| `correlation_id` | workflow/request correlation |
| `causation_id` | event or command that caused this fact |
| `sequence` | optional monotonic sequence within a named stream |
| `tenant_id` | opaque tenant reference when applicable |
| `operator_id` | opaque operator reference when applicable |
| `authorization_id` | grant reference for privileged activity |
| `policy_decision_id` | policy decision reference |
| `classification` | payload data classification |
| `trace_context` | transport-neutral tracing identifiers |
| `payload` | schema-defined bounded facts |
| `integrity` | digest/signature metadata when required |

Null, absent, and unknown have distinct schema-defined meaning. Identifiers are
opaque and not reused.

## Event naming

Use past-tense facts:

```text
<domain>.<entity>.<fact>
```

Examples:

- `inference.request.completed`
- `agent.step.proposed`
- `tool.call.denied`
- `security.scope.violated`
- `checkpoint.artifact.approved`

Commands such as “run tool” are request contracts, not facts, and use a separate
command interface even if transported through the same system.

## Payload rules

- Include facts needed by declared consumers, not internal object dumps.
- Reference large/sensitive artifacts by immutable ID and digest.
- Use explicit units and UTC time.
- Bound strings, arrays, nesting, and extension data.
- Validate before publication and consumption.
- Do not include secrets or credentials.
- Include safe error codes, not raw provider or target responses.
- Include source revisions and configuration/artifact digests needed for
  reproduction when the event records an evaluation or privileged action.

## Ordering

No global order is assumed. A producer may define a stream and monotonic sequence
for one aggregate, request, tool call, agent run, or artifact. Consumers detect
gaps and duplicates. Cross-stream relationships use causation and correlation, not
timestamps alone.

Clock skew is expected and observable. `occurred_at` is not an authorization
decision time; authorization references include their own evaluated validity.

## Delivery and idempotency

**Proposed baseline:** at-least-once delivery with idempotent consumers. This
remains unresolved until transport selection.

Consumers:

- deduplicate by event ID within policy-defined retention;
- make state updates idempotent or transactional with consumption;
- do not emit duplicate side effects on redelivery;
- apply bounded retry and dead-letter handling;
- preserve the original event and error evidence; and
- expose lag, drop, and poison-event health.

An event bus is not a tool gateway. Receiving an event does not authorize an
external action.

## Evolution

Event compatibility follows the
[versioning standard](../standards/versioning-standard.md).

- Immutable published events are never edited.
- Compatible minor evolution adds optional fields with safe defaults.
- Incompatible semantics require a new major schema version or event type.
- Producers do not repurpose fields or enum values.
- Consumers handle unknown optional fields.
- Corrected facts are new events with explicit supersession/correction reference.

## Security and privacy

- Authenticate producers and authorize publish/subscribe by event class and
  tenant.
- Enforce tenant isolation at transport and consumer boundaries.
- Encrypt in transit and at rest.
- Apply schema validation, size limits, rate limits, deadlines, and backpressure.
- Redact/minimize before publication.
- Restrict audit and evidence classes separately from operational telemetry.
- Record administrative access and replay.
- Verify integrity/signatures for policy, approval, provenance, and other
  high-assurance events as required.

Prompts, memory, tool output, and provider responses remain untrusted even when
wrapped in an authenticated event.

## Audit events

Privileged-operation events include safe references for operator/service identity,
authorization, normalized scope, policy decision, capability/tool version, target,
limits, timing, outcome, evidence digest, and cleanup/rollback.

Audit event failure handling is policy-controlled. High-risk actions fail closed if
their required audit event cannot be durably accepted.

## Model and artifact events

Model lifecycle facts include dataset/tokenizer/checkpoint digests, training and
evaluation runs, promotion/revocation decisions, producer versions, and
compatibility. Events never carry weights or full dataset records.

Inference facts include model/tokenizer revision, token counts, finish reason,
duration, resource use, and protected content references where policy allows.

## Agent and tool events

Agent and tool events preserve:

- request/run/call and step identity;
- parent/child and causation;
- budget snapshots;
- policy decision;
- tool/version and side-effect class;
- start/terminal state;
- evidence and cleanup; and
- safe error code.

Exactly one terminal event is expected per run/call stream; duplicate delivery may
repeat that event but not create a second logical terminal transition.

## Reproducibility

Events documenting a result reference immutable inputs, component and contract
versions, safe configuration digest, environment, limits, timestamps, seed where
meaningful, evidence digest, and known non-determinism.

## Conformance tests

- minimal and representative envelope fixtures;
- unknown optional and missing required fields;
- unsupported schema versions;
- size, nesting, classification, and redaction;
- duplicate, out-of-order, gap, and replay;
- tenant and publish/subscribe denial;
- clock skew and invalid time;
- integrity/signature failure;
- poison event, retry, and dead-letter behavior;
- idempotent side-effect consumer; and
- terminal uniqueness for agent/tool workflows.

## Unresolved decisions

- Canonical encoding and schema language.
- Broker, persistence, partitions, and delivery semantics.
- Event-type and schema registry owner.
- Retention and deduplication windows.
- Integrity/signing and replay authorization.
- Data-classification vocabulary.
