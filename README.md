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

## Stage Workflows

Automation is split by event type and lifecycle stage so behavior can be customized safely.

### Issue Stages - Intake and Reply

- Workflow: `.github/workflows/issue-stage-draft.yml` (auto-apply `Draft` on issue open when no lifecycle label exists)
- Workflow: `.github/workflows/issue-stage-thread.yml` (thread replies for `Draft`/`Planning`/`Review`)
- Trigger set: issue `opened`, `edited`, `reopened`, `labeled`
- Behavior: reply-only stage guidance; no repository write actions
- Uses reusable core workflow: `.github/workflows/issue-demo.yml`

### Issue Stage - Develop Kickoff

- Workflow: `.github/workflows/issue-stage-develop.yml`
- Trigger: issue labeled `Develop`
- Behavior: creates `docs/plans/issue-<n>-develop.plan.md`, creates a branch, and opens a draft kickoff PR
- If repository policy blocks Actions from creating PRs, workflow posts a manual `gh pr create` fallback command

### PR Stage - Implement

- Workflow: `.github/workflows/pr-stage-implement.yml`
- Trigger: PR comment command `'/agent-implement <task>'`
- Behavior: runs implementation flow and can commit/push changes to same-repo PR branches

### Shared Core Workflows

- `.github/workflows/issue-demo.yml`: reusable issue-reply core (`workflow_dispatch` + `workflow_call`)
- `.github/workflows/devbox-image.yml`: publishes `ghcr.io/<owner>/cursed-fab-devbox:main` for pull-first container reuse
- `.github/workflows/label-governance.yml`: keeps repository labels aligned to the curated stage/type set

Model provider credential secrets:

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `OPENCODE_API_KEY`
- `OPENROUTER_API_KEY`

If none are configured, the workflow posts a guidance message instead of attempting a model call.

Optional model override:

- `OPENCODE_MODEL` repository variable (for example: `openrouter/openai/gpt-5-mini`)
- `workflow_dispatch` input `model` on `issue-demo.yml`

Reply formatting and stage behavior contracts are defined in `REPLY.md`.

## Planning and Templates

- Roadmap and pending work live in `TODO.md`.
- Issue and PR scaffolds live in `docs/templates/`.
- Operator runbook lives in `docs/context/github-operator-loop.md`.
- Reply formatting contract lives in `REPLY.md`.

## GitHub CLI Loop

Use this baseline loop to drive issue-to-PR delivery with agent support:

1. Create or refine an issue from `docs/templates/issue.template.md`.
2. Move the issue state label (`Draft` -> `Planning` -> `Develop` -> `Review` -> `Accepted`).
3. Setting `Develop` triggers kickoff automation (plan doc + branch + draft PR).
4. Trigger implementation by commenting `/agent-implement <task>` on the PR.
5. Validate, merge, then move issue to `Accepted`.

Example command sequence:

```bash
gh issue create --title "System // Stage automation task" --body-file docs/templates/issue.template.md --label Draft
gh issue edit <issue-number> --remove-label Draft --add-label Planning
gh issue edit <issue-number> --remove-label Planning --add-label Develop
# wait for kickoff comment with draft PR URL, then comment on that PR:
# /agent-implement <task>
```

To manually run the reusable issue-reply core for a specific issue:

```bash
gh workflow run issue-demo.yml -f issue_number=123 -f stage=Planning
```

To force an OpenRouter model on manual dispatch:

```bash
gh workflow run issue-demo.yml -f issue_number=123 -f stage=Planning -f model="openrouter/openai/gpt-5-mini"
```

To trigger PR implementation behavior, comment on a PR thread:

```text
/agent-implement <task>
```
