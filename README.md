# cursed-fab

`cursed-fab` explores Git-host (GitHub/GitLab) based agentic development where issues, pull requests, and CI workflows are the interface, and dockerized OpenCode agents are the actors.

## Quick Start

This repo includes a Docker + Dev Container setup for running agent workflows in a reproducible environment.

1. Copy env defaults:

```bash
cp .env.example .env
```

2. Build and start the development container:

```bash
docker compose up --build -d devbox
```

3. Open a shell inside it:

```bash
docker compose exec devbox bash
```

4. Verify toolchain availability:

```bash
opencode --version
node -v
bun -v
rustc -V
```

## Dev Box

- Base image: Ubuntu 24.04 (lean package set)
- Included tools: OpenCode CLI, Node.js (with npm/npx), Bun, Rust (rustup/cargo), and common CLI utilities

### Environment Overrides

Optional overrides are read from `.env`:

- `DEVBOX_USERNAME` (default: `ubuntu`)
- `DEVBOX_NODE_MAJOR` (default: `22`)

### Make Shortcuts

```bash
make devbox-build
make devbox-up
make devbox-shell
make devbox-check
make devbox-down
```

### Dev Container (VS Code / compatible IDEs)

Open this folder in a Dev Container and use the `devbox` service from `docker-compose.yml`.
Current Dev Container defaults assume `DEVBOX_USERNAME=ubuntu`.
The post-create step validates:

- `node`, `npm`, `npx`
- `bun`
- `rustc`, `cargo`
- `opencode`

### Bun Script Entrypoints

Task scripts use shebang execution. Run them directly:

```bash
scripts/devbox.sh.ts up
scripts/devbox.sh.ts check
scripts/devbox.sh.ts shell
scripts/devbox.sh.ts down
scripts/install.sh.ts
scripts/install.sh.ts proto
```

## Agentic Workflow Model

- Use GitHub/GitLab services to drive agentic development through Issues, PRs/MRs, and Actions/CI.
- Treat issue descriptions as prompts and use labels to represent lifecycle state.

### Suggested Issue Lifecycle Labels

- `Draft`: issue created, no planning iteration yet.
- `Planning`: humans and agents iterate in-thread to finalize implementation details.
- `Develop`: implementation PRs/MRs are actively being authored.
- `Review`: changes are validated, reviewed, and refined; move back to `Develop` if needed.
- `Accepted`: implementation is complete and accepted.

### Runtime Pattern

- CI workflows run dockerized OpenCode agents that can read/write repository content and comment in issue/PR contexts.
- Future `ocx` profiles can map specialized behavior by role (for example: reviewer, docs, implementation).

## Issue Demo Workflow

The `Issue Demo` GitHub Action runs on issue open/edit events and via manual dispatch.

- Builds the `devbox` service from `docker-compose.yml`.
- Verifies `opencode` inside the container.
- Passes issue text into `opencode run`.
- Posts OpenCode output back to the issue as a comment.

Model provider credential secrets:

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `OPENCODE_API_KEY`

If none are configured, the workflow posts a guidance message instead of attempting a model call.

## Planning and Templates

- Roadmap and pending work live in `TODO.md`.
- Issue and PR scaffolds live in `docs/templates/`.
- Operator runbook lives in `docs/context/github-operator-loop.md`.

## GitHub CLI Loop

Use this baseline loop to drive issue-to-PR delivery with agent support:

1. Create or refine an issue from `docs/templates/issue.template.md`.
2. Move the issue state label (`Draft` -> `Planning` -> `Develop` -> `Review` -> `Accepted`).
3. Create a branch using the repository style (`vfp/agent/<topic>`).
4. Commit with the style in `STYLE.md`.
5. Open a PR using `docs/templates/pull_request.template.md`.

Example command sequence:

```bash
gh issue create --title "Docs // Improve README and TODO flow" --body-file docs/templates/issue.template.md --label Planning
git checkout -b vfp/agent/docs-readme-todo-flow
git commit -m "[<issue-number>] {System} // Improve docs workflow clarity (Tags: WIP)"
gh pr create --title "Docs // Improve README and TODO flow" --body-file docs/templates/pull_request.template.md
```

To manually run the issue demo workflow for a specific issue:

```bash
gh workflow run issue-demo.yml -f issue_number=123 -f issue_body="$(gh issue view 123 --json body -q .body)"
```
