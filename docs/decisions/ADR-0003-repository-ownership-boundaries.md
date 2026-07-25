# ADR-0003: Repository Ownership Boundaries

## Status

**Accepted** — 2026-07-25

## Context

The repository map identifies overlapping names for foundation and core, model
definitions, agents and reasoning, security execution, enterprise services,
licensing, and cloud delivery. Without explicit ownership, the same schema or
behavior could be implemented in multiple repositories, causing divergent
contracts and dependency cycles.

Ownership must distinguish four concerns:

- the repository that defines a public contract;
- repositories that implement or consume the contract;
- artifact and service deployment boundaries; and
- observed implementation status.

These concerns do not need to coincide, and approving an owner does not claim
that owner is implemented.

## Decision

CyberSecGPT assigns authoritative production ownership to existing repositories
using these rules:

1. `cybersecgpt-foundation` owns cross-domain primitives, model architecture
   definitions, shared artifact identity, and the common event envelope.
2. `cybersecgpt-tokenizer`, `cybersecgpt-datasets`,
   `cybersecgpt-training`, `cybersecgpt-runtime`,
   `cybersecgpt-inference`, and `cybersecgpt-evaluation` own their respective
   model-lifecycle domains.
3. `cybersecgpt-reasoning` owns reasoning and agent orchestration;
   `cybersecgpt-memory` owns governed memory; and `cybersecgpt-tools` owns tool
   registration, invocation, and side-effect execution contracts.
4. `cybersecgpt-security` owns cybersecurity policy enforcement, security-domain
   techniques, findings, evidence references, and authorized validation
   orchestration.
5. `cybersecgpt-sdk`, `cybersecgpt-api`, `cybersecgpt-cli`,
   `cybersecgpt-web`, and `cybersecgpt-desktop` own their distinct client or
   transport surfaces. They do not own lower-layer domain behavior.
6. `cybersecgpt-platform` owns the enterprise-capable control plane and runtime
   entitlement enforcement. `cybersecgpt-governance` owns policy and approval,
   including licensing policy when adopted.
7. `cybersecgpt-infrastructure` owns declarative deployment resources,
   `cybersecgpt-devops` owns build and delivery automation, and
   `cybersecgpt-monitoring` owns operational observability products and
   monitoring-specific semantic conventions.
8. `cybersecgpt-docs` owns conceptual architecture, standards, ADRs, and
   conceptual contract specifications. Executable schemas and implementations
   remain with the designated code owner.
9. A domain owner may implement internal process or service isolation without
   creating another repository. A separate repository requires distinct contract
   ownership, release lifecycle, access controls, and an accepted split ADR.

Accordingly, `cybersecgpt-core`, `cybersecgpt-model`,
`cybersecgpt-agents`, `cybersecgpt-security-engine`,
`cybersecgpt-exploit-validation`, `cybersecgpt-enterprise`,
`cybersecgpt-licensing`, and `cybersecgpt-cloud` are deferred. Their names
must not be used as package or service authorities.

The detailed classification and rationale are normative in the
[repository approval matrix](../architecture/repository-approval-matrix.md).

## Consequences

### Positive

- Every approved production contract has a single accountable owner.
- Existing repositories absorb overlapping responsibilities without adding
  duplicate boundaries.
- Process isolation and least privilege can be introduced independently of
  repository proliferation.
- Documentation can specify contracts without becoming a runtime dependency.

### Costs and constraints

- Some existing owners cover multiple closely related concerns and must preserve
  strong internal modules.
- A future split requires evidence that scale, release cadence, security
  isolation, or access control cannot be handled within the current owner.
- Consumers must use published contracts and cannot import private source merely
  because repositories share an organization.
- Contract transfers require a compatibility and migration period.

## Alternatives Considered

### Approve all proposed repositories

Rejected because each proposed name currently overlaps an existing owner and no
independent lifecycle has been demonstrated.

### Put all shared contracts in `cybersecgpt-docs`

Rejected because documentation is not a runtime package. It owns conceptual
semantics, while executable schemas belong to code owners.

### Allow co-ownership of contracts

Rejected because co-ownership makes compatibility authority and deprecation
decisions ambiguous.

### Split repositories whenever process isolation is required

Rejected because source ownership and runtime isolation solve different
problems. Workers can be independently deployed and sandboxed from one repository.
