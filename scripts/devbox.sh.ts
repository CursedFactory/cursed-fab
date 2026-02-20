#!/usr/bin/env bun

import { dirname, resolve } from "node:path";
import { runCommand } from "./helpers/run_command.sh.ts";

type Mode = "build" | "up" | "shell" | "check" | "down";

const repoRoot = resolve(dirname(import.meta.dir));
const mode = (Bun.argv[2] as Mode | undefined) ?? "up";

if (mode === "build") {
  await runCommand(["docker", "compose", "build", "devbox"], { cwd: repoRoot });
  process.exit(0);
}

if (mode === "up") {
  await runCommand(["docker", "compose", "up", "--build", "-d", "devbox"], {
    cwd: repoRoot,
  });
  process.exit(0);
}

if (mode === "shell") {
  await runCommand(["docker", "compose", "exec", "devbox", "bash"], {
    cwd: repoRoot,
  });
  process.exit(0);
}

if (mode === "check") {
  await runCommand(
    [
      "docker",
      "compose",
      "run",
      "--rm",
      "devbox",
      "bash",
      "-lc",
      "node -v && npm -v && npx -v && bun -v && rustc -V && cargo -V && opencode --version",
    ],
    { cwd: repoRoot },
  );
  process.exit(0);
}

if (mode === "down") {
  await runCommand(["docker", "compose", "down"], { cwd: repoRoot });
  process.exit(0);
}

throw new Error(`Unknown mode: ${mode}`);
