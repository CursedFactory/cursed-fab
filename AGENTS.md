# AGENTS.md

This file is for autonomous coding agents working in `cursed-fab`.
Keep changes minimal, explicit, and easy to review.

## Repository Snapshot

- Current repo is intentionally minimal.
- Present files: `README.md`, `.gitignore`, `LICENSE`.
- No application source tree exists yet.
- No `package.json`, Makefile, CI workflow, or test runner config is present today.
- Treat this as a bootstrap/spec repository unless new files are added.

## External Agent Rules Check

Checked for additional instruction sources:

- `.cursorrules`: not found
- `.cursor/rules/`: not found
- `.github/copilot-instructions.md`: not found

If any of these files are added later, they become mandatory guidance.

## OpenCode Setup (Minimal)

Use the lightest setup that matches your environment.

1. Install prerequisites:
   - `git`
   - `docker` (for containerized agent runs)
2. Install OpenCode CLI using your team-approved channel.
3. Verify install:
   - `opencode --version`
4. Authenticate if required by your runtime/profile.
5. Run from repo root:
   - `pwd` should be `.../cursed-fab`

Note: This repo does not pin an OpenCode version yet. Prefer stable release channels.

## Build / Lint / Test Commands

### Current State

- There are no build, lint, or test commands configured in-repo yet.
- Do not invent CI-critical commands in commits unless adding the corresponding tooling.

### When JS/TS Tooling Is Added

Default to npm scripts so commands stay repo-local and reproducible.

- Install deps: `npm install`
- Build: `npm run build`
- Lint: `npm run lint`
- Format check: `npm run format -- --check` (if configured)
- Test all: `npm test`

### Single Test Execution (Important)

Prefer one of these patterns, depending on configured runner:

- Vitest (file): `npx vitest run path/to/test.spec.ts`
- Vitest (name): `npx vitest run -t "test name"`
- Jest (file): `npx jest path/to/test.spec.ts`
- Jest (name): `npx jest -t "test name"`
- Node test runner (file): `node --test path/to/test.test.js`
- Pytest (file): `pytest path/to/test_file.py`
- Pytest (node id): `pytest path/to/test_file.py::test_case_name`

If a package script exists for test targeting, prefer that script over ad-hoc command lines.

### Bun Shebang Script Pattern (Imported Context)

When this repo adopts Bun-based task scripts, use the tinyverse-style pattern:

- Script naming: `scripts/*.sh.ts`.
- First line shebang: `#!/usr/bin/env bun`.
- Invoke scripts directly: `scripts/<name>.sh.ts`.
- Keep thin entrypoints in `scripts/`; move reusable logic to `scripts/helpers/`.
- Use explicit mode unions for dispatcher scripts (`type Mode = "build" | "test" | ...`).
- Read arguments from `Bun.argv` and validate unsupported modes with clear errors.

Example skeleton:

```ts
#!/usr/bin/env bun

const mode = Bun.argv[2] ?? "default";

if (mode === "default") {
  // run default flow
  process.exit(0);
}

throw new Error(`Unknown mode: ${mode}`);
```

For command execution helpers, prefer a shared `runCommand` utility that:

- logs invoked commands (`$ cmd ...args`)
- runs with inherited stdio by default
- throws on non-zero exit unless explicitly allowed
- supports optional `cwd` and env overrides

## Development Workflow Expectations

- Read `README.md` first for product intent.
- Keep PRs focused; avoid unrelated refactors.
- Update docs when behavior, interfaces, or workflows change.
- If you add tooling (lint/test/build), add scripts and document exact usage in README.

## Code Style Guidelines

Given the current empty codebase, follow these defaults unless overridden by future config.

### Formatting

- Use automated formatters; do not hand-format stylistic details.
- Prefer Prettier defaults for JS/TS/JSON/Markdown once configured.
- Use LF line endings.
- Ensure file ends with a newline.
- Keep diffs small and avoid formatting-only churn.

### Imports

- Order imports: standard library, third-party, internal modules.
- Keep import groups separated by one blank line.
- In Bun/Node script modules, use `node:` specifiers for built-ins.
- Avoid deep relative chains when aliases are available.
- Remove unused imports.
- Prefer named exports over large default-export modules for shared libraries.

### Types

- Prefer TypeScript for new JavaScript code.
- Enable strict type checking when TS config is introduced.
- Avoid `any`; use narrow unions, generics, or `unknown` with runtime guards.
- Model domain entities with explicit types/interfaces.
- Encode nullable/optional data intentionally (no implicit undefined drift).

### Naming Conventions

- Files: `kebab-case` for modules, `PascalCase` for React components.
- Variables/functions: `camelCase`.
- Types/classes/interfaces: `PascalCase`.
- Constants/env keys: `UPPER_SNAKE_CASE`.
- Test names should describe behavior, not implementation details.

### Functions and Modules

- Keep functions focused and side-effect boundaries obvious.
- Prefer pure helpers for transform logic.
- Use small modules with clear responsibilities.
- Avoid circular dependencies.
- Do not introduce hidden global state.

### Error Handling

- Fail fast on invalid inputs at boundaries.
- Throw typed/context-rich errors; avoid opaque string throws.
- Include actionable context in logs/errors (ids, operation, input shape).
- Never swallow errors silently.
- Map internal errors to stable user-facing messages at API/UI boundaries.

### Testing Standards

- Add tests for new behavior and bug fixes.
- Keep tests deterministic and isolated.
- Avoid network calls in unit tests; mock external boundaries.
- Assert outcomes and observable behavior, not private internals.
- Include at least one failure-path test for non-trivial logic.

### Config and Secrets

- Never commit secrets.
- Use `.env.example` for documented env vars.
- Validate required env vars on startup.
- Prefer explicit config objects over scattered `process.env` reads.

### Git and Review Hygiene

- Commit messages should explain intent (`why`), not only file changes.
- Keep branches rebased/mergeable with mainline.
- Run lint/tests before opening PR when available.
- PR descriptions should include scope, risks, and verification steps.
