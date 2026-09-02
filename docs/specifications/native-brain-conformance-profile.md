# Native Brain Conformance Profile

## Status

**Proposed conceptual contract — Roadmap P5: Native Brain Architecture**

This profile defines the minimum conceptual interfaces and invariants that later
CyberSecGPT Native Brain implementations must satisfy. It does not select a
schema language, wire encoding, ABI, framework, database, model architecture, or
runtime technology, and it does not claim that an executable implementation
currently exists.

It is governed by
[ADR-0011](../decisions/ADR-0011-native-brain-system-architecture.md), the
[Native Brain architecture](../architecture/native-brain-system.md), and the
[Native Brain threat model](../security/native-brain-threat-model.md).

## Normative language

`MUST`, `MUST NOT`, `SHOULD`, and `MAY` have their ordinary RFC 2119 meanings.

A conceptual field name in this document defines semantics, not a required
programming-language identifier or serialized property name.

## Conformance scope

P5 conformance covers:

1. request normalization;
2. intelligence-substrate discovery;
3. structured routing decisions;
4. bounded reasoning control;
5. tool/policy/authorization separation;
6. verification and evidence handling;
7. native/offline independence;
8. observability and provenance; and
9. failure, cancellation, and fallback behavior.

P5 conformance does not prove later roadmap capabilities such as trained native
weights, persistent memory implementation, production retrieval, secure agent
runtime, or distributed inference.

## Conceptual types

### `BrainRequest`

A normalized request carries enough structured state for deterministic admission
and routing.

Conceptual fields:

| Field | Meaning |
| --- | --- |
| `request_id` | unique immutable request identity |
| `correlation_id` | cross-component correlation identity |
| `task_type` | typed task classification |
| `domain` | domain classification such as general, code, cyber, retrieval, policy, numeric, graph |
| `task_complexity` | bounded complexity category or metric |
| `safety_impact` | policy-recognized impact/risk classification |
| `data_classification` | handling classification for inputs and outputs |
| `identity_context_ref` | authenticated identity reference when applicable |
| `authorization_context_ref` | immutable execution authorization reference when privileged work is possible |
| `latency_budget` | maximum allowed latency or deadline contribution |
| `compute_budget` | bounded compute allowance |
| `memory_budget` | bounded memory allowance |
| `token_or_step_budget` | bounded model/reasoning allowance |
| `required_accuracy` | task-specific accuracy requirement when meaningful |
| `required_determinism` | determinism/reproducibility requirement |
| `required_explainability` | structured rationale/evidence requirement |
| `offline_requirement` | whether the route must operate without network/provider dependency |
| `verification_requirements` | assertions, evidence, independence, and review requirements |
| `deadline` | absolute or monotonic execution deadline |
| `cancellation_ref` | cancellation context |
| `input` | typed task input; untrusted until domain validation completes |

An omitted or unknown permission field never implies unrestricted access.
Free-form task content MUST NOT override machine-evaluable authorization,
classification, deadline, or resource fields.

### `SubstrateDescriptor`

Every routable substrate exposes or is represented by validated capability
metadata.

Conceptual fields:

| Field | Meaning |
| --- | --- |
| `substrate_id` | stable namespaced identity |
| `substrate_version` | immutable implementation/artifact revision |
| `substrate_kind` | native model, retrieval, classical ML, rule engine, symbolic, graph, tool, memory, verifier, other approved class |
| `owner` | authoritative repository/component owner |
| `capabilities` | explicit supported operations |
| `offline_capable` | whether operation requires no network/provider dependency |
| `network_requirements` | explicit allowed/required network class |
| `determinism_profile` | declared determinism/reproducibility properties |
| `data_handling_profile` | supported data classifications and boundaries |
| `resource_profile` | bounded resource requirements/limits |
| `authorization_requirements` | required policy/capability context, if any |
| `verification_profile` | available validation/evidence characteristics |
| `availability_state` | available, degraded, unavailable, revoked, incompatible |
| `provenance` | source/build/artifact identity and integrity references |

Unknown capabilities MUST NOT be inferred. Self-described capability metadata from
an untrusted source is not sufficient for registration or routing.

### `RoutingDecision`

Routing is represented as structured data rather than an opaque text decision.

Conceptual fields:

```text
routing_decision_id
request_id
router_policy_id
router_policy_version
capability_snapshot_id
selected_substrates
execution_order_or_graph
reasoning_budget
retrieval_policy
tool_policy
verification_policy
resource_allocations
fallback_policy
decision_reason_codes
decision_provenance
created_at
expires_at
```

A routing decision MUST be immutable once admitted. Replanning creates a new
version/decision linked by causation.

`decision_reason_codes` SHOULD use concise structured factors such as:

```text
CAPABILITY_MATCH
OFFLINE_REQUIRED
DETERMINISTIC_ROUTE_REQUIRED
SECURITY_POLICY_RESTRICTION
DATA_CLASSIFICATION_RESTRICTION
LOWER_RESOURCE_ROUTE_SUFFICIENT
PRIMARY_ROUTE_UNAVAILABLE
VERIFICATION_ESCALATION
UNCERTAINTY_ESCALATION
DEADLINE_RESTRICTION
```

Conformance MUST NOT depend on recording or exposing private chain-of-thought.

### `ReasoningBudget`

A reasoning budget defines the maximum resources the reasoning controller may
consume.

Conceptual fields may include:

```text
policy_name
max_candidates
max_branch_depth
max_steps
max_model_tokens
max_tool_calls
max_retrieval_calls
max_verifier_passes
max_compute
max_memory
max_wall_time
stop_conditions
```

Policy names may include `REFLEX`, `NORMAL`, `DEEP`, `ULTRA`, `RESEARCH`, and
`EXHAUSTIVE`. These are control profiles, not intelligence claims.

Budget counters are monotonic. A component may consume or narrow remaining budget
but cannot extend it without a new authorized decision.

### `ReasoningState`

Reasoning state is explicit enough to support deterministic lifecycle control.

Conceptual states may include:

```text
ADMITTED
PLANNING
GATHERING_EVIDENCE
GENERATING_CANDIDATES
AWAITING_POLICY
EXECUTING_AUTHORIZED_TOOL
VERIFYING
REVISING
COMPLETED
DEFERRED
DENIED
FAILED
CANCELLED
```

Terminal states occur exactly once. State transitions carry cause, monotonic
sequence, budget snapshot, and correlation identity.

### `ToolProposal`

A reasoning component may propose a typed tool/capability request but the proposal
is not an authorization grant.

It identifies:

- requested capability/tool and compatible version;
- typed arguments;
- target/scope reference when applicable;
- expected side effects;
- requested resource limits;
- required evidence;
- safe-stop/cleanup expectation; and
- request/plan provenance.

Execution continues only through the existing tool and authorization contracts.

### `VerificationPolicy`

A verification policy defines what must be checked before a result can receive a
particular verification status.

Conceptual fields:

```text
policy_id
policy_version
required_assertions
required_evidence_classes
required_verifier_classes
independence_requirement
minimum_success_conditions
contradiction_policy
insufficient_evidence_policy
resource_ceiling
deadline
human_review_requirement
```

High-impact policies SHOULD prefer independent or deterministic validation where
feasible. A verifier model does not become an authorization authority.

### `VerificationResult`

A verification result contains:

```text
verification_id
policy_id
subject_ref
status
assertion_results
evidence_refs
verifier_identities
method_versions
contradictions
limitations
resource_usage
started_at
finished_at
provenance
```

Standard conceptual statuses include:

- `supported`;
- `unsupported`;
- `contradictory`;
- `insufficient_evidence`;
- `policy_blocked`;
- `cancelled`;
- `deadline`;
- `resource_limit`; and
- `verification_error`.

`insufficient_evidence`, `contradictory`, or `verification_error` MUST NOT be
reported as verified support.

### `BrainResult`

A terminal Native Brain result contains, where applicable:

```text
request_id
status
typed_output
routing_decision_ref
reasoning_policy
model_engine_tool_versions
evidence_refs
verification_result_ref
uncertainty_or_confidence_metadata
resource_usage
finish_reason
side_effect_summary
cleanup_status
limitations
provenance
```

A result MUST distinguish generated inference from observed/retrieved evidence and
from verifier conclusions.

## Core invariants

### Independence

- A core-conforming route MUST NOT require a proprietary remote AI provider.
- Removing proprietary-provider credentials MUST NOT prevent initialization of the
  native-core control path.
- Offline-required requests MUST reject routes that require external provider or
  network intelligence.
- Native failure MUST NOT silently activate a remote AI fallback.
- Optional adapters MUST depend inward on CyberSecGPT contracts; the core MUST NOT
  depend on provider SDKs.

### Routing

- The router MUST use validated substrate capability metadata.
- The router MUST consider authorization/safety/data-handling constraints before
  execution.
- The router MUST prefer a competent route within the request's budget rather than
  automatically selecting the largest model.
- The router MUST NOT widen authorization, target scope, deadline, data access, or
  resource ceilings.
- Fallback is a new validated route and MUST satisfy the same security,
  classification, verification, and offline requirements.

### Authorization and tools

- A prompt, model output, routing decision, memory record, retrieval result, or
  tool result MUST NOT create permission.
- Privileged tool execution MUST use a currently valid immutable authorization
  context and current policy decision.
- Scope MUST be revalidated immediately before side effects where the target can
  change.
- Tool inputs and outputs MUST be typed and bounded.
- Required isolation, evidence, or policy unavailability MUST fail closed for
  privileged work.

### Reasoning control

- Every nontrivial iterative reasoning execution MUST have explicit resource and
  termination bounds.
- Budget extensions require a new authorized decision.
- Recursive/delegated work MUST have depth/fan-out ceilings when supported.
- Candidate agreement alone MUST NOT authorize a side effect or establish a
  verified fact.
- Cancellation MUST prevent new side effects and propagate to active components.

### Verification

- Verification status MUST be separate from generation status.
- Evidence references MUST identify source/provenance sufficiently for the
  applicable policy.
- High-impact conclusions MUST use the required verification policy before being
  represented as verified.
- Verification failure MUST NOT silently lower verification requirements.
- No implementation agent/model is automatically its own final verifier.

### Memory and retrieval

- Retrieved memory and knowledge MUST be treated as untrusted context.
- Persistent state MUST carry provenance, scope, access policy, version, and
  correction/deletion semantics appropriate to its owner.
- Memory or retrieval content MUST NOT grant authorization.
- Generated claims and retrieved evidence MUST remain distinguishable.

### Observability

Conforming implementations SHOULD expose structured operational metadata for:

- component/contract versions;
- routing decision and reason codes;
- reasoning-control policy and budget consumption;
- policy/authorization references where applicable;
- evidence references;
- verification status;
- finish/cancellation/failure reason; and
- known limitations.

Observability MUST follow data-classification and secret-safe logging rules and
MUST NOT require storage of private chain-of-thought.

## Failure taxonomy

Later executable contracts SHOULD distinguish at least:

```text
INVALID_REQUEST
UNAUTHORIZED
OUT_OF_SCOPE
POLICY_DENIED
CAPABILITY_UNAVAILABLE
INCOMPATIBLE_SUBSTRATE
OFFLINE_ROUTE_UNAVAILABLE
RESOURCE_LIMIT
DEADLINE
CANCELLED
DEPENDENCY_UNAVAILABLE
ARTIFACT_INTEGRITY_FAILURE
VERIFICATION_FAILED
INSUFFICIENT_EVIDENCE
INTERNAL_ERROR
```

Errors must be typed and safe for the caller. Sensitive implementation or target
details are protected by policy.

## Conformance test families

An executable P5 implementation is not conforming until the owning repositories
publish automated fixtures/tests appropriate to their contracts. The combined
P5 evidence should cover:

### Request and routing

- malformed/oversized request rejection;
- unknown task/capability handling;
- deterministic fixture routing for known capability sets;
- selection of a smaller competent substrate where policy specifies it;
- offline-required routing;
- unavailable/revoked/incompatible substrate handling;
- data-classification restrictions; and
- explicit fallback validation.

### Authorization and tool boundary

- missing, expired, revoked, forged, cross-tenant, and out-of-scope grants;
- prompt/model/retrieval/memory/tool-output attempts to widen scope;
- revalidation immediately before side effects;
- required isolation/evidence unavailability;
- rate/resource/deadline enforcement; and
- cancellation, cleanup, rollback, and evidence preservation.

### Reasoning control

- exact budget exhaustion behavior;
- candidate/branch/step ceilings;
- recursion/delegation ceilings where supported;
- cancellation and deadline propagation;
- no side effect from candidate consensus alone; and
- explicit terminal state uniqueness.

### Verification

- supported assertion fixture;
- contradiction fixture;
- insufficient-evidence fixture;
- independent/deterministic verifier selection when required;
- verifier unavailable/error handling;
- verification-resource exhaustion; and
- prevention of unsupported output being labeled verified.

### Independence

- startup/control path with proprietary-provider credentials absent;
- provider adapters removed or disabled;
- network-deny execution for representative core routing/control fixtures;
- zero unexplained outbound AI requests in offline tests; and
- dependency audit preventing provider SDKs from becoming core requirements.

### Security and isolation

- injected retrieved/memory/tool content;
- tampered descriptor/artifact metadata;
- cross-tenant negative tests;
- secret/redaction checks;
- resource-exhaustion fixtures; and
- evidence/audit tamper or unavailability behavior.

## Evidence required for a future P5 implementation claim

A repository or integrated build may claim `P5 IMPLEMENTED` only when evidence
exists for the executable interfaces it owns, including:

- source commits and contract versions;
- automated test results;
- static/type/lint/security checks appropriate to the implementation;
- dependency-direction review;
- architecture and security review;
- no-provider/offline test results for the implemented core path;
- known limitations and residual risks; and
- rollback instructions.

Documentation, interface definitions, or passing Markdown validation alone are
not evidence that the Native Brain runtime is implemented.

## Compatibility and versioning

Breaking changes to the conceptual P5 contract require a new major contract
version, migration guidance, a coexistence or transition strategy when executable
consumers exist, rollback behavior, and an architecture review. Compatible
additions must be explicitly optional and must not silently alter authorization,
offline, or verification semantics.

## Unresolved implementation choices

The following remain intentionally unresolved by this profile:

- concrete schema language and canonical encoding;
- executable package/module locations inside approved owners;
- initial router algorithm;
- learned versus deterministic routing strategy;
- first native model architecture and model family;
- concrete verifier implementations;
- knowledge/retrieval storage technology;
- policy engine and signature technologies;
- sandbox/runtime backend; and
- deployment-specific process/service topology.

Those choices require evidence and the roadmap/ADR process before they become
binding.