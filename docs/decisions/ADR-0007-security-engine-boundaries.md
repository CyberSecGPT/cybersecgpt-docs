# ADR-0007: Security Engine Boundaries

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT requires defensive analysis and explicitly authorized validation
without permitting an agent, model, product surface, or tool to widen authority.
The existing `cybersecgpt-security` repository overlaps the absent
`cybersecgpt-security-engine` and `cybersecgpt-exploit-validation` proposals.
Repository separation could support stronger access controls, but it does not by
itself enforce scope, least privilege, or safe execution.

The architecture must support isolation while avoiding duplicate policy,
finding, technique, evidence, and validation-result contracts. It must also avoid
publishing weaponized exploit payloads, malware, credential theft, persistence,
evasion, destructive actions, or unauthorized access procedures.

## Decision

`cybersecgpt-security` is the authoritative cybersecurity domain and enforcement
owner. It owns:

- capability and risk classification;
- authorization and target-scope evaluation for security operations;
- policy decisions and reason codes;
- defensive technique selection and authorized validation orchestration;
- finding, observation, evidence-reference, cleanup, and validation-result
  contracts; and
- security-domain audit events and reproducibility requirements.

Security execution follows these mandatory controls:

1. Every operation has an authenticated operator and service identity.
2. A verifiable authorization grant names the permitted purpose, target scope,
   capabilities, time window, and applicable policy.
3. Admission and each side effect are independently policy-checked and denied by
   default.
4. Credentials, network access, filesystem access, and tool capabilities use
   least privilege.
5. Rate limits, concurrency limits, deadlines, cancellation, output bounds, and
   cleanup controls are enforced outside model reasoning.
6. Audit records capture request identity, policy decision, normalized scope,
   tool and artifact versions, timing, result status, and evidence hashes without
   leaking secrets.
7. Evidence is integrity-protected and retained under policy; reproducibility
   records describe inputs, environment, versions, and material configuration.
8. Partial side effects, cleanup verification, rollback guidance, and escalation
   paths are part of the result.

`cybersecgpt-tools` owns the generic tool gateway and tool execution mechanics.
`cybersecgpt-reasoning` may propose an action but cannot authorize it.
`cybersecgpt-runtime` may supply sandboxing and resource primitives but cannot
define security policy.

High-risk validation workers may be separately deployed, isolated, restricted,
and operated under additional approval while remaining owned by
`cybersecgpt-security`. Repository topology is not a substitute for process,
identity, network, secret, and evidence isolation.

`cybersecgpt-security-engine` and `cybersecgpt-exploit-validation` are
**Deferred**. A split ADR must demonstrate that separate access control, release,
or assurance lifecycles cannot be enforced within the existing owner and must
define one-way contracts, migration, rollback, and incident containment.

## Consequences

### Positive

- Security policy and domain semantics have one accountable owner.
- Every side effect remains bounded by authorization, scope, policy, and
  deterministic controls.
- Strong worker isolation can be introduced without duplicating public schemas.
- Evidence and reproducibility are contractual outcomes rather than optional
  logging features.

### Costs and constraints

- The security repository needs strong internal separation between policy,
  orchestration, technique packages, and isolated workers.
- Authorized validation cannot proceed when identity, grant, scope, policy,
  evidence, or cleanup requirements are unavailable.
- Security techniques require elevated review, controlled distribution, and
  conformance testing.
- A future repository split would require coordinated contract and operational
  migration.

## Alternatives Considered

### Approve a separate security engine immediately

Rejected because it would duplicate the initial execution and policy boundary
without an established independent lifecycle.

### Approve a separate validation repository immediately

Rejected because process and deployment isolation can be enforced now under the
existing security owner. Repository separation may be reconsidered with evidence.

### Let tools enforce all cybersecurity policy

Rejected because the generic tool gateway should enforce typed decisions, not own
domain-specific risk and target-scope semantics.

### Let agents determine whether an operation is authorized

Rejected because model and agent outputs are untrusted proposals and cannot grant
or expand authority.
