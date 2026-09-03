# P5 Native Brain Independent Review Checklist

## Status

**Review evidence template — Roadmap P5: Native Brain Architecture**

This document defines the minimum independent architecture and security review
record required before ADR-0011 may move from **Proposed** to **Accepted**.

It is intentionally separate from authoring-agent pre-review. A person or agent
that materially authored the P5 architecture package MUST NOT be treated as the
sole final verifier.

## Review target

Review the complete P5.1 architecture package as one change set:

- `docs/architecture/native-brain-system.md`
- `docs/decisions/ADR-0011-native-brain-system-architecture.md`
- `docs/security/native-brain-threat-model.md`
- `docs/specifications/native-brain-conformance-profile.md`
- related README/index/validation updates in PR #4

The current review target is the head of PR #4. The reviewer MUST record the exact
commit SHA reviewed. If the PR head changes after acceptance, the acceptance is
stale until the reviewer confirms the new head or a new independent review occurs.

## Independence declaration

Before reviewing, record:

```text
Reviewer identity:
Reviewer role:
GitHub identity (if applicable):
Review date/time:
Reviewed commit SHA:
Material author of this P5.1 change set: YES / NO
Has a direct conflict that prevents independent review: YES / NO
```

Acceptance is valid only when:

- `Material author of this P5.1 change set` is `NO`; and
- `Has a direct conflict that prevents independent review` is `NO`.

The repository owner may perform the review when acting as an independent reviewer
rather than simply repeating an authoring-agent conclusion.

## Evidence prerequisites

The reviewer MUST confirm the following evidence exists for the reviewed head:

- Architecture Validation completed successfully;
- CyberSecGPT Agent Policy Gate completed successfully;
- PR diff is available for review;
- ADR-0011 remains `Proposed` before acceptance;
- the branch is based on the expected `main` architecture baseline or any divergence
  is explicitly documented;
- no unresolved blocking review thread is hidden by the acceptance record; and
- the review is tied to the exact PR head SHA.

Automated validation is necessary evidence but is not a substitute for independent
architecture/security review.

## Architecture review

Mark each item `PASS`, `FAIL`, or `N/A` and record a short evidence note.

| ID | Review requirement | Result | Evidence / note |
| --- | --- | --- | --- |
| AR-01 | P5 scope remains architecture/contracts only and does not claim P6+ runtime/model implementation |  |  |
| AR-02 | CyberSecGPT-native intelligence remains the required core; proprietary remote AI remains optional only |  |  |
| AR-03 | Local/offline/air-gapped and online/self-hosted profiles preserve the same native-intelligence ownership model |  |  |
| AR-04 | The design is hybrid rather than LLM-only and permits neural, retrieval, classical/statistical, deterministic, symbolic/graph, tool, and verification substrates |  |  |
| AR-05 | Repository ownership matches accepted ADRs and does not create duplicate responsibility |  |  |
| AR-06 | Dependency direction remains acyclic and Foundation remains a small trust anchor |  |  |
| AR-07 | The Intelligence Router selects substrates but does not absorb implementation ownership from domain repositories |  |  |
| AR-08 | The authoritative security-policy/authorization evaluator is outside router choice |  |  |
| AR-09 | Routing decisions are structured, versioned, bounded, observable, expiring, and security-context-bound |  |  |
| AR-10 | Reasoning policies have explicit resource and termination bounds |  |  |
| AR-11 | Verification remains separable from generation and routing |  |  |
| AR-12 | P5 does not prematurely select tokenizer, model architecture, policy engine, sandbox, database, vector store, or provider SDK |  |  |
| AR-13 | Existing model, agent, tool, event, authorization, and scope contracts are not contradicted |  |  |
| AR-14 | Migration/rollback for this documentation-only increment is explicit and credible |  |  |

Any `FAIL` in AR-01 through AR-14 blocks acceptance until resolved or formally
superseded by an approved architecture change.

## Security review

| ID | Review requirement | Result | Evidence / note |
| --- | --- | --- | --- |
| SR-01 | Prompts, retrieval, memory, model output, tool output, and source-provided labels are treated as untrusted data |  |  |
| SR-02 | Models and routers cannot create authorization, widen scope, mint credentials, or suppress evidence |  |  |
| SR-03 | Privileged actions fail closed when identity, authorization, policy, scope, classification, capability, isolation, evidence, or verification cannot be validated |  |  |
| SR-04 | Effective data classification is derived/validated from authoritative policy/trusted metadata and cannot be downgraded by untrusted content |  |  |
| SR-05 | Router cannot select, replace, disable, or bypass the authoritative security-policy/authorization evaluator |  |  |
| SR-06 | Routing decisions are rejected on expiry or request/security-context/policy/classification/provider/capability mismatch |  |  |
| SR-07 | Hidden fallback to a proprietary remote AI provider is prohibited |  |  |
| SR-08 | Offline-required routes reject provider/network intelligence dependencies |  |  |
| SR-09 | Capability descriptors and model/checkpoint/tokenizer artifacts are treated as untrusted until integrity/compatibility validation |  |  |
| SR-10 | Prompt/data/tool/retrieval/memory injection cannot directly invoke privileged side effects |  |  |
| SR-11 | Cross-tenant and data-classification boundaries are represented and fail safely |  |  |
| SR-12 | Resource exhaustion and recursive reasoning have bounded controls and cancellation |  |  |
| SR-13 | Verification failure, contradiction, or insufficient evidence cannot be represented as verified support |  |  |
| SR-14 | TOCTOU/revocation is addressed by revalidation before privileged side effects |  |  |
| SR-15 | Secrets, sensitive evidence, and private reasoning traces are not required in general logs |  |  |
| SR-16 | Rollback/cleanup cannot silently widen authorization or destroy required evidence |  |  |
| SR-17 | Cybersecurity execution remains authorization-aware and does not infer target permission from prompts or public accessibility |  |  |

Any `FAIL` in SR-01 through SR-17 blocks acceptance until resolved or explicitly
accepted through the appropriate security/governance process. A reviewer MUST NOT
use a general statement such as "looks secure" as a substitute for these checks.

## Conformance-contract review

Confirm that the P5 conformance profile defines enough semantics for later owner
repositories to implement compatible contracts without inventing security-critical
behavior.

| ID | Contract requirement | Result | Evidence / note |
| --- | --- | --- | --- |
| CR-01 | `BrainRequest` represents immutable request/security/budget/offline state |  |  |
| CR-02 | `SubstrateDescriptor` represents validated routable capability metadata |  |  |
| CR-03 | Authoritative security policy is not modeled as a router-selectable substrate |  |  |
| CR-04 | `RoutingDecision` has explicit request/security/classification/provider/capability/policy bindings and expiry |  |  |
| CR-05 | `ReasoningBudget` has monotonic ceilings and cannot self-extend |  |  |
| CR-06 | Tool proposals are distinct from authorization grants |  |  |
| CR-07 | Verification policy/result semantics distinguish supported, contradictory, insufficient, blocked, cancelled, and error states |  |  |
| CR-08 | Failure taxonomy includes authorization, classification, offline-route, stale-routing, integrity, resource, verification, and evidence failures |  |  |
| CR-09 | Conformance tests include offline/no-provider and authorization-negative scenarios |  |  |
| CR-10 | Contract versioning rules prohibit silent weakening of authorization, classification, provider/network, offline, or verification semantics |  |  |

## Native-independence review

The reviewer MUST answer all of the following `YES` before acceptance:

```text
Does P5 require CyberSecGPT-controlled intelligence for the native core? YES / NO
Can the architecture operate with proprietary AI credentials absent? YES / NO
Is hidden provider fallback prohibited? YES / NO
Is offline-required routing explicitly represented? YES / NO
Does optional provider integration depend inward on CyberSecGPT contracts? YES / NO
Does the architecture avoid making Internet connectivity a requirement for core intelligence? YES / NO
```

A `NO` blocks acceptance.

## Hardening verification

The independent reviewer MUST specifically verify the three findings from the
technical pre-review were resolved in the reviewed head:

1. **Authorization authority outside router choice** — confirm domain rules/schemas
   may be routable but the security authorizer is a separate trusted control plane.
2. **Non-downgradable effective classification** — confirm user/model/retrieval/
   memory/router/fallback/tool content cannot lower authoritative handling level.
3. **Bound and expiring routing decisions** — confirm replay/stale decisions are
   rejected when authorization, policy, classification, provider/offline policy,
   capability snapshot, request identity, or expiry changes.

Record:

```text
Hardening finding 1: PASS / FAIL
Hardening finding 2: PASS / FAIL
Hardening finding 3: PASS / FAIL
```

## Review decision

Choose exactly one:

- **ACCEPT** — no blocking architecture/security issue remains for P5.1.
- **REQUEST CHANGES** — one or more blocking issues must be resolved.
- **DEFER** — evidence or reviewer independence is insufficient for a decision.

Record:

```text
Decision:
Blocking findings:
Non-blocking findings:
Residual risks accepted for this documentation-only P5.1 increment:
Required follow-up issues/ADRs:
Reviewer identity:
Reviewed commit SHA:
Review date/time:
```

## Acceptance procedure

Only after an independent `ACCEPT` decision tied to the current PR head:

1. update ADR-0011 from `Proposed` to `Accepted` with the review date;
2. update the ADR index if necessary;
3. record the independent review evidence in the PR conversation or an accepted
   repository evidence document;
4. rerun architecture and agent-policy validation on the acceptance commit;
5. verify the final diff contains no unreviewed architecture/security changes;
6. merge PR #4 using the repository's normal protected process; and
7. verify `main` contains the accepted ADR and passing validation evidence.

If the acceptance commit changes architecture/security semantics beyond status or
review-evidence metadata, a reviewer MUST confirm those changes before merge.

## Post-acceptance boundary

Acceptance of ADR-0011 means the P5.1 conceptual architecture is approved. It does
not mean the Native Brain runtime, tokenizer, models, training, memory, retrieval,
agents, inference, or later-roadmap capabilities are implemented.

The next executable P5 increment may begin only in the repository that owns the
specific accepted contract, with its own tests, security review, and evidence.
