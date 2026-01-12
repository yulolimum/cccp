---
name: generate-pr-description
description: Generate concise, technically-focused PR descriptions by analyzing git diff between base and current branch. Creates structured markdown with tasks, notes, and optional diagrams ready for GitHub.
---

# Generate PR Description

## Overview

This skill analyzes git changes between branches to generate professional, concise PR descriptions following a standardized format. It examines commits, diffs, and change patterns to automatically categorize changes into actionable tasks and important notes, with optional architectural diagrams.

## When to Use This Skill

Invoke this skill when:

- Creating a pull request and need a description
- Want to document changes before creating PR
- Need to summarize branch work for review
- Generating release notes from changes
- Understanding what changed in a branch

## Output Format

The skill generates markdown in this exact format:

```markdown
## Tasks
- [Action verb] [high-level change description]
- [Action verb] [another top-level change]
- [Action verb] [change with sub-items if scope is large]
   - [Sub-item describing specific aspect of parent change]
   - [Another sub-item for the same parent change]

## Notes
- **[Topic Category]**: [One-sentence description of important context, gotcha, or consideration]
- **[Another Category]**: [Additional information developers need when integrating these changes]

## Diagram
[Optional Mermaid diagram showing architecture/flow/structure of PR changes - only include when 5+ files changed or architectural changes made]
```

**Action verbs**: Add, Update, Fix, Remove, Refactor, Migrate, Deprecate
**Topic categories**: Breaking Change, Migration Required, Configuration, Dependencies, Performance, Security, Testing, etc.

## Workflow

### Step 1: Branch Detection and Validation

1. Identify current branch
2. Detect base branch automatically:
   - Check `origin/HEAD` default branch
   - Look for common branches (main, master, develop)
   - Prompt user if ambiguous
3. Validate both branches exist

**Git Commands:**
```bash
# Current branch
git branch --show-current

# Default base
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'

# Available branches
git branch -r | grep -E 'origin/(main|master|develop)'
```

### Step 2: Gather Change Information

Collect comprehensive git information in parallel:

**Commit History:**
```bash
git log [base]..HEAD --format="%h %s%n%b%n---"
```

**Change Statistics:**
```bash
git diff [base]...HEAD --stat
git diff [base]...HEAD --name-status
```

**Full Diff:**
```bash
git diff [base]...HEAD
```

### Step 3: Analyze Changes

**Task Categorization:**
- Group files by module/directory
- Identify functional areas (auth, api, ui, database, tests)
- Detect new features, updates, fixes, refactors
- Analyze commit messages for intent
- Create hierarchical task list

**Note Extraction:**
- Scan commits for keywords:
  - "breaking", "deprecated", "migration"
  - "security", "performance", "gotcha"
  - "config", "environment", "setup"
- Identify breaking changes from:
  - Removed functions/exports
  - Changed function signatures
  - API endpoint changes
- Detect dependencies:
  - package.json changes
  - New imports
- Spot configuration needs:
  - .env changes
  - Config file updates

**Diagram Assessment:**
- Count files changed
- Detect architectural patterns:
  - New component interactions
  - Data flow changes
  - API additions/changes
  - State management updates
- Decide diagram type and necessity

### Step 4: Generate Markdown

**Tasks Section:**
- Use concise bullet points
- Group related changes
- Indent sub-items for large scopes
- Lead with verb (Add, Update, Fix, Remove, Refactor)
- Focus on WHAT changed
- **Keep tasks at feature/module level - DO NOT enumerate details**
  - ❌ BAD: "Implement GammaApi client with 17 endpoints (status, teams, sports, tags, events, markets...)"
  - ✅ GOOD: "Implement GammaApi client"
  - Don't list specific functions, endpoints, components, or implementation details
  - Tasks describe the change, not every aspect of it

**Notes Section:**
- Bold topic headings
- One-sentence descriptions
- **Include only developer-impacting information:**
  - Breaking changes
  - Migration steps required
  - Configuration needs (env vars, config files)
  - New dependencies
  - Performance implications that affect usage
  - Security considerations
- **EXCLUDE implementation details visible in code:**
  - ❌ BAD: "Architecture: Uses result type pattern ({ ok: true, data } | { ok: false, error })"
  - ❌ BAD: "Implementation: Uses factory pattern for service creation"
  - ❌ BAD: "Code structure: Separates concerns into modules"
  - These are visible in code review - don't waste note space on them
- Focus on information that requires developer action or awareness

**Diagram Section:**
- Use mermaid syntax
- Choose appropriate type:
  - `flowchart TD` for flows
  - `sequenceDiagram` for interactions
  - `classDiagram` for structure
  - `stateDiagram-v2` for states
- Keep concise (< 15 nodes)
- Label clearly
- Show only PR changes, not entire system

### Step 5: Present and Refine

- **Output raw markdown wrapped in a markdown code fence** (```markdown ... ```)
- This makes the output copy-pastable - user can select and copy the raw markdown syntax directly
- Do NOT output formatted/rendered markdown - output the raw text
- Verify accuracy with user
- Offer refinements if needed
- Ready to paste into GitHub PR

## Examples

### Example 1: Feature Addition

**User request:** "Generate PR description for my feature branch"

**Process:**
1. Detect branches: `feature/user-auth` → `main`
2. Find commits: 8 commits about authentication
3. Analyze files: auth/, api/auth.ts, components/LoginForm.tsx
4. Generate:
   - Tasks: Add user authentication, Add login form, Add auth middleware
   - Notes: Requires AUTH_SECRET env var, Breaking: /login endpoint moved
   - Diagram: Sequence diagram showing auth flow

### Example 2: Bug Fix

**User request:** "/generate-pr-description"

**Process:**
1. Detect branches: `fix/memory-leak` → `develop`
2. Find commits: 2 commits fixing memory issue
3. Analyze files: utils/cache.ts, tests/cache.test.ts
4. Generate:
   - Tasks: Fix memory leak in cache, Add cache cleanup tests
   - Notes: Performance: Memory usage reduced by 40% (Note: Only include notes with developer impact - omit if no breaking changes or config needed)
   - Diagram: None (simple fix, < 5 files)

### Example 3: Refactor

**User request:** "Generate description comparing to main"

**Process:**
1. Detect branches: `refactor/api-layer` → `main`
2. Find commits: 15 commits restructuring API
3. Analyze files: api/*, services/*, types/*, tests/*
4. Generate:
   - Tasks: Refactor API layer (service extraction, type updates, test updates)
   - Notes: Breaking: Import paths changed, Migration: Update imports from api/* to services/*
   - Diagram: Class diagram showing new service architecture

## Best Practices

### Analysis Quality

- Read ALL commits in range, not just latest
- Consider file locations for context
- Check for implicit breaking changes
- Verify test coverage changes
- Note dependency updates

### Description Conciseness

- Target: 5-10 task items
- Target: 2-5 note items
- One sentence per item
- Technical audience (skip fluff)
- Action-oriented language

### Diagram Guidelines

- Only when adding clarity
- Focus on new/changed parts
- Keep < 15 nodes
- Use standard mermaid syntax
- Label clearly
- Show relationships, not every detail

### Token Efficiency

- Don't fetch full diff if > 10K lines
- Summarize large refactors
- Focus on public API changes
- Skip cosmetic changes in summary
