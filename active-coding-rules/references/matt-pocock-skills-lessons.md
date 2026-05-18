# Lessons from Matt Pocock's Skills

This document captures what `active-coding-rules` should learn from the local `skills/` repository by Matt Pocock, filtered through agent-skill engineering best practices. It is not a copy plan. It is an adaptation plan for keeping `active-coding-rules` small, composable, and useful during real coding work.

## Executive Summary

Matt's repository succeeds because it turns broad engineering wisdom into small, triggerable workflows. Each skill has a narrow job, a crisp trigger description, and deeper reference files only where the task needs them.

`active-coding-rules` should keep its current role as the default behavioral guardrail: think first, keep changes small, verify concretely. The best way to absorb Matt's ideas is not to make `SKILL.md` huge. Instead, use progressive disclosure:

- keep the main skill short and always useful;
- add optional task-mode references for diagnosis, TDD, architecture review, prototype work, and durable task briefs;
- teach the agent to choose the right workflow shape when a task is complex;
- add small deterministic scripts only when repeated validation or manifest checks become error-prone.

## What To Learn

### 1. Small, Composable Skills Beat One Giant Process

Matt's active skills are split by job: `diagnose`, `tdd`, `prototype`, `to-prd`, `to-issues`, `triage`, `zoom-out`, `grill-with-docs`, and so on. This keeps each workflow clear enough that the agent can enter with the right mindset.

Best-practice principle:

- A skill should be an operational behavior, not a knowledge dump.
- The description should say exactly when to trigger it.
- Details should live in references loaded only when needed.

Adaptation for `active-coding-rules`:

- Keep `active-coding-rules` as the umbrella discipline.
- Add task-mode reference files only when they carry distinct operational value.
- Avoid turning the main `SKILL.md` into a full engineering handbook.

### 2. Progressive Disclosure Is The Core Skill Architecture

Matt's repository uses short `SKILL.md` files plus adjacent files like `LANGUAGE.md`, `DEEPENING.md`, `LOGIC.md`, `UI.md`, `AGENT-BRIEF.md`, and `OUT-OF-SCOPE.md`.

Best-practice principle:

- Metadata is always loaded, so it must be precise.
- `SKILL.md` should contain the routing and core loop.
- Reference files should hold examples, templates, and uncommon branches.
- Scripts should handle deterministic or fragile operations.

Adaptation for `active-coding-rules`:

- Keep the main operating loop in `SKILL.md`.
- Put richer workflows in `references/`.
- Use one-level reference links from `SKILL.md`; avoid nested reference chasing.
- Treat examples as calibration, not mandatory context for every task.

### 3. Feedback Loops Are More Important Than Code Reading

The strongest idea in `diagnose` is that debugging starts by building a fast, deterministic pass/fail signal. The skill treats this as the whole game: failing test, curl script, CLI fixture, browser script, replayed trace, throwaway harness, fuzz loop, bisect harness, differential loop, or a structured human-in-the-loop script.

Best-practice principle:

- A bug without a feedback loop is mostly speculation.
- Reproduction must match the user's symptom, not a nearby failure.
- Hypotheses should be falsifiable and ranked before probes begin.
- Debug instrumentation should be targeted, tagged, and removed.

Adaptation for `active-coding-rules`:

- Upgrade "verify with the relevant command" into "construct the tightest feedback loop."
- For hard bugs, require reproduction or an explicit explanation of why reproduction is blocked.
- Encourage 3-5 ranked hypotheses only after a loop exists.
- Add debug-log tagging guidance such as `[DEBUG-xxxx]` for cleanup.
- Treat "no correct regression seam exists" as an architecture finding.

### 4. Alignment Requires Structured Grilling, Not Vague Clarification

`grill-me` and `grill-with-docs` convert ambiguity into a deliberate interview. The important pattern is not asking lots of questions; it is walking the decision tree one branch at a time, offering a recommended answer, and exploring the codebase instead of asking when the answer is discoverable.

Best-practice principle:

- Ask only questions that change the implementation or decision.
- Ask one question at a time when human judgment is needed.
- Provide a recommended answer so the user can accept, reject, or refine.
- Use concrete scenarios to expose hidden edge cases.

Adaptation for `active-coding-rules`:

- Preserve the current "ask when ambiguity changes behavior" rule.
- For complex plans, turn clarification into a bounded design interrogation.
- Prefer code exploration over user questions for facts already present in the repo.
- Record resolved terms and decisions when they will matter later.

### 5. Shared Language Reduces Agent Drift

Matt's `CONTEXT.md` pattern is a lightweight domain glossary. It defines project-specific terms, aliases to avoid, relationships, example dialogue, and flagged ambiguities. It explicitly avoids implementation details.

Best-practice principle:

- Domain vocabulary is a tool for code navigation, naming, tests, issues, and summaries.
- A glossary should define what a term is, not how it is implemented.
- Conflicting terms should be resolved explicitly.
- Multi-context repos need a map so the agent reads the right glossary.

Adaptation for `active-coding-rules`:

- For non-trivial work, look for `CONTEXT.md`, `CONTEXT-MAP.md`, and ADRs before naming concepts or proposing architecture.
- If they do not exist, proceed silently; do not force documentation work into every coding task.
- Encourage agents to use project vocabulary in test names, issue titles, hypotheses, and final reports.
- Avoid inventing synonyms where the repo already has a term.

### 6. ADRs Should Be Tiny And Rare

Matt's ADR format is intentionally small: a numbered markdown file with a short title and one to three sentences. ADRs are offered only when the decision is hard to reverse, surprising without context, and the result of a real trade-off.

Best-practice principle:

- Architecture memory should be cheap enough to write and useful enough to read.
- ADRs should stop future agents from re-litigating deliberate choices.
- Not every implementation detail deserves an ADR.

Adaptation for `active-coding-rules`:

- Mention ADRs as optional durable memory for load-bearing decisions.
- Do not add ADR creation to the default loop.
- Recommend ADRs when the agent is about to encode a surprising or costly architectural choice.

### 7. TDD Works Best As Vertical Slices

Matt's `tdd` skill is strict about red-green-refactor, but the more valuable point is vertical slicing: one behavior test, one minimal implementation, repeat. It explicitly rejects writing all tests first and all implementation later.

Best-practice principle:

- Tests should verify behavior through public interfaces.
- Tests should survive internal refactors.
- Mock only system boundaries: time, randomness, external APIs, sometimes DB/filesystem.
- Avoid asserting internal call counts or private method behavior.

Adaptation for `active-coding-rules`:

- Add a "one behavior at a time" bias for test-first work.
- Encourage integration-style tests at the smallest meaningful public interface.
- For refactors, preserve behavior through interface-level checks.
- Treat over-mocking as a warning that the interface may be poorly shaped.

### 8. Deep Modules Are A Better Architecture Target Than More Abstraction

`improve-codebase-architecture` uses a precise vocabulary: module, interface, implementation, depth, seam, adapter, leverage, and locality. The central rule is that a good module hides substantial behavior behind a small interface.

Best-practice principle:

- Depth is about leverage at the interface, not implementation size.
- The interface is the test surface.
- Use the deletion test: if deleting a module merely spreads its complexity across callers, it was earning its keep; if complexity vanishes, it was pass-through.
- One adapter is usually a hypothetical seam; two adapters make a real seam.

Adaptation for `active-coding-rules`:

- Keep "do not add abstraction for single-use code."
- Add a positive target: add abstraction only when it increases locality or leverage.
- For architecture work, assess whether modules are shallow pass-throughs or deep behavior owners.
- Classify dependencies before proposing seams: in-process, local-substitutable, remote-owned, true external.

### 9. Prototype Code Must Answer A Question And Then Leave

Matt's `prototype` skill distinguishes logic prototypes from UI prototypes. A prototype is throwaway code that answers one question. It should be runnable in one command, avoid persistence by default, expose state clearly, and be deleted or absorbed after the answer is captured.

Best-practice principle:

- Prototype constraints are different from production constraints.
- The question determines the prototype shape.
- The validated decision is the artifact; the prototype shell is not.

Adaptation for `active-coding-rules`:

- When users ask to explore a design, explicitly name the question being answered.
- Keep prototype code visibly separate from production code.
- Do not add tests or abstractions to throwaway prototypes.
- Capture the answer in a durable place before deleting or absorbing the prototype.

### 10. PRDs, Issues, And Agent Briefs Should Be Durable Contracts

`to-prd`, `to-issues`, and `triage/AGENT-BRIEF.md` share a crucial principle: durable task descriptions should focus on behavior, interfaces, acceptance criteria, and scope boundaries. They should not depend on current file paths or line numbers that may go stale.

Best-practice principle:

- A task brief is a contract for future work.
- It should describe current behavior, desired behavior, key interfaces, acceptance criteria, and out-of-scope boundaries.
- Vertical slices are more agent-friendly than layer-by-layer tasks.
- Distinguish AFK work from HITL work.

Adaptation for `active-coding-rules`:

- For substantial tasks, encourage a compact "brief" before editing.
- Include out-of-scope explicitly when the task tempts scope creep.
- Prefer thin vertical slices that are independently demoable or verifiable.
- Do not over-prescribe files unless the user asks for surgical edits in known files.

### 11. Triage Is A State Machine

Matt's `triage` skill makes issue processing explicit: category roles (`bug`, `enhancement`) and state roles (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). It also distinguishes maintainer judgment from agent-ready implementation.

Best-practice principle:

- Workflow states should be canonical; tracker labels are just mappings.
- `needs-info` questions must be specific and actionable.
- Prior context should be read before re-asking resolved questions.
- Agent-ready work needs a brief; human-ready work needs the reason it cannot be delegated.

Adaptation for `active-coding-rules`:

- We do not need a full issue-triage workflow inside the main skill.
- We should borrow the state-machine mindset for complex coding tasks: unknown, reproducing, ready-to-fix, blocked, verified.
- For issue-writing features later, adopt the durable agent brief template.

### 12. Out-of-Scope Decisions Are Institutional Memory

Matt's `.out-of-scope/` pattern records rejected feature requests by concept, not by issue. The goal is to avoid re-litigating the same rejected request over and over.

Best-practice principle:

- Rejections need durable reasoning, not just closed issues.
- A rejection reason should be strategic or architectural, not "we are busy."
- Similar future requests should surface the prior decision.

Adaptation for `active-coding-rules`:

- For our own skill evolution, keep a small out-of-scope record if repeated feature requests appear.
- Use this especially for requests that would make the skill too broad, too verbose, or too platform-specific.

### 13. Brevity Can Be A Mode, But Clarity Has Overrides

`caveman` demonstrates an explicit communication mode: compressed output with technical fidelity. The important reusable idea is not the style itself, but persistence and exception rules.

Best-practice principle:

- A communication mode should define activation, persistence, deactivation, and safety exceptions.
- Compression should never corrupt technical terms, error messages, or irreversible-action warnings.

Adaptation for `active-coding-rules`:

- Keep final reports concise by default.
- Do not add a persistent brevity mode unless users ask for it.
- Borrow the "auto-clarity exception" concept for dangerous or ambiguous actions.

### 14. Handoffs Should Reference Existing Artifacts, Not Duplicate Them

Matt's `handoff` skill says not to duplicate content already captured in PRDs, plans, ADRs, issues, commits, or diffs. It should summarize only what a fresh agent needs.

Best-practice principle:

- Handoffs should minimize entropy.
- The next agent needs pointers, current state, open questions, and suggested skills.
- Duplicating artifacts creates drift.

Adaptation for `active-coding-rules`:

- For long tasks, final reports should include durable pointers and residual risks.
- If adding a handoff reference later, make it point-first and non-duplicative.

### 15. Setup And Manifest Consistency Matter

Matt's repo has a clear bucket structure (`engineering`, `productivity`, `misc`, `personal`, `in-progress`, `deprecated`) and a plugin manifest for promoted skills. The associated `CLAUDE.md` defines which buckets must appear in README and manifest entries.

Best-practice principle:

- Published skills need a manifest, docs, and install metadata to stay consistent.
- Draft, personal, and deprecated skills should not be promoted accidentally.
- Consistency checks are good candidates for scripts.

Adaptation for `active-coding-rules`:

- If we split `active-coding-rules` into multiple skills later, define promotion rules.
- Add a manifest/docs consistency script only when the repo has enough moving parts.
- Keep generated or downloaded comparison repos out of release metadata.

### 16. Deterministic Scripts Belong Beside Fragile Workflows

Matt uses scripts for repeatable tasks such as linking skills and structured HITL loops. The broader lesson is to stop asking the model to repeatedly regenerate fragile command sequences.

Best-practice principle:

- Use scripts for validation, formatting, scaffolding, parsing, and safety checks.
- Keep scripts small and focused.
- Let instructions explain when to run the script, not reimplement the script in prose.

Adaptation for `active-coding-rules`:

- Potential future scripts:
  - validate `SKILL.md` references exist;
  - check line count and frontmatter constraints;
  - check README and install instructions remain aligned;
  - scan examples for outdated file names.

## Source Skill Mapping

| Matt skill/artifact | Worth learning | Adaptation for `active-coding-rules` |
| --- | --- | --- |
| `README.md` | Clear product thesis: small, composable skills for real engineering | Keep README focused on behavior and concrete use cases |
| `.claude-plugin/plugin.json` | Explicit promoted-skill manifest | Add manifest checks only if this repo grows beyond one skill |
| `CLAUDE.md` | Repository maintenance rules for skill buckets | Add internal contributor rules if we split into multiple skills |
| `CONTEXT.md` | Shared language and flagged ambiguities | Recommend reading project context docs for non-trivial work |
| `diagnose` | Feedback loop before hypotheses and fixes | Add diagnosis task mode guidance |
| `grill-me` | One-question-at-a-time decision-tree interview | Use for complex ambiguity, not simple tasks |
| `grill-with-docs` | Clarification plus durable glossary/ADR updates | Adopt glossary/ADR awareness without forcing docs creation |
| `tdd` | Vertical red-green-refactor, behavior tests | Add "one behavior, one test, one slice" guidance |
| `improve-codebase-architecture` | Deep modules, seams, deletion test | Add architecture vocabulary and abstraction criteria |
| `prototype` | Throwaway prototypes answer one question | Add prototype discipline for exploratory work |
| `zoom-out` | Ask for system map before local edits | Add "zoom out" move for unfamiliar code areas |
| `to-prd` | Synthesizes current context into a durable spec | Borrow PRD structure for larger tasks, not default edits |
| `to-issues` | Thin vertical implementation slices | Use vertical slicing for multi-step implementation plans |
| `triage` | Explicit workflow states and actionable `needs-info` | Borrow state-machine thinking and agent brief format |
| `AGENT-BRIEF.md` | Durable behavior contract for AFK agents | Add as future reference for issue/spec writing |
| `OUT-OF-SCOPE.md` | Rejection memory by concept | Use for repeated rejected skill-scope requests |
| `handoff` | Compact continuation documents | Borrow pointer-first handoff style |
| `write-a-skill` | Skill structure, descriptions, scripts, references | Align with Codex skill best practices |
| `caveman` | Mode activation, persistence, deactivation, exceptions | Borrow mode design discipline, not necessarily the style |
| `git-guardrails-claude-code` | Tool-level safety hooks | Keep as inspiration for deterministic guardrails |
| `setup-pre-commit` | Environment detection, installation, verification | Good model for future setup workflows |
| Deprecated skills | Evolution by retiring weaker shapes | Be willing to replace broad prompts with sharper workflows |

## Recommended Integration Shape

### Current Change

This document becomes a reference for the `active-coding-rules` skill. The main `SKILL.md` should link to it only for:

- improving this skill;
- designing sub-workflows;
- handling complex diagnosis, TDD, architecture, planning, prototype, or issue-brief tasks.

### Near-Term Refinements

Add compact sections to `references/core-rules.md` or separate one-level references:

- `diagnosis-mode.md`
  - Build feedback loop.
  - Reproduce exact symptom.
  - Rank falsifiable hypotheses.
  - Instrument one variable at a time.
  - Fix with regression test or document missing seam.

- `tdd-mode.md`
  - One behavior test.
  - Minimal implementation.
  - Repeat.
  - Refactor only after green.
  - Test through public interfaces.

- `architecture-mode.md`
  - Use module/interface/seam/adapter/depth/locality/leverage.
  - Apply deletion test.
  - Add abstraction only for real locality or leverage.
  - Treat interface as test surface.

- `prototype-mode.md`
  - State the question.
  - Choose logic or UI prototype.
  - Mark throwaway.
  - One command to run.
  - Capture answer, delete or absorb.

- `brief-mode.md`
  - Current behavior.
  - Desired behavior.
  - Key interfaces.
  - Acceptance criteria.
  - Out of scope.

### What Not To Adopt

- Do not import the whole Matt workflow into the main skill.
- Do not make issue tracker setup a hard dependency for coding guardrails.
- Do not require `CONTEXT.md` or ADR creation for normal edits.
- Do not add persistent communication modes unless users ask for them.
- Do not create many tiny skills until there is real repeated usage to justify them.

## Proposed Active-Coding-Rules Additions

These are the highest-value rule additions, phrased in the style of our existing skill:

- For hard bugs, first build the tightest feedback loop that reproduces the user's symptom.
- Treat a fast deterministic failing signal as more valuable than a plausible explanation.
- For TDD, move one vertical behavior slice at a time: one failing test, minimal code, then repeat.
- Test behavior through the smallest meaningful public interface; avoid coupling tests to implementation details.
- Add abstraction only when it increases locality or leverage, not because future variation is imaginable.
- When unfamiliar with a code area, zoom out and map relevant modules and callers before editing.
- For exploratory work, mark prototype code as throwaway and capture the answer before deleting or absorbing it.
- For substantial delegated tasks, write durable briefs with current behavior, desired behavior, key interfaces, acceptance criteria, and out-of-scope boundaries.
- Use project vocabulary from `CONTEXT.md` when available; do not invent synonyms for established domain concepts.
- Record load-bearing architectural decisions sparingly, only when they are hard to reverse, surprising, and trade-off driven.

## Skill Engineering Checklist

Use this checklist whenever evolving `active-coding-rules`:

- Does the main `SKILL.md` remain small enough to load on every invocation?
- Is each added rule operational, or is it just advice?
- Does the trigger description explain when the skill should be used?
- Are detailed examples and uncommon branches moved to `references/`?
- Is each reference linked directly from `SKILL.md` or another obvious entry point?
- Are deterministic or fragile tasks better handled by a script?
- Does any new workflow define its success signal?
- Does the workflow preserve user-owned changes and avoid unrelated edits?
- Does it state when to ask the user and when to inspect the repo instead?
- Does it reduce agent failure modes without making simple tasks heavy?

