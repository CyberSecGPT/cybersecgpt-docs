# Model Contract

## Status

This is a **stable conceptual contract proposal**. It defines ownership,
invariants, and compatibility semantics for first-party models. No concrete schema,
ABI, model architecture, or implementation is claimed production-ready.

The authoritative implementation owner is **Unresolved** between the existing
`cybersecgpt-foundation` repository and the absent proposed
`cybersecgpt-model` repository. See the
[repository map](../architecture/repository-map.md).

## Goals

The contract separates model semantics from training, checkpoint storage,
inference scheduling, hardware runtime, applications, and optional external
providers. It supports:

- independently defined CyberSecGPT model architectures;
- validated loading from portable checkpoint manifests;
- tokenizer and runtime compatibility;
- bounded generation and streaming;
- deterministic or reproducible modes where supported;
- capability negotiation; and
- implementation replacement without changing product contracts.

## Non-goals

- Selecting a transformer or other architecture.
- Defining a tensor binary encoding.
- Standardizing optimizer or training-loop internals.
- Exposing hidden reasoning traces.
- Mirroring one external provider's API as the core model abstraction.

## Core types

### `ModelDescriptor`

Required conceptual fields:

| Field | Meaning |
| --- | --- |
| `model_id` | immutable artifact identity or digest-bound identifier |
| `model_revision` | immutable trained revision |
| `contract_version` | model contract version |
| `architecture_id` | versioned architecture definition |
| `architecture_config` | validated architecture parameters |
| `parameter_schema_id` | parameter naming and shape convention |
| `tokenizer_fingerprint` | required tokenizer artifact |
| `numeric_formats` | supported weights and computation formats |
| `capabilities` | declared supported operations |
| `context_limits` | input, output, and combined limits |
| `runtime_requirements` | supported devices and minimum resources |
| `checkpoint_manifest_digest` | exact checkpoint manifest |
| `provenance` | producer, source revision, training run, and approval references |
| `license_metadata` | explicit artifact license status; may be unresolved |

Identity-bearing fields are immutable for one model revision.

### `ModelCapabilities`

Capabilities are explicit and extensible. Initial conceptual capabilities may
include:

- causal text generation;
- embeddings;
- structured-output constraints;
- tool-call proposal;
- streaming;
- deterministic seeded generation;
- adapter attachment; and
- attention/cache modes.

Unknown capabilities are not assumed. A runtime must reject a request requiring an
unsupported capability before execution.

### `ModelInput`

`ModelInput` carries:

- request and correlation identifiers;
- token IDs or another architecture-defined validated input;
- attention/position metadata;
- optional typed multimodal inputs only when declared;
- generation or forward-operation parameters;
- resource, token, and time budgets;
- deterministic seed when supported;
- cancellation/deadline context; and
- data classification for handling and logging.

Raw prompts are converted by the tokenizer boundary; a model does not silently
select a tokenizer.

### `ModelOutput`

`ModelOutput` carries:

- model and tokenizer identities;
- output token IDs, embeddings, or typed architecture result;
- finish reason;
- usage and resource measurements;
- deterministic/reproducibility metadata;
- safety or policy-stop reference when applicable;
- warnings and limitations; and
- optional evidence/event references.

Standard finish reasons conceptually distinguish `stop`, `length_limit`,
`resource_limit`, `cancelled`, `deadline`, `policy_stop`, and `error`.

## Execution interface

A conforming model implementation conceptually supports:

1. `describe()` — return immutable descriptor and capabilities.
2. `validate_input(input)` — validate without side effects or expensive allocation.
3. `estimate_resources(input)` — produce a bounded resource estimate.
4. `open_session(context)` — acquire a runtime execution session.
5. `execute(input)` or `stream(input)` — produce typed results within budgets.
6. `cancel(request_id)` — propagate cancellation to a safe boundary.
7. `close()` — release owned resources idempotently.

Language-specific method names may differ. Semantics and tests remain equivalent.

## Invariants

- Token IDs are valid for the declared tokenizer fingerprint.
- Input length and generated length stay within descriptor and request limits.
- The loaded parameter schema matches architecture, names, shapes, and dtypes.
- All tensor/resource allocation is preceded by manifest and size validation.
- A model never grants authorization or executes a side effecting tool.
- Generation parameters are captured in reproducibility metadata.
- Streaming chunks are ordered, correlated, bounded, and terminate exactly once.
- Cancellation and timeout produce an explicit terminal reason.
- Provider-specific metadata remains inside an optional adapter extension.

## Training boundary

Training produces candidate model/checkpoint artifacts conforming to this contract.
The model contract does not depend on training implementation. A training run
records the architecture descriptor, tokenizer fingerprint, dataset manifests,
configuration, source revision, dependency environment, and produced checkpoint
digest.

Promotion requires evaluation evidence; successful training is not approval.

## Inference and runtime boundary

Inference owns batching, routing, streaming transport, admission, and service-level
behavior. Runtime owns devices, allocation, scheduling primitives, and hardware
backends. The model implementation owns mathematical forward semantics and
parameter interpretation.

Neither inference nor runtime may reinterpret a model descriptor silently.

## Optional provider adapters

An adapter translates provider-neutral model requests into an external API and
back. It:

- advertises only capabilities it can faithfully provide;
- preserves request budgets and cancellation as far as the provider permits;
- identifies provider/model and limitations;
- minimizes transmitted data;
- isolates credentials;
- maps errors to the standard taxonomy; and
- remains optional.

External provider identifiers are not first-party model revisions.

## Compatibility

A loader accepts a model only when it supports:

- contract major version;
- architecture and parameter schema;
- tokenizer fingerprint;
- checkpoint format;
- numeric format and runtime device;
- required capabilities; and
- resource constraints.

Unsupported major versions and mismatched identity fail before allocation or
execution. Compatible minor additions are ignored only when explicitly optional.

## Security

Descriptors and manifests are untrusted until schema, size, hash, signature when
required, and provenance validation completes. Model loading must not execute
artifact-supplied code. Inputs and outputs follow data-classification policy and
the [logging standard](../standards/logging-standard.md).

## Conformance tests

- descriptor and capability fixtures;
- minimal reference forward/generation vectors;
- tokenizer mismatch;
- unsupported contract/architecture/numeric format;
- tensor name, shape, dtype, and size mismatch;
- input and output limits;
- deterministic seed behavior where supported;
- streaming order and terminal state;
- cancellation, deadline, and resource exhaustion;
- no-provider core operation; and
- redaction and typed error mapping.

## Unresolved decisions

- Model architecture owner and first architecture.
- Concrete descriptor schema and canonical encoding.
- Parameter naming conventions.
- Determinism guarantees across devices.
- Supported numeric formats and hardware.
- Model, weight, and output licenses.
- Whether multimodal inputs are in the initial contract.
