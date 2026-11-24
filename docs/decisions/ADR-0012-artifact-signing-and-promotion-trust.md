# ADR-0012: Artifact Signing and Promotion Trust Architecture

## Status

**Proposed — Roadmap P6.12**

This decision is not binding and MUST NOT authorize signing, publication, or
promotion until the exact pull-request head receives explicit project-owner
architecture/security/release acceptance and the accepted head is squash-merged
with required checks unchanged.

## Context

ADR-0010 requires portable artifacts to carry immutable identity, provenance,
compatibility, licensing, and integrity metadata, but deliberately left signing
technology and trust-root ownership unresolved. The repository map assigns
artifact construction to domain owners, independent promotion evidence to
`cybersecgpt-evaluation`, policy and approvals to `cybersecgpt-governance`,
release actions to `cybersecgpt-devops`, and protected operational resources to
`cybersecgpt-infrastructure`.

The accepted
[P6.12 tokenizer gate](https://github.com/CyberSecGPT/cybersecgpt-tokenizer/blob/a1edeb0e930142fdafd40cd24407b6ecfc5645b1/docs/P6_12_TOKENIZER_V1_ARTIFACT_PROMOTION_GATE.md)
requires a canonical decision before an unsigned Tokenizer v1 candidate can be
packaged, signed, published, promoted, or consumed. The decision must support
local/offline verification, separate construction from approval and promotion,
permit revocation and rollback, avoid proprietary hosted dependencies, and make
every failure ineligible rather than silently accepting unsigned content.

Signatures alone do not establish quality, safety, licence permission,
compatibility, authorization, or promotion eligibility. Mutable tags, filenames,
branches, registry paths, and channels are also insufficient artifact identity.

## Decision

CyberSecGPT adopts the conceptual
[Artifact Trust and Promotion Contract](../specifications/artifact-trust-and-promotion-contract.md)
and the initial profile `csgpt-artifact-trust-v1`.

### Authority and repository ownership

No repository receives all release authority.

| Responsibility | Authoritative owner |
| --- | --- |
| Domain payload, manifest, compatibility, and conformance fixtures | Domain owner, including `cybersecgpt-tokenizer` for tokenizer artifacts |
| Common artifact identifiers and digest/compatibility primitives | `cybersecgpt-foundation` |
| Independent quality, safety, security, and compatibility evidence | `cybersecgpt-evaluation` |
| Licence, risk, exception, approval, and revocation policy | `cybersecgpt-governance` |
| Build provenance, SBOM generation, signing integration, publication, promotion, and rollback execution | `cybersecgpt-devops` |
| Key-custody, registry, secret, identity, storage, backup, and recovery resources | `cybersecgpt-infrastructure` |
| Runtime admission and loading | The relevant consumer, under current policy and trusted metadata |

Artifact, evaluation, policy, signing, registry, routing, or model output is data,
not authorization. Construction, independent evaluation, governance approval,
release signing/promotion, and consumer admission remain distinct decisions and
evidence even when one operator temporarily holds more than one accountable role.
Workload identities, role keys, and credentials MUST remain separate. Evidence
from one authority cannot be manufactured or countersigned into existence by the
release authority.

### Artifact signature profile

The first profile uses the following public standards:

- [OpenSSF Model Signing (OMS) predicate version 1.0](https://github.com/ossf/model-signing-spec/blob/main/spec/v1.0.md);
- [Dead Simple Signing Envelope (DSSE) v1](https://github.com/secure-systems-lab/dsse)
  pre-authentication encoding;
- [in-toto Statement v1](https://github.com/in-toto/attestation/blob/main/spec/v1/statement.md);
- [Sigstore bundle](https://docs.sigstore.dev/about/bundle/) media type
  `application/vnd.dev.sigstore.bundle.v0.3+json`;
- the OMS `key` signing method;
- Ed25519 as `PKIX_ED25519` under
  [RFC 8032](https://www.rfc-editor.org/rfc/rfc8032.html);
- SHA-256 for file, subject, immutable-object, and policy binding digests; and
- OMS `files` serialization with symbolic links disabled.

The OMS producer implementation MUST pin and record the exact upstream schema,
test-vector, and algorithm-registry revisions it implements. A later compatible
upstream release is not adopted merely because a dependency resolves to it.

Build provenance, independent evaluation, governance approval/revocation, and
promotion records use role-specific DSSE/in-toto statements and domain-owned
predicate schemas. Their Ed25519 keys are distinct from each other and from the
OMS artifact-signing and TUF metadata keys. The artifact release signer verifies
these statements but cannot produce them.

The signed release root contains only explicitly admitted regular files. It MUST
include the domain payload and domain manifest and, when required by policy, the
[SPDX 3.0](https://spdx.dev/use/specifications/) JSON software bill of materials
and [SLSA Provenance v1](https://slsa.dev/spec/v1.2/build-provenance)
attestation bundle. No user-configured ignore path, unlisted file, symbolic link,
executable extension, external reference, or `ignore unsigned files` behavior is
allowed.
The detached OMS signature file is outside its own signing scope as required by
OMS and is itself bound by trusted promotion metadata.

The initial profile does not use public Sigstore keyless signing, a hosted
transparency service, or an external certificate authority. Those may be added
only as optional profiles through a later accepted ADR. Their absence cannot
prevent local or air-gapped verification.

The public-key hint inside an OMS bundle is non-authoritative. A verifier obtains
an allowed public key and algorithm only from the current trusted metadata chain,
then confirms that the hint matches. An artifact cannot introduce its own trust
root.

### Trust-root and update profile

CyberSecGPT uses
[The Update Framework (TUF) Specification v1.0.33](https://theupdateframework.github.io/specification/v1.0.33/)
for trust-root distribution, delegated release metadata, freshness, consistent
views, key rotation, revocation, and rollback/freeze protection.

The initial trusted `root.json` is distributed out of band with a consumer or an
approved offline trust package. The root role uses three independently generated
offline Ed25519 keys and a two-of-three signature threshold. Root keys MUST remain
offline except during a documented ceremony. Root rotation requires a sequential
TUF root chain signed according to both the previous and new root thresholds.

Expiry and freeze checks use a policy-approved trusted clock and a protected
monotonic floor recording the last accepted metadata versions and verification
time. Clock rollback, unavailable trusted time, or metadata older than that floor
cannot admit a new installation, promotion, or trust-root update.

Top-level targets metadata uses a two-of-three offline threshold and delegates
path-constrained `build-provenance`, `evaluation-evidence`,
`governance-decisions`, and `tokenizer-releases` roles to distinct protected
metadata keys. Snapshot and timestamp roles use separate protected keys. The OMS
artifact-signing key and every evidence-statement key are distinct from every TUF
role key and from artifact-construction identities.

Each delegated role's signed metadata binds the exact allowed evidence-statement
public keys, algorithms, predicate types, validity, and subject/path scope. Key
hints or verification material carried inside an evidence statement are
non-authoritative and must match that external role policy.

`cybersecgpt-governance` owns the policy that authorizes trust-root membership,
thresholds, release roles, acceptable algorithms, expiry ceilings, emergency
revocation, and exceptions. `cybersecgpt-infrastructure` owns protected custody,
backup, recovery, and access resources. `cybersecgpt-devops` executes reviewed key
ceremonies and release workflows but cannot change governance policy or use a key
outside its role. Consumers pin the trusted root and perform the TUF client
update workflow; they do not trust keys copied from artifact or registry data.

P6 Tokenizer v1 promotion is blocked until the root ceremony, custodian records,
recovery test, and role-specific public metadata are independently reviewed.

### Provenance, SBOM, and evidence bindings

A signed artifact is eligible only when all required evidence resolves by
immutable digest. The release set MUST bind at least:

- exact domain payload and manifest bytes;
- source revision and reproducible build identity;
- SLSA Provenance v1 subject and builder identity;
- SPDX 3.0 JSON SBOM identity;
- domain conformance and compatibility results;
- independent evaluation report and recommendation;
- governance licence/risk/approval decision;
- signing profile and trusted-key identities;
- publication target and immutable registry object identities; and
- rollback target or an explicit absence of a prior promoted version.

Build provenance is produced by a dedicated build identity and signed separately
from the release signature. Evaluation and governance records are signed by their
own admitted role keys. TUF delegations authenticate the allowed key and path for
each evidence class. The release signer verifies these records and their exact
subject digests but cannot rewrite or replace them. The OMS signature
authenticates the admitted release files; TUF metadata authenticates which exact
immutable artifact, detached signature, and authority-signed evidence are
eligible in a channel.

### Promotion-state model

Artifact state and channel state are separate append-only records. The allowed
artifact states are:

```text
unsigned_candidate
evaluation_eligible
governance_approved
signed
published
promoted
deprecated
revoked
```

Only the contract-defined forward transitions are permitted. Failure,
cancellation, deadline, resource limit, contradiction, insufficient evidence,
licence denial, integrity failure, signature failure, or policy rejection creates
a separate terminal attempt result; it never advances artifact state.

A channel such as `stable` is a signed mapping to one immutable promoted digest.
Promotion changes the mapping by appending a new authorized transition. Rollback
is another signed transition to a previously eligible digest; it does not delete
history, mutate an artifact, make a revoked artifact eligible, or erase evidence.
`latest` and other mutable labels are never identity, provenance, compatibility,
or authorization evidence.

### Verification and admission order

A consumer MUST verify in this order before parsing or loading the domain payload.
Trust metadata is handled only by bounded, non-executing parsers:

1. enforce byte, file-count, recursion, time, and memory limits;
2. load the pinned TUF root and apply only sequential threshold-valid root updates;
3. verify timestamp, snapshot, targets, and delegated metadata signatures,
   versions, expiry, hashes, lengths, consistent view, and rollback/freeze rules;
4. resolve the channel, artifact, OMS signature, evidence, and policy records to
   immutable digests and byte counts;
5. hash every downloaded object before interpreting it;
6. reject revoked keys, artifacts, evidence, policy decisions, or promotion
   records;
7. verify the OMS DSSE signature using the trusted delegated artifact-signing key;
8. validate the in-toto Statement and OMS manifest with no unlisted files,
   symlinks, path escape, alternate algorithm, or permissive unsigned-file mode;
9. verify role-specific provenance, evaluation, governance, compatibility, and
   promotion signatures plus SBOM and identity bindings; and
10. run the domain manifest and consumer compatibility validators before any
    allocation, deserialization, installation, or load.

Successful signature verification does not skip any later policy, licence,
compatibility, classification, or domain-validation step.

### Revocation, expiry, and offline behavior

Key compromise is handled by new threshold-valid TUF root or delegated metadata
that removes the key and publishes the applicable revocation record. Artifact,
evidence, policy, or promotion revocation is published in signed targets metadata
and the append-only promotion record. A mathematically valid historical signature
does not override a current revocation or policy denial.

Offline verification uses an approved trust package containing a pinned root
chain and the required unexpired TUF and evidence metadata. It performs the same
cryptographic and semantic checks without network access. Expired or incomplete
metadata, untrusted current time, or clock rollback cannot admit a new
installation or promotion. Continued use of an
already installed artifact, when current revocation status is unavailable, is a
separate explicit deployment-policy decision and MUST NOT be reported as current
verification.

Revocation stops new admission immediately when learned. Active consumers stop at
the next safe boundary according to component policy, preserve evidence, and
perform only separately authorized rollback or cleanup.

## Compatibility impact

This ADR introduces a new conceptual release profile; it does not change existing
tokenizer payload bytes, tokenizer behavior fingerprints, checkpoint formats, or
runtime APIs. Unsigned historical artifacts remain historical evidence and are
not promoted by this decision.

Implementations MUST publish versioned schemas and conformance fixtures. A change
to the OMS predicate, DSSE payload type, signing method, algorithm, TUF role
structure, threshold, trust-root rules, promotion-state semantics, or verification
order requires compatibility review and, when trust or authorization changes, a
new ADR.

## Security and privacy consequences

The design provides offline authenticity, explicit trust-root ownership,
separation of duties, threshold root recovery, digest-addressed promotion,
rollback/freeze resistance, revocation, and fail-closed consumer admission. It
adds operational cost for key ceremonies, protected custody, short-lived release
credentials, metadata expiry/refresh, recovery tests, and independent evidence.

Signing keys, root shares, recovery material, identity tokens, and registry
credentials MUST NOT enter source, artifacts, fixtures, logs, exceptions, model
context, or general CI output. Signing happens only in a protected release job
after exact immutable evidence and approvals are admitted. A build job cannot
request or access the artifact-signing key.

## Migration and rollback

The first implementation begins with no trusted production root and no promoted
artifact. It must create and review the trust root before publishing a release.
Therefore no existing production artifact migration is required.

The architecture proposal can be rolled back before implementation by reverting
this ADR and contract together. Once consumers pin a root, migration uses TUF
root rotation and versioned contract coexistence; replacing trust metadata out of
band is an emergency recovery action requiring governance and security approval.

## Alternatives considered

### Public Sigstore keyless signing as the only profile

Rejected for the initial profile because mandatory Fulcio, Rekor, identity
provider, and network availability would conflict with local/offline and
air-gapped verification. A private or public Sigstore profile may remain optional.

### A raw detached signature over one file

Rejected because it would not bind file-set semantics, payload type, provenance,
SBOM, policy evidence, or promotion state and would invite format-confusion and
partial-package attacks.

### A self-signed key embedded in the artifact

Rejected because attacker-controlled content cannot establish its own trust
anchor.

### One online signing key for root, artifact, and promotion

Rejected because compromise would defeat separation of duties, revocation, and
recovery.

### Registry access control and TLS without signed metadata

Rejected because a compromised registry, credential, mirror, or mutable channel
could substitute, freeze, or roll back content without offline-detectable proof.

### A CyberSecGPT-private signature envelope

Rejected because OMS, DSSE, in-toto, Sigstore bundle, SLSA, SPDX, and TUF provide
reviewed interoperable building blocks and conformance material. CyberSecGPT owns
its policy and evidence bindings without inventing a new cryptographic container.

## Acceptance and follow-up

The tokenizer gate must be amended and separately accepted before implementation:
governance first approves the rights basis and policy for constructing an inert
candidate without granting distribution rights. After construction and independent
evaluation, governance must separately approve distribution of the exact unsigned
candidate digest and evidence. No approval can refer to a not-yet-produced
signature, and signing cannot substitute for exact-candidate approval.

This proposal authorizes no key creation, signing, publication, promotion,
installation, model work, or P7 work. If accepted, the next ordered proposal is a
`cybersecgpt-governance` decision binding Tokenizer v1 licence, notices,
distribution rights, approval roles, expiry, revocation, and exceptions to the
exact artifact identities. Each later implementation remains separately reviewed
and exact-head accepted.
