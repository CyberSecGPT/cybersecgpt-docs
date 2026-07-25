# Security Policy

## Reporting a vulnerability

Report suspected vulnerabilities through the organization's designated
confidential security-reporting channel or a private repository security advisory
when one is available. Do not include exploit details, credentials, personal data,
or live target identifiers in a public issue.

No durable confidential contact address was confirmed during repository
inspection. Establishing and publishing that contact is an **unresolved operational
requirement**. Until then, use an access-controlled channel to the repository
maintainers and share only the minimum information needed to establish contact.

Include:

- affected repository, component, and version or commit;
- impact and preconditions;
- a minimal, non-destructive reproduction;
- relevant logs with secrets and personal data removed;
- suggested containment, if known; and
- whether active exploitation is suspected.

## Safe handling

- Test only systems and data for which you have explicit authorization.
- Stay within the approved targets, methods, time window, and rate limits.
- Stop if scope or authorization is ambiguous.
- Do not access unrelated data to demonstrate impact.
- Do not use destructive actions, persistence, evasion, malware, credential theft,
  or weaponized payloads.
- Preserve evidence integrity and record the tool version, configuration, time,
  and authorization reference needed for reproduction.

## Response principles

Maintainers should acknowledge receipt through the confidential channel, assign an
owner, preserve evidence, assess severity, and coordinate remediation and
disclosure. Remediation must include tests, deployment rollback guidance, and an
audit trail. Public disclosure timing is decided case by case with affected
parties; no fixed service-level target is established yet.

## Architecture requirements

Security-sensitive components must follow:

- [Authorization model](docs/security/authorization-model.md)
- [Scope enforcement](docs/security/scope-enforcement.md)
- [Secure development](docs/security/secure-development.md)
- [Logging standard](docs/standards/logging-standard.md)
- [Error-handling standard](docs/standards/error-handling-standard.md)

The absence of an implementation does not waive these requirements.
