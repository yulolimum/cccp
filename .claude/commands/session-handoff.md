---
description: Create and rotate a session handoff snapshot
---

# Session Handoff

Create a structured snapshot of the current session for future session continuity.

## What This Command Does

1. Rotates the previous `LATEST.md` snapshot to a timestamped archive
2. Generates a new `LATEST.md` with structured session knowledge
3. Stores snapshots in `.claude/memory/handoff/`

## Rotation Process

First, run the rotation script:

```bash
.claude/scripts/rotate-handoff.sh
```

## Snapshot Generation

Then create `.claude/memory/handoff/LATEST.md` using the Write tool with the following structure:

### Format Contract

- **Self-contained**: Must be readable without prior conversation context
- **Exact references**: Use full file paths, exact commands, specific line numbers when relevant
- **No speculation**: Only record what actually happened or exists
- **Size limit**: Target ≤ 250 lines, hard cap ≤ 350 lines
- **Style**: Bullets preferred, avoid long prose

### Required Sections (in this order)

```markdown
# Session Handoff

## Goal
- <One paragraph or 3–5 bullets describing the objective>

## Current State
- What exists now
- What works
- What is broken or incomplete

## Decisions Made
- <Decision>
  - Rationale:
  - Alternatives considered:
  - Implications:

## Referenced Files
- path/to/file.ext — why it matters / what changed
- path/to/other.ext — why it matters / what changed

## Commands / Migrations Run
- <exact command>
- <exact command>
- Notes: <only if needed>

## Research / Conclusions
- <finding>
  - Evidence: <brief note>
  - Impact:

## TODO / Next Steps
1. <concrete next action>
2. <concrete next action>

## Open Questions / Risks
- <question or risk>
- <question or risk>
```

## What to Include

### Goal
State the primary objective of this session. What were you trying to accomplish?

### Current State
- What code/files exist now
- What functionality is working
- What is broken, incomplete, or blocked

### Decisions Made
Record architectural or implementation decisions made during this session:
- The decision itself
- Why this approach was chosen
- What alternatives were considered
- What implications this has for future work

### Referenced Files
List files that were read, edited, or created with:
- Full path from project root
- Brief note on why it matters or what changed

### Commands / Migrations Run
Record exact commands executed that changed state:
- Build commands
- Test commands
- Git operations
- Database migrations
- Package installations
- Script executions

Include outcomes only if non-obvious (e.g., "3 tests failed" or "migration created users table").

### Research / Conclusions
Summarize investigations and their findings:
- What you researched
- What you discovered
- Evidence or source
- Impact on the work

### TODO / Next Steps
Concrete, actionable items for continuing the work. Be specific about what needs to happen next.

### Open Questions / Risks
Record unknowns, uncertainties, blockers, or risks that need resolution.

## What NOT to Include

- Raw chat transcripts or full conversation logs
- Speculative claims or guesses about how things work
- Detailed code dumps (reference files instead)
- Future feature ideas unrelated to the current goal
- Personal notes or meta-commentary

## Snapshot Quality Guidelines

**Good snapshot characteristics:**
- Future session can pick up the work without confusion
- Contains enough context to make informed decisions
- References are specific and verifiable
- Decisions are documented with rationale
- Unknowns are explicitly stated

**Bad snapshot characteristics:**
- Requires reading prior conversation to understand
- Contains vague references ("that file", "the API")
- Missing critical decisions or their rationale
- Treats uncertain information as fact
- Omits commands that changed system state

## After Creating Snapshot

Confirm snapshot creation:
- Path: `.claude/memory/handoff/LATEST.md`
- Archived previous: `.claude/memory/handoff/YYYY-MM-DD_HH-MM-SS.md` (if applicable)
- Line count: [actual count]
