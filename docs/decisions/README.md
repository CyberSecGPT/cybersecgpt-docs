# Architecture Decision Records

This directory is the authoritative index of accepted cross-repository
architecture decisions for CyberSecGPT. The repository inventory and observed
implementation status remain authoritative in the
[repository map](../architecture/repository-map.md); approval to use a repository
boundary is recorded in the
[repository approval matrix](../architecture/repository-approval-matrix.md).

## Decision status

- **Proposed** — under review and not binding.
- **Accepted** — binding for new work and architecture reviews.
- **Superseded** — replaced by a later ADR that identifies the replacement.
- **Deprecated** — retained for history but no longer approved for new work.

An ADR records a decision, not implementation completion. An accepted ADR may
define a boundary whose repository is still empty.

## Index

| ADR | Title | Status |
| --- | --- | --- |
| [ADR-0001](ADR-0001-independent-ai-first.md) | Independent AI First | Accepted |
| [ADR-0002](ADR-0002-multi-repository-strategy.md) | Multi-Repository Strategy | Accepted |
| [ADR-0003](ADR-0003-repository-ownership-boundaries.md) | Repository Ownership Boundaries | Accepted |
| [ADR-0004](ADR-0004-dependency-direction.md) | Dependency Direction | Accepted |
| [ADR-0005](ADR-0005-model-ownership.md) | Model Ownership | Accepted |
| [ADR-0006](ADR-0006-agent-runtime-ownership.md) | Agent Runtime Ownership | Accepted |
| [ADR-0007](ADR-0007-security-engine-boundaries.md) | Security Engine Boundaries | Accepted |
| [ADR-0008](ADR-0008-enterprise-and-governance-boundaries.md) | Enterprise and Governance Boundaries | Accepted |
| [ADR-0009](ADR-0009-cloud-and-infrastructure-boundaries.md) | Cloud and Infrastructure Boundaries | Accepted |
| [ADR-0010](ADR-0010-artifact-and-event-contracts.md) | Artifact and Event Contracts | Accepted |

## Governance

Accepted ADRs apply prospectively. A change that creates, renames, splits,
consolidates, or transfers ownership between repositories requires a new ADR. The
new ADR must identify affected contracts and artifacts, compatibility impact,
migration stages, rollback conditions, and the ADRs it supersedes.

If documents conflict, the latest accepted ADR governs the decision, the
repository map governs observed existence and implementation evidence, and the
approval matrix governs whether a repository boundary is authorized.
