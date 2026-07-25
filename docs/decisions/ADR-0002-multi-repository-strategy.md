# ADR-0002: Multi-Repository Strategy

## Status

**Accepted** — 2026-07-25

## Context

The CyberSecGPT workspace contains multiple Git repositories representing
foundational libraries, model lifecycle components, intelligence services,
security controls, product surfaces, governance, and operations. Most are empty
placeholders, while a small number contain scaffold or active implementation.
Directory existence therefore cannot be treated as either approval of a boundary
or evidence of capability.

A multi-repository design can provide clear ownership and independent release
cadences, but indiscriminate repository creation produces duplicated contracts,
cyclic dependencies, fragmented testing, and ambiguous accountability.

## Decision

CyberSecGPT will retain a **contract-oriented multi-repository architecture**
subject to the following controls:

1. The [repository approval matrix](../architecture/repository-approval-matrix.md)
   is the authoritative approval state for every documented repository name.
2. A repository classified **Existing Owner** is an approved production ownership
   boundary. The classification does not claim that its implementation exists.
3. **Approved New** authorizes creation of an absent repository. No repository is
   classified Approved New by this decision set.
4. **Deferred** reserves no implementation authority. An absent deferred
   repository is not created, and an existing deferred placeholder does not
   become a production dependency.
5. **Consolidate** permits only compatibility, migration, and retirement work in
   the source repository; new authoritative implementation belongs in the named
   destination.
6. **Experimental** repositories may produce evidence and prototypes, but
   production repositories cannot depend on their code or mutable outputs.
7. Each public contract has one authoritative owner. Consumers use published
   contracts, released packages, services, artifacts, or events rather than
   another repository's private modules or storage.
8. Repository creation, rename, split, merge, or ownership transfer requires an
   accepted ADR with contract migration, compatibility, rollback, and archival
   guidance.
9. Cross-repository releases use explicit version constraints and a bill of
   materials. A repository's release cadence does not imply lockstep versioning.

The existing `cybersecgpt` umbrella repository remains deferred until a release
composition need is demonstrated. `cybersecgpt-bootstrap-py` will consolidate
into `cybersecgpt-bootstrap`. The eight absent proposed repositories remain
deferred because accepted ADRs assign their intended responsibilities to existing
owners.

## Consequences

### Positive

- Ownership, review scope, release cadence, and blast radius are explicit.
- Repository count grows only when a non-duplicate boundary has been accepted.
- Empty placeholders cannot be mistaken for approved or implemented components.
- Experimental work remains available without becoming a production dependency.

### Costs and constraints

- Public contract design and compatibility testing are required earlier.
- Cross-repository changes need coordinated releases and integration testing.
- Consolidation requires migration and archival authority before physical
  repository retirement.
- A release manifest or equivalent bill of materials will be required when
  installable distributions span repositories.

## Alternatives Considered

### Single monorepository

Rejected for the current ecosystem because the established repository inventory
already expresses durable domain and operational boundaries. A monorepository
migration would add disruption without removing the need for contract ownership.

### Repository per service or deployable

Rejected because deployment topology changes more frequently than domain
ownership and would create unnecessary repositories for internal workers.

### Activate every existing and proposed name

Rejected because names alone are not architecture evidence and several proposed
names duplicate existing owners.

### One umbrella repository with component folders

Rejected as the authoritative source model because it would blur independent
release and security boundaries. The umbrella name may later carry distribution
metadata if an ADR approves that limited role.
