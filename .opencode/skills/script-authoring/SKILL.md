---
name: script-authoring
description: Author Bun shebang scripts using `scripts/*.sh.ts` + shared helpers.
---

## What this skill does

- Creates reusable Bun entrypoint scripts under `scripts/`.
- Normalizes script style to shebang + helper-first conventions.
- Converts successful one-off shell sequences into maintainable script files.

## Conventions

- Use file naming: `scripts/<name>.sh.ts`.
- First line: `#!/usr/bin/env bun`.
- Prefer thin script entrypoints and reusable helpers under `scripts/helpers/`.
- Parse script mode/args from `Bun.argv` with explicit validation.
- Throw on unknown modes using clear errors.
- Keep flow deterministic and fail fast on command errors.

## Command helper pattern

Use a shared helper (for example `scripts/helpers/run_command.sh.ts`) that:

- logs commands before execution (for example `$ moon :test`)
- supports optional `cwd` and env overrides
- defaults to inherited stdio
- throws on non-zero exit unless explicitly allowed

## Usage notes

- Avoid embedding secrets and machine-specific absolute paths.
- Keep scripts idempotent where practical.
- If behavior changes, update `README.md` and `AGENTS.md`.
