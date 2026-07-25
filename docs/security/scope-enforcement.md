# Scope Enforcement

## Status

Scope enforcement is an **Established requirement** for any operation that can
interact with a target, filesystem, process, account, dataset, model artifact,
tenant, or external service. The selector language and policy engine are
**Unresolved**.

## Principle

A target is permitted only when the normalized action is demonstrably contained
within an active authorization grant. Ambiguity, resolution failure, conflicting
selectors, or inability to enforce a required limit results in denial.

Scope is not a display string. It is a typed, versioned, machine-evaluable object.

## Scope dimensions

`TargetScope` can constrain:

- organization, tenant, account, subscription, project, or namespace;
- environment such as isolated lab, development, staging, or production;
- asset identifiers and explicit exclusions;
- hostnames, canonical addresses, approved ranges, and service endpoints;
- protocols, ports, API resources, and methods;
- repositories, paths, files, models, datasets, or records;
- allowed capability and technique identifiers;
- data classification and maximum accessible fields;
- redirect, proxy, dependency, and third-party rules;
- time window and maintenance window;
- requests, concurrency, bandwidth, compute, and storage;
- geographic or jurisdictional restrictions; and
- required evidence, supervision, cleanup, and stop conditions.

Wildcard or broad ranges require explicit policy approval. An empty selector never
means “all.”

## Canonicalization

Before policy evaluation:

1. parse with a strict typed parser;
2. normalize case, Unicode, separators, addresses, ports, and identifiers according
   to the target domain;
3. resolve aliases through an approved authoritative source;
4. preserve the original request for audit;
5. produce canonical inclusion and exclusion sets;
6. reject traversal, ambiguous encoding, unsupported schemes, and duplicate
   conflicting rules; and
7. hash the canonical scope for correlation.

Filesystem paths are resolved against an approved root and checked after symlink
resolution. Archive members, templates, and generated paths receive the same
containment checks.

Network names are resolved within the execution environment. Resolved destinations
must remain in scope at connection time; redirects and alternate addresses are new
scope decisions, not automatic continuations.

## Enforcement points

```mermaid
flowchart LR
    Admission[Workflow admission]
    Plan[Plan validation]
    Tool[Tool-call validation]
    Resolve[Target resolution]
    Connect[Immediately before side effect]
    Continue[Periodic active-work revalidation]
    Evidence[Evidence and cleanup]

    Admission --> Plan --> Tool --> Resolve --> Connect --> Continue --> Evidence
```

Each enforcement point uses the immutable grant plus current revocation, policy,
time, and budget state. Caching is bounded by policy-decision expiry.

## Action containment

An action is allowed only when:

- operator and service identity match the grant;
- capability and method are explicitly allowed;
- every canonical target is included and not excluded;
- environment and tenant match;
- current time is inside all windows;
- rate, concurrency, resource, and action budgets remain;
- required supervision and evidence channels are available;
- data access stays within classification and field limits;
- the action's side effects and cleanup are declared; and
- current policy returns allow with satisfiable obligations.

Batch requests are evaluated per member. One allowed target never authorizes peers.
Systems either reject the batch atomically or report per-target decisions without
executing denied members, according to the declared contract.

## Dynamic target behavior

Targets may change during execution. The system must:

- re-evaluate DNS/address changes before connection;
- evaluate redirects and discovered dependencies independently;
- pin or revalidate approved identities at safe intervals;
- stop when a target moves outside scope;
- prevent tool output or model suggestions from adding targets; and
- record resolution evidence without exposing sensitive data unnecessarily.

Discovery may report an out-of-scope reference as a redacted observation. It may
not follow or interact with that reference.

## Limits and safe stop

Policy applies the minimum of grant, tenant, tool, environment, and operator limits:

- requests per interval;
- target-specific rate;
- concurrent operations;
- total operations;
- connection and operation timeout;
- workflow deadline;
- bytes read or written;
- CPU, accelerator, memory, and storage;
- result and evidence size; and
- retry attempts.

On limit, timeout, cancellation, expiry, or revocation:

1. prevent new side effects;
2. stop at the declared safe boundary;
3. preserve partial evidence;
4. run authorized cleanup;
5. verify cleanup where possible;
6. emit terminal audit events; and
7. provide operator rollback guidance.

## Evidence

Evidence records:

- original request digest;
- canonical scope identifier and hash;
- identity, grant, and policy-decision references;
- resolution facts and time;
- tool/capability version;
- applied limits;
- start and end state;
- result and artifact hashes;
- cancellation, cleanup, and rollback state; and
- reproducibility metadata.

Sensitive target details are stored only in an authorized evidence tier. Operational
logs use protected references.

## Testing

Use isolated fixtures, never unapproved public targets. Tests cover:

- exact inclusion and exclusion;
- boundary addresses, paths, ports, methods, and times;
- Unicode, case, alternate encodings, traversal, symlinks, and archive paths;
- alias changes, redirects, and changing resolution;
- empty, overlapping, and contradictory selectors;
- cross-tenant and cross-environment requests;
- rate, concurrency, size, timeout, and retry limits;
- revocation during execution;
- evidence failure and safe-stop behavior; and
- cleanup and rollback verification.

Property-based and mutation testing are recommended for containment predicates.

## Prohibited behavior

Scope enforcement must not:

- infer authorization from ownership-like names or prompt claims;
- silently broaden a selector to make a tool succeed;
- treat discovery as authorization;
- follow redirects outside scope;
- reuse expired grants;
- suppress denied attempts from audit; or
- perform destructive proof to establish impact.

## Related documents

- [Authorization model](authorization-model.md)
- [Secure development](secure-development.md)
- [Tool contract](../specifications/tool-contract.md)
- [Testing standard](../standards/testing-standard.md)

## Unresolved decisions

- Canonical selector language and schema.
- Authoritative asset inventory and resolution services.
- Rules for approved dynamic infrastructure.
- Default limits by capability class.
- Evidence redaction and retention by target classification.
