# Repository Standard

## Status

- **Established:** repository ownership, public contracts, dependency direction,
  security boundaries, and implementation status must be explicit.
- **Proposed:** the default layout and required automation below.
- **Unresolved:** organization-wide license, hosting controls, and mandatory CI
  provider.

## Repository charter

Every repository README must state:

- purpose and intended users;
- responsibilities and non-responsibilities;
- owning team or role;
- implementation maturity;
- public contracts and artifacts;
- allowed and forbidden cross-repository dependencies;
- supported runtime and platform versions;
- security and data classifications;
- local development and validation commands; and
- links to the [repository map](../architecture/repository-map.md) and relevant
  specifications.

A repository name is not a charter. Empty repositories must say they are
placeholders once content is added; they must not claim production readiness.

## Required top-level files

| File | Requirement |
| --- | --- |
| `README.md` | charter, status, setup, validation, contract links |
| `CONTRIBUTING.md` | contribution and review workflow |
| `SECURITY.md` | confidential reporting and supported security process |
| `CHANGELOG.md` | user-visible and contract changes |
| `.gitignore` | only generated, local, and secret-prone files |
| build manifest | language-specific package/build definition |
| tests directory | automated tests and conformance fixtures |
| CI configuration | formatting, linting, typing, tests, build, and security gates |

Add `LICENSE` only after the applicable license is approved. An empty or template
license is not a substitute for a decision. Until then, README and release metadata
must state that licensing is unresolved and distribution is not authorized merely
by repository visibility.

## Proposed layout

```text
.
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
├── docs/
│   ├── architecture/
│   └── decisions/
├── src/ or language-standard source root
├── tests/
│   ├── unit/
│   ├── integration/
│   └── contract/
├── configs/
├── scripts/
└── build manifest
```

Directories are added only when used. Generated artifacts, local environments,
secrets, credentials, production evidence, model weights, and unrestricted
datasets are not committed.

## Public and private boundaries

Public contracts must have:

- an authoritative owner;
- version and compatibility policy;
- machine-readable schema or typed interface where practical;
- validation behavior;
- error model;
- security and privacy classification;
- conformance fixtures; and
- deprecation and migration guidance.

Anything not intentionally exported is private. Consumers must not depend on
private modules, internal paths, database tables, queue names, undocumented event
fields, or test helpers.

Cross-repository changes are contract-first: update the conceptual contract and
producer conformance tests, publish a compatible contract version, then update
consumers. Coordinated commits do not justify an undocumented breaking change.

## Dependency governance

Every dependency must:

1. follow the [acyclic dependency graph](../architecture/dependency-graph.md);
2. have a documented purpose and owner;
3. use the narrowest public surface;
4. be version constrained reproducibly;
5. pass provenance, license, and vulnerability review appropriate to risk; and
6. have a removal or replacement path for critical dependencies.

Core repositories must not require external AI-provider SDKs. Provider adapters
are optional packages that depend on provider-neutral CyberSecGPT contracts.

## Change control

An ADR is required for:

- creating, renaming, splitting, merging, or archiving a repository;
- changing a public contract incompatibly;
- adding a cross-layer dependency;
- changing a trust or authorization boundary;
- selecting a durable storage or serialization format;
- introducing mandatory hosted infrastructure; or
- changing licensing or artifact-distribution policy.

Small internal refactors do not require an ADR when public behavior and boundaries
are unchanged.

## Branches, commits, and releases

- Protect the default branch once repository hosting is configured.
- Use short-lived branches and focused commits.
- Never commit secrets or generated credentials.
- Require green validation and required reviewers before merge.
- Sign release artifacts when signing infrastructure is established.
- Tag only intentional releases; a tag must resolve to reproducible source.
- Record user-visible and contract changes in the changelog.

Commit-message convention is **Proposed** as:

```text
<type>(optional-scope): imperative summary
```

Common types are `feat`, `fix`, `docs`, `test`, `refactor`, `build`, `ci`,
`security`, and `chore`.

## Security baseline

Repositories must:

- use least-privilege CI identities;
- pin or lock build dependencies where supported;
- generate a software bill of materials for releases;
- scan dependencies and secrets;
- isolate untrusted tests;
- redact sensitive logs;
- document rollback;
- preserve build provenance; and
- follow [secure development](../security/secure-development.md).

Security or validation repositories additionally require explicit authorization
fixtures and tests proving scope, rate, timeout, evidence, and denial behavior.

## Definition of ready

A repository may call a component implemented only when source exists and its
declared validation passes. “Production-ready” additionally requires accepted
contracts, security review, operational guidance, supported-version policy,
rollback, observability, and release evidence.

## Unresolved decisions

- License and copyright policy.
- Repository owners and required reviewer groups.
- Default CI, artifact registry, and signing services.
- Commit-signing and developer identity requirements.
- Archive and retention policy for replaced repositories.
