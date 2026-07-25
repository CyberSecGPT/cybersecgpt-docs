# Architecture Change Gate

## Status

**Established**

## Purpose

This policy makes `cybersecgpt-docs` the authoritative source for cross-repository
architecture, repository ownership, dependency direction, stable conceptual
contracts, engineering standards, and security boundaries.

Implementation repositories MUST conform to the accepted architecture documented
here.

## Sources of architectural authority

Architecture changes MUST be evaluated against:

1. `docs/architecture/system-overview.md`
2. `docs/architecture/repository-map.md`
3. `docs/architecture/repository-approval-matrix.md`
4. `docs/architecture/dependency-graph.md`
5. accepted ADRs under `docs/decisions/`
6. contracts under `docs/specifications/`
7. standards under `docs/standards/`
8. security requirements under `docs/security/`

## Requirements for implementation repositories

Every active CyberSecGPT implementation repository MUST:

- identify its owning responsibility;
- link to the relevant repository-map entry;
- list its allowed upstream and downstream dependencies;
- link to every contract it implements or consumes;
- distinguish implemented behavior from proposed behavior;
- avoid assuming ownership assigned to another repository;
- avoid introducing an undocumented cross-repository dependency;
- avoid introducing a new wire format that conflicts with a conceptual contract;
- comply with the authorization and scope-enforcement requirements where
  cybersecurity capabilities are involved.

## Change classifications

A pull request MUST classify itself as one or more of:

- implementation-only;
- contract-compatible implementation;
- architecture clarification;
- architecture change;
- repository ownership change;
- dependency change;
- security-boundary change;
- compatibility-breaking change.

## ADR requirement

An ADR is required when a change affects:

- repository creation, removal, renaming, splitting, or consolidation;
- repository ownership or non-responsibilities;
- dependency direction;
- public contract compatibility;
- artifact or checkpoint formats;
- model, tokenizer, runtime, memory, reasoning, agent, or tool boundaries;
- authorization, trust, identity, audit, or evidence boundaries;
- organization-wide infrastructure or governance policy.

Until the ADR is accepted, the affected design MUST remain **Proposed** or
**Unresolved**.

## Repository creation gate

A new repository MUST NOT be created unless:

1. it appears in the repository approval matrix with an approved status;
2. its purpose and non-responsibilities are documented;
3. its dependencies are represented in the dependency graph;
4. no existing repository already owns the responsibility;
5. its contracts and produced artifacts are identified;
6. an ADR exists when ownership or dependency structure changes;
7. implementation sequencing has been reviewed.

An empty directory or placeholder repository does not constitute architectural
approval or implementation maturity.

## Pull-request gate

A cross-repository or architecture-sensitive pull request MUST answer:

- Which repository owns this responsibility?
- Which ADR authorizes the design?
- Which contracts are implemented or consumed?
- Which dependencies are added, removed, or changed?
- Does the dependency graph remain acyclic?
- Does the approval matrix remain accurate?
- Is backward compatibility preserved?
- Are security and privacy consequences documented?
- Is a migration or rollback plan required?

## Validation evidence

Before approval, the pull request SHOULD include:

- affected repositories;
- relevant document and ADR links;
- dependency impact;
- compatibility impact;
- security impact;
- implementation evidence;
- test or validation evidence;
- migration and rollback notes.

## Review requirements

Cross-repository architecture changes require architecture review.

Changes affecting authorization, validation, audit, evidence, identity, tool
execution, or policy enforcement require security review.

Reviewers MUST reject:

- undocumented ownership changes;
- cyclic dependencies;
- duplicate responsibility;
- unsupported production-readiness claims;
- implementation that contradicts an accepted ADR;
- incompatible contract changes without migration planning.

## Exception process

An implementation MAY temporarily diverge only when:

1. the divergence is explicitly documented;
2. the reason and scope are recorded;
3. the affected behavior is marked experimental;
4. no production-readiness claim is made;
5. a reconciliation issue or ADR is created;
6. the divergence has an owner and review date.
