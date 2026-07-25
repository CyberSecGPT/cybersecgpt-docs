# ADR-0008: Enterprise and Governance Boundaries

## Status

**Accepted** — 2026-07-25

## Context

Enterprise operation requires tenancy, identity integration, quotas, policy
administration, audit access, lifecycle management, and entitlement enforcement.
Governance requires approvals, risk classifications, exceptions, and decisions
about source, documentation, datasets, tokenizers, models, weights, and product
licensing. The existing `cybersecgpt-platform` and
`cybersecgpt-governance` repositories overlap the absent
`cybersecgpt-enterprise` and `cybersecgpt-licensing` proposals.

Combining policy authorship with commercial enforcement would allow product code
to silently redefine governance. Splitting enterprise and licensing repositories
before policies, contracts, or services exist would instead duplicate tenancy,
identity, policy, and event boundaries.

## Decision

`cybersecgpt-platform` is the authoritative owner of the enterprise-capable
control plane. It owns:

- tenant and organization lifecycle;
- identity-provider integration and role assignment;
- policy administration interfaces;
- quotas, service composition, deployment profiles, and supportability controls;
- entitlement evaluation and enforcement based on approved policy artifacts;
- usage records needed for transparent enforcement; and
- tenant-scoped audit access and control-plane events.

`cybersecgpt-governance` is the authoritative owner of policy intent and approval.
It owns:

- governance policy lifecycle and versioned policy bundles;
- risk classifications, approval records, exceptions, and expiry;
- model, dataset, security, privacy, and acceptable-use policy;
- recording licensing decisions after appropriate organizational and legal
  approval; and
- governance decision events and rationales.

The separation is mandatory:

1. Governance publishes signed or integrity-verifiable policy artifacts.
2. Platform evaluates and enforces those artifacts; it cannot author an implicit
   replacement policy.
3. Governance does not depend on platform implementation or product storage.
4. Enforcement decisions identify the policy version, subject, tenant, resource,
   decision, and reason.
5. Usage collection is disclosed, minimized, tenant-scoped, access-controlled,
   and never hidden telemetry.
6. A fail-closed behavior and documented recovery or rollback path are required
   when policy authenticity or compatibility cannot be established.

`cybersecgpt-enterprise` and `cybersecgpt-licensing` are **Deferred**.
Enterprise features remain deployment-neutral platform capabilities. Licensing
policy remains unresolved until approved; this ADR does not select a source,
documentation, data, tokenizer, model, weight, or product license.

A future split requires a distinct access-control or commercial release boundary,
one-way dependencies, data migration and deletion rules, offline enforcement
behavior, compatibility, and rollback guidance.

## Consequences

### Positive

- Enterprise capability can grow in one control plane without duplicating
  tenancy and identity.
- Governance decisions remain reviewable and independent from product
  enforcement code.
- Licensing can be introduced after approval without prematurely selecting a
  license or repository.
- Enforcement is traceable to immutable policy versions and reason codes.

### Costs and constraints

- Platform and governance require a versioned policy-distribution contract.
- Offline and degraded-mode entitlement behavior must be designed explicitly.
- Identity, tenant isolation, metering privacy, and policy rollback need
  conformance and security tests.
- A later commercial packaging split would require a staged migration rather
  than parallel ownership.

## Alternatives Considered

### Approve `cybersecgpt-enterprise`

Rejected because its proposed control-plane responsibilities are already owned by
platform and no independent packaging boundary has been established.

### Approve `cybersecgpt-licensing`

Rejected because no organization-wide licensing decision or standalone
entitlement lifecycle is established. Governance and platform provide the
necessary initial separation.

### Put policy authorship in platform

Rejected because enforcement code must not silently create or alter the policy it
enforces.

### Put runtime enforcement in governance

Rejected because governance should publish decisions without depending on
product runtime, tenancy storage, or request paths.
