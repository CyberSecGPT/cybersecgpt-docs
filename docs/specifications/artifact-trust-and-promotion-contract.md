# Artifact Trust and Promotion Contract

## Status

**Proposed — governed by
[ADR-0012](../decisions/ADR-0012-artifact-signing-and-promotion-trust.md).**

This is a conceptual cross-repository contract. It does not claim an executable
schema, trust root, key ceremony, registry, signer, promotion service, or consumer
implementation exists. Until ADR-0012 is accepted, signing and promotion
technology remains unresolved.

## Purpose

This contract defines how an inert CyberSecGPT artifact moves from a constructed
candidate to a consumer-admissible promoted release without allowing construction,
evaluation, signatures, registry state, or mutable labels to create authorization.

The contract applies to tokenizer, dataset, checkpoint, model, policy, and other
portable artifacts when their domain policy adopts an artifact trust profile.
Domain manifests remain owned by the domain repository. This contract defines the
cross-repository trust, evidence, promotion, revocation, and admission semantics.

## Invariants

- Artifact identity is an immutable digest over exact bytes, not a name, version,
  tag, branch, path, URL, registry channel, or signature.
- Artifact content, manifests, signatures, attestations, evidence, policy records,
  registry responses, and promotion records are untrusted until independently
  validated.
- A signature proves possession of an admitted key over specific bytes; it does
  not prove quality, safety, compatibility, licence permission, authorization, or
  promotion eligibility.
- Construction, evaluation, governance approval, signing/promotion, and consumer
  admission are separate decisions, role keys, and evidence.
- No failure or indeterminate result can advance artifact or channel state.
- Trust metadata is parsed only with bounded, non-executing parsers. Trust and
  domain verification precede domain-payload parsing, allocation, installation,
  or execution.
- Core verification supports local/offline operation and does not require a
  proprietary provider or hosted AI service.
- Revocation, expiry, rollback, cancellation, and evidence preservation are
  first-class states, not exceptional shortcuts.

## Profile identifier

The initial profile identifier is:

```text
csgpt-artifact-trust-v1
```

An implementation advertises this exact identifier only when it conforms to the
accepted ADR-0012 standards, role separation, verification order, failure
semantics, and conformance cases. A compatible extension uses an explicitly
versioned profile identifier. An incompatible change requires a new major profile
and migration decision.

## Conceptual records

### `ArtifactTrustProfile`

| Field | Meaning |
| --- | --- |
| `profile_id` | exact trust-profile identifier |
| `contract_version` | this conceptual contract version |
| `oms_predicate` | accepted OMS predicate URI and pinned schema revision |
| `dsse_profile` | payload type and PAE version |
| `bundle_media_type` | accepted detached-bundle media type |
| `signature_method` | accepted signing method |
| `signature_algorithm` | accepted algorithm identifier |
| `digest_algorithm` | accepted content-digest algorithm |
| `tuf_specification` | accepted TUF specification version |
| `root_threshold` | trusted root key count and signature threshold |
| `role_policy` | role names, algorithms, thresholds, path scopes, and expiry ceilings |
| `evidence_signature_policy` | admitted DSSE/in-toto predicate and role-key requirements |
| `trusted_time_policy` | approved time source and protected monotonic-floor behavior |
| `required_evidence` | required evidence kinds and schema versions |
| `verification_limits` | byte, file, nesting, time, and memory ceilings |
| `consumer_policy` | required verification and admission behavior |

Unknown profile, algorithm, media type, predicate, role, threshold, or required
field is rejected before artifact admission.

### `UnsignedCandidateIdentity`

The candidate identity is fixed at construction: it binds the artifact kind,
contract and format versions, exact payload and manifest digests and lengths,
source revision, and applicable pre-construction policy revision. The manifest
MUST NOT contain the digest of itself or of any downstream decision. Evaluation
and exact-candidate governance approval reference this identity without modifying
it. Pre-construction rights approval does not authorize distribution.

### `ArtifactReleaseIdentity`

This record is created only after signing. It extends, and MUST explicitly
reference, the unchanged unsigned candidate identity. Build, evaluation and
governance statements MUST NOT bind the digest of the detached signature or a
later publication or promotion record. Publication and promotion records refer to
the completed release identity, never the reverse.

| Field | Meaning |
| --- | --- |
| `artifact_kind` | domain artifact kind |
| `domain_contract_version` | domain contract implemented by the artifact |
| `payload_digest` | SHA-256 of exact payload bytes |
| `payload_size` | exact payload byte count |
| `domain_manifest_digest` | SHA-256 of the exact domain manifest bytes |
| `domain_manifest_size` | exact manifest byte count |
| `release_set_root_digest` | OMS subject root digest for the admitted file set |
| `oms_bundle_digest` | SHA-256 of the detached OMS bundle bytes |
| `source_revision` | immutable producing source revision |
| `build_provenance_digest` | immutable SLSA provenance identity |
| `sbom_digest` | immutable SPDX document identity |
| `evaluation_digest` | independent evaluation identity |
| `governance_decision_digest` | licence/risk/approval decision identity |
| `compatibility_digest` | domain compatibility/conformance result identity |
| `trust_profile_id` | exact admitted trust profile |

All required identity fields are bound together. A different byte, size, source,
manifest, evidence record, policy decision, profile, or digest identifies a
different release proposal.

### `PromotionRecord`

| Field | Meaning |
| --- | --- |
| `promotion_id` | immutable transition identifier |
| `artifact_identity` | exact unsigned candidate reference for pre-signing transitions; on signing and thereafter, also bind the signed release identity |
| `from_state` | prior artifact state |
| `to_state` | requested artifact state |
| `channel` | optional channel affected by the transition |
| `previous_channel_digest` | prior immutable channel target, if any |
| `new_channel_digest` | new immutable channel target, if any |
| `policy_revision` | exact governance policy used |
| `approval_refs` | immutable required approval records |
| `evidence_refs` | immutable required evaluation/build/licence evidence |
| `actor_identity` | authenticated release workload and accountable operator |
| `created_at` | authoritative transition time |
| `expires_at` | transition or approval expiry, when applicable |
| `idempotency_key` | unique retry-safe operation identity |
| `result` | succeeded, rejected, failed, cancelled, expired, or indeterminate |
| `reason_codes` | structured, non-secret result reasons |
| `previous_record_digest` | append-only chain reference |

`result=succeeded` is valid only when the transition, evidence, approvals,
identity, policy, signature, registry objects, and current state all match. Other
results do not mutate artifact or channel state.

### `RevocationRecord`

| Field | Meaning |
| --- | --- |
| `revocation_id` | immutable revocation identity |
| `subject_kind` | root key, role key, artifact, evidence, policy, promotion, or channel |
| `subject_digest_or_key_id` | exact revoked subject |
| `scope` | affected artifacts, roles, channels, or time range |
| `effective_at` | authoritative effective time |
| `reason_code` | structured public-safe reason |
| `policy_revision` | authorizing revocation policy |
| `approval_refs` | required security/governance approvals |
| `replacement_ref` | optional replacement or recovery reference |
| `evidence_ref` | protected incident evidence reference |

Revocation records do not contain secrets, private incident data, or key
material. They are authenticated through the accepted TUF metadata chain.

### `ArtifactVerificationResult`

| Field | Meaning |
| --- | --- |
| `verification_id` | immutable result identifier |
| `artifact_identity` | exact subject evaluated |
| `profile_id` | applied trust profile |
| `trusted_root_version` | final accepted TUF root version |
| `metadata_versions` | timestamp, snapshot, targets, and delegated versions |
| `verified_at` | verification time |
| `fresh_until` | earliest applicable signed metadata expiry |
| `monotonic_floor` | protected last accepted metadata versions and verification time |
| `checks` | structured per-stage results |
| `outcome` | supported, unsupported, revoked, expired, contradictory, insufficient_evidence, cancelled, resource_limit, or verification_error |
| `limitations` | bounded, non-secret limitations |

Only `supported` is admissible, and only for the exact artifact, profile, policy,
root, metadata set, time, and consumer requirements recorded. A verification
result is evidence, not authorization to perform unrelated actions.

## Artifact lifecycle

The only successful state transitions are:

| From | To | Minimum evidence and authority |
| --- | --- | --- |
| none | `unsigned_candidate` | domain owner constructs exact inert bytes and manifest after pre-construction rights and policy approval |
| `unsigned_candidate` | `evaluation_eligible` | domain validation, deterministic identity, provenance, SBOM, and evidence completeness pass |
| `evaluation_eligible` | `governance_approved` | independent evaluation supports release and governance approves exact licence/risk/distribution identity |
| `governance_approved` | `signed` | protected release signer signs the exact admitted file set under the accepted profile |
| `signed` | `published` | immutable registry write succeeds and read-back hashes every object and metadata binding |
| `published` | `promoted` | authorized TUF channel metadata and append-only promotion record commit atomically or recover safely |
| `promoted` | `deprecated` | governance-approved supersession without integrity compromise |
| any non-revoked state | `revoked` | current signed revocation decision applies to the exact subject |

No transition skips a state. A denied, failed, cancelled, expired, contradictory,
insufficient, resource-limited, or unverifiable attempt records an attempt result
and preserves the prior state.

`revoked` is terminal for the exact identity. Rebuilding identical logical
behavior with changed evidence or signatures creates a distinct release identity;
it does not un-revoke the old one.

## Channel lifecycle and rollback

A channel record maps a human-readable channel to exactly one immutable promoted
artifact digest and the signed metadata/evidence versions used for the mapping.
Channel updates are compare-and-swap transitions against the previously observed
record digest and use an idempotency key.

Rollback is a new signed channel transition to a previously promoted,
non-revoked, policy-compatible artifact that passes current verification. It MUST
NOT:

- delete or rewrite the failed transition;
- restore a revoked or currently incompatible artifact;
- reuse expired approval;
- bypass current licence or security policy;
- weaken classification, offline, provider, target-scope, budget, or verification
  requirements; or
- erase evidence needed for incident review.

A partial publication that cannot be completed leaves no promoted channel mapping.
Unreferenced immutable objects are quarantined or garbage-collected only under a
separate retention policy after evidence preservation.

## Signing scope

The `csgpt-artifact-trust-v1` release root is an explicit allowlist of regular,
inert files. For Tokenizer v1 it includes, at minimum:

```text
tokenizer payload
tokenizer domain manifest
SPDX 3.0 JSON SBOM
SLSA Provenance v1 attestation bundle
```

The domain manifest binds existing source, dataset, training, and conformance
identities by digest rather than embedding sensitive or mutable source material.
The release identity binds downstream independent evaluation and exact-candidate
governance records separately, without rewriting the candidate manifest. The
detached OMS bundle is stored beside the release set and is bound by TUF targets
metadata.

No archive, executable object graph, plugin, callback, script, symlink, device,
named pipe, external reference, installer, dynamic import, or automatic dependency
installation is admitted by this contract.

## Trust-root and key rules

- Consumers begin with a pinned TUF root obtained through an authenticated
  out-of-band path.
- Root metadata requires two signatures from three independently generated
  offline Ed25519 root keys.
- Root, top-level targets, delegated targets, snapshot, timestamp, OMS artifact,
  build-attestation, evaluation, governance, promotion, and workload identity keys
  are role-distinct.
- Private keys never appear in artifacts, repositories, fixtures, general CI,
  logs, exceptions, or model context.
- Signing access is short-lived, workload-bound, least-privileged, audited, and
  unavailable to ordinary build jobs.
- Rotation and revocation preserve a sequential threshold-valid root chain.
- Expiry uses a policy-approved trusted clock and a protected monotonic floor;
  clock rollback or unavailable trusted time fails new admission.
- Bundle key hints and embedded verification material cannot add trust.
- Delegated metadata binds each admitted evidence-statement public key,
  algorithm, predicate type, validity, and subject/path scope.
- Unknown, weak, deprecated, mismatched, expired, or revoked keys and algorithms
  fail closed.

## Consumer verification algorithm

A conforming consumer performs these stages in order:

1. **Preflight limits** — bound metadata, object, file, nesting, path, memory,
   hashing, and deadline costs.
2. **Root update** — verify the pinned root and each sequential root update under
   the old and new thresholds.
3. **Repository metadata** — verify timestamp, snapshot, targets, and delegated
   roles, including versions, expiry, lengths, hashes, thresholds, consistent
   snapshot, path scope, rollback, and freeze protection.
4. **Immutable resolution** — resolve channel and release objects to exact SHA-256
   digests and byte counts.
5. **Object integrity** — hash every object before interpreting its content.
6. **Revocation** — reject any applicable revoked key, artifact, evidence,
   approval, policy, promotion, or channel record.
7. **OMS signature** — verify DSSE PAE with the externally trusted Ed25519 public
   key and require the accepted payload type and predicate.
8. **OMS file set** — validate schema, safe paths, regular files, no symlinks, no
   unlisted files, exact SHA-256 digests, and exact OMS subject root.
9. **Evidence graph** — validate role-specific DSSE/in-toto signatures for build
   provenance, evaluation, governance, compatibility, and promotion, then validate
   SBOM, publication, expiry, and identity links.
10. **Domain admission** — validate the domain manifest, behavior identity,
    compatibility, resource bounds, and consumer policy before parse or load.

The verifier stops on the first unsafe boundary but may continue bounded
non-sensitive checks to provide a complete diagnostic when policy allows. It
never attempts a weaker algorithm, alternate root, unsigned path, mutable tag,
remote provider, or prior approval as fallback.

## Offline trust package

An offline trust package contains only public, signed, immutable verification
material:

- pinned root and sequential root updates;
- current unexpired timestamp, snapshot, targets, and delegated metadata;
- revocation and promotion records;
- exact artifact, detached signature, provenance, SBOM, evaluation, governance,
  and compatibility objects; and
- a package manifest with digests and byte counts.

The package contains no private key, credential, identity token, mutable network
location, or hidden remote dependency. Import validates the trust chain before
making any content visible to an artifact consumer.

If signed freshness metadata is expired, trusted current time is unavailable, the
clock is behind the protected monotonic floor, or required revocation information
is missing, offline verification cannot admit a new installation or promotion.

## Failure semantics

The following outcomes are never promoted to `supported`:

- malformed, missing, duplicate, unknown-required, oversized, truncated,
  trailing, non-canonical, or path-escaping content;
- signature, digest, byte-count, root-threshold, role, delegation, version,
  expiry, consistent-view, rollback, freeze, or revocation failure;
- unlisted file, symlink, executable content, external reference, or unsupported
  serialization;
- source, build, SBOM, evaluation, governance, licence, compatibility,
  publication, promotion, or channel mismatch;
- cancelled, deadline, resource-limit, policy-unavailable, contradictory,
  insufficient-evidence, or internal verification error; and
- any attempt to widen authorization, classification, target scope,
  provider/network policy, offline requirement, deadline, budget, or required
  verification.

Errors use stable public-safe codes. Sensitive paths, identities, incident data,
payload content, secrets, and private evidence remain referenced under access
control rather than copied into diagnostics.

## Conformance evidence

An executable implementation must publish deterministic fixtures and tests for:

- accepted OMS/DSSE/in-toto/Sigstore-bundle schema and upstream test vectors;
- valid and invalid Ed25519 signatures and SHA-256 identities;
- TUF root threshold, sequential rotation, role separation, delegation scope,
  trusted-time loss, clock rollback, expiry, rollback, freeze, mix-and-match, key
  compromise, and revocation;
- exact release file enumeration, ordering, path normalization, symlink denial,
  unlisted-file denial, truncation, trailing data, size/count limits, and digest
  sensitivity;
- provenance, SBOM, evaluation, governance, licence, compatibility, promotion,
  role-signature, and channel-binding mismatches;
- every allowed and forbidden lifecycle transition;
- idempotent retry, cancellation, deadline, partial publication, recovery, and
  rollback;
- offline verification with all network access denied;
- absence of private keys, credentials, provider SDKs, artifact execution, and
  automatic dependency installation; and
- independent producer/consumer interoperability.

Conformance requires negative-path and branch coverage appropriate to security-
critical parsing, policy, state-transition, and verification logic. Passing a
signature test alone is insufficient.

## Unresolved implementation choices

This contract does not select:

- an artifact registry vendor or network endpoint;
- a secret-manager, hardware security module, or offline key device;
- named human custodians or operational on-call roles;
- concrete executable schema language or implementation language;
- exact metadata expiry and retention durations within the accepted ceilings;
- registry replication, backup, or disaster-recovery product; or
- consumer user interface.

Those choices require owner-specific proposals and must preserve this contract.
