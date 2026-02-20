# GitHub Operator Loop

This runbook describes the stage-based GitHub workflow model in `cursed-fab`.

## One-Time Setup

1. Authenticate CLI access:

```bash
gh auth status
```

2. Configure at least one model provider secret:

```bash
gh secret set OPENAI_API_KEY
# or
gh secret set ANTHROPIC_API_KEY
# or
gh secret set OPENCODE_API_KEY
# or
gh secret set OPENROUTER_API_KEY
```

3. Optional: set a default model override:

```bash
gh api --method POST repos/CursedFactory/cursed-fab/actions/variables \
  -f name='OPENCODE_MODEL' \
  -f value='openrouter/openai/gpt-5-mini' \
  || gh api --method PATCH repos/CursedFactory/cursed-fab/actions/variables/OPENCODE_MODEL \
    -f name='OPENCODE_MODEL' \
    -f value='openrouter/openai/gpt-5-mini'
```

4. Optional: refresh prebuilt devbox image:

```bash
gh workflow run devbox-image.yml
gh run list --workflow devbox-image.yml --limit 5
```

5. Optional: enforce curated labels via automation:

```bash
gh workflow run label-governance.yml
```

6. Optional: provide a token for PR creation in restricted repositories:

```bash
gh secret set AUTOMATION_PAT
```

Use this when repository policy blocks PR creation with the default `GITHUB_TOKEN`.

## Stage Workflows

### 1) Draft Intake + Planning/Review Replies

- Workflow: `.github/workflows/issue-stage-draft.yml`
- Trigger: issue `opened`
- Scope: applies `Draft` automatically when lifecycle labels are absent

- Workflow: `.github/workflows/issue-stage-thread.yml`
- Trigger: issue `opened`, `edited`, `reopened`, `labeled`
- Scope: comment-only stage guidance
- Core worker: `.github/workflows/issue-demo.yml` (`Issue Reply Core`)

### 2) Develop (Issue Kickoff to Draft PR)

- Workflow: `.github/workflows/issue-stage-develop.yml`
- Trigger: issue labeled `Develop`
- Output:
  - creates `docs/plans/issue-<n>-develop.plan.md`
  - creates a branch (`vfp/agent/issue-<n>-<slug>`)
  - opens a draft kickoff PR

### 3) PR Implementation (Code Editing Stage)

- Workflow: `.github/workflows/pr-stage-implement.yml`
- Trigger: comment on PR with:

```text
/agent-implement <task>
```

- Scope: implementation run that can commit/push to same-repo PR branches

## Manual Controls

Run issue-reply core directly:

```bash
gh workflow run issue-demo.yml -f issue_number=<issue-number> -f stage=Planning
```

Run issue-reply core with explicit model override:

```bash
gh workflow run issue-demo.yml -f issue_number=<issue-number> -f stage=Planning -f model="openrouter/openai/gpt-5-mini"
```

List recent runs:

```bash
gh run list --workflow issue-stage-thread.yml --limit 5
gh run list --workflow issue-stage-draft.yml --limit 5
gh run list --workflow issue-stage-develop.yml --limit 5
gh run list --workflow pr-stage-implement.yml --limit 5
```

## Response Formatting

- Stage reply conventions live in `REPLY.md`.
- Update `REPLY.md` to tune structure and tone without changing workflow logic.

## Merge and Close

After PR approval and merge:

```bash
gh issue edit <issue-number> --remove-label Review --add-label Accepted
gh issue close <issue-number>
```
