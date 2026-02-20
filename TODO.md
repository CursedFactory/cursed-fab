# TODO

## Agent Runtime Backlog

- [x] Guard issue demo workflow against missing credentials and stalled OpenCode runs
- [x] Add OpenRouter credential/model override path in issue demo workflow
- [x] Prebuild devbox image in dedicated workflow and reuse it in issue-demo with build fallback
- [x] Split stage automation into issue-thread, develop-kickoff, and PR-implementation workflows
- [x] Add develop-stage automation to write kickoff plan docs and open draft PRs
- [x] Add PR command workflow (`/agent-implement`) that can push implementation commits
- [x] Improve issue reply formatting with structured prompt contract (`REPLY.md`) and clean comment output
- [x] Remove unused default labels and add label governance workflow
- [x] Add develop kickoff fallback path when workflow token cannot create PRs
- [ ] Setup `ocx` profiles for core agent roles and stages
- [ ] Implement profile launcher that selects profile by action/event type and stage
  - [ ] Map issue planning flow (example: `issue_planning`)
  - [ ] Map PR comment flow (example: `pr_comment`)
  - [ ] Map PR commit flow (example: `pr_commit`)
  - [ ] Define default/fallback profile behavior for unknown events
- [ ] Add demo workflow step for writing files through agent execution
- [ ] Add demo workflow step for comment reply behavior in issue/PR threads

## Documentation and Process

- [x] Clarify README quick start and workflow model
- [x] Document GitHub CLI loop for issue -> branch -> commit -> PR
- [x] Add a contributor runbook for issue lifecycle operations (`gh issue`, labels, and workflow dispatch)
