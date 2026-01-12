# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## AI Guidance

- Use code-searcher subagent for code searches, inspections, troubleshooting to save context
- Read files before proposing edits. Never speculate about unread code. If user references a file, read it first
- Reflect on tool results quality before determining next action
- Summarize after completing tasks
- Use parallel tool calls when operations are independent (sequential when dependent, never use placeholders)
- Verify solutions before finishing
- Do what's asked; nothing more, nothing less
- File creation: Only when necessary. Prefer editing existing files. No proactive docs/README creation. Clean up temp files afterward
- Update memory bank when modifying core context files
- Commits: Exclude CLAUDE.md and memory bank files (*.md in .claude/memory/)
- Default to research/recommendations when user intent is ambiguous. Only implement when explicitly requested

## Memory Bank System

This project uses a streamlined 3-file memory bank system. Check these files for relevant context:

### Core Context Files

Read in this order:

1. **@.claude/memory/active-context.md** - Current work, goals, and progress (if exists)
   - Dynamic: Updated during active development
   - Ephemeral: Reset when starting new major tasks
   - Check first to understand current session state

2. **@.claude/memory/project-brief.md** - Project overview and architectural knowledge (if exists)
   - Architecture decisions and rationale
   - Known issues and proven solutions
   - Technical constraints and gotchas
   - Semi-static: Changes infrequently

3. **@.claude/memory/project-patterns.md** - Code conventions and implementation patterns (if exists)
   - Established patterns in this codebase
   - Project-specific coding standards
   - Common implementations and examples
   - Semi-static: Evolves with codebase

**Important:** Always check active-context.md first to understand what's currently being worked on and maintain session continuity.

## Claude Code Official Documentation

When working on Claude Code features (hooks, skills, subagents, MCP servers, etc.), use the `claude-docs-consultant` skill to selectively fetch official documentation from docs.claude.com.

## Custom Project Rules

**IMPORTANT:** Read these project-specific coding standards and conventions found in this folder: @.claude/rules/

These rules define the project's coding standards and must be followed for all code changes.

## Tool Preferences

Use fast modern tools:
- **File finding**: `fd` (not `find`, not `tree`, not `ls -R`)
- **Content search**: `rg` (not `grep`)
- **List files**: `rg --files` or `fd . -t f`

Banned (slow/not installed): `tree`, `find`, `grep -r`, `ls -R`
