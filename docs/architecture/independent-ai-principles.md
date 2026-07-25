# Independent AI Principles

## Status

The principles marked **Established** are platform constraints. Implementation
mechanisms remain **Proposed** until accepted through ADRs and delivered in the
owning repositories.

## 1. Core operation is provider-independent

**Established:** CyberSecGPT must perform core tokenization, model loading,
inference, reasoning, agent orchestration, memory access, security-policy
evaluation, and authorized tool execution without OpenAI, Anthropic, Google,
Ollama, or another external provider.

Provider absence, credential removal, network isolation, or provider outage must
not prevent local core startup. A capability may be unavailable because local
artifacts were not installed, but it must not be silently delegated to a hosted
provider.

## 2. The organization owns the complete model lifecycle

**Established:** the architecture provides first-party ownership boundaries for:

- tokenizer training and artifacts;
- model architecture and configuration;
- dataset manifests and provenance;
- training and fine-tuning pipelines;
- checkpoint manifests and compatibility;
- inference and hardware adaptation;
- evaluation, promotion, and rollback; and
- runtime, reasoning, agent, memory, and tool contracts.

Ownership does not imply those components are implemented today. Repository
evidence is recorded in the [repository map](repository-map.md).

## 3. Contracts precede coupling

**Established:** repositories integrate through versioned public contracts and
artifacts. They must not import another repository's private modules, database
tables, internal filesystem layout, or undocumented event payloads.

The conceptual contracts in `docs/specifications/` define stable semantics.
Concrete schemas remain proposals until an owning implementation and compatibility
tests exist.

## 4. Adapters are replaceable and capability-scoped

**Established:** an external-provider adapter:

- implements the same provider-neutral request and result semantics exposed to
  callers;
- declares supported capabilities and limitations;
- is disabled unless explicitly configured;
- receives only the data and credentials required for one request;
- cannot become the durable system of record;
- emits auditable provider and model identity without exposing secrets; and
- can be removed without changing core domain contracts.

**Proposed:** adapters belong at application or inference boundaries, behind
interfaces owned by the independent stack. Domain packages must not import
provider SDKs.

## 5. Artifacts are portable and self-describing

**Established:** tokenizer, model, checkpoint, dataset, evaluation, and policy
artifacts identify:

- artifact and contract versions;
- content hashes;
- producing component and version;
- compatibility requirements;
- provenance and relevant configuration; and
- integrity or signature information when required by policy.

Portability does not require one universal binary encoding. The
[checkpoint specification](../specifications/checkpoint-format.md) separates the
logical manifest from the unresolved tensor container.

## 6. Reproducibility is a product property

**Established:** training, evaluation, inference investigations, and authorized
security validation preserve the inputs and environment needed to reproduce a
result to the extent the underlying hardware and algorithms permit.

Records include deterministic seeds where meaningful, dependency and artifact
versions, configuration hashes, policy decisions, timestamps, and known sources of
non-determinism. A result must not be labeled reproducible when required data or
artifacts are unavailable.

## 7. Security policy outranks model intent

**Established:** a model, planner, agent, adapter, or tool output cannot grant
authorization, widen scope, suppress required logging, or disable safety limits.
Security decisions are made by deterministic policy enforcement using authenticated
identity and explicit grants.

Prompt text is never proof of authorization. Retrieved memory is never proof of
authorization. Provider metadata is never proof of authorization.

See the [authorization model](../security/authorization-model.md) and
[scope-enforcement requirements](../security/scope-enforcement.md).

## 8. Local-first does not mean single-process

**Established:** independence is compatible with distributed deployment. A
self-hosted CyberSecGPT installation may use multiple services, accelerators,
queues, databases, and object stores. It remains independent when every required
component can be operated under the deployer's control without a mandatory
third-party AI service.

## 9. Data custody is explicit

**Established:** every dataset, prompt, memory item, model output, evidence object,
and telemetry record has an owner, classification, retention rule, and permitted
uses. Training use is not inferred from operational access.

External transmission requires policy authorization and adapter-specific
disclosure. Secret, personal, or controlled data is minimized and redacted before
logging.

## 10. Evaluation gates promotion

**Established:** a checkpoint or policy bundle is not promoted solely because it
was produced successfully. Promotion requires versioned evaluation evidence,
security review proportional to risk, compatibility checks, and a rollback target.

Thresholds and approval roles are **unresolved** and must be policy-configurable.

## 11. Open formats and licenses are separate decisions

**Established:** a documented format does not determine the source-code, model,
weight, dataset, or documentation license. Each artifact carries explicit license
metadata when a license has been approved.

**Unresolved:** no organization-wide license was established by the inspected
repositories. Component-level MIT declarations in bootstrap repositories do not
settle the broader decision.

## 12. Independence is continuously tested

**Proposed:** release validation should include a provider-disconnected profile
that:

1. starts the local runtime;
2. loads a first-party tokenizer and checkpoint fixture;
3. completes a bounded inference request;
4. executes a non-side-effecting agent/tool contract test;
5. evaluates policy locally; and
6. verifies no network call to an external AI provider is attempted.

This test becomes an **Established** release gate only after the relevant
implementations and fixtures exist.

## Acceptance criteria for new components

A component aligns with these principles when it:

- has a provider-neutral public contract;
- documents artifact ownership and compatibility;
- declares data and trust boundaries;
- works in a self-hosted deployment profile;
- applies policy before side effects;
- has bounded resource behavior;
- emits privacy-safe audit events; and
- does not introduce a dependency cycle.

## Unresolved decisions

- Which checkpoint encodings are required first.
- What local reference model defines the initial independence test.
- Which artifact signing system and trust roots are used.
- Minimum offline hardware and supported accelerators.
- Licensing for source, documentation, datasets, tokenizers, models, and weights.
