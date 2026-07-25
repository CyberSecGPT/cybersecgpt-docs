# Contributing to CyberSecGPT Documentation

## Scope

This repository owns cross-repository architecture, engineering standards,
security requirements, and stable conceptual contracts. Component-specific
implementation guides should live with their component and link back to the
relevant contract here.

## Before proposing a change

1. Read the [system overview](docs/architecture/system-overview.md), the
   [repository map](docs/architecture/repository-map.md), and the relevant
   standard or specification.
2. Classify the change as an established constraint, proposal, unresolved
   question, or observed implementation fact.
3. Verify implementation claims directly against the owning repository. Include
   the repository, branch or commit, and inspection date when the claim may age.
4. Check that a proposed dependency follows the
   [acyclic dependency graph](docs/architecture/dependency-graph.md).
5. For security-sensitive changes, apply the
   [authorization model](docs/security/authorization-model.md) and
   [scope-enforcement requirements](docs/security/scope-enforcement.md).

## Architecture decisions

Use an ADR for changes that alter repository ownership, dependency direction,
public contract compatibility, trust boundaries, persistence formats, or security
policy. An ADR should contain:

- context and problem statement;
- decision status and owner;
- considered alternatives;
- selected decision and rationale;
- security and privacy consequences;
- migration and rollback plan;
- compatibility impact; and
- unresolved follow-up work.

Until an ADR is accepted, wording must remain **Proposed** or **Unresolved**.

## Documentation rules

- Use precise, testable requirements: **MUST**, **MUST NOT**, **SHOULD**, and
  **MAY** have their ordinary RFC 2119 meanings.
- Define acronyms and domain terms at first use.
- Use relative Markdown links for repository-internal navigation.
- Add Mermaid only when it clarifies boundaries, data flow, or state.
- Do not present a conceptual contract as an implemented wire format.
- Do not copy secrets, personal data, proprietary datasets, exploit payloads, or
  live target details into examples.
- Keep examples inert and defensive.
- Do not select or imply a project license without an approved organization-wide
  licensing decision.

## Repository-map changes

Adding a directory does not establish ownership or implementation maturity. A map
change must record:

- whether the repository is observed or merely proposed;
- evidence of implementation;
- purpose and non-responsibilities;
- allowed and forbidden dependencies;
- public contracts and produced artifacts; and
- overlap with existing owners.

Prefer assigning responsibility to an existing suitable repository over creating
a duplicate. Renames, splits, and consolidations require an ADR and migration plan.

## Architecture governance gate

All cross-repository and architecture-sensitive changes MUST follow the
[architecture change gate](docs/governance/architecture-change-gate.md).

Implementation repositories must reference their repository-map ownership,
approved dependencies, relevant ADRs, and the contracts they implement or
consume. A repository placeholder or local directory does not establish
architectural approval.

## Validation

Before submitting a change:

1. review heading order and code fences;
2. verify every relative link resolves;
3. run an installed Markdown linter, if available;
4. inspect `git diff --check`;
5. inspect the complete `git diff`; and
6. confirm no unrelated repository was changed.

## Review expectations

At least one architecture owner should review cross-repository boundaries. A
security reviewer is required for authorization, validation, audit, evidence,
identity, or policy-enforcement changes. Reviewers should challenge unsupported
implementation claims and cyclic dependencies.
