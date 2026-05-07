# active-coding-rules

[简体中文说明](README.zh-CN.md)

`active-coding-rules` is a Codex Skill that turns a small set of practical coding rules into an installable, reusable agent behavior package.

Its job is simple: make coding agents slower to assume, faster to verify, and less likely to overengineer or make unrelated edits.

This repository packages Karpathy-inspired coding guardrails into a structure that can be installed under a Codex skills directory and used directly in day-to-day coding work.

## What This Skill Does

This skill pushes the agent toward four behaviors:

- **Think Before Coding**: surface assumptions and ambiguity before implementation.
- **Simplicity First**: solve the current problem with the minimum code necessary.
- **Surgical Changes**: keep diffs narrow and avoid drive-by refactors.
- **Goal-Driven Execution**: define success criteria and verify with the tightest relevant check.

In practice, this means the agent is more likely to:

- inspect local code before proposing a solution
- ask or state assumptions when ambiguity changes behavior
- avoid speculative abstractions and unnecessary flexibility
- make smaller, more reviewable edits
- run focused validation instead of declaring success too early
- produce better code reviews with concrete findings and verification notes

## Who This Is For

Use this skill if you want your coding agent to behave more like a disciplined senior engineer and less like an autocomplete engine.

It is especially useful when you care about:

- keeping PRs small and easy to review
- reducing hidden assumptions in implementation
- preventing unnecessary rewrites and refactors
- forcing clearer verification after each change
- making code review output concrete and actionable

## Language Coverage

This is a **language-agnostic behavior skill**.

It works well with Python, TypeScript, JavaScript, Go, Rust, Java, C, and C++ because it changes how the agent works, not just what syntax it writes.

For C and C++, this skill is helpful, but it is **not** a replacement for language-specific engineering rules. You should still pair it with your normal toolchain and checks, such as:

- CMake, Ninja, Make, or your existing build system
- compiler warnings and standard version flags
- unit tests and integration tests
- sanitizers such as ASan and UBSan
- static analysis and formatting rules used by your project

## Quick Start

### 1. Clone or download this repository

Put the repository anywhere you want to maintain it locally.

### 2. Install the skill with the provided script

The repository includes an `install.sh` helper that creates a symlink named `active-coding-rules` inside your Codex skills parent directory.

Example:

```bash
chmod +x install.sh
./install.sh -path "$HOME/.codex/skills"
```

Important:

- pass the **parent directory** of your skills folder
- do **not** append `/active-coding-rules` yourself
- the script will create the symlink for you

For example, if your skills are normally installed under:

```bash
$HOME/.codex/skills/
```

then the correct command is:

```bash
./install.sh -path "$HOME/.codex/skills"
```

### 3. Verify the install

You should see a symlink like this under your skills directory:

```bash
ls -l "$HOME/.codex/skills/active-coding-rules"
```

If the skill is already installed and points to the same source directory, the installer exits cleanly and reports that it is already installed.

## How To Use It

In environments that support explicit skill invocation, reference the skill directly in your prompt.

Examples:

```text
$active-coding-rules fix the failing test in src/parser.cpp and verify with the narrowest command.
```

```text
$active-coding-rules review this patch and list concrete findings ordered by severity.
```

```text
$active-coding-rules refactor this function without changing behavior, then tell me exactly what you verified.
```

```text
$active-coding-rules debug this crash, reproduce it first, make the smallest fix, and avoid unrelated cleanup.
```

## What Behavior To Expect

After applying this skill, the agent should tend to follow a loop like this:

1. Clarify the goal, constraints, and expected behavior.
2. Inspect the local code before deciding on an approach.
3. State meaningful assumptions when ambiguity affects implementation.
4. Make the smallest change that satisfies the request.
5. Verify with the most relevant test, build, lint, or manual check.
6. Report what changed, what was verified, and any remaining risk.

That leads to a few practical changes in day-to-day use:

- fewer big speculative rewrites
- fewer hidden assumptions
- fewer “done” claims without validation
- smaller diffs with clearer intent
- better review output with more actionable findings

## When To Use It

This skill is a strong default for:

- bug fixes
- refactors that must preserve behavior
- debugging ambiguous failures
- code reviews
- small and medium scoped feature work
- tasks where verification quality matters as much as implementation speed

It is less useful as the only guidance for:

- language-specific architecture decisions
- framework-specific conventions
- platform-specific build and release workflows
- specialized domains that need their own detailed policy

## Repository Structure

```text
.
├── README.md
├── install.sh
└── active-coding-rules/
	├── SKILL.md
	├── agents/
	│   └── openai.yaml
	└── references/
		├── core-rules.md
		└── karpathy-examples.md
```

Key files:

- `active-coding-rules/SKILL.md`: the main skill definition and operating instructions
- `active-coding-rules/references/core-rules.md`: expanded checklist for non-trivial coding tasks
- `active-coding-rules/references/karpathy-examples.md`: examples and anti-patterns that calibrate expected behavior
- `install.sh`: installation helper that creates the symlink into your skills directory

## Local Development

Because installation uses a symlink, changes you make in this repository are reflected immediately in the installed skill.

That means you usually do **not** need to reinstall after editing the skill files, unless you delete or move the symlink.

## Validate The Skill

If your local Codex setup includes the validator script, you can run:

```bash
python "$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py" active-coding-rules
```

If your validator is installed in a different location, adjust the path accordingly.

## Uninstall

To remove the installed skill, delete the symlink from your skills directory:

```bash
rm -f "$HOME/.codex/skills/active-coding-rules"
```

This removes only the installed link, not the repository itself.

## FAQ

### Do I pass the final skill directory or the parent directory?

Pass the parent directory.

Correct:

```bash
./install.sh -path "$HOME/.codex/skills"
```

Incorrect:

```bash
./install.sh -path "$HOME/.codex/skills/active-coding-rules"
```

### Do I need to reinstall after changing the skill files?

Usually no. The installed entry is a symlink to this repository.

### What happens if the target already exists?

- if the existing symlink already points to this repository, installation succeeds with an “already installed” message
- if the target points somewhere else, the script exits with an error
- if a normal file or directory already exists at that path, the script exits with an error

## Source And Intent

This repository ports the reusable guidance from the local `andrej-karpathy-skills` project into a Codex Skill structure while intentionally leaving out Claude/Cursor-specific installation files and nested `.git` data.

The goal is not to create a large framework. The goal is to create a small, reusable operating discipline for coding agents.
