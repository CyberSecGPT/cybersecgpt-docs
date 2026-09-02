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
   security context, data classification, deadlines, resource budgets, and
   offline requirements.
2. **Intelligence Router** — chooses the smallest competent authorized substrate
   or composition of substrates using structured capability, risk, resource, and
   verification inputs.
3. **Native neural plane** — CyberSecGPT-controlled model descriptors, tokenizer
   bindings, weights, and model execution as later roadmap milestones implement
   them.
4. **Knowledge and analytical plane** — retrieval, evidence stores, classical or
   statistical ML, deterministic rules, symbolic/constraint solving, graph
   engines, parsers, compilers, and other specialized computation.
5. **Reasoning-control plane** — bounded planning, candidate search, adaptive
   reasoning budgets, revision, and synthesis.
6. **Tool-execution plane** — typed capability-scoped tools behind authorization,
   capability, scope, sandbox, resource, and evidence gates.
7. **Verification plane** — independent validators, evidence checks, tests,
   uncertainty handling, and accept/revise/defer decisions.
8. **Memory plane** — governed, provenance-aware memory whose retrieved content is
   treated as untrusted context rather than authority.
9. **Observability and assurance plane** — records structured routing, policy,
   version, resource, evidence, and verification metadata without requiring
   private chain-of-thought disclosure.

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
| Security policy, authorization evaluation, target scope, security findings and evidence references | `cybersecgpt-security` |
| Offline/continuous TEVV suites, measurements, regression and promotion evidence | `cybersecgpt-evaluation` |
| Product composition and user-facing orchestration | existing L4/L5 application owners |

The Intelligence Router may consume public capability descriptors from multiple
owners, but it does not take ownership of those implementations. Inference
executes selected model work; it does not become the cross-substrate routing
authority. Security policy decisions remain authoritative for privileged actions
and cannot be replaced by routing or model output.

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

### Authorization and trust

Prompts, retrieved documents, memory, model output, source code, logs, webpages,
threat feeds, and tool output are untrusted data. They MUST NOT create or widen
permission.

Privileged execution follows the existing trusted path:

```text
UNTRUSTED DATA
→ INTERPRET / PROPOSE
→ POLICY CHECK
→ AUTHORIZATION
→ CAPABILITY CHECK
→ SCOPE / RESOURCE CHECK
→ SANDBOX
→ EXECUTION
→ EVIDENCE
→ VERIFICATION
```

A model or router may propose an action. It cannot grant itself authorization,
mint credentials, widen target scope, or suppress evidence.

## Compatibility impact

P5.1 is conceptual architecture. It does not select a wire encoding, language ABI,
model architecture, tokenizer algorithm, policy engine, sandbox backend, database,
vector store, or provider SDK. Existing conceptual model, agent, tool, event, and
authorization contracts remain valid.

Later executable P5 interfaces MUST be implemented by the designated repository
owners and MUST preserve the acyclic dependency direction established by
ADR-0004.

## Security and privacy consequences

Positive consequences include explicit authorization separation, provider
independence, bounded resource use, evidence provenance, and a distinct verifier
boundary. Costs include additional validation state, capability registries,
version negotiation, and the need to protect routing metadata and evidence from
tampering.

The Native Brain System must fail closed for privileged actions when authorization,
policy, scope, capability, or evidence requirements cannot be validated.
Read-only reasoning may degrade according to policy but must report missing
substrates or verification rather than silently changing trust assumptions.

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

## Acceptance and follow-up

Before this ADR becomes Accepted, architecture review and security review are
required. The P5 conformance profile defines the evidence expected from later
implementations. Acceptance of this ADR does not claim those implementations
exist.