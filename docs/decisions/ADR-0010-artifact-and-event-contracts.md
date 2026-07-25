# ADR-0010: Artifact and Event Contracts

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT repositories exchange durable artifacts—including tokenizer bundles,
dataset manifests, checkpoints, evaluation reports, policy bundles, and evidence—
and asynchronous events. Without stable identity, version, provenance, and
compatibility rules, those exchanges become private implementation dependencies.
If all schemas are centralized, however, domain owners cannot evolve their
payloads without a bottleneck and foundation can accumulate higher-layer
knowledge.

The documentation specifications define stable conceptual contracts, but no
concrete schema language, registry, transport, checkpoint container, or
production implementation has been selected.

## Decision

CyberSecGPT adopts a two-level contract ownership model.

### Conceptual and executable ownership

`cybersecgpt-docs` owns the conceptual
[model](../specifications/model-contract.md),
[tokenizer](../specifications/tokenizer-contract.md),
[checkpoint](../specifications/checkpoint-format.md),
[agent](../specifications/agent-contract.md),
[tool](../specifications/tool-contract.md), and
[event](../specifications/event-contract.md) specifications.

`cybersecgpt-foundation` owns executable common types for:

- stable identifiers and content digests;
- artifact references, provenance references, and compatibility results;
- the model descriptor and logical checkpoint manifest;
- the common event envelope, causation and correlation identifiers; and
- contract-version negotiation and shared typed errors.

Each domain owner owns its executable payload schemas and conformance fixtures:

| Contract or artifact | Authoritative implementation owner |
| --- | --- |
| Model descriptor and logical checkpoint manifest | `cybersecgpt-foundation` |
| Tokenizer artifact and compatibility | `cybersecgpt-tokenizer` |
| Dataset manifest and lineage | `cybersecgpt-datasets` |
| Training run and checkpoint-production record | `cybersecgpt-training` |
| Inference request, stream, and load diagnostics | `cybersecgpt-inference` |
| Evaluation report and promotion evidence | `cybersecgpt-evaluation` |
| Agent and reasoning event payloads | `cybersecgpt-reasoning` |
| Tool descriptor, call, and result payloads | `cybersecgpt-tools` |
| Security finding, policy decision, evidence, and validation result | `cybersecgpt-security` |
| Governance policy and approval artifacts | `cybersecgpt-governance` |
| Tenant, entitlement, and control-plane events | `cybersecgpt-platform` |
| Monitoring-specific telemetry conventions and derived products | `cybersecgpt-monitoring` |

Monitoring consumes domain events; it does not become the owner of domain facts.
Documentation defines semantics; runtime components consume published executable
schemas and do not import documentation tooling.

### Artifact requirements

Every portable artifact manifest includes:

- artifact identifier, kind, contract name, and contract version;
- content digests, byte sizes, and an explicit file or shard inventory;
- producer identity, producing software versions, timestamp, and provenance;
- compatibility requirements and referenced artifact identities;
- data classification, license status, and distribution restrictions;
- integrity or signature metadata when available; and
- reproducibility inputs and validation status appropriate to the artifact.

A logical manifest is separate from its physical container. Container and tensor
encodings may evolve behind an explicit format identifier. Consumers verify
identity, bounds, compatibility, and integrity before deserializing content.

### Event requirements

Every event uses the common envelope and includes a unique event identifier,
event type, schema version, occurred and observed times, producer, subject,
correlation and causation identifiers, tenant or security context where
applicable, classification, and payload.

Events are immutable facts, not remote procedure calls or authorization grants.
Consumers must handle duplication, delayed delivery, compatible unknown fields,
and unavailable producers. Side effects use idempotency controls. Sensitive
payloads, credentials, raw model prompts, and evidence content are omitted or
referenced under access control. An event relationship must not conceal a
dependency cycle.

Breaking changes require a new major contract version, migration guidance, a
defined coexistence window, conformance fixtures, and rollback behavior. Concrete
schema language, canonical encoding, registry, transport, retention, and delivery
guarantees remain unresolved until separate decisions are accepted.

## Consequences

### Positive

- Artifacts and events can cross repository and language boundaries without
  private imports.
- Common identity and envelope behavior is consistent while domain owners retain
  payload authority.
- Provenance, integrity, licensing status, evidence, and reproducibility are
  first-class contract data.
- Training and inference remain decoupled through checkpoints and manifests.

### Costs and constraints

- Domain repositories must publish schemas and conformance fixtures with their
  releases.
- Consumers need version negotiation, unknown-field handling, idempotency, and
  migration support.
- Foundation must keep common types domain-neutral and resist absorbing payload
  semantics.
- Concrete encodings and transports require later ADRs before production claims
  can be made.

## Alternatives Considered

### Centralize every payload schema in foundation

Rejected because foundation would depend conceptually on higher domains and
become a release bottleneck.

### Let each repository define its own envelope and identifiers

Rejected because correlation, provenance, compatibility, and audit semantics
would diverge.

### Treat documentation files as runtime schemas

Rejected because runtime components must consume versioned executable artifacts,
not documentation tooling or repository paths.

### Let the message transport define event semantics

Rejected because broker-specific delivery and serialization would undermine
portability and independent operation.
