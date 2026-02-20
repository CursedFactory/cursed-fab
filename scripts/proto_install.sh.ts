#!/usr/bin/env bun

import { dirname, resolve } from "node:path";
import { runCommand } from "./helpers/run_command.sh.ts";

const repoRoot = resolve(dirname(import.meta.dir));

await runCommand(["proto", "install"], { cwd: repoRoot });
