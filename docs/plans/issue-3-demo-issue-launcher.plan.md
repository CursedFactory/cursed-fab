# Issue #3 Plan - Demo Issue Launcher Container with OpenCode

## Objective
Demonstrate that our GitHub Actions workflow can run inside the project devcontainer, invoke OpenCode from that container, and post a response based on the issue description.

## Implementation Plan
- Update the demo GitHub Action to run using the repo devcontainer setup.
- Add a step that invokes OpenCode with the issue body (for example: `opencode run "$ISSUE_DESC"`).
- Capture the OpenCode output and publish it back to the issue as a comment.

## Gate Checks
- Devcontainer and docker compose stack build successfully.
- OpenCode runs inside the container and answers a basic prompt.
- GitHub Action can run with the devcontainer without container startup/runtime errors.
- GitHub Action posts an issue response generated from the issue description.

## Notes
- Start with the existing devcontainer as the base image/runtime.
- Free model usage is acceptable for this demo workflow.
