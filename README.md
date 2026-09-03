# CyberSecGPT Architecture Documentation

CyberSecGPT is an independent AI and cybersecurity platform under design. The
target system owns its tokenizer, model architecture, training pipeline, datasets,
checkpoint format, inference engine, runtime, reasoning and agent systems, memory,
security controls, authorized validation framework, evaluation, governance,
enterprise services, licensing model, and cloud infrastructure.

OpenAI, Anthropic, Google, Ollama, and similar providers may be supported through
optional adapters. No external model or hosted provider is a prerequisite for core
operation.

## Document status language

Every architecture document uses the following meanings:

- **Established** — a constraint accepted for the platform, including the
  independence and security requirements stated above.
- **Proposed** — a design direction requiring implementation and, where material,
  an architecture decision record (ADR).
- **Unresolved** — a decision intentionally left open. It must not be inferred
  from examples or placeholder repositories.
- **Observed** — repository or implementation evidence inspected on 2026-07-25.
  Observation is not a claim of production readiness.

## Architecture

- [System overview](docs/architecture/system-overview.md)
- [Native Brain System architecture](docs/architecture/native-brain-system.md)
- [Independent AI principles](docs/architecture/independent-ai-principles.md)
- [Repository map](docs/architecture/repository-map.md)
- [Repository approval matrix](docs/architecture/repository-approval-matrix.md)
- [Dependency graph](docs/architecture/dependency-graph.md)
- [Architecture change gate](docs/governance/architecture-change-gate.md)

The Native Brain System document is a **Proposed P5 architecture** until
ADR-0011 receives the required independent architecture and security acceptance
review.

## Architecture decisions

The [ADR index](docs/decisions/README.md) records accepted decisions for
independent AI operation, repository ownership, dependency direction, model and
agent ownership, security, enterprise, infrastructure, and artifact/event
contracts, together with proposed decisions under review. An accepted ADR defines
an authoritative direction; it does not claim that the affected implementation is
complete.

## P5 review evidence

- [P5 Native Brain independent review checklist](docs/reviews/p5-native-brain-independent-review-checklist.md)

The checklist defines objective architecture, security, conformance, native-
independence, reviewer-independence, commit-binding, and acceptance requirements
for ADR-0011. Automated validation does not substitute for that independent final
review.

## Engineering standards

- [Repository standard](docs/standards/repository-standard.md)
- [Python standard](docs/standards/python-standard.md)
- [Testing standard](docs/standards/testing-standard.md)
- [Versioning standard](docs/standards/versioning-standard.md)
- [Logging standard](docs/standards/logging-standard.md)
- [Error-handling standard](docs/standards/error-handling-standard.md)

## Security

- [Authorization model](docs/security/authorization-model.md)
- [Scope enforcement](docs/security/scope-enforcement.md)
- [Native Brain threat model](docs/security/native-brain-threat-model.md)
- [Secure development](docs/security/secure-development.md)

Cybersecurity functionality is limited to authorized, scoped, policy-controlled
use. This repository does not document weaponized payloads, malware, credential
theft, persistence, evasion, destructive actions, or unauthorized access.

## Stable conceptual contracts

- [Model contract](docs/specifications/model-contract.md)
- [Tokenizer contract](docs/specifications/tokenizer-contract.md)
- [Checkpoint format](docs/specifications/checkpoint-format.md)
- [Agent contract](docs/specifications/agent-contract.md)
- [Tool contract](docs/specifications/tool-contract.md)
- [Event contract](docs/specifications/event-contract.md)
- [Native Brain conformance profile](docs/specifications/native-brain-conformance-profile.md)

These specifications establish conceptual boundaries and compatibility rules.
They do not assert that a wire format, implementation, or artifact is currently
production-ready. The Native Brain conformance profile is **Proposed** while
ADR-0011 is under review.

## Repository evidence

The repository map covers every `cybersecgpt*` directory observed under
`D:\SOFTWARE\Project_Gpt` and separately marks requested repository names that do
not exist. Most existing repositories are empty placeholders. The map therefore
distinguishes intended ownership from observed implementation.

## Contributing and security

See [CONTRIBUTING.md](CONTRIBUTING.md) for documentation workflow and
[SECURITY.md](SECURITY.md) for confidential vulnerability reporting guidance.

## Licensing

**Unresolved:** no organization-wide CyberSecGPT license was confirmed during the
repository inventory. Two bootstrap repositories contain component-level MIT
metadata, but that evidence does not establish a license for this repository or
the broader platform. No license is selected by these documents.
