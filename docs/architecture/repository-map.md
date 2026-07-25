# Repository Map

## Scope and evidence

This map records the CyberSecGPT directories observed under
`D:\SOFTWARE\Project_Gpt` on 2026-07-25 and the eight additional names requested as
proposals. Inspection included Git history, tracked files, top-level manifests,
README files, and source layout. It did not treat a directory name as evidence of
implementation.

### Observed implementation summary

- 28 `cybersecgpt*` directories exist and are Git repositories.
- 25 of those repositories have no commits and no files outside `.git`.
- `cybersecgpt-bootstrap` has 12 commits and contains a Python CLI, configuration,
  repository registry, template renderer, project initializer work, and tests.
- `cybersecgpt-bootstrap-py` has one scaffold commit with placeholder Python
  modules and tests.
- `cybersecgpt-docs` had one commit containing empty scaffold files before this
  documentation set was authored.
- None of the eight requested proposed repository names exists.

The status labels mean:

- **Existing** — the Git repository directory exists.
- **Proposed** — the directory does not exist; the boundary is only a design
  candidate.
- **Overlapping** — responsibilities conflict with another existing or proposed
  owner and require an ADR before implementation.

All responsibilities below are **Proposed ownership** unless the status explicitly
identifies observed implementation.

## Ownership principles

1. Reuse a suitable existing repository before creating another.
2. One public contract has one authoritative owner.
3. A repository may depend only on public contracts in the direction allowed by
   the [dependency graph](dependency-graph.md).
4. Artifact flow does not imply source-code dependency.
5. Product code never depends on research, experiment, benchmark, deployment, or
   provider-adapter internals.
6. Repository creation, rename, split, or consolidation requires an ADR with a
   migration and rollback plan.

## Existing repositories

### `cybersecgpt`

- **Purpose:** candidate umbrella entry point and release manifest for the
  CyberSecGPT product family.
- **Responsibilities:** if retained, publish a bill of materials, compatible
  component versions, installation profiles, and navigation.
- **Non-responsibilities:** model, runtime, security, UI, deployment, or shared
  domain implementation.
- **Allowed dependencies:** released metadata and public packages from application
  and platform repositories; no private imports.
- **Forbidden dependencies:** provider SDKs, component internals, shared databases,
  and infrastructure source.
- **Public contracts:** distribution manifest and compatibility matrix.
- **Likely produced artifacts:** meta-package, lock or bill-of-materials files,
  release notes.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-api`

- **Purpose:** network-facing API boundary for CyberSecGPT capabilities.
- **Responsibilities:** transport authentication, request validation, contract
  translation, quotas, cancellation, and privacy-safe API telemetry.
- **Non-responsibilities:** reasoning, policy decisions, model execution, or tool
  implementation.
- **Allowed dependencies:** `cybersecgpt-sdk` and public identity/policy contracts;
  calls lower services through public interfaces.
- **Forbidden dependencies:** training, private inference or security modules,
  provider SDKs in core routes, and infrastructure source.
- **Public contracts:** versioned HTTP/RPC schemas, authentication profile, error
  envelope, pagination and streaming semantics.
- **Likely produced artifacts:** API service image, OpenAPI or RPC descriptors,
  client-generation inputs.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-benchmarks`

- **Purpose:** reproducible performance and quality benchmark definitions.
- **Responsibilities:** benchmark manifests, harness adapters, baselines, resource
  measurements, and comparable reports.
- **Non-responsibilities:** production evaluation gates, model training, runtime
  implementation, or marketing claims without evidence.
- **Allowed dependencies:** released tokenizer, inference, evaluation, security,
  and SDK contracts.
- **Forbidden dependencies:** production components depending on this repository,
  private modules, live unauthorized targets, or mutable unpublished datasets.
- **Public contracts:** benchmark case, environment, measurement, and report
  schemas.
- **Likely produced artifacts:** benchmark suites, signed result bundles,
  dashboards or summary reports.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-bootstrap`

- **Purpose:** project scaffolding, repository inventory, workspace diagnostics,
  and template-driven initialization.
- **Responsibilities:** safe project generation, bootstrap templates, repository
  registry parsing, diagnostics, and related CLI commands.
- **Non-responsibilities:** runtime orchestration, model lifecycle, security
  operations, or organization-wide policy enforcement.
- **Allowed dependencies:** Python standard library, configuration parsing, Git as
  a local tool, and documentation/template inputs.
- **Forbidden dependencies:** production AI components, external AI providers,
  application services, and deployment control planes.
- **Public contracts:** `csgpt` bootstrap CLI, repository-registry schema,
  template-placeholder contract, initializer option/result types.
- **Likely produced artifacts:** Python distribution, generated project trees,
  diagnostics and bootstrap configuration.
- **Current status:** **Existing**; observed Python implementation and tests with 12
  commits. Active uncommitted initializer changes were present during inspection;
  this is not a production-readiness claim.

### `cybersecgpt-bootstrap-py`

- **Purpose:** earlier Python bootstrap scaffold.
- **Responsibilities:** only maintain compatibility or migration material while a
  consolidation decision is pending.
- **Non-responsibilities:** a second authoritative bootstrap CLI or template
  contract.
- **Allowed dependencies:** Python standard library and bootstrap test tooling.
- **Forbidden dependencies:** runtime components and duplicated ownership of active
  `cybersecgpt-bootstrap` contracts.
- **Public contracts:** observed placeholder `csgpt` modules; no stable contract is
  established.
- **Likely produced artifacts:** scaffold Python package, if retained.
- **Current status:** **Existing, overlapping**; one scaffold commit with Python
  placeholder modules and tests. Prefer consolidation into
  `cybersecgpt-bootstrap` rather than parallel development.

### `cybersecgpt-cli`

- **Purpose:** operator command-line product surface.
- **Responsibilities:** local command UX, input validation, configuration
  selection, API/SDK invocation, progress, and actionable errors.
- **Non-responsibilities:** model inference internals, authorization decisions,
  security techniques, or bootstrap project generation unless explicitly
  delegated to the bootstrap package.
- **Allowed dependencies:** `cybersecgpt-sdk`, stable API contracts, and narrowly
  scoped bootstrap commands.
- **Forbidden dependencies:** private service modules, provider SDKs, training, and
  infrastructure source.
- **Public contracts:** CLI grammar, exit-code taxonomy, machine-readable output
  schemas.
- **Likely produced artifacts:** executable package, shell completions, command
  reference.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-datasets`

- **Purpose:** governed dataset manifests, loaders, provenance, and transformation
  contracts.
- **Responsibilities:** dataset identity, splits, lineage, consent/license
  metadata, validation, redaction records, and deterministic transforms.
- **Non-responsibilities:** storing unrestricted raw data in Git, tokenizer
  implementation, training orchestration, or evaluation decisions.
- **Allowed dependencies:** foundational schema and storage interfaces.
- **Forbidden dependencies:** training, inference, product surfaces, external AI
  providers, and undocumented source acquisition.
- **Public contracts:** dataset manifest, record envelope, split, transform, and
  provenance schemas.
- **Likely produced artifacts:** manifests, validation reports, content-addressed
  dataset references, small approved fixtures.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-desktop`

- **Purpose:** local desktop user experience.
- **Responsibilities:** desktop presentation, secure local credential integration,
  session UX, update UX, and SDK/API invocation.
- **Non-responsibilities:** core inference, authorization, security tools, or
  durable enterprise policy.
- **Allowed dependencies:** `cybersecgpt-sdk` and documented API/event contracts.
- **Forbidden dependencies:** private model/runtime modules, provider SDKs as a
  core requirement, and infrastructure source.
- **Public contracts:** desktop configuration, deep-link, update, and local IPC
  profiles.
- **Likely produced artifacts:** signed installers, desktop bundles, update
  manifests.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-devops`

- **Purpose:** build, test, release, promotion, and delivery automation.
- **Responsibilities:** CI/CD workflows, artifact provenance, signing integration,
  promotion gates, reproducible builds, and rollback automation.
- **Non-responsibilities:** cloud resource definitions, application authorization
  policy, or runtime business logic.
- **Allowed dependencies:** released build interfaces, test contracts,
  `cybersecgpt-infrastructure` deployment entry points, governance policy artifacts.
- **Forbidden dependencies:** production packages importing DevOps code, embedded
  long-lived credentials, and provider-specific assumptions in core builds.
- **Public contracts:** build inputs/outputs, promotion evidence, deployment and
  rollback interfaces.
- **Likely produced artifacts:** pipelines, provenance attestations, SBOMs, signed
  releases, promotion records.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-docs`

- **Purpose:** authoritative cross-repository architecture, standards, security
  requirements, and conceptual contracts.
- **Responsibilities:** repository ownership, dependency direction, platform-wide
  requirements, ADR governance, and contract semantics.
- **Non-responsibilities:** component implementation, generated API reference,
  source licensing selection, or claims unsupported by repository evidence.
- **Allowed dependencies:** links to public component documentation and observed
  repository evidence; no runtime dependencies.
- **Forbidden dependencies:** executable production coupling, secrets, sensitive
  evidence, and provider-specific core assumptions.
- **Public contracts:** the documents under `docs/specifications/` and standards in
  this repository.
- **Likely produced artifacts:** Markdown site, diagrams, ADRs, architecture
  baselines.
- **Current status:** **Existing**; one empty scaffold commit preceded this authored
  baseline. Documentation is not evidence that component implementations exist.

### `cybersecgpt-evaluation`

- **Purpose:** independent quality, safety, security, and compatibility evaluation.
- **Responsibilities:** evaluation suites, metrics, acceptance evidence,
  regression comparison, and promotion recommendations.
- **Non-responsibilities:** training, benchmark marketing, artifact promotion
  authority, or altering evaluated systems.
- **Allowed dependencies:** public tokenizer, inference, security, dataset, and
  model/checkpoint contracts.
- **Forbidden dependencies:** production components depending on evaluation code,
  private training internals, and unversioned test data.
- **Public contracts:** evaluation case, run manifest, metric, finding, and report
  schemas.
- **Likely produced artifacts:** evaluation reports, scorecards, evidence bundles,
  promotion inputs.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-experiments`

- **Purpose:** controlled, disposable experimental implementations and run
  definitions.
- **Responsibilities:** hypotheses, experiment manifests, isolated prototypes,
  results, and reproducibility notes.
- **Non-responsibilities:** production APIs, durable contracts, release artifacts,
  or unrestricted security testing.
- **Allowed dependencies:** released research and component interfaces plus
  approved fixture data.
- **Forbidden dependencies:** production dependencies on experiments, secrets,
  unapproved datasets, and live unauthorized targets.
- **Public contracts:** experiment manifest and result record.
- **Likely produced artifacts:** experiment configurations, notebooks without
  sensitive output, reproducibility reports.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-foundation`

- **Purpose:** lowest-level domain types, portability abstractions, and stable
  first-party AI contracts.
- **Responsibilities:** identifiers, artifact descriptors, capabilities,
  cancellation/deadline primitives, contract-neutral types, and potentially model
  architecture definitions after an ADR.
- **Non-responsibilities:** orchestration, network services, provider adapters,
  product UI, or deployment.
- **Allowed dependencies:** standard libraries and minimal audited utility
  libraries; published documentation schemas.
- **Forbidden dependencies:** every higher layer, provider SDKs, and application
  frameworks.
- **Public contracts:** foundational types, artifact identity, capability and
  compatibility interfaces.
- **Likely produced artifacts:** small language packages, schemas, conformance
  fixtures.
- **Current status:** **Existing, overlapping** with proposed `cybersecgpt-core`
  and `cybersecgpt-model`; empty Git repository with no commits.

### `cybersecgpt-governance`

- **Purpose:** machine-readable and human governance policy ownership.
- **Responsibilities:** policy lifecycle, approvals, risk classifications,
  exceptions, model/data usage rules, and licensing policy decisions once adopted.
- **Non-responsibilities:** runtime policy enforcement, commercial metering, legal
  advice, or choosing a license without approval.
- **Allowed dependencies:** architecture and event contracts; publishes policy
  artifacts consumed by platform/security.
- **Forbidden dependencies:** product UI, provider SDKs, model internals, and
  infrastructure implementation.
- **Public contracts:** policy bundle, decision rationale, approval, exception, and
  governance-event schemas.
- **Likely produced artifacts:** signed policy bundles, decision records, risk
  registers, license-policy metadata.
- **Current status:** **Existing, overlapping** with proposed
  `cybersecgpt-licensing`; empty Git repository with no commits.

### `cybersecgpt-inference`

- **Purpose:** first-party checkpoint loading, scheduling, generation, and
  hardware-aware inference.
- **Responsibilities:** model execution, batching, cache management, streaming,
  resource limits, capabilities, and deterministic execution metadata.
- **Non-responsibilities:** training, agent planning, product APIs, authorization,
  or provider-specific core behavior.
- **Allowed dependencies:** foundation, tokenizer, runtime, and model/checkpoint
  contracts; optional adapters depend on inference, not the reverse.
- **Forbidden dependencies:** training implementation, applications, reasoning,
  external-provider SDKs in core, and infrastructure source.
- **Public contracts:** [model contract](../specifications/model-contract.md),
  inference request/result, stream, capability, and load diagnostics.
- **Likely produced artifacts:** inference engine libraries/services, hardware
  plugins, performance profiles.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-infrastructure`

- **Purpose:** declarative self-hosted infrastructure and environment composition.
- **Responsibilities:** compute, network, storage, identity integration, secrets
  references, backup, recovery, and environment modules.
- **Non-responsibilities:** CI/CD workflows, application logic, security-operation
  authorization, or model contracts.
- **Allowed dependencies:** released deployment interfaces, policy constraints,
  and platform operational requirements.
- **Forbidden dependencies:** production packages importing infrastructure code,
  embedded secrets, and mandatory external AI services.
- **Public contracts:** environment variables, service endpoints, deployment
  topology, backup and recovery interfaces.
- **Likely produced artifacts:** infrastructure modules, deployment plans,
  environment manifests, recovery runbooks.
- **Current status:** **Existing, overlapping** with `cybersecgpt-devops` and
  proposed `cybersecgpt-cloud`; empty Git repository with no commits.

### `cybersecgpt-memory`

- **Purpose:** governed short- and long-term memory services for agents and users.
- **Responsibilities:** typed memory items, retrieval, tenancy, provenance,
  retention, deletion, summarization lineage, and access control hooks.
- **Non-responsibilities:** authorization grants, model weights, raw audit
  evidence, or unbounded transcript retention.
- **Allowed dependencies:** foundation, storage abstractions, identity/policy
  contracts, and embedding interfaces behind provider-neutral boundaries.
- **Forbidden dependencies:** product UIs, provider SDKs in core, security-tool
  execution, and direct access to audit stores.
- **Public contracts:** memory item, query, result, lifecycle, retention, and
  deletion schemas.
- **Likely produced artifacts:** memory service/library, storage adapters,
  conformance tests.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-monitoring`

- **Purpose:** operational observability and alerting.
- **Responsibilities:** telemetry collection profiles, dashboards, service-level
  indicators, alert rules, and privacy-safe operational correlation.
- **Non-responsibilities:** canonical audit evidence, business authorization,
  model evaluation, or changing application behavior.
- **Allowed dependencies:** public event/metric/trace contracts and deployment
  inventory.
- **Forbidden dependencies:** production components importing monitoring code,
  secret payload capture, and private databases.
- **Public contracts:** telemetry semantic conventions, health, metric, trace, and
  alert schemas.
- **Likely produced artifacts:** collector configuration, dashboards, alerts,
  operational reports.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-platform`

- **Purpose:** multi-user and enterprise-capable CyberSecGPT control plane.
- **Responsibilities:** tenancy, identity integration, policy administration,
  service composition, quotas, lifecycle, audit access, and product configuration.
- **Non-responsibilities:** core model architecture, security techniques, UI
  implementation, infrastructure definitions, or licensing policy authorship.
- **Allowed dependencies:** API, SDK, security, governance, event, and identity
  contracts.
- **Forbidden dependencies:** private model/runtime modules, provider SDKs as core
  dependencies, and infrastructure source.
- **Public contracts:** tenant, entitlement, policy administration, deployment
  profile, and service lifecycle APIs.
- **Likely produced artifacts:** platform services, administration APIs,
  deployment-neutral control-plane images.
- **Current status:** **Existing, overlapping** with proposed
  `cybersecgpt-enterprise`; empty Git repository with no commits.

### `cybersecgpt-reasoning`

- **Purpose:** model-independent planning, reasoning, and agent orchestration.
- **Responsibilities:** bounded plans, agent state machines, delegation rules,
  tool proposal, budgets, cancellation, and explanation traces suitable for
  policy.
- **Non-responsibilities:** granting authorization, implementing tools, storing
  memory, inference kernels, or product UX.
- **Allowed dependencies:** foundation, inference, memory, tools, and immutable
  authorization-context contracts.
- **Forbidden dependencies:** applications, security-policy bypasses, provider
  SDKs in core, and direct target access.
- **Public contracts:** [agent contract](../specifications/agent-contract.md),
  plan/step, budget, and reasoning-event semantics.
- **Likely produced artifacts:** orchestration library/service, planner plugins,
  agent conformance tests.
- **Current status:** **Existing, overlapping** with proposed
  `cybersecgpt-agents`; empty Git repository with no commits.

### `cybersecgpt-research`

- **Purpose:** research records, design exploration, and evidence informing ADRs.
- **Responsibilities:** research questions, literature notes, safe prototypes,
  limitations, and reproducibility packages.
- **Non-responsibilities:** production contracts, shipped components, unsupported
  capability claims, or operational security testing.
- **Allowed dependencies:** public released contracts and approved research data.
- **Forbidden dependencies:** production dependence on research code, secrets,
  restricted data without governance, and unauthorized targets.
- **Public contracts:** research record and reproducibility manifest.
- **Likely produced artifacts:** papers, reports, prototype branches, experiment
  proposals.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-runtime`

- **Purpose:** portable execution substrate for model and controlled component
  workloads.
- **Responsibilities:** device abstraction, resource accounting, scheduling
  primitives, cancellation, deadlines, plugin isolation, and runtime diagnostics.
- **Non-responsibilities:** inference semantics, agent planning, product APIs,
  security authorization, or cloud provisioning.
- **Allowed dependencies:** foundation and audited system/accelerator libraries.
- **Forbidden dependencies:** inference callers, reasoning, applications,
  provider SDKs, and infrastructure source.
- **Public contracts:** device, allocation, execution session, cancellation,
  capability, and resource-usage interfaces.
- **Likely produced artifacts:** runtime libraries, native extensions, hardware
  backends, conformance suites.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-sdk`

- **Purpose:** stable client and embedding interfaces for CyberSecGPT services.
- **Responsibilities:** typed clients, local/remote transport abstraction,
  authentication hooks, retries within budgets, and contract compatibility.
- **Non-responsibilities:** implementing server policy, model execution, agent
  internals, or UI.
- **Allowed dependencies:** public foundation, inference, agent, tool, security,
  API, and event contracts.
- **Forbidden dependencies:** service private modules, provider SDKs as mandatory
  dependencies, and infrastructure code.
- **Public contracts:** language client APIs, transport profiles, typed errors,
  streaming and cancellation semantics.
- **Likely produced artifacts:** language SDK packages, API bindings, examples,
  compatibility tests.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-security`

- **Purpose:** policy-controlled cybersecurity domain and enforcement boundary.
- **Responsibilities:** capability classification, policy decisions, target-scope
  enforcement, defensive analysis, authorized technique orchestration, evidence
  references, and safety limits.
- **Non-responsibilities:** operator authorization issuance, product UI, generic
  agent planning, infrastructure administration, or unrestricted exploit content.
- **Allowed dependencies:** foundation, reasoning, tools, event, identity, and
  policy contracts.
- **Forbidden dependencies:** bypassing policy, direct UI dependencies, mandatory
  provider SDKs, destructive or unauthorized behavior.
- **Public contracts:** authorization/scope context, security finding, technique,
  policy decision, evidence reference, and validation result.
- **Likely produced artifacts:** security service/library, policy rules,
  defensive-technique packages, evidence schemas.
- **Current status:** **Existing, overlapping** with proposed
  `cybersecgpt-security-engine` and `cybersecgpt-exploit-validation`; empty Git
  repository with no commits.

### `cybersecgpt-tokenizer`

- **Purpose:** first-party tokenizer training, execution, and artifact ownership.
- **Responsibilities:** normalization, vocabulary and special-token management,
  encode/decode, training provenance, deterministic fingerprints, and
  compatibility tests.
- **Non-responsibilities:** model training, inference scheduling, dataset
  governance, or provider token accounting.
- **Allowed dependencies:** foundation and approved normalization/data interfaces.
- **Forbidden dependencies:** model/inference/training implementation, product
  surfaces, and external-provider tokenizers as core dependencies.
- **Public contracts:** [tokenizer contract](../specifications/tokenizer-contract.md)
  and tokenizer artifact manifest.
- **Likely produced artifacts:** tokenizer packages, vocabulary/model files,
  manifests, conformance vectors.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-tools`

- **Purpose:** provider-neutral tool registry, contracts, sandbox adapters, and
  side-effect boundary.
- **Responsibilities:** typed descriptors, schema validation, risk classification,
  execution gateways, idempotency, deadlines, and result normalization.
- **Non-responsibilities:** authorization issuance, agent planning, hidden shell
  access, or ownership of every domain tool.
- **Allowed dependencies:** foundation, runtime isolation, authorization/policy,
  event, and domain-specific public contracts.
- **Forbidden dependencies:** product UI, bypassing policy, mandatory provider
  SDKs, and unrestricted process/network/filesystem access.
- **Public contracts:** [tool contract](../specifications/tool-contract.md),
  registry and execution interfaces.
- **Likely produced artifacts:** tool SDK, sandbox runners, registry service,
  conformance tests.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-training`

- **Purpose:** first-party model training and fine-tuning pipelines.
- **Responsibilities:** run manifests, distributed training, optimizer/scheduler
  configuration, checkpoints, resumption, provenance, and resource metrics.
- **Non-responsibilities:** dataset ownership, tokenizer ownership, evaluation
  approval, serving, or artifact promotion authority.
- **Allowed dependencies:** foundation, tokenizer, datasets, runtime primitives,
  and model/checkpoint contracts.
- **Forbidden dependencies:** inference service implementation, applications,
  external AI providers as core dependencies, and ungoverned data.
- **Public contracts:** training run, checkpoint producer, metric stream, resume,
  and provenance schemas.
- **Likely produced artifacts:** training packages/images, candidate checkpoints,
  run manifests, metrics and provenance.
- **Current status:** **Existing**; empty Git repository with no commits.

### `cybersecgpt-web`

- **Purpose:** browser-based CyberSecGPT user and administration experience.
- **Responsibilities:** presentation, accessible workflows, API integration,
  session safety, and client-side input/output handling.
- **Non-responsibilities:** server authorization, model execution, security tools,
  or durable enterprise policy.
- **Allowed dependencies:** public API, event-stream, and generated client
  contracts.
- **Forbidden dependencies:** server private modules, provider SDKs as core,
  secrets in client bundles, and infrastructure source.
- **Public contracts:** web configuration, browser session, UI extension, and
  accessibility profiles.
- **Likely produced artifacts:** static bundles, web application image, source
  maps under controlled release policy.
- **Current status:** **Existing**; empty Git repository with no commits.

## Proposed repositories

These names do not exist. A proposal does not authorize creating the repository.

### `cybersecgpt-core`

- **Purpose:** proposed shared core primitives.
- **Responsibilities:** only responsibilities not already covered by foundation,
  if an ADR identifies such a gap.
- **Non-responsibilities:** a second foundational type system or umbrella dumping
  ground.
- **Allowed dependencies:** standard libraries and published contract schemas.
- **Forbidden dependencies:** higher layers and `cybersecgpt-foundation` mutual
  imports.
- **Public contracts:** would duplicate foundational contracts unless narrowed.
- **Likely produced artifacts:** small core packages and schemas.
- **Current status:** **Proposed, overlapping**; absent. Preferred action is to use
  `cybersecgpt-foundation`, not create this repository.

### `cybersecgpt-model`

- **Purpose:** proposed authoritative model architecture and configuration owner.
- **Responsibilities:** architecture descriptors, parameter naming, forward
  semantics, capabilities, and model compatibility if separated by ADR.
- **Non-responsibilities:** tokenizer, training orchestration, inference
  scheduling, checkpoint tensor storage, or a duplicate foundation layer.
- **Allowed dependencies:** foundation and tokenizer contracts.
- **Forbidden dependencies:** training/inference implementations, applications,
  provider SDKs, and reverse dependency from foundation.
- **Public contracts:** [model contract](../specifications/model-contract.md) and
  architecture configuration schemas.
- **Likely produced artifacts:** model-definition packages, configuration schemas,
  reference state dictionaries, conformance fixtures.
- **Current status:** **Proposed, overlapping**; absent. Resolve overlap with
  `cybersecgpt-foundation` before creation; reusing foundation is the default.

### `cybersecgpt-agents`

- **Purpose:** proposed agent framework and lifecycle owner.
- **Responsibilities:** agent descriptors, lifecycle, delegation, budgets, and
  orchestration only if those are separated from reasoning by ADR.
- **Non-responsibilities:** duplicate planning loops, tools, memory, authorization,
  or UI.
- **Allowed dependencies:** foundation, inference, reasoning contracts, memory,
  tools, and authorization context.
- **Forbidden dependencies:** cyclic dependency with `cybersecgpt-reasoning`,
  direct targets, provider SDKs, and applications.
- **Public contracts:** [agent contract](../specifications/agent-contract.md).
- **Likely produced artifacts:** agent SDK/runtime and conformance tests.
- **Current status:** **Proposed, overlapping**; absent. Prefer
  `cybersecgpt-reasoning` as the initial agent-framework owner.

### `cybersecgpt-security-engine`

- **Purpose:** proposed execution engine for cybersecurity capabilities.
- **Responsibilities:** only an isolated engine boundary selected by ADR.
- **Non-responsibilities:** duplicate policy, scope, finding, technique, or
  evidence contracts.
- **Allowed dependencies:** `cybersecgpt-security`, tools, runtime, and
  authorization contracts if implemented as a subordinate engine.
- **Forbidden dependencies:** reverse dependency from security policy to engine
  internals, unrestricted execution, UI, and provider SDKs.
- **Public contracts:** engine capability and bounded execution interfaces.
- **Likely produced artifacts:** isolated worker service and capability plugins.
- **Current status:** **Proposed, overlapping**; absent. Prefer implementing the
  initial boundary in `cybersecgpt-security`.

### `cybersecgpt-exploit-validation`

- **Purpose:** proposed high-isolation framework for explicitly authorized,
  non-destructive validation of findings.
- **Responsibilities:** scope revalidation, safe technique selection, sandboxed
  execution, rate/deadline enforcement, evidence capture, and cleanup verification.
- **Non-responsibilities:** exploit publishing, weaponized payloads, unauthorized
  access, persistence, evasion, destructive testing, or general policy issuance.
- **Allowed dependencies:** security public contracts, tools, runtime isolation,
  event/evidence, and immutable authorization grants.
- **Forbidden dependencies:** applications, direct authorization issuance,
  unbounded target access, and any core dependency on this repository.
- **Public contracts:** validation request, approved technique, observation,
  evidence, cleanup, and result schemas.
- **Likely produced artifacts:** isolated validation workers, safe technique
  packages, evidence bundles, conformance suites.
- **Current status:** **Proposed, overlapping**; absent. Repository-level isolation
  may be justified by risk, but an ADR must compare it with ownership inside
  `cybersecgpt-security`.

### `cybersecgpt-enterprise`

- **Purpose:** proposed enterprise product and administration layer.
- **Responsibilities:** only enterprise responsibilities not already owned by
  platform after an ADR.
- **Non-responsibilities:** a duplicate control plane, UI, infrastructure, model,
  or security engine.
- **Allowed dependencies:** platform, API, SDK, security, governance, and identity
  contracts.
- **Forbidden dependencies:** platform/enterprise mutual imports, private model
  code, provider SDKs as core, and infrastructure source.
- **Public contracts:** tenant, entitlement, administration, audit-access, and
  supportability APIs.
- **Likely produced artifacts:** enterprise service packages and administration
  integrations.
- **Current status:** **Proposed, overlapping**; absent. Prefer
  `cybersecgpt-platform` as owner unless a packaging or access-control boundary is
  accepted.

### `cybersecgpt-licensing`

- **Purpose:** proposed license and entitlement service.
- **Responsibilities:** machine-readable entitlement evaluation and usage records
  only after legal and governance policy exists.
- **Non-responsibilities:** selecting licenses, legal interpretation, governance
  approvals, or duplicating platform tenancy.
- **Allowed dependencies:** governance policy, platform identity/tenant, event, and
  cryptographic verification contracts.
- **Forbidden dependencies:** governance/licensing cycles, model internals, UI,
  hidden telemetry, and license decisions encoded without approval.
- **Public contracts:** entitlement, license policy reference, usage decision, and
  verification schemas.
- **Likely produced artifacts:** entitlement service/library, signed license
  tokens, conformance suites.
- **Current status:** **Proposed, overlapping**; absent. Governance should own
  policy and platform can initially enforce it; separate only by ADR.

### `cybersecgpt-cloud`

- **Purpose:** proposed curated cloud deployment profiles.
- **Responsibilities:** cloud-specific compositions only if a distinct ownership
  boundary is accepted.
- **Non-responsibilities:** generic infrastructure modules, CI/CD, application
  logic, or a mandatory hosted service.
- **Allowed dependencies:** infrastructure modules, DevOps deployment interfaces,
  platform operational contracts.
- **Forbidden dependencies:** production packages depending on cloud code,
  duplicated generic modules, mandatory external AI providers, and embedded
  secrets.
- **Public contracts:** cloud profile, region, identity, storage, network, and
  recovery configuration.
- **Likely produced artifacts:** cloud overlays, deployment profiles, cost and
  recovery guidance.
- **Current status:** **Proposed, overlapping**; absent. Prefer
  `cybersecgpt-infrastructure` plus `cybersecgpt-devops` until a distinct product
  boundary is demonstrated.

## Overlap decisions required

| Overlap | Default direction | Decision still required |
| --- | --- | --- |
| `cybersecgpt-bootstrap` / `cybersecgpt-bootstrap-py` | consolidate on the active `cybersecgpt-bootstrap` implementation | migration and archival plan |
| `cybersecgpt-foundation` / `cybersecgpt-core` | use foundation | whether the umbrella `cybersecgpt` meta-package needs any shared code |
| `cybersecgpt-foundation` / `cybersecgpt-model` | begin in foundation or rename deliberately; do not duplicate | long-term model architecture owner |
| `cybersecgpt-reasoning` / `cybersecgpt-agents` | reasoning owns the initial agent framework | whether orchestration scale warrants a later split |
| `cybersecgpt-security` / `cybersecgpt-security-engine` | security owns policy and initial execution boundary | whether engine isolation becomes a subordinate repository |
| `cybersecgpt-security` / `cybersecgpt-exploit-validation` | keep policy in security | whether high-risk validation requires isolated ownership |
| `cybersecgpt-platform` / `cybersecgpt-enterprise` | platform owns enterprise control-plane concerns | commercial packaging boundary |
| infrastructure / DevOps / cloud | infrastructure owns resources; DevOps owns delivery; no cloud repo initially | whether curated cloud profiles become a separate product |
| governance / licensing | governance owns policy; platform initially enforces | whether a standalone entitlement service is required |

## Organization-wide unresolved decisions

- Source, documentation, model, weight, tokenizer, and dataset licenses.
- Repository consolidation and archival authority.
- Model architecture owner and concrete checkpoint encodings.
- Language/runtime support matrix and package coordinates.
- Policy signing, artifact signing, and trust-root ownership.
- Whether authorized validation requires a separate repository and process boundary.
- Enterprise packaging, entitlement, and cloud product boundaries.
