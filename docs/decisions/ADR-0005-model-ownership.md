# ADR-0005: Model Ownership

## Status

**Accepted** — 2026-07-25

## Context

CyberSecGPT needs an authoritative owner for first-party model architecture,
configuration, parameter identity, capabilities, and compatibility. The existing
`cybersecgpt-foundation` repository was proposed for stable AI contracts, while
the absent `cybersecgpt-model` name was proposed for a possible dedicated model
package. Approving both without a precise split would create competing model
descriptors and force tokenizer, training, and inference to choose between them.

The current repositories contain no production model implementation, so this ADR
selects ownership and dependency direction; it does not claim that an
architecture or checkpoint encoding has been implemented.

## Decision

`cybersecgpt-foundation` is the authoritative owner of first-party model
architecture contracts and definitions.

Its model responsibilities include:

- model descriptors, architecture configuration, and capability declarations;
- canonical parameter names, shapes, roles, and compatibility identifiers;
- provider-neutral forward and generation semantics;
- model contract versions and conformance fixtures;
- shared artifact identity and the logical checkpoint manifest schema; and
- stable errors and compatibility results used by training and inference.

The boundary remains narrow:

- `cybersecgpt-tokenizer` owns tokenizer algorithms, vocabulary artifacts, and
  tokenizer compatibility details.
- `cybersecgpt-training` owns training orchestration, optimization state,
  checkpoint production, and training-run provenance.
- `cybersecgpt-inference` owns checkpoint loading, batching, caches, generation
  scheduling, and serving behavior.
- `cybersecgpt-runtime` owns device abstraction, allocation, kernels or backend
  integration, cancellation, and resource accounting.
- `cybersecgpt-evaluation` owns evaluation suites, measurements, and promotion
  evidence.

Foundation may refer to tokenizer, checkpoint, or runtime capabilities through
opaque identifiers and lower-level value types. It must not import those
repositories or incorporate training, inference, accelerator, or provider SDK
implementation.

`cybersecgpt-model` is **Deferred** and must not be created or used as a package
authority. A future split may be proposed only if model definitions acquire a
distinct release lifecycle or dependency set that cannot remain foundational.
Such an ADR must preserve a one-way `model -> foundation` direction, identify
contract migration, and prevent dual ownership.

## Consequences

### Positive

- Training, inference, evaluation, and tooling share one model vocabulary.
- A duplicate repository is avoided while the architecture remains unimplemented
  and the model package boundary is still small.
- Model semantics remain below execution and product layers and cannot acquire a
  mandatory provider dependency.
- Logical checkpoint compatibility can be validated without importing training
  into inference.

### Costs and constraints

- Foundation maintainers must keep model definitions free of heavyweight runtime
  and framework dependencies.
- Architecture-specific code must be modular enough to split later without
  changing canonical identifiers.
- Model architecture selection, tensor encoding, hardware support, and licensing
  remain separate unresolved decisions.
- Foundation versioning requires careful compatibility review because multiple
  model-lifecycle repositories consume it.

## Alternatives Considered

### Approve `cybersecgpt-model` immediately

Rejected because the absent repository would initially duplicate the exact
contract boundary already assigned to foundation without demonstrated release or
dependency isolation.

### Let training own model definitions

Rejected because inference and evaluation would then depend on training
implementation, violating the layer direction.

### Let inference own model definitions

Rejected because training would depend on a serving implementation and model
semantics would become coupled to a specific execution strategy.

### Co-own descriptors across training and inference

Rejected because copied or co-owned schemas would drift and make checkpoint
compatibility authority ambiguous.
