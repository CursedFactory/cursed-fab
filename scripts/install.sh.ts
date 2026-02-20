#!/usr/bin/env bun

import { dirname, resolve } from "node:path";
import { runCommand } from "./helpers/run_command.sh.ts";

type InstallMode = "all" | "proto";

const repoRoot = resolve(dirname(import.meta.dir));
const mode = (Bun.argv[2] as InstallMode | undefined) ?? "all";

if (mode === "all" || mode === "proto") {
  await runCommand(["scripts/proto_install.sh.ts"], { cwd: repoRoot });
  process.exit(0);
}

throw new Error(`Unknown install mode: ${mode}`);
