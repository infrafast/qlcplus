# Codex Context — QLC+ 5 Raspberry Pi ARM64 Cross-Build Setup

## Current session checkpoint — 2026-08-13

This section is the authoritative restart point for the next Codex session.

### Current repository state

- Current branch: `dev-984f0e7`
- Current committed HEAD before the pending fix: `d4c4d4d78`
- HEAD description: `Add Raspberry Pi ARM64 Codespaces cross-build environment`
- Remote tracking branch: `origin/dev-984f0e7`
- `CODEX_QLCPLUS5_RPI_ARM64_CONTEXT.md` is currently untracked. Preserve it.
- `.devcontainer/Dockerfile` has one intentional, uncommitted modification described below.
- `.devcontainer/devcontainer.json` has one intentional, uncommitted
  modification: `openai.chatgpt` was added to `customizations.vscode.extensions`
  so the OpenAI extension is automatically installed again after rebuilds.

### What has already been validated

The devcontainer was rebuilt successfully and the following command passed:

```bash
./scripts/raspi/check-env.sh
```

Validated results:

- QLC+ CMake project detected;
- Codespace host architecture is `amd64`;
- target architecture is `arm64`;
- the `aarch64-linux-gnu` cross-toolchain is available;
- ARM64 Qt 6 CMake packages are detected at `/usr/lib/aarch64-linux-gnu/cmake/Qt6`;
- the toolchain file is `cmake/toolchains/raspberry-pi-arm64.cmake`.

### First CMake configuration result

The following command was executed:

```bash
./scripts/raspi/configure.sh
```

CMake correctly detected the ARM64 GCC/G++ compilers, ARM64 OpenGL, XKB,
threads and atomic support. Configuration then failed because the required
Qt component `LinguistTools` could not be found:

```text
Failed to find required Qt component "LinguistTools".
Expected Config file at
"/usr/lib/aarch64-linux-gnu/cmake/Qt6LinguistTools/Qt6LinguistToolsConfig.cmake"
does not exist
```

The non-blocking output also reported that CUPS was not found. Do not address
CUPS until CMake is rerun and it is confirmed to be required for this build.

### Diagnosis and pending fix

The native Qt executable `/usr/lib/qt6/bin/lrelease` is already present, but
`Qt6LinguistToolsConfig.cmake` is absent. Debian's native
`qt6-tools-dev:amd64` package supplies the missing development integration and
depends on `qt6-tools-dev-tools`.

An APT simulation was performed:

```bash
sudo apt-get install --simulate --no-install-recommends qt6-tools-dev:amd64
```

It proposed only native package additions and did not remove or replace the
installed ARM64 target packages.

The persistent fix has therefore already been applied to
`.devcontainer/Dockerfile`: `qt6-tools-dev` was added to the native Qt package
list. `git diff --check` passed. This change is not committed yet.

The installed OpenAI extension identifier was verified with
`code --list-extensions` as `openai.chatgpt`, then added to
`.devcontainer/devcontainer.json` for persistence across container rebuilds.

Git push initially failed because the repository's pre-push hook requires Git
LFS but `git-lfs` was missing. `git-lfs` was therefore added to the native
package list in `.devcontainer/Dockerfile` so pushes continue working after
future rebuilds.

### Exact next action

The user must now run this VS Code command:

```text
Dev Containers: Rebuild Container
```

After the new session reconnects, do not immediately build. Resume with these
steps one at a time, stopping after each one to report and obtain user
confirmation:

1. Read this checkpoint and inspect `git status` plus the Dockerfile diff.
2. Run `./scripts/raspi/check-env.sh`.
3. Confirm that `Qt6LinguistToolsConfig.cmake` now exists (normally from the
   native `qt6-tools-dev` package).
4. Rerun `./scripts/raspi/configure.sh` and inspect the complete result.
5. If configuration succeeds, wait for confirmation before starting the build.

Do not commit, discard, reset or clean the pending changes unless the user
explicitly requests it.

## Purpose

You are connected to the user's fork of the official QLC+ repository.

Your role is to guide the user step by step and, when appropriate, directly inspect or modify the repository in order to set up and validate a GitHub Codespaces development environment capable of cross-compiling QLC+ 5 for Raspberry Pi 5 ARM64.

The user will manually upload and unzip the following archive at the root of the fork:

```text
qlcplus5-rpi-arm64-codespaces.zip
```

The archive has already been generated and contains the Codespaces/devcontainer and ARM64 cross-build support files described below.

The user wants to work from the QLC+ source state corresponding to commit:

```text
984f0e7
```

Do not assume that the current branch or current checkout already points to that commit. Verify it.

---

# User workflow preference

This is critical.

The user wants to proceed **one step at a time**.

You must:

1. Give only the next concrete action.
2. Wait for the user to provide the result or confirm success.
3. Validate that result.
4. Only then move to the next step.

Do not dump the whole migration procedure into one answer unless explicitly asked.

When terminal commands are required:

- Prefer short commands.
- Prefer one command per line.
- Avoid unnecessary shell escaping.
- Avoid line continuations with `\\` where possible.
- Do not assume a command succeeded until the user shows or confirms the result.
- Explain briefly what each command is checking or changing.

If you can inspect the repository directly through Codex, do so before asking the user to run unnecessary diagnostic commands.

---

# Repository context

The target project is QLC+ 5.

Upstream repository:

```text
mcallegari/qlcplus
```

The user is working in their own fork.

The target source commit is:

```text
984f0e7
```

The goal is to create a development branch starting from that commit rather than working in detached HEAD state.

Preferred branch name:

```text
dev-984f0e7
```

The desired source history is conceptually:

```text
QLC+ upstream history
        |
        +-- 984f0e7
              |
              +-- dev-984f0e7
                    |
                    +-- user's future modifications
```

Before creating the branch, verify whether:

- commit `984f0e7` is present locally;
- the branch already exists;
- there are uncommitted changes;
- the uploaded Codespaces ZIP has already been extracted.

Never overwrite or discard existing user work.

---

# Important Git safety rules

Before switching branches or checking out the target commit:

1. Run or inspect the equivalent of:

```bash
git status
```

2. Preserve all existing user modifications.

3. If the working tree contains modifications, do not reset, clean, checkout destructively, or overwrite them without explicit user approval.

4. Do not use:

```bash
git reset --hard
```

unless the user explicitly asks for a destructive reset and understands the consequences.

5. Do not use:

```bash
git clean -fd
```

without explicit user approval.

6. Prefer creating a branch from the exact commit:

```bash
git switch -c dev-984f0e7 984f0e7
```

If that branch already exists, inspect it rather than recreating it blindly.

7. If the target commit is not available locally, fetch the required Git history before proceeding.

---

# Cross-build archive expected at repository root

The user will upload and unzip:

```text
qlcplus5-rpi-arm64-codespaces.zip
```

The archive is expected to add these files:

```text
.devcontainer/devcontainer.json
.devcontainer/Dockerfile
.devcontainer/post-create.sh

cmake/toolchains/raspberry-pi-arm64.cmake

scripts/raspi/common.sh
scripts/raspi/check-env.sh
scripts/raspi/configure.sh
scripts/raspi/build.sh
scripts/raspi/package.sh
scripts/raspi/clean.sh
scripts/raspi/all.sh

.vscode/tasks.json
.vscode/settings.json

README-RASPBERRY-CROSSBUILD.md
INSTALL-FIRST.txt
```

The archive is designed to add development environment files only.

It should not intentionally replace QLC+ source files.

After extraction, verify the actual repository diff before committing anything.

Useful inspection:

```bash
git status
```

and, where relevant:

```bash
git diff --stat
```

Do not assume the archive contents match this document if the actual files differ. Inspect the files present in the repository and use the repository as the source of truth.

---

# Technical target

The build target is:

```text
Raspberry Pi 5
Linux ARM64 / AArch64
64-bit Raspberry Pi OS / Debian-compatible environment
```

The user does not want macOS handled by this environment.

macOS will be compiled separately and natively on macOS.

The Codespace itself is expected to run on x86-64 Linux.

The cross-compilation target is ARM64 using:

```text
aarch64-linux-gnu-gcc
aarch64-linux-gnu-g++
```

The QLC+ 5 build is expected to use:

```text
CMake
Qt 6
-Dqmlui=ON
```

The expected QLC+ 5 executable is typically:

```text
qlcplus-qml
```

A likely build output path is:

```text
build-rpi-arm64/qmlui/qlcplus-qml
```

However, do not hard-code assumptions if upstream QLC+ at commit `984f0e7` uses a different output path. Inspect the actual CMake build structure.

---

# Devcontainer design

The supplied devcontainer is intended to:

- keep the Codespace host architecture as amd64/x86-64;
- install an ARM64 GCC/G++ cross compiler;
- enable Debian ARM64 multiarch packages;
- install ARM64 Qt6 development libraries;
- install native host-side Qt6 development tools required during the build;
- avoid full ARM emulation;
- produce ARM64 Linux binaries that are then tested on the Raspberry Pi.

Important:

The ARM64 binary is not expected to run directly inside the x86-64 Codespace.

Validation in Codespaces should therefore include checking the output with:

```bash
file <path-to-qlcplus-qml>
```

The desired result must indicate an ARM64/AArch64 ELF executable.

---

# Expected helper scripts

The archive provides these commands.

Environment check:

```bash
./scripts/raspi/check-env.sh
```

Configure:

```bash
./scripts/raspi/configure.sh
```

Build:

```bash
./scripts/raspi/build.sh
```

Package:

```bash
./scripts/raspi/package.sh
```

Full sequence:

```bash
./scripts/raspi/all.sh
```

Clean generated files:

```bash
./scripts/raspi/clean.sh
```

Do not immediately run `all.sh` before validating that:

- the devcontainer has rebuilt successfully;
- ARM64 compiler tools exist;
- required target Qt6 libraries are present;
- CMake recognizes the QLC+ source tree;
- the supplied scripts are compatible with commit `984f0e7`.

If any supplied script is incorrect for this exact commit, fix the development-environment files rather than modifying QLC+ source code unless the source genuinely requires modification.

---

# Compatibility requirement with the Raspberry Pi

The user intends to deploy the resulting binary to a Raspberry Pi 5.

Before treating the cross-build as production-valid, confirm the Raspberry Pi OS version.

The relevant Raspberry Pi commands are:

```bash
cat /etc/os-release
```

and:

```bash
uname -m
```

Expected architecture:

```text
aarch64
```

The development container currently targets Debian 13 / Trixie style ARM64 development packages.

If the Raspberry Pi runs Debian 12 / Bookworm or another significantly different runtime, do not assume ABI compatibility.

In that case, explicitly explain the mismatch and adapt the cross-build environment so that its target sysroot/library versions match the Pi runtime as closely as practical.

The goal is not merely to produce "an ARM64 binary"; the goal is to produce a binary compatible with the actual Raspberry Pi runtime.

---

# Validation sequence

## Phase 1 — Repository safety

Verify:

```text
current branch
working tree state
remote/fork state
presence of commit 984f0e7
```

Do not modify anything yet unless needed.

## Phase 2 — Target branch

Create or switch safely to:

```text
dev-984f0e7
```

based exactly on:

```text
984f0e7
```

Verify:

```bash
git rev-parse HEAD
```

The commit should resolve to the intended source state before user modifications are committed.

## Phase 3 — ZIP extraction

The user will upload and unzip the generated archive at repository root.

Inspect:

```text
.devcontainer/
.vscode/
cmake/toolchains/
scripts/raspi/
README-RASPBERRY-CROSSBUILD.md
INSTALL-FIRST.txt
```

Confirm no unintended upstream source files were replaced.

## Phase 4 — Commit environment files

Only after inspection, add and commit the environment files to the user's branch.

Suggested commit message:

```text
Add Raspberry Pi ARM64 Codespaces cross-build environment
```

Do not commit generated build directories.

## Phase 5 — Rebuild devcontainer

Guide the user to rebuild the Codespace container.

Preferred VS Code command:

```text
Dev Containers: Rebuild Container
```

If Codespaces automatically rebuilds from `.devcontainer`, adapt to the actual UI/environment.

## Phase 6 — Environment validation

Run:

```bash
./scripts/raspi/check-env.sh
```

Verify:

```text
host = amd64
target = arm64
aarch64-linux-gnu-g++
Qt6 ARM64 target CMake packages
CMake source project detected
```

## Phase 7 — CMake configure

Run:

```bash
./scripts/raspi/configure.sh
```

Inspect all CMake errors carefully.

Do not "solve" missing dependency errors by disabling random QLC+ components unless there is a documented reason.

Prefer installing the required ARM64 development package or correcting the toolchain/sysroot configuration.

## Phase 8 — Build

Run:

```bash
./scripts/raspi/build.sh
```

If the build fails:

- identify the first real compiler/linker failure;
- distinguish host-tool problems from target-library problems;
- inspect QLC+ CMake logic at commit `984f0e7`;
- make the minimum necessary fix;
- document the reason.

## Phase 9 — Architecture verification

Locate the generated `qlcplus-qml` binary and run:

```bash
file <binary>
```

It must be ARM64/AArch64.

Also inspect linked library expectations when useful, for example with an ARM-compatible `readelf` invocation.

## Phase 10 — Packaging

Run:

```bash
./scripts/raspi/package.sh
```

Verify the archive under:

```text
out/
```

Do not treat packaging success as runtime validation.

## Phase 11 — Raspberry Pi runtime test

Once the user is ready, guide the transfer and runtime validation on the actual Raspberry Pi 5.

Do not overwrite the user's known-working QLC+ installation blindly.

Prefer a safe test location or backup first.

---

# Repository hygiene

Generated directories such as:

```text
build-rpi-arm64/
out/
```

should not normally be committed.

If not already ignored, consider adding only the necessary ignore entries to `.gitignore`.

Before changing `.gitignore`, inspect whether equivalent rules already exist.

Do not make unrelated formatting or cleanup changes in the upstream QLC+ source tree.

Keep the fork easy to sync/rebase with upstream.

---

# Scope of source-code changes

The initial task is infrastructure only.

Do not modify QLC+ application behavior merely to get the environment installed.

QLC+ source modifications may come later.

For this initial setup, source-code edits are acceptable only if:

- commit `984f0e7` genuinely requires a small build-system compatibility fix;
- the reason is understood;
- the change is clearly separated from the Codespaces infrastructure changes.

If source changes become necessary, propose creating a separate commit.

---

# Expected interaction style

Guide the user as an engineering pair.

At every stage:

- state what you verified;
- state the next single action;
- give the exact command if needed;
- ask the user to paste the result;
- validate it before continuing.

Do not assume success.

Do not jump directly from repository setup to deployment.

The user explicitly wants a controlled, step-by-step workflow.

---

# First action to perform

When this document is first given to you, begin by inspecting the repository.

Determine:

```text
current branch
HEAD commit
git status
available remotes
whether commit 984f0e7 exists
whether dev-984f0e7 already exists
whether the Codespaces ZIP has already been extracted
```

Do not immediately create or change branches before this inspection.

Then report the findings briefly and give the user only the next safe action.

If repository inspection shows uncommitted user work, preserve it and adapt the plan.

---

# Success criteria

The setup is complete only when all of the following are true:

- the working development branch originates from QLC+ commit `984f0e7`;
- the Codespaces environment files are installed in the fork;
- the devcontainer rebuilds successfully;
- QLC+ 5 configures with CMake for ARM64;
- QLC+ 5 builds successfully;
- `qlcplus-qml` is verified as ARM64/AArch64;
- a deployment archive can be produced;
- compatibility with the actual Raspberry Pi OS is checked;
- the final binary is tested on the Raspberry Pi 5 without destroying the known-working installation.

Until then, continue one validated step at a time.
