# Repository Approval Matrix

## Status and authority

This matrix is **Accepted** by
[ADR-0002](../decisions/ADR-0002-multi-repository-strategy.md) and
[ADR-0003](../decisions/ADR-0003-repository-ownership-boundaries.md). It
classifies every repository name in the
[repository map](repository-map.md) exactly once. No repository names are added
by this document.

Approval is distinct from implementation status. **Existing Owner** approves a
boundary for production implementation; it does not assert that the repository
contains working code. The observed state column reflects the inventory performed
on 2026-07-25.

## Classification rules

| Classification | Meaning |
| --- | --- |
| **Existing Owner** | An existing repository is the approved authoritative owner for its documented boundary. |
| **Approved New** | An absent repository is authorized for creation after normal bootstrap and security review. |
| **Deferred** | The name has no active implementation authority; retain it only as an observed placeholder or documented proposal. |
| **Consolidate** | Independent ownership ends; compatibility and migration work moves responsibility to the named destination. |
| **Experimental** | The repository may hold non-production research, experiments, or benchmarks; production code cannot depend on it. |

A repository cannot hold more than one classification. There are currently no
**Approved New** repositories.

## Matrix

| Repository | Observed state | Classification | Rationale |
| --- | --- | --- | --- |
| `cybersecgpt` | Existing, empty | **Deferred** | An umbrella release manifest may be useful later, but no distribution lifecycle or non-duplicate implementation boundary is accepted. |
| `cybersecgpt-api` | Existing, empty | **Existing Owner** | Owns network transport, authentication integration, validation, quotas, and translation to SDK/public service contracts. |
| `cybersecgpt-benchmarks` | Existing, empty | **Experimental** | Owns reproducible benchmark definitions and reports; benchmark code and mutable results cannot become production dependencies. |
| `cybersecgpt-bootstrap` | Existing, implemented in part | **Existing Owner** | It is the active owner of repository and project initialization, templates, registry validation, and bootstrap CLI behavior. |
| `cybersecgpt-bootstrap-py` | Existing scaffold | **Consolidate** | Its Python bootstrap scope duplicates the active `cybersecgpt-bootstrap`; migrate any distinct compatibility surface there before archival. |
| `cybersecgpt-cli` | Existing, empty | **Existing Owner** | Owns the terminal user experience and consumes SDK contracts without implementing domain behavior. |
| `cybersecgpt-datasets` | Existing, empty | **Existing Owner** | Owns dataset manifests, lineage, validation, partitioning, and data-governance metadata. |
| `cybersecgpt-desktop` | Existing, empty | **Existing Owner** | Owns the desktop user experience and secure local client integration through public SDK contracts. |
| `cybersecgpt-devops` | Existing, empty | **Existing Owner** | Owns build, verification, provenance, promotion, deployment automation, and release rollback workflows. |
| `cybersecgpt-docs` | Existing, authored | **Existing Owner** | Owns conceptual architecture, standards, ADRs, security requirements, and conceptual contract specifications. |
| `cybersecgpt-evaluation` | Existing, empty | **Existing Owner** | Owns evaluation suites, safety and quality measurements, reports, and evidence used by promotion policy. |
| `cybersecgpt-experiments` | Existing, empty | **Experimental** | Owns bounded experiments and reproducibility records; successful results require review and migration to an approved owner. |
| `cybersecgpt-foundation` | Existing, empty | **Existing Owner** | Owns low-level types, model architecture contracts, artifact identity, logical checkpoint manifests, and the common event envelope under ADR-0005 and ADR-0010. |
| `cybersecgpt-governance` | Existing, empty | **Existing Owner** | Owns policy intent, approvals, risk classifications, exceptions, and recorded licensing decisions; it does not perform runtime enforcement. |
| `cybersecgpt-inference` | Existing, empty | **Existing Owner** | Owns first-party checkpoint loading, batching, caching, generation, streaming, and inference diagnostics. |
| `cybersecgpt-infrastructure` | Existing, empty | **Existing Owner** | Owns provider-neutral declarative infrastructure, self-hosted composition, and provider-specific deployment overlays. |
| `cybersecgpt-memory` | Existing, empty | **Existing Owner** | Owns governed memory storage, retrieval, retention, provenance, and deletion contracts. |
| `cybersecgpt-monitoring` | Existing, empty | **Existing Owner** | Owns operational collectors, dashboards, alerts, service-level indicators, and monitoring-specific semantic conventions. |
| `cybersecgpt-platform` | Existing, empty | **Existing Owner** | Owns the enterprise-capable control plane, tenancy, identity integration, policy administration, quotas, and entitlement enforcement. |
| `cybersecgpt-reasoning` | Existing, empty | **Existing Owner** | Owns planning, reasoning, agent lifecycle, delegation, budgets, and orchestration under ADR-0006. |
| `cybersecgpt-research` | Existing, empty | **Experimental** | Owns research evidence and safe prototypes; production contracts and code must be transferred through review to an approved owner. |
| `cybersecgpt-runtime` | Existing, empty | **Existing Owner** | Owns the provider-neutral device and workload substrate, resource accounting, cancellation, deadlines, and isolation primitives. |
| `cybersecgpt-sdk` | Existing, empty | **Existing Owner** | Owns typed client and embedding interfaces, transport abstraction, compatibility handling, and client-side errors. |
| `cybersecgpt-security` | Existing, empty | **Existing Owner** | Owns security-domain policy enforcement, scope controls, defensive techniques, findings, evidence references, and authorized validation orchestration under ADR-0007. |
| `cybersecgpt-tokenizer` | Existing, empty | **Existing Owner** | Owns tokenizer training and execution, normalization, vocabulary artifacts, fingerprints, and compatibility tests. |
| `cybersecgpt-tools` | Existing, empty | **Existing Owner** | Owns tool discovery, typed invocation, policy-gated side-effect execution, isolation adapters, and tool results. |
| `cybersecgpt-training` | Existing, empty | **Existing Owner** | Owns training orchestration, optimization, distributed run state, checkpoint production, and run provenance. |
| `cybersecgpt-web` | Existing, empty | **Existing Owner** | Owns the browser user experience and consumes API contracts without importing private platform or model code. |
| `cybersecgpt-core` | Absent proposal | **Deferred** | Its proposed primitives duplicate `cybersecgpt-foundation`; no distinct contract or lifecycle is accepted. |
| `cybersecgpt-model` | Absent proposal | **Deferred** | ADR-0005 assigns model definitions and contracts to `cybersecgpt-foundation`; a split requires new evidence and an ADR. |
| `cybersecgpt-agents` | Absent proposal | **Deferred** | ADR-0006 assigns the agent runtime and orchestration contract to `cybersecgpt-reasoning`, avoiding a reasoning/agents cycle. |
| `cybersecgpt-security-engine` | Absent proposal | **Deferred** | ADR-0007 keeps policy and the initial execution boundary in `cybersecgpt-security`; isolated workers do not require separate source ownership. |
| `cybersecgpt-exploit-validation` | Absent proposal | **Deferred** | Authorized, non-destructive validation remains an isolated capability of `cybersecgpt-security` until a distinct assurance lifecycle is demonstrated. |
| `cybersecgpt-enterprise` | Absent proposal | **Deferred** | ADR-0008 assigns enterprise control-plane responsibilities to `cybersecgpt-platform`; no separate packaging boundary is accepted. |
| `cybersecgpt-licensing` | Absent proposal | **Deferred** | Governance owns approved licensing policy and platform owns enforcement; neither a license nor standalone entitlement lifecycle is established. |
| `cybersecgpt-cloud` | Absent proposal | **Deferred** | ADR-0009 assigns cloud overlays to infrastructure and delivery to DevOps until a separate cloud product lifecycle is accepted. |

## Classification totals

| Classification | Count |
| --- | ---: |
| Existing Owner | 23 |
| Approved New | 0 |
| Deferred | 9 |
| Consolidate | 1 |
| Experimental | 3 |
| **Total** | **36** |

## Approval effects

- New production implementation belongs only in an **Existing Owner** or a future
  **Approved New** repository.
- The existing `cybersecgpt` placeholder remains inactive while deferred.
- `cybersecgpt-bootstrap-py` accepts no new independent capability. Consolidation
  requires an inventory of any distinct API or history, a migration notice,
  compatibility tests, and an archival or read-only action by an authorized
  repository administrator.
- Experimental evidence enters production only through review, reproducibility
  checks, security and license review, and implementation by the approved domain
  owner.
- A deferred name may be reconsidered only through an ADR that demonstrates a
  non-duplicate contract, allowed dependency direction, independent lifecycle,
  migration path, and rollback plan.

## Consistency with architecture layers

The matrix preserves the acyclic
[dependency graph](dependency-graph.md): foundation and model-lifecycle owners
occupy L0-L1; intelligence owners occupy L2; security and evaluation occupy L3;
product surfaces occupy L4; platform occupies L5; and infrastructure, DevOps,
monitoring, governance, documentation, and experimental repositories remain in
their designated planes. None of the deferred overlapping names is introduced as
a second graph node.

See the [system overview](system-overview.md) for runtime flows and
[repository map](repository-map.md) for detailed responsibilities,
non-responsibilities, allowed dependencies, artifacts, and observed evidence.
