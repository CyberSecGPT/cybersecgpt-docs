# ADR-0004: Dependency Direction

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT spans foundational contracts, model execution, intelligence,
security, applications, enterprise services, and operations. Mutual imports,
shared databases, callbacks, or events can create logical cycles even when
package managers do not report a source-code cycle. Cycles make independent
testing, versioning, security review, and rollback unreliable.

The architecture also moves datasets, tokenizer artifacts, checkpoints,
evaluation evidence, and deployment bundles between repositories. Those flows
must not be confused with permission to depend on producer internals.

## Decision

Production dependencies follow the acyclic layers defined in the
[dependency graph](../architecture/dependency-graph.md):

1. **L0 Foundational:** foundation, tokenizer, and dataset contracts.
2. **L1 Model/runtime:** runtime, training, and inference depend on L0.
3. **L2 Intelligence:** memory, tools, and reasoning depend on L0-L1.
4. **L3 Security/evaluation:** security and evaluation depend on L0-L2.
5. **L4 Application:** SDK, API, CLI, web, and desktop depend on L0-L3
   through public interfaces.
6. **L5 Enterprise:** platform depends on L0-L4 and published governance
   artifacts.
7. The governance, operational, and experimental planes are not imported by the
   L0-L5 production graph.

Within a layer, an edge is allowed only when its direction is documented and no
reverse path exists. Shared abstractions move to an existing lower-layer owner;
they are not copied between peers.

An artifact, event, deployment, or API call does not exempt a relationship from
cycle review. A logical dependency exists when one component cannot evolve or
operate without another component's private behavior. Event request/reply loops,
shared mutable databases, generated source copied without versioning, and
bidirectional service callbacks are forbidden ways to conceal a cycle.

Every new cross-repository edge must name:

- the public contract and owner;
- the consumer and allowed version range;
- the layer direction;
- contract and integration tests;
- data classification and trust boundary; and
- cancellation, timeout, failure, and rollback behavior.

Optional external adapters depend inward on CyberSecGPT adapter contracts. No
core edge points to a provider SDK.

## Consequences

### Positive

- Lower layers remain reusable, independently testable, and provider-neutral.
- Training and inference can exchange checkpoints without importing each other.
- Applications and deployment tooling cannot redefine security or model
  behavior through private coupling.
- Cycles are reviewable at contract, service, event, and storage levels.

### Costs and constraints

- Some changes require publishing a lower-layer contract before consumer work.
- Duplicate convenience types are not accepted as a shortcut around ownership.
- Integration tests and compatibility fixtures are required at repository
  boundaries.
- Event-driven designs still require dependency and failure-mode analysis.

## Alternatives Considered

### Allow bidirectional dependencies within a domain

Rejected because domain proximity does not remove versioning and rollback risks.

### Treat services and events as automatically decoupled

Rejected because synchronous callbacks, shared event assumptions, and request
cycles can be as tightly coupled as imports.

### Put every interface in a new shared repository

Rejected because it would create a generic dumping ground and duplicate
`cybersecgpt-foundation`. Contracts remain with their lowest suitable domain
owner.

### Let deployment repositories define application interfaces

Rejected because production code must remain deployable independently of a
specific infrastructure or delivery implementation.
