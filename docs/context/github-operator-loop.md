# GitHub Operator Loop

This runbook describes a practical issue-to-PR loop using `gh`, `git`, and the repository conventions in `STYLE.md`.

## One-Time Setup

1. Authenticate CLI access:

```bash
gh auth status
```

2. Ensure lifecycle labels exist:

```bash
gh label create Draft --description "Issue created, no planning yet" --color BFD4F2
gh label create Planning --description "Issue is in planning iteration" --color FEF2C0
gh label create Develop --description "Implementation in progress" --color C2E0C6
gh label create Review --description "Work is in review" --color F9D0C4
gh label create Accepted --description "Implementation accepted" --color C5DEF5
```

If labels already exist, `gh` will return an error for that label; this is safe to ignore.

3. Configure at least one model credential secret if you want model-generated issue replies:

```bash
gh secret set OPENAI_API_KEY
# or
gh secret set ANTHROPIC_API_KEY
# or
gh secret set OPENCODE_API_KEY
# or
gh secret set OPENROUTER_API_KEY
```

4. Optional: set a repository-level default model override:

```bash
gh api --method POST repos/CursedFactory/cursed-fab/actions/variables \
  -f name='OPENCODE_MODEL' \
  -f value='openrouter/openai/gpt-5-mini' \
  || gh api --method PATCH repos/CursedFactory/cursed-fab/actions/variables/OPENCODE_MODEL \
    -f name='OPENCODE_MODEL' \
    -f value='openrouter/openai/gpt-5-mini'
```

5. Optional: prebuild the devbox image used by issue workflows:

```bash
gh workflow run devbox-image.yml
gh run list --workflow devbox-image.yml --limit 5
```

## Issue to Branch

1. Create an issue from template:

```bash
gh issue create --title "Docs // Improve README and TODO flow" --body-file docs/templates/issue.template.md --label Draft
```

2. Move it into planning once discussion starts:

```bash
gh issue edit <issue-number> --remove-label Draft --add-label Planning
```

3. Create your working branch (repository style: `vfp/agent/<name>`):

```bash
git checkout -b vfp/agent/<topic>
```

4. Move issue to development:

```bash
gh issue edit <issue-number> --remove-label Planning --add-label Develop
```

## Branch to PR

1. Commit changes (message style from `STYLE.md`):

```bash
git add README.md TODO.md
git commit -m "[<issue-number>] {System} // Improve docs workflow clarity (Tags: WIP)"
```

2. Push branch:

```bash
git push -u origin vfp/agent/<topic>
```

3. Open PR from template:

```bash
gh pr create --title "Docs // Improve README and TODO flow" --body-file docs/templates/pull_request.template.md
```

4. Move issue to review:

```bash
gh issue edit <issue-number> --remove-label Develop --add-label Review
```

## Optional: Trigger Issue Demo Workflow Manually

Run against a specific issue body using `workflow_dispatch`:

```bash
gh workflow run issue-demo.yml -f issue_number=<issue-number> -f issue_body="$(gh issue view <issue-number> --json body -q .body)"
```

Run with explicit model override:

```bash
gh workflow run issue-demo.yml -f issue_number=<issue-number> -f issue_body="$(gh issue view <issue-number> --json body -q .body)" -f model="openrouter/openai/gpt-5-mini"
```

Inspect the latest runs:

```bash
gh run list --workflow issue-demo.yml --limit 5
```

If issue runs are rebuilding too often, refresh the prebuilt image:

```bash
gh workflow run devbox-image.yml
```

## Merge and Close

After PR approval and merge:

1. Mark the issue as accepted:

```bash
gh issue edit <issue-number> --remove-label Review --add-label Accepted
```

2. Close the issue:

```bash
gh issue close <issue-number>
```
