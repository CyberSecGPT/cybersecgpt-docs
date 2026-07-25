#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "README.md"
  "CONTRIBUTING.md"
  "docs/architecture/system-overview.md"
  "docs/architecture/repository-map.md"
  "docs/architecture/repository-approval-matrix.md"
  "docs/architecture/dependency-graph.md"
  "docs/governance/architecture-change-gate.md"
  "docs/decisions/README.md"
  "docs/specifications/model-contract.md"
  "docs/specifications/tokenizer-contract.md"
  "docs/specifications/checkpoint-format.md"
  "docs/specifications/agent-contract.md"
  "docs/specifications/tool-contract.md"
  "docs/specifications/event-contract.md"
)

echo "Checking required architecture files..."

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: Missing required file: $file" >&2
    exit 1
  fi
done

echo "Checking for unfinished markers..."

if grep -RniE 'TODO|TBD|FIXME|XXX' \
  README.md CONTRIBUTING.md docs .github scripts \
  --exclude='validate-architecture.sh'; then
  echo "ERROR: Unfinished markers were found." >&2
  exit 1
fi

echo "Checking ADR status declarations..."

for adr in docs/decisions/ADR-*.md; do
  if ! grep -qiE 'Accepted|Proposed|Superseded|Deprecated|Rejected' "$adr"; then
    echo "ERROR: ADR has no recognizable status: $adr" >&2
    exit 1
  fi
done

echo "Checking Markdown relative links..."

python - <<'PY'
from __future__ import annotations

import re
import sys
from pathlib import Path

root = Path.cwd()
files = list(root.rglob("*.md"))
pattern = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
errors: list[str] = []

for file in files:
    text = file.read_text(encoding="utf-8")
    for target in pattern.findall(text):
        target = target.strip()

        if (
            not target
            or target.startswith(("#", "http://", "https://", "mailto:"))
        ):
            continue

        target = target.split("#", 1)[0]
        if not target:
            continue

        resolved = (file.parent / target).resolve()

        try:
            resolved.relative_to(root.resolve())
        except ValueError:
            errors.append(
                f"{file.relative_to(root)}: link leaves repository: {target}"
            )
            continue

        if not resolved.exists():
            errors.append(
                f"{file.relative_to(root)}: missing link target: {target}"
            )

if errors:
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"Validated relative links in {len(files)} Markdown files.")
PY

echo "Checking whitespace and conflict markers..."

git diff --check

if grep -RniE '^(<<<<<<<|=======|>>>>>>>)' \
  README.md CONTRIBUTING.md docs .github scripts; then
  echo "ERROR: Merge-conflict markers were found." >&2
  exit 1
fi

echo "Architecture documentation validation passed."
