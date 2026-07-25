# ADR-0006: Agent Runtime Ownership

## Status

**Accepted** — 2026-07-25

## Context

Agent execution combines planning, state transitions, delegation, model calls,
memory access, tool proposals, budgets, cancellation, and evidence. The existing
`cybersecgpt-reasoning` repository and absent `cybersecgpt-agents` proposal
overlap across those responsibilities. The name "runtime" also risks confusion
with `cybersecgpt-runtime`, whose intended role is generic device and workload
execution rather than agent semantics.

Splitting agent and reasoning loops before either is implemented would require a
cyclic protocol or duplicate plan and state models. At the same time, agent
orchestration must not absorb authorization, tool implementation, memory storage,
or inference kernels.

## Decision

`cybersecgpt-reasoning` is the authoritative owner of reasoning and the agent
runtime.

The agent-runtime boundary includes:

- agent descriptors and lifecycle state machines;
- bounded planning, replanning, and terminal-state semantics;
- delegation, depth, fan-out, and resource budgets;
- orchestration of model, memory, and tool public contracts;
- cancellation, deadline, retry, checkpoint/resume, and recovery semantics; and
- reasoning and agent-domain event payloads.

Adjacent ownership remains separate:

- `cybersecgpt-inference` executes model requests.
- `cybersecgpt-memory` stores and retrieves governed memory.
- `cybersecgpt-tools` registers tools and performs policy-gated side effects.
- `cybersecgpt-security` evaluates cybersecurity policy, target scope, and
  authorized techniques.
- `cybersecgpt-runtime` supplies generic resource, device, isolation, and
  cancellation primitives without knowing agent goals or plans.
- Product surfaces submit requests and render results but do not implement agent
  state machines.

Agents receive immutable authorization context and may narrow it for delegated
work. They cannot issue grants, widen scope, mint credentials, bypass policy, or
suppress audit events. A model proposes; deterministic policy and a tool gateway
control side effects.

`cybersecgpt-agents` is **Deferred**. A later split requires evidence of an
independent public contract and release lifecycle, a one-way dependency that does
not create reasoning/agent cycles, and a staged migration of the
[agent contract](../specifications/agent-contract.md).

## Consequences

### Positive

- One owner controls plans, lifecycle transitions, delegation, and agent events.
- Reasoning and execution budgets can be tested as a coherent state machine.
- Tool, memory, inference, runtime, and security boundaries remain independently
  replaceable.
- The absent agents repository is not created solely to mirror terminology.

### Costs and constraints

- `cybersecgpt-reasoning` must maintain clear internal separation between
  planning strategies and deterministic lifecycle control.
- The repository may eventually need multiple independently deployable workers
  while retaining one source owner.
- Persistent agent-state technology, default budgets, and human-supervision UX
  remain unresolved implementation decisions.
- Contract changes affect several consumers and require conformance fixtures.

## Alternatives Considered

### Approve `cybersecgpt-agents` as a peer

Rejected because bidirectional plan and state dependencies would be likely before
a stable separation exists.

### Make `cybersecgpt-runtime` the agent owner

Rejected because the runtime is a lower-level execution substrate and must not
depend on inference, reasoning, memory, tools, or applications.

### Put agent loops in each product surface

Rejected because behavior, budgets, cancellation, and policy integration would
diverge across CLI, API, web, desktop, and platform.

### Let the model control agent state directly

Rejected because model output is untrusted proposal data, not an authorization or
deterministic lifecycle decision.
