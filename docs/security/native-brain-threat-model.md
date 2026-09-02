# Native Brain Threat Model

## Status

**Proposed — Roadmap P5: Native Brain Architecture**

This threat model applies to the conceptual
[Native Brain System](../architecture/native-brain-system.md) governed by
[ADR-0011](../decisions/ADR-0011-native-brain-system-architecture.md). It defines
security requirements for later implementations and does not claim that those
controls are already deployed.

## Security objectives

The Native Brain System must preserve:

- explicit authorization and target scope for privileged actions;
- integrity of routing, policy, capability, model, memory, and evidence metadata;
- confidentiality of classified prompts, evidence, memory, credentials, and
  tenant data;
- availability within bounded resource policies;
- CyberSecGPT-native offline operation without mandatory remote AI services;
- provenance for artifacts, retrieval, tool observations, and verifier decisions;
- separation of proposal/generation from authorization and side effects;
- independent verification appropriate to task impact; and
- rollback and safe-stop behavior for failures or revocation.

## Protected assets

Assets include:

- operator identity and authorization references;
- target-scope and policy decisions;
- model, tokenizer, checkpoint, and capability identities;
- routing policies and routing decisions;
- reasoning-control budgets and state;
- memory records and retrieval indexes;
- tool descriptors, calls, results, credentials, and sandbox configuration;
- verifier policies, assertions, results, and evidence;
- audit/evidence records and integrity metadata;
- tenant boundaries and data-classification labels; and
- the invariant that core intelligence has no mandatory proprietary AI
  dependency.

## Trust boundaries

### TB-01 — Untrusted input to normalized request

User prompts, uploaded files, source code, logs, documents, webpages, datasets,
model-generated text, and external content are untrusted until parsed,
classified, normalized, and bounded.

### TB-02 — Capability/artifact metadata to routing

Model descriptors, tool descriptors, registry entries, memory metadata, retrieval
metadata, and availability reports are untrusted until identity, version,
integrity, compatibility, and policy checks complete.

### TB-03 — Router/reasoning output to side-effect authority

Routing decisions, plans, model tool-call proposals, and generated commands are
proposal data. They cannot grant permission or bypass deterministic policy.

### TB-04 — Tool gateway to operating environment or target

Filesystem, process, network, account, repository, cloud, model-artifact, dataset,
and cybersecurity target interactions cross a privileged side-effect boundary.

### TB-05 — Tool/retrieval/memory observations back to reasoning

Returned content may be attacker-controlled or stale. It is evidence or context,
not instruction authority.

### TB-06 — Model/checkpoint package to execution

Model manifests, tensor shards, tokenizer artifacts, configuration, and optional
extensions are untrusted supply-chain input until validated.

### TB-07 — Native core to optional network/provider adapters

The core/native boundary must prevent accidental data transmission or hidden
replacement of CyberSecGPT intelligence with remote provider intelligence.

### TB-08 — Tenant/security domain boundary

Identity, memory, evidence, tool state, routing metadata, caches, and model inputs
must not cross tenants or security compartments without explicit policy.

## Adversary model

The design assumes possible adversaries include:

- a malicious or compromised user supplying crafted prompts or files;
- malicious content embedded in retrieved documents, repositories, logs, webpages,
  memory, or tool results;
- a compromised or malicious tool implementation;
- poisoned datasets, retrieval indexes, capability registries, or memory records;
- tampered model/checkpoint/tokenizer artifacts;
- a compromised dependency or build artifact;
- an authenticated actor attempting to exceed granted scope;
- a tenant attempting cross-tenant data access;
- a remote service attempting to induce provider dependency or data exfiltration;
- an attacker seeking resource exhaustion or denial of service; and
- a verifier or policy integration failure that could incorrectly accept unsafe
  output.

The design does not assume generative model output is trustworthy merely because
it was produced by a CyberSecGPT model.

## Threats and required controls

| ID | Threat | Required controls |
| --- | --- | --- |
| NB-T01 | Prompt or instruction injection attempts to override policy, scope, or system contracts | Treat content as data; typed normalization; immutable authorization context; deterministic policy; no prompt-defined permission |
| NB-T02 | Retrieved document, memory, log, webpage, or tool output contains instructions that trigger privileged execution | Untrusted-data boundary; typed proposal parsing; policy/authorization/capability checks before tool admission; output validation |
| NB-T03 | Router manipulation selects an unsafe, overprivileged, or inappropriate substrate | Signed/versioned policy where required; validated capability descriptors; authorization-aware routing; reason codes; resource ceilings; route conformance tests |
| NB-T04 | Hidden fallback sends a failed native task to a proprietary remote AI provider | Explicit fallback policy; provider adapters disabled by default for native-core conformance; outbound-network controls; no-provider and network-deny tests |
| NB-T05 | Capability spoofing falsely claims a model/tool/engine supports required operations | Immutable descriptors; provenance; digest/signature policy; compatibility validation; unknown capability fails closed |
| NB-T06 | Model/checkpoint/tokenizer artifact tampering or unsafe deserialization | Schema and bounds validation before allocation; content digests; signature policy where required; non-executable artifact formats; no artifact-supplied code execution |
| NB-T07 | Retrieval or knowledge poisoning causes false evidence or malicious instructions | Source provenance; ingestion validation; content classification; retrieval diversity when useful; evidence/model-inference separation; verifier checks |
| NB-T08 | Persistent-memory poisoning influences future decisions | Typed writes; provenance; confidence/verification state; access control; correction/deletion; memory never treated as authorization or automatically true |
| NB-T09 | Model or router self-authorizes a tool or widens target scope | Immutable execution authorization context; final policy check at tool boundary; scope revalidation; model/router cannot mint grants or credentials |
| NB-T10 | Tool injection or arbitrary-command escape bypasses typed capability controls | Registered typed tools only; strict schemas; capability-specific APIs; sandboxing; least privilege; no undocumented direct shell/network escape |
| NB-T11 | Tool output is forged, malicious, oversized, or used as executable instruction | Typed result schema; output size limits; evidence digests; treat output as untrusted observation; parser isolation |
| NB-T12 | Cross-tenant or cross-compartment leakage through prompts, memory, caches, retrieval, evidence, or logs | Tenant-scoped identifiers and storage; cache partitioning; access control; data classification; redaction; cross-tenant negative tests |
| NB-T13 | Secrets leak through prompts, logs, traces, evidence, provider adapters, or error messages | Secret-safe logging; minimal payload logging; protected evidence references; scoped ephemeral credentials; adapter data minimization; redaction tests |
| NB-T14 | Resource-exhaustion attack consumes model tokens, candidate branches, tools, memory, GPU/CPU, storage, or network | Admission controls; reasoning budgets; token/step/tool ceilings; deadlines; per-tenant quotas; output limits; cancellation and safe stop |
| NB-T15 | Recursive agents or reasoning loops fail to terminate | Explicit depth/fan-out/step ceilings; monotonic budget consumption; terminal-state rules; deadlines; cancellation propagation |
| NB-T16 | Verifier gaming or self-review accepts unsupported conclusions | Separate verifier interface; independent/deterministic checks where feasible; evidence requirements; contradictory/insufficient states; high-impact review policy |
| NB-T17 | Policy or verifier service unavailable and privileged action proceeds anyway | Fail closed for privileged work; bounded decision cache with expiry; no stale implicit allow; explicit unavailable status |
| NB-T18 | Audit/evidence tampering hides denied or harmful actions | Append-oriented evidence; digests; access separation; immutable correlation IDs; protected storage; verification of evidence availability for high-risk tools |
| NB-T19 | Race or time-of-check/time-of-use changes target, grant, DNS, scope, policy, or artifact identity after admission | Revalidate immediately before side effect; decision expiry; target resolution at action time; immutable artifact identity; active-work revocation checks |
| NB-T20 | Optional provider or plugin dependency becomes required for core startup or reasoning | Dependency audit; adapter inversion; core build/test without provider SDKs or credentials; offline conformance test |
| NB-T21 | Malicious dependency, plugin, or build artifact compromises routing, tools, or models | Locked dependencies where appropriate; provenance/SBOM; artifact verification; restricted dynamic loading; supply-chain scanning and review |
| NB-T22 | Unsafe model output produces harmful cybersecurity actions outside authorization | Authorized-use boundary; security policy; typed capabilities; explicit target-owner authorization; non-destructive defaults; rate/scope limits; human approval where required |
| NB-T23 | Generated or retrieved content is misrepresented as verified fact | Evidence typing; provenance references; verification status; explicit uncertainty and limitations; verifier result separate from generator output |
| NB-T24 | Rollback or cleanup exceeds scope or destroys evidence | Rollback declared in tool contract; separately authorized compensation; cleanup idempotency; evidence preserved; rollback verification |
| NB-T25 | Private chain-of-thought or sensitive intermediate data is unnecessarily logged | Structured reason codes, plan facts, evidence references, and policy explanations; do not require private reasoning traces for observability |

## Router-specific controls

The Intelligence Router is security-sensitive because it can choose components with
different resource, network, determinism, data-handling, or verification
properties.

A routing implementation MUST:

- validate every substrate descriptor before selection;
- bind the decision to a capability/policy snapshot or version;
- include authorization and data-classification constraints in routing;
- reject required capabilities that are unavailable or unknown;
- preserve offline requirements;
- enforce a configured network/provider policy;
- allocate bounded resource budgets;
- record structured reason codes without relying on hidden natural-language
  reasoning;
- validate fallback routes with the same requirements as the primary route; and
- send high-impact results through the required verification policy.

The router MUST NOT:

- treat model confidence text as authorization;
- select a provider solely because local execution failed;
- lower a verification requirement to fit an available substrate;
- enlarge a grant, target scope, deadline, or data-access boundary; or
- register a capability based only on untrusted self-description.

## Reasoning-control threats

Candidate search and iterative reasoning create amplification risk. Controls
include:

- explicit reasoning policy names and immutable ceilings;
- maximum candidate count, branch depth, steps, tool calls, and verifier passes;
- cancellation and wall-clock deadlines;
- deduplication of repeated actions;
- no side effect merely because multiple candidates agree;
- independent evidence for high-impact claims; and
- graceful `insufficient_evidence` or `resource_limit` completion rather than
  unbounded search.

## Tool and cybersecurity safety boundary

Cybersecurity functionality is limited to authorized penetration testing,
authorized red teaming, controlled labs, defensive validation, security research,
simulation, investigation, and protection.

The Native Brain architecture does not authorize malicious persistence, credential
theft, malware deployment, destructive attacks, unauthorized access, or evasion of
legitimate security controls. "Stealth" retains its defensive meaning: least
privilege, privacy, compartmentalization, minimal attack surface, local processing,
and minimal unnecessary telemetry.

No component may infer target authorization from a prompt, hostname, organization
name, public accessibility, discovered ownership metadata, or prior authorization
record. A currently valid machine-evaluable grant is required for privileged
interaction.

## Data and privacy controls

- Classify data before storage, retrieval, model use, or adapter transmission.
- Store sensitive tool/evidence payloads in protected stores and pass references
  when practical.
- Apply minimum necessary retention and access control to memory and evidence.
- Partition tenant state, caches, indexes, and temporary workspaces.
- Keep credentials out of prompts, memory, and general logs.
- Record provider/adaptor transmission explicitly when such optional use is
  authorized.
- Do not expose private reasoning traces as a condition of auditability.

## Failure behavior

For privileged operations, failure to verify any of the following causes denial or
safe stop:

- operator/service identity;
- authorization grant;
- target scope;
- current policy;
- capability descriptor;
- required isolation;
- resource limits;
- required audit/evidence path; or
- required verification gate.

For non-privileged reasoning, missing optional components may result in a bounded
partial, unavailable, deferred, or uncertain result. The system must disclose the
limitation and MUST NOT silently change network or trust policy.

## Verification scenarios

Later P5 executable implementations should support isolated tests covering at
least:

1. prompt injection cannot widen authorization;
2. retrieved/tool/memory injection cannot invoke a tool directly;
3. out-of-scope tool proposals are denied;
4. revoked or expired grants stop active privileged work at a safe boundary;
5. router capability spoofing is rejected;
6. offline mode rejects a route requiring a remote provider;
7. removal of all proprietary-provider credentials does not break the native-core
   control path;
8. network-deny mode generates no unexplained outbound AI request;
9. poisoned memory is surfaced with provenance and cannot become permission;
10. tampered model/checkpoint/tokenizer artifacts fail before execution;
11. reasoning and tool budgets terminate recursive or oversized work;
12. cross-tenant memory/retrieval/evidence access is denied;
13. verifier contradiction or insufficient evidence cannot be reported as
   verified support;
14. unavailable policy/evidence services fail closed for privileged actions;
15. fallback cannot lower verification, scope, or data-handling requirements; and
16. cancellation preserves evidence and performs only authorized cleanup.

Tests interacting with cybersecurity behavior must use isolated fixtures or
explicitly authorized targets.

## Residual risks

Even with these controls, later implementations must account for model
misclassification, unknown supply-chain flaws, imperfect confidence calibration,
novel prompt/data injection, emergent interaction between multiple substrates,
hardware/runtime vulnerabilities, and operator policy mistakes. P5 architecture
reduces and contains these risks; it does not eliminate them.

Residual risk acceptance for high-impact deployments belongs to governance and
security review and must be based on measured implementation and TEVV evidence.

## Review requirement

Because this document affects authorization, trust, tool execution, evidence,
model loading, memory, provider isolation, and cross-tenant boundaries, a security
review is required before ADR-0011 becomes Accepted.