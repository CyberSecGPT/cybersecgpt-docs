# ADR-0009: Cloud and Infrastructure Boundaries

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT must support local, self-hosted, enterprise, and potentially managed
cloud deployments without making a cloud provider or external AI service a core
dependency. The existing `cybersecgpt-infrastructure`,
`cybersecgpt-devops`, and `cybersecgpt-monitoring` repositories already cover
deployment resources, delivery automation, and operations. The absent
`cybersecgpt-cloud` proposal overlaps those owners.

Cloud overlays may eventually become a separately released product, but creating
another repository before that lifecycle exists would duplicate modules, pipeline
logic, and operational policy.

## Decision

Operational ownership is divided as follows:

- `cybersecgpt-infrastructure` owns declarative, provider-neutral infrastructure
  modules, self-hosted environment composition, and provider-specific deployment
  overlays.
- `cybersecgpt-devops` owns build, test, provenance, signing integration,
  promotion, deployment automation, and rollback workflows for released
  artifacts.
- `cybersecgpt-monitoring` owns collectors, dashboards, alerts, service-level
  indicators, and monitoring-specific semantic conventions based on public
  telemetry.
- `cybersecgpt-platform` owns deployment-neutral application configuration,
  service lifecycle intent, tenancy, and product health contracts.

The operational plane consumes versioned release artifacts and public operational
interfaces. L0-L5 production repositories do not import infrastructure, DevOps,
or monitoring source. Deployment configuration cannot bypass application
authorization, widen security scope, redefine governance policy, or make an
external AI provider mandatory.

Infrastructure and delivery artifacts must:

- keep secrets in approved secret-management boundaries rather than source,
  images, logs, or state outputs;
- support least-privilege identities and network policies;
- pin or constrain artifact versions and verify provenance;
- define health, timeout, rate, capacity, backup, recovery, and rollback
  behavior;
- isolate tenant and security-sensitive workloads according to policy; and
- emit audit and operational evidence sufficient to reproduce a deployment.

`cybersecgpt-cloud` is **Deferred**. Cloud-specific profiles remain overlays
owned by infrastructure and delivered through DevOps. A future split requires a
distinct product lifecycle, support model, access boundary, migration path, and
proof that generic modules will not be duplicated.

## Consequences

### Positive

- The same product artifacts can be deployed locally, self-hosted, or in
  supported cloud environments.
- Infrastructure, delivery, and observability have distinct accountable owners.
- Cloud-specific configuration does not become a core source dependency.
- Operational controls can evolve without redefining application authorization
  or governance.

### Costs and constraints

- Infrastructure must preserve a provider-neutral module layer while maintaining
  tested provider overlays.
- Cross-repository release promotion needs artifact manifests, provenance, and
  compatibility checks.
- Monitoring schemas must distinguish common event fields from
  monitoring-specific conventions.
- A managed cloud product, if approved later, will require an explicit support,
  tenancy, recovery, cost, and compliance model.

## Alternatives Considered

### Approve `cybersecgpt-cloud` immediately

Rejected because no separate cloud product lifecycle exists and its proposed
responsibilities are covered by infrastructure and DevOps.

### Put deployment definitions in each application repository

Rejected because definitions would diverge, duplicate security controls, and
couple applications to deployment environments.

### Make one cloud provider the reference core

Rejected because mandatory provider services would contradict independent,
self-hosted operation.

### Combine infrastructure, DevOps, and monitoring

Rejected because resource definitions, delivery authority, and operational
observation have different access controls, change cadences, and rollback
responsibilities.
