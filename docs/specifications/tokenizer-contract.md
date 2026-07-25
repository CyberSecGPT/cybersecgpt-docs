# Tokenizer Contract

## Status

This is a **stable conceptual contract proposal** for independently owned
CyberSecGPT tokenizers. `cybersecgpt-tokenizer` exists but is empty; no tokenizer
algorithm, vocabulary, artifact encoding, or production implementation is claimed.

## Goals

- Deterministic text-to-token and token-to-text semantics.
- Portable, self-describing tokenizer artifacts.
- Exact model/tokenizer compatibility through fingerprints.
- First-party tokenizer training and validation.
- Streaming-safe operation and bounded resources.
- No dependency on an external AI provider's tokenizer.

## Non-goals

- Selecting BPE, unigram, WordPiece, byte-level, or another algorithm.
- Requiring human-readable tokens.
- Guaranteeing decode of arbitrary token sequences to the original text unless the
  selected tokenizer declares that property.
- Defining provider billing token counts.

## `TokenizerDescriptor`

| Field | Meaning |
| --- | --- |
| `tokenizer_id` | immutable artifact identifier |
| `contract_version` | tokenizer contract version |
| `algorithm_id` | versioned algorithm and configuration |
| `artifact_format_version` | serialized artifact layout |
| `normalization_profile` | exact ordered normalization rules |
| `pretokenization_profile` | exact ordered segmentation rules |
| `vocabulary_size` | number of addressable token IDs |
| `token_id_range` | valid integer range and reserved regions |
| `special_tokens` | named roles and exact IDs |
| `byte_fallback` | declared support and semantics |
| `input_encoding` | accepted text/byte encoding behavior |
| `fingerprint` | digest over canonical behavior-defining artifacts |
| `provenance` | trainer, data-manifest references, configuration, source revision |
| `license_metadata` | tokenizer and training-data license status |

Changing any behavior-defining field produces a new fingerprint.

## Operations

### `encode`

Input:

- text or declared byte sequence;
- special-token handling mode;
- normalization enabled according to descriptor;
- maximum output tokens;
- truncation policy, if explicitly requested;
- offset-mapping request; and
- deadline/cancellation.

Output:

- ordered token IDs;
- optional token spans in original and normalized input;
- normalization/truncation metadata;
- tokenizer fingerprint;
- warnings; and
- finish status.

Encoding never silently truncates unless a truncation policy was supplied. Invalid
input behavior is explicit.

### `decode`

Input:

- token IDs;
- special-token handling mode;
- error policy for invalid IDs;
- maximum output size; and
- deadline/cancellation.

Output:

- text or declared byte output;
- invalid/replacement metadata;
- tokenizer fingerprint; and
- finish status.

Every token ID is range-checked before lookup.

### Streaming

Streaming encode/decode maintains explicit state and yields the same semantic result
as non-streaming execution for supported boundary splits. Chunks are bounded and
ordered. The descriptor declares any look-behind or finalization behavior.

### Training

Tokenizer training input includes versioned dataset manifests, selection and
sampling policy, normalization/algorithm configuration, special-token allocation,
random seed where meaningful, resource limits, and provenance.

Training output is a candidate artifact plus descriptor, validation report, and
content hashes. Training success is not artifact approval.

## Special-token requirements

Special tokens have stable named roles, exact IDs, and insertion rules. Roles may
include beginning/end, padding, unknown, mask, separator, tool/control delimiters,
or modality markers.

- IDs do not overlap ordinary token allocations.
- Control tokens are not inferred from untrusted text unless explicitly escaped
  and parsed by a higher contract.
- Unknown roles are not treated as known control instructions.
- Models declare the required role-to-ID mapping through tokenizer fingerprint.

## Fingerprint

The fingerprint covers canonical:

- vocabulary and token-to-ID mapping;
- merge/model data;
- normalization and pretokenization configuration;
- special-token mapping and behavior;
- byte/unknown fallback behavior;
- algorithm and artifact versions; and
- behavior-affecting flags.

Path, filename, mutable label, or repository revision alone is not a fingerprint.

## Compatibility

A model and tokenizer are compatible only when the model descriptor names the exact
tokenizer fingerprint or an approved compatibility relation with conformance
evidence. Matching vocabulary size is insufficient.

Artifact format migrations preserve the fingerprint only if observable tokenization
behavior is identical and verified by canonical vectors. Otherwise they create a
new tokenizer identity.

## Security and limits

- Validate artifact schema, hashes, sizes, counts, and integer bounds before
  allocation.
- Reject path traversal and external references not allowed by manifest policy.
- Bound input bytes, output tokens, offsets, decode output, memory, and time.
- Treat special/control token rendering as untrusted output.
- Do not load executable code from tokenizer artifacts.
- Do not log raw input or decoded output by default.
- Preserve dataset provenance and licensing status.

## Conformance vectors

The owning repository publishes vectors for:

- empty, ASCII, Unicode, normalization, and combining characters;
- invalid byte policy;
- whitespace and boundary behavior;
- every special token and escape rule;
- unknown and fallback behavior;
- encode/decode round trips where promised;
- streaming splits at every relevant boundary;
- output and resource limits;
- deterministic training fixture where feasible; and
- fingerprint changes and artifact migrations.

## Errors

Stable conceptual errors include unsupported version, invalid artifact, integrity
failure, invalid input encoding, invalid token ID, output limit, deadline,
cancelled, incompatible model, and internal invariant failure. They follow the
[error-handling standard](../standards/error-handling-standard.md).

## Unresolved decisions

- Tokenization algorithm and training corpus.
- Artifact encoding and canonical fingerprint algorithm.
- Initial special-token roles and IDs.
- Unicode normalization and invalid-byte policy.
- Offset semantics.
- Licensing for tokenizer code, artifacts, and training data.
