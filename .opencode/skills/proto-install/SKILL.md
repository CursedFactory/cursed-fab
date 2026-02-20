---
name: proto-install
description: Run `proto install` through a Bun script from repository root.
---

## What this skill does

- Standardizes toolchain installation using a repo-local script entrypoint.
- Ensures consistent execution from repository root.

## Preferred command

- `scripts/proto_install.sh.ts`

## Conventions

- Follow Bun script naming and shebang pattern (`scripts/*.sh.ts`).
- Use shared command helpers for process execution.
- Report failures with direct next actions; do not invent hidden fallback behavior.
