# Versioning Standard

## Status

Semantic Versioning is **Proposed** for source packages and services. Contract and
artifact version fields are **Established requirements**, but their initial values
are not selected here.

## Version domains

Versions are independent:

| Domain | Meaning |
| --- | --- |
| Component version | source package, executable, or service release |
| Contract version | public schema or behavioral interface |
| Artifact format version | tokenizer, checkpoint, dataset, policy, evidence, or report layout |
| Model revision | immutable trained artifact identity |
| Deployment revision | composed environment and configuration |
| Policy revision | approved immutable policy bundle |

A component release must declare the contract and artifact versions it supports.
Do not infer compatibility from matching component versions.

## Semantic versions

For stable components:

- **MAJOR** changes remove or incompatibly alter supported public behavior.
- **MINOR** changes add backward-compatible behavior.
- **PATCH** changes correct behavior without changing supported contracts.

Before `1.0.0`, compatibility is still explicit. `0.x` is not permission to break
consumers silently. Pre-release and build metadata follow SemVer syntax when used.

## Contract compatibility

A consumer must:

- reject unsupported major versions before side effects;
- tolerate documented compatible minor additions, including unknown optional
  fields;
- preserve unknown fields when acting as a transparent relay if the contract
  requires it;
- never reinterpret an existing field incompatibly; and
- report supported ranges in capabilities or negotiation.

Required-field addition, semantic reinterpretation, identifier reuse, enum closure,
and default changes that alter behavior are breaking unless introduced through a
new negotiated version.

## Artifact identity

An artifact version is not its identity. Immutable artifact identity includes a
cryptographic digest over canonical content and manifest. Mutable labels such as
`latest`, environment names, or channels resolve to immutable identities and are
never recorded as sole provenance.

Tokenizer, checkpoint, dataset, evaluation, and policy artifacts state:

- format version;
- logical contract version;
- producer component and version;
- content digest;
- compatibility requirements; and
- migration history, if transformed.

## Database and event evolution

Database migrations are ordered, reviewable, backward-aware, and have rollback or
roll-forward guidance. Deployments must account for mixed-version readers and
writers.

Events are immutable once published. Corrective facts use new events. Producers do
not publish a new incompatible payload under an existing event type and major
schema version.

## Deprecation

Deprecation notices include:

- replacement;
- first deprecated version;
- earliest removal version or date;
- migration instructions;
- telemetry or evidence used to judge remaining consumers; and
- security implications.

Emergency removal of unsafe behavior may shorten the window, but requires a
security decision, communication, and mitigation path.

## Changelogs and releases

Each release records additions, changes, deprecations, removals, fixes, and
security changes. It identifies contract, format, migration, minimum dependency,
and rollback impacts.

Tags and artifacts are created only by the release process after validation.
Repositories without implemented releasable content do not publish placeholder
versions as evidence of maturity.

## Compatibility matrices

Owners publish machine-readable or generated matrices for:

- model architecture and checkpoint loader;
- tokenizer fingerprint and model revision;
- runtime and hardware backend;
- SDK and service API;
- policy engine and policy bundle;
- event producer and consumer; and
- deployment profile and component bill of materials.

## Unresolved decisions

- Initial versions for all contracts in this repository.
- Pre-`1.0` stability and support windows.
- Long-term-support cadence.
- Schema registry and compatibility automation.
- Release signing, timestamping, and revocation technology.
