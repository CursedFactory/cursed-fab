# REPLY.md

This file defines formatting and behavior rules for automated GitHub replies.

## Issue Stage Reply Contract

- Keep replies concise and actionable.
- Use this structure:
  1. `### Stage Update`
  2. `**What I understood**` (1-3 bullets)
  3. `**Proposed next steps**` (1-3 bullets)
  4. `**Needs input**` (only if actually blocked)
- Never include raw command logs, stack traces, or ANSI output in the main reply body.
- If execution fails, summarize the failure in plain language and suggest one recovery step.

## PR Implementation Reply Contract

- Use this structure:
  1. `### Implementation Update`
  2. `**Applied changes**` (short bullets)
  3. `**Validation**` (what was checked)
  4. `**Follow-ups**` (optional)
- If files were changed, mention file paths directly.
- If no files changed, explain why and what command/request should be used next.

## Global Rules

- Do not ask broad open-ended questions.
- Ask at most one targeted clarification when blocked.
- Prefer deterministic, stage-specific language over generic assistant prose.
