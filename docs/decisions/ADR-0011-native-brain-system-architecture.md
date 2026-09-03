# ADR-0011: Native Brain System Architecture

## Status

**Proposed** — 2026-09-02

## Context

Roadmap milestone P5 establishes the architecture boundary for the CyberSecGPT
native brain before later tokenizer, dataset, neural-architecture, training,
reasoning, memory, agent-runtime, and inference milestones add executable
capability.

The master specification requires CyberSecGPT to remain capable of independent
local/offline operation, to avoid mandatory proprietary AI providers, and to use a
hybrid intelligence architecture rather than treating one foundation model as the
entire system. The deep-reasoning directive additionally requires an explicit
Intelligence Router, structured reasoning-control policies, verifier boundaries,
and deterministic authorization around side-effecting tools.

Existing ADRs already assign model contracts to `cybersecgpt-foundation`, model
execution to `cybersecgpt-inference`, reasoning and agent orchestration to
`cybersecgpt-reasoning`, memory to `cybersecgpt-memory`, tool contracts and
side-effect execution to `cybersecgpt-tools`, security policy to
`cybersecgpt-security`, and TEVV artifacts to `cybersecgpt-evaluation`. P5 must
join those responsibilities without creating a new monolithic brain repository or
a dependency cycle.

## Decision

If accepted, CyberSecGPT will adopt the logical Native Brain System described in
[the P5 architecture](../architecture/native-brain-system.md) and constrained by
[the P5 threat model](../security/native-brain-threat-model.md) and
[conformance profile](../specifications/native-brain-conformance-profile.md).

### Logical planes

The Native Brain System consists of separable, testable planes:

1. **Request and context plane** — validates task metadata, identity references,
   security context, source/claimed data classification, authoritative effective
   data classification, deadlines, resource budgets, provider/network policy, and
   offline requirements.
2. **Authoritative security-policy and authorization plane** — evaluates trusted
   policy, identity, grants, scope, effective classification, and other mandatory
   security constraints. It is a control-plane authority and is not selected,
   replaced, disabled, or bypassed by the Intelligence Router.
3. **Intelligence Router** — chooses the smallest competent authorized substrate
   or composition of substrates using structured capability, risk, resource, and
   verification inputs while consuming authoritative security constraints.
4. **Native neural plane** — CyberSecGPT-controlled model descriptors, tokenizer
   bindings, weights, and model execution as later roadmap milestones implement
   them.
5. **Knowledge and analytical plane** — retrieval, evidence stores, classical or
   statistical ML, deterministic domain rules/schemas, symbolic/constraint
   solving, graph engines, parsers, compilers, and other specialized computation.
6. **Reasoning-control plane** — bounded planning, candidate search, adaptive
   reasoning budgets, revision, and synthesis.
7. **Tool-execution plane** — typed capability-scoped tools behind authorization,
   capability, scope, classification, sandbox, resource, routing-binding, and
   evidence gates.
8. **Verification plane** — independent validators, evidence checks, tests,
   uncertainty handling, and accept/revise/defer decisions.
9. **Memory plane** — governed, provenance-aware memory whose retrieved content is
   treated as untrusted context rather than authority.
10. **Observability and assurance plane** — records structured routing, policy,
    classification, version, resource, evidence, and verification metadata without
    requiring private chain-of-thought disclosure.

### Ownership

This ADR does not create a new repository. Conceptual ownership remains in
`cybersecgpt-docs`; executable ownership follows the existing repository graph.

| Responsibility | Executable owner or boundary |
| --- | --- |
| Cross-domain primitive identifiers and first-party model architecture contracts | `cybersecgpt-foundation` |
| Native model execution and serving behavior | `cybersecgpt-inference` |
| Intelligence Router control, reasoning budgets, planning/search state, runtime verifier orchestration | `cybersecgpt-reasoning` |
| Governed persistent memory | `cybersecgpt-memory` |
| Tool registration, typed invocation, and policy-gated side effects | `cybersecgpt-tools` |
| Generic device, isolation, cancellation, and resource primitives | `cybersecgpt-runtime` |
| Security policy, authorization evaluation, target scope, effective-classification policy, security findings and evidence references | `cybersecgpt-security` |
| Offline/continuous TEVV suites, measurements, regression and promotion evidence | `cybersecgpt-evaluation` |
| Product composition and user-facing orchestration | existing L4/L5 application owners |

The Intelligence Router may consume public capability descriptors from multiple
owners, but it does not take ownership of those implementations. Inference
executes selected model work; it does not become the cross-substrate routing
authority. Security policy and authorization decisions remain authoritative for
privileged actions and cannot be replaced by routing or model output.

The implementation owner for a future dedicated knowledge/RAG service remains
unresolved until the later retrieval milestone provides evidence for a repository
boundary. P5 must not create `cybersecgpt-knowledge` merely to satisfy terminology.

### Native independence

Core routes MUST have no mandatory proprietary remote AI dependency. External AI
providers, if later supported, remain optional adapters outside the core native
brain. Native failure MUST NOT silently trigger a remote AI fallback.

One architecture supports both local/offline/air-gapped and online/self-hosted
profiles. Profiles may differ in scale and available CyberSecGPT-controlled
substrates, but not in the ownership of core intelligence.

### Authorization, classification, routing freshness, and trust

Prompts, retrieved documents, memory, model output, source code, logs, webpages,
threat feeds, source-provided classification labels, and tool output are untrusted
data. They MUST NOT create or widen permission.

The authoritative security-policy/authorization evaluator is not a routable
substrate. The router consumes its current constraints and decision references but
MUST NOT choose, replace, disable, or bypass that authority. Domain-specific rule
or schema engines may be routed when their capabilities are valid, but they do not
become the platform authorizer merely because they are deterministic.

The effective data classification used for routing, storage, logging, model/tool
execution, adapter transmission, and output handling MUST be derived or validated
from authoritative policy and trusted metadata. User, model, memory, retrieval,
fallback, router, or tool content may cause policy to increase handling
restrictions, but none of those sources may lower the effective classification.
Unknown or conflicting classification is handled conservatively according to
policy.

A routing decision is immutable after admission and is valid only for the
security state to which it was bound. Executable contracts MUST bind it to the
request, authorization/security context, effective data classification,
provider/network and offline policy, capability snapshot, relevant policy revision,
and explicit lifetime. Expiry or any binding mismatch invalidates the decision
and requires a fresh routing decision. Stale or replayed routing metadata cannot
retain broader grants, weaker classification, or older provider permissions.

Privileged execution follows the existing trusted path:

```text
UNTRUSTED DATA
→ INTERPRET / PROPOSE
→ AUTHORITATIVE POLICY CHECK
→ AUTHORIZATION
→ EFFECTIVE CLASSIFICATION
→ CAPABILITY CHECK
→ SCOPE / RESOURCE CHECK
→ ROUTING BINDING / EXPIRY CHECK
→ SANDBOX
→ EXECUTION
→ EVIDENCE
→ VERIFICATION
```

A model or router may propose an action. It cannot grant itself authorization,
mint credentials, widen target scope, lower classification, suppress evidence, or
reuse an obsolete routing decision.

## Compatibility impact

P5.1 is conceptual architecture. It does not select a wire encoding, language ABI,
model architecture, tokenizer algorithm, policy engine, sandbox backend, database,
vector store, or provider SDK. Existing conceptual model, agent, tool, event, and
authorization contracts remain valid.

The hardening clarifications make explicit three security properties already
consistent with existing contracts: authoritative authorization remains outside
router choice, effective data classification is non-downgradable by untrusted
content, and routing decisions are security-context-bound and expiring. No
production runtime migration is introduced by these documentation changes.

Later executable P5 interfaces MUST be implemented by the designated repository
owners and MUST preserve the acyclic dependency direction established by
ADR-0004.

## Security and privacy consequences

Positive consequences include explicit authorization separation, provider
independence, non-downgradable classification, bounded resource use, replay/stale
routing resistance, evidence provenance, and a distinct verifier boundary. Costs
include additional validation state, capability registries, policy/classification
version negotiation, routing-context binding, and the need to protect routing
metadata and evidence from tampering.

The Native Brain System must fail closed for privileged actions when authorization,
policy, scope, classification, routing freshness/bindings, capability, or evidence
requirements cannot be validated. Read-only reasoning may degrade according to
policy but must report missing substrates or verification rather than silently
changing trust assumptions.

## Migration and rollback

No production runtime migration is required for this documentation-only P5.1
increment. If the ADR is rejected, the P5 documents can be removed without
changing executable artifacts. If accepted, implementation proceeds incrementally
in existing owner repositories with contract-versioning and rollback requirements
for each executable change.

## Alternatives Considered

### One monolithic foundation model as the entire brain

Rejected because deterministic authorization, specialist analytics, tools,
retrieval, symbolic computation, and independent verification are first-class
requirements and often require different trust or resource properties.

### A wrapper around proprietary remote AI providers

Rejected because it violates the native-independence and offline requirements.

### Put all Native Brain implementation into `cybersecgpt-foundation`

Rejected because Foundation is a small low-dependency trust anchor and must not
absorb model runtimes, reasoning engines, databases, agent behavior, or product
logic.

### Create a new `cybersecgpt-brain` repository

Rejected for P5 because current responsibilities already have approved owners and
no distinct release lifecycle has been demonstrated.

### Let model output or the router authorize tools

Rejected because generated output is untrusted proposal data, not a source of
permission.

### Let the Intelligence Router choose the security authorizer

Rejected because a security-critical route could otherwise substitute or bypass
the control that is supposed to constrain that same routing decision. The router
therefore consumes authoritative policy constraints rather than selecting its own
authorizer.

### Trust caller/model data-classification labels

Rejected because attacker-controlled or model-generated labels could downgrade
handling requirements. Effective classification must come from authoritative
policy and trusted metadata and may only change according to that policy.

### Reuse routing decisions until execution completes

Rejected because authorization, policy, classification, provider permissions, or
capability state can change after admission. Routing decisions require explicit
security bindings and expiry, with revalidation before privileged side effects.

## Acceptance and follow-up

Before this ADR becomes Accepted, architecture review and security review are
required. The P5 conformance profile defines the evidence expected from later
implementations. Acceptance of this ADR does not claim those implementations
exist.
