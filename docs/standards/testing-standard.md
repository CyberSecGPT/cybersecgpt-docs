# Testing Standard

## Status

- **Established:** tests must be deterministic where practical, isolated,
  authorization-safe, and independent of user credentials and production targets.
- **Proposed:** coverage thresholds and release gates remain repository-specific
  until implementations exist.

## Test classes

| Class | Purpose | Default execution |
| --- | --- | --- |
| Unit | one behavior with dependencies isolated | every change |
| Contract | producer/consumer conformance to a public contract | every contract or consumer change |
| Integration | multiple real components with local disposable resources | every change when practical |
| System | end-to-end product workflow | protected branch and release |
| Security | abuse cases, authorization denial, scope and isolation | every security-relevant change |
| Compatibility | supported versions and artifact migrations | protected branch and release |
| Performance | resource and latency regression | scheduled and release |
| Reproducibility | repeatability of artifact or result | artifact promotion |

Benchmarks are not substitutes for correctness or evaluation.

## Test design

Each test should state one observable contract and arrange only the state it owns.
Tests must:

- use temporary or disposable storage;
- avoid order dependence;
- control time, randomness, locale, and environment where relevant;
- bound threads, processes, network calls, and waits;
- clean invocation-owned resources;
- assert both successful and denied behavior;
- avoid sleeps when a condition or fake clock is available; and
- produce enough failure context without exposing secrets.

Flaky tests are defects. Quarantine, if unavoidable, requires an owner, issue,
expiry date, and unaffected gate; silent retries are not a fix.

## Contract testing

Every public contract has:

- valid minimal and representative fixtures;
- invalid and unknown-field cases;
- supported-version matrix;
- canonicalization rules;
- typed error expectations;
- compatibility vectors;
- privacy and classification examples; and
- producer and consumer conformance tests.

Model, tokenizer, checkpoint, agent, tool, and event contracts use fixtures owned
by their authoritative repository. Consumers must not copy and diverge schemas.

## AI and artifact testing

Tokenizer tests cover normalization, special tokens, round trips, fingerprints,
invalid bytes, and deterministic vectors.

Model and checkpoint tests cover:

- descriptor validation;
- tensor names, shapes, dtypes, and shard hashes;
- tokenizer and architecture compatibility;
- resource preflight and bounded failure;
- known reference inputs;
- migration and rollback; and
- rejection of executable or unexpected content.

Training tests use tiny synthetic or approved fixture datasets. They validate
resumption, provenance, configuration capture, checkpoint atomicity, and expected
non-determinism declarations.

Inference tests cover batching, streaming order, cancellation, deadlines, resource
limits, deterministic modes, and provider-disconnected operation.

## Agent and tool testing

Agent tests use deterministic fake models and tools. They cover:

- step, token, time, cost, and concurrency budgets;
- cancellation and terminal states;
- malformed model output;
- tool denial and partial failure;
- memory access controls;
- event causation and correlation;
- repeated delivery and idempotency; and
- inability to widen authorization.

Tool tests execute in a sandbox or fake backend. Tests prove schema validation,
least privilege, deadline enforcement, rate limiting, evidence generation,
cleanup, and stable error mapping.

## Security validation testing

No automated test may target a public or production system unless a separate
explicit authorization record permits that exact test. Default CI uses local fakes,
containers, or isolated ranges.

Security suites must cover:

- absent, expired, revoked, and mismatched authorization;
- target canonicalization and scope boundaries;
- operator and service identity;
- policy deny and obligation handling;
- rate, concurrency, and timeout limits;
- evidence integrity and redaction;
- reproducibility metadata;
- cancellation, cleanup, and rollback; and
- attempts to inject scope through prompts, memory, tool output, or redirects.

Examples remain non-weaponized and non-destructive.

## Coverage and mutation

Line coverage is diagnostic, not proof. Each repository proposes thresholds based
on risk and records exclusions. Authorization, policy, scope, parser, migration,
and integrity logic requires branch and negative-path coverage.

Mutation testing is recommended for high-risk pure logic such as scope predicates,
policy decisions, manifest validators, and compatibility checks.

## CI gates

Proposed minimum gates:

1. format check;
2. lint;
3. type check;
4. unit and contract tests;
5. integration tests supported by local disposable resources;
6. package/build validation;
7. dependency and secret scanning;
8. artifact provenance generation; and
9. no-provider independence profile for core releases.

Tests that require accelerators or extended time are labeled and run in controlled
jobs. A smaller CPU conformance suite remains mandatory.

## Test evidence

Release and promotion evidence identifies source revision, dependency lock,
contract versions, environment, test selection, timestamps, tool versions, result
hashes, known skips, and approver where required.

## Unresolved decisions

- Organization-wide coverage and mutation thresholds.
- Supported accelerator test matrix.
- Long-running evaluation cadence.
- Canonical fixture registry and retention.
- Required artifact-signing and CI attestation systems.
