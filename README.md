<div align="center">

<img width="280" alt="CCCP Logo" src="https://github.com/user-attachments/assets/d336bec4-60c7-4e3e-8019-9529d9fe7c6f" />

# CCCP
**Claude Code Cline Powerhouse**

A unified configuration repository that enables seamless collaboration between Cline and Claude Code AI assistants through shared memory banks and coding standards.

</div>

---

## What is CCCP?

CCCP provides a standardized setup for using both **Cline** (VS Code extension) and **Claude Code** (Anthropic's official CLI/extension) in the same project. It includes:

- **Shared memory bank** (`CLAUDE.md`) - Both tools read the same context and project knowledge
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

## Claude Code Features

### Agents (Subagents)
- **code-searcher** - Efficiently searches and analyzes codebase
- **get-current-datetime** - Gets accurate timestamps for file creation
- **memory-bank-synchronizer** - Keeps documentation in sync with code
- **ux-design-expert** - Provides UX/UI design guidance

### Commands (Slash Commands)
- **/apply-thinking-to** - Applies Anthropic's extended thinking patterns to prompts
- **/ccusage-daily** - Generates Claude Code usage cost analysis
- **/cleanup-context** - Optimizes memory bank to reduce token usage
- **/explain-architecture-pattern** - Identifies and explains architectural patterns
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
