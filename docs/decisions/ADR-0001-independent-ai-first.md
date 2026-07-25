# ADR-0001: Independent AI First

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT is intended to be an independent AI and cybersecurity platform.
External model providers can accelerate development or provide optional
capabilities, but making one of them part of the core execution path would
transfer control over availability, data handling, model behavior, cost, and
compatibility outside the organization.

Independence does not require every low-level library to be developed in-house.
It requires CyberSecGPT to own the contracts, artifacts, and implementations that
define its AI behavior and to remain operable when external AI credentials,
adapters, and network access are absent.

## Decision

CyberSecGPT will use an **independent-AI-first** architecture.

1. First-party components own tokenizer behavior, model architecture, training,
   datasets, checkpoint semantics, inference, runtime, reasoning and agent
   orchestration, memory, tool contracts, evaluation, and security policy.
2. A core release must support a documented self-hosted profile that performs its
   declared core functions with all external AI provider adapters disabled.
3. OpenAI, Anthropic, Google, Ollama, and similar integrations are optional,
   separately configurable adapters. An adapter depends on a CyberSecGPT public
   contract; core repositories do not depend on the adapter or its provider SDK.
4. Provider-specific identifiers, errors, token accounting, and capabilities are
   translated at the adapter boundary. They do not become canonical core types.
5. Checkpoints, tokenizer artifacts, dataset manifests, evaluation records, and
   execution evidence use provider-neutral, versioned contracts.
6. Release qualification will include a provider-disconnected conformance
   profile once reference implementations and fixtures exist. Until then, that
   profile is a required implementation target, not a claim of current readiness.
7. Third-party infrastructure and compute libraries are permitted when they are
   replaceable, license-reviewed, security-reviewed, and do not redefine a
   CyberSecGPT public contract.

This decision is elaborated by the
[independent AI principles](../architecture/independent-ai-principles.md).

## Consequences

### Positive

- CyberSecGPT controls its core behavior, data custody, release cadence, and
  compatibility policy.
- Deployments can select local, self-hosted, or optional external execution
  without changing product-level contracts.
- Provider outages, commercial changes, or account restrictions do not define
  the availability of the independent core.

### Costs and constraints

- The organization must build and maintain a complete model lifecycle and
  conformance suite.
- Provider adapters may expose only the intersection that can be represented
  safely by the public contracts, plus explicitly negotiated extensions.
- Performance parity with hosted providers is not assumed and must be measured.
- Artifact provenance, licensing, hardware support, and offline installation
  require explicit engineering and governance work.

## Alternatives Considered

### Hosted-provider-first core

Rejected because a mandatory hosted API would contradict independent operation
and make external policy, availability, and pricing part of the core.

### Mandatory local third-party model server

Rejected because requiring Ollama or another model server would replace one
mandatory provider with another. Such systems remain valid optional adapters.

### Equal first-class provider and first-party implementations

Rejected because symmetric dependency treatment tends to leak provider concepts
into canonical contracts. Adapter dependency inversion preserves optionality.

### Defer independence until after product development

Rejected because dependency direction and artifact portability are expensive to
retrofit after provider-specific assumptions enter public APIs.
