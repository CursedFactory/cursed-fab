# cursed-fab
Git-host (GitLab/GitHub) based - agentic development using Issues, Actions, PRs as interface and dockerized OpenCode agents as actors. 

## Dev Box

This repo now includes a Docker and Dev Container setup for agentic development.

- Base image: Ubuntu 24.04 (lean package set)
- Included tools: OpenCode CLI, Node.js (with npm/npx), Bun, Rust (rustup/cargo), and common CLI dev utilities

### Docker Compose

Optional overrides are read from `.env` (copy from `.env.example`):

```bash
cp .env.example .env
```

Current overrides:

- `DEVBOX_USERNAME` (default: `ubuntu`)
- `DEVBOX_NODE_MAJOR` (default: `22`)

Build and start the development container:

```bash
docker compose up --build -d
```

Open a shell inside it:

```bash
docker compose exec devbox bash
```

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
Dev Container currently assumes `DEVBOX_USERNAME=ubuntu`.
The post-create step validates installs for:

- `node`, `npm`, `npx`
- `bun`
- `rustc`, `cargo`
- `opencode`

### Bun Script Entrypoints

Bun task scripts in this repo use shebang execution. Run them directly:

```bash
scripts/devbox.sh.ts up
scripts/devbox.sh.ts check
scripts/devbox.sh.ts shell
scripts/devbox.sh.ts down
scripts/install.sh.ts
scripts/install.sh.ts proto
```


## Concept Notes

- Use GitHub/GitLab services to enable agentic development
  - Involves using their Issue, PR/MR, and Action/CI features as the interface for the agents to interact with the codebase and development process.
- Issues act the entry point for agents, with humans/agents
  - Treat the descr like a prompt
  - Use labels to track current state
    - Draft - Just created, no iteration yet
    - Planning - Agents can now reply in the issue thread back and forth to plan out the implementation details, with the goal of creating a clear implementation plan that can be executed on.
    - Develop - Once the plan is solidified, the issue can be moved to this state, where agents can now start creating PRs/MRs to implement the feature or fix the bug described in the issue.
    - Review - Once the implementation is done, the issue can be moved to this state, where agents can now review the code, run tests, and provide feedback. This can involve multiple iterations of review and feedback until the implementation is solidified and ready to be merged. Moves back into Develop if changes are needed.
    - Acccepted - Done.
- Spawned CI actions run dockerized OpenCode agents that can read/write to the repo, comment on issues/PRs/MRs, and trigger other actions as needed. These agents can be designed to have specific roles or expertise, such as a "Code Reviewer" agent that specializes in reviewing code for best practices and potential bugs, or a "Documentation" agent that focuses on improving the documentation of the codebase
  - Will use ocx to create the profiles for a given agent, which will determine its behavior and capabilities. For example, a "Code Reviewer" agent might have a profile that emphasizes code quality and best practices, while a "Documentation" agent might have a profile that focuses on clarity and comprehensiveness in documentation.

## Issue Demo Workflow

The `Issue Demo` GitHub Action runs when issues are opened or edited.

- It builds the project `devbox` from `docker-compose.yml`.
- It verifies `opencode` is available inside that container.
- It passes the issue description into `opencode run` inside the container.
- It posts the OpenCode output back to the issue as a comment.

Optional secrets for model provider credentials:

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `OPENCODE_API_KEY`

    
