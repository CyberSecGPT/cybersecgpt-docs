# Secure Development

## Status

This document defines **Established security requirements** for CyberSecGPT
development. Specific tools, hosting controls, and service-level targets remain
**Unresolved**.

## Secure lifecycle

### Design

Every material feature identifies:

- assets and data classifications;
- actors and trust boundaries;
- authorization and least-privilege requirements;
- expected and prohibited side effects;
- misuse and abuse cases;
- rate, timeout, cancellation, and resource limits;
- audit and evidence requirements;
- reproducibility needs;
- dependency and supply-chain risks;
- failure, cleanup, rollback, and recovery; and
- unresolved risks and required reviewers.

Threat modeling is required for model loading, deserialization, plugins, tools,
agents, memory, external adapters, identity, policy, evidence, and target access.

### Implementation

- Validate all external data at the boundary.
- Use safe serialization and parsers.
- Resolve and contain filesystem paths.
- Avoid shell interpretation of untrusted input.
- Apply outbound network allowlists and deadlines.
- Use memory, process, filesystem, and network isolation proportional to risk.
- Keep secrets out of source, logs, exceptions, fixtures, and artifacts.
- Use cryptographic libraries and approved algorithms.
- Make authorization context immutable and revalidate before side effects.
- Bound queues, recursion, agent steps, tokens, retries, and generated output.
- Preserve evidence before attempting rollback.

### Review

Security review is required for changes to:

- identity, authentication, authorization, policy, scope, or tenancy;
- tools, subprocesses, network access, filesystems, or plugins;
- model/checkpoint loading and executable formats;
- cryptography, signing, secrets, and supply-chain controls;
- sensitive logging, memory, evidence, or retention;
- external-provider adapters;
- deployment privilege or public exposure; and
- authorized validation capabilities.

Reviewers verify both allowed and denied paths.

### Validation and release

Releases require applicable format, lint, type, unit, contract, integration,
security, compatibility, package, provenance, dependency, and secret checks.
Artifacts identify source revision, build environment, dependencies, tests,
signatures when configured, and rollback target.

No component is promoted because a security scanner alone passed.

## AI-specific threats

### Prompt and content injection

Prompts, retrieved documents, model output, tool output, and memory are untrusted
content. They cannot alter system policy, authorization, target scope, secrets
access, or tool capabilities. Separate instructions from data using typed
boundaries, not prompt wording alone.

### Model and checkpoint loading

Validate manifest version, hashes, signatures when required, architecture,
tokenizer fingerprint, tensor names/shapes/dtypes, resource estimates, and shard
containment before allocation. Do not load executable object graphs from untrusted
artifacts. See [checkpoint format](../specifications/checkpoint-format.md).

### Data poisoning and provenance

Dataset and tokenizer artifacts record source, license/consent status, transforms,
validation, exclusions, and digests. Training and evaluation do not consume
unapproved mutable inputs.

### Resource exhaustion

Bound prompt length, generation, context, batch, tensor allocation, decompression,
agent steps, tool output, recursion, and concurrency. Perform resource preflight
before expensive allocation.

### External adapters

Adapters are optional, capability-scoped, separately configured, and prevented
from becoming core dependencies. Minimize transmitted data, identify destination
and policy, isolate credentials, validate responses, and record provider/model
identity without logging secrets.

## Cybersecurity capability safeguards

All security operations require the
[authorization model](authorization-model.md) and
[scope enforcement](scope-enforcement.md).

Capabilities are risk-classified and mapped to:

- required identity assurance;
- target-owner authorization;
- approval and supervision;
- sandbox and network restrictions;
- least-privilege credentials;
- rate, concurrency, timeout, and resource limits;
- evidence and reproducibility requirements;
- cleanup and rollback;
- retention; and
- allowed environments.

This repository and its examples must not include weaponized exploit payloads,
malware, credential theft, persistence, evasion, destructive actions, or
unauthorized access procedures.

## Secrets and credentials

- Use an approved secret manager or OS credential facility.
- Prefer short-lived, workload-bound credentials.
- Separate development, CI, test, staging, and production identities.
- Rotate and revoke credentials with audit.
- Never expose secrets to models unless explicitly required and policy-approved;
  provide scoped handles instead where possible.
- Redact at source and test redaction.
- Treat any committed secret as compromised and follow incident response.

## Dependency and build security

- Minimize dependencies.
- Verify origin, maintenance, license status, integrity, and vulnerability posture.
- Pin build tooling and lock deployable environments.
- Isolate builds and avoid unreviewed install-time scripts.
- Generate an SBOM and provenance for releases.
- Review native code, model files, containers, and downloaded artifacts.
- Use protected promotion; building does not automatically approve release.
- Maintain an emergency update and rollback path.

## Data and privacy

Collect the minimum data needed for a declared purpose. Assign owner,
classification, permitted uses, residency, retention, deletion, and access policy.
Training use requires explicit governance; operational data is not training data by
default.

Use synthetic or approved fixtures in tests. Evidence and memory are separate
stores with separate purposes and access controls.

## Logging, evidence, and reproducibility

Follow the [logging standard](../standards/logging-standard.md). Privileged actions
emit correlated policy and evidence events. Evidence is append-oriented, hashed,
encrypted, access-controlled, and preserved across failure. Reproduction requires
fresh authorization and records the original versions and configuration.

## Vulnerability handling

Follow [SECURITY.md](../../SECURITY.md). Triage confidentially, preserve evidence,
identify affected versions, contain with least privilege, develop tests, remediate,
validate, provide rollback, and coordinate disclosure. Do not publish operational
details that unnecessarily increase risk.

## Rollback and recovery

Every deployment and side-effecting feature documents:

- last known good version or state;
- compatibility during rollback;
- database/artifact migration behavior;
- preservation of audit and evidence;
- cleanup and verification;
- credentials or policy requiring revocation; and
- conditions that require operator intervention.

Rollback must not weaken authorization or restore known-vulnerable behavior without
an explicit time-bounded risk decision.

## Security test baseline

Tests include boundary parsing, authorization denial, scope containment,
cross-tenant access, secret redaction, timeouts, rate limiting, cancellation,
resource exhaustion, dependency failure, malformed artifacts, prompt/tool
injection, evidence failure, cleanup, rollback, and reproducibility metadata.

## Unresolved decisions

- Confidential security contact and response targets.
- Approved identity, policy, secrets, signing, and evidence systems.
- Data classification and retention schedules.
- Dependency and container allowlists.
- Capability risk taxonomy and approval matrix.
- Secure development training and reviewer ownership.
