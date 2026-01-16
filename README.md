<div align="center">

<img width="280" alt="CCCP Logo" src="https://github.com/user-attachments/assets/d336bec4-60c7-4e3e-8019-9529d9fe7c6f" />

# CCCP
**Claude Code Cline Powerhouse**

A unified configuration repository that enables seamless collaboration between Cline and Claude Code AI assistants through shared memory banks and coding standards.

</div>

---

## What is CCCP?

CCCP provides a standardized setup for using both **Cline** (VS Code extension) and **Claude Code** (Anthropic's official CLI/extension) in the same project. It includes:

- **Shared memory bank** (`CLAUDE.md` + `.claude/memory/`) - Both tools read the same context and project knowledge through a streamlined 3-file system
- **Custom coding rules** - Consistent standards enforced across both AI assistants
- **Claude Code features** - Agents, commands, and skills for advanced workflows
- **Zero configuration** - Works out of the box for both tools

<details>
<summary><strong>Tool Differences: Cline vs Claude Code</strong></summary>

### What Both Tools Share
- ✅ `CLAUDE.md` - Memory bank for context retention
- ✅ `.claude/rules/*.md` - Custom coding standards
- ✅ Project-specific guidelines

### Cline-Specific
- Uses `.clinerules` file
- VS Code extension only
- Own command system

### Claude Code-Specific
- Uses `.claude/` directory
- CLI + VS Code extension
- Agents (subagents for complex tasks)
- Slash commands (quick workflows)
- Skills (on-demand expertise)
- MCP server support

</details>

---

## Prerequisites

### Required
- **Cline** - VS Code extension
- **Claude Code** - CLI tool or VS Code extension from Anthropic
- **ripgrep** (`rg`) - Fast content search
- **fd** - Fast file finding
- **jq** - JSON processing
- **terminal-notifier** - Desktop notifications (macOS only)

### Installation (macOS)

```bash
# Install all required tools via Homebrew
brew install ripgrep fd jq terminal-notifier
```

---

## Setup

1. Copy files to your project directory
2. Modify `CLAUDE.md` for your project needs
3. Adjust `.claude/settings.json` as needed
4. Start using Cline or Claude Code with shared context

Both tools will automatically load your custom rules and memory bank!

---

## Usage Recipes

### 1) Bootstrap a New Project
**Goal:** Get shared context and rules working on day one.

1. Copy this repo into your project root
2. Edit `CLAUDE.md` with your project overview and constraints
3. Add initial notes to `.claude/memory/project-brief.md`
4. Start a Claude Code session and ask it to summarize architecture

### 2) Daily Work Loop (Cline + Claude Code)
**Goal:** Keep context consistent across tools.

1. In Cline, work normally with `.clinerules` and `.claude/rules/`
2. In Claude Code, reference the same files for shared standards
3. When you finish a feature, run `/update-memory-bank`
4. If a session ends mid-task, run `/session-handoff`

### 3) Resume Previous Work
**Goal:** Pick up exactly where you left off.

1. Start session with "continue" or "resume"
2. `session-interrogation` agent loads handoff context silently
3. Review TODO from handoff, continue with full context

### 4) Fast Architecture Orientation
**Goal:** Ramp up on a repo quickly without hunting for docs.

1. Ask Claude Code to read `README.md` and `.claude/memory/project-brief.md`
2. Use `/explain-architecture-pattern` on key modules or folders
3. Capture decisions in `.claude/memory/project-patterns.md`

### 5) Debug and Fix a Bug
**Goal:** Find, fix, and document a bug end-to-end.

1. Use `code-searcher` agent to locate relevant code
2. Track investigation in `active-context.md`
3. Fix the bug
4. Run `/update-memory-bank` to capture solution patterns
5. Run `/generate-pr-description` for the fix PR

### 6) Multi-Session Refactor
**Goal:** Execute large refactor without losing context.

1. Plan in `active-context.md`
2. Use `code-searcher` agent to map affected files
3. Make changes incrementally
4. Run `/session-handoff` at end of each session
5. Use `memory-bank-synchronizer` when patterns change

### 7) Ship a PR
**Goal:** Generate well-documented PR description.

1. Complete feature work
2. Run `/generate-pr-description` skill
3. Copy generated markdown into GitHub PR

### 8) Token-Efficient Code Analysis
**Goal:** Analyze large codebase with minimal tokens.

1. Use `code-searcher` with CoD (Chain of Draft) mode: "Use CoD to find [pattern]"
2. Get compressed symbolic results (80-90% token reduction)
3. Expand specific areas as needed

**Example — finding auth logic:**

| Mode | Output |
|------|--------|
| Standard | "I'll search for authentication logic by first looking for auth-related files, then examining login functions, checking for JWT implementations..." |
| CoD | `Auth→glob:*auth*→grep:login|jwt→found:auth.service:45→implements:JWT+bcrypt` |

---

## Claude Code Features

### Agents (Subagents)
- **code-searcher** - Efficiently searches and analyzes codebase
- **memory-bank-synchronizer** - Keeps documentation in sync with code
- **session-interrogation** - Proactively queries session handoff snapshots when detecting continuation intent or context gaps
- **ux-design-expert** - Provides UX/UI design guidance

### Commands (Slash Commands)
- **/apply-thinking-to** - Applies Anthropic's extended thinking patterns to prompts
- **/ccusage-daily** - Generates Claude Code usage cost analysis
- **/cleanup-context** - Optimizes memory bank to reduce token usage
- **/explain-architecture-pattern** - Identifies and explains architectural patterns
- **/session-handoff** - Creates structured session snapshots for continuity across context resets
- **/update-memory-bank** - Updates CLAUDE.md and memory bank files

### Skills
- **claude-docs-consultant** - Fetches official Claude Code documentation on-demand

### Custom Rules
- **agent-behavior-rules.md** - Communication style and banned phrases
- **general-programming-rules.md** - Coding standards and naming conventions
- **react-rules.md** - React component patterns and best practices

---

## Credits

This project is a based on [centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup), focused on Cline + Claude Code collaboration.

## License
See [LICENSE](LICENSE) file for details.
