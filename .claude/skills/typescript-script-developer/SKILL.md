---
name: typescript-script-developer
description: Write TypeScript automation scripts using Inquirer.js modular packages for prompts, zx for fs/shell, top-level await, tsx execution, repo-root node_modules cache, minimist arg parsing, and --verbose debug logging.
---

# TypeScript Script Developer

You write small, focused **TypeScript** scripts for automation and repo maintenance. Prefer correctness, clear UX, and predictable behavior over cleverness.

## Defaults

- **Execution:** `tsx <script>.ts`
- **Language/runtime:** TypeScript + Node (ESM) with **top-level await**
- **Tooling:**
  - **Inquirer.js modular packages** for prompts (install individual: `@inquirer/select`, `@inquirer/input`, `@inquirer/confirm`)
  - **zx** for fs operations and shell commands when needed
- **Args:** parse with **minimist** (shipped with zx)
- **Cache:** persist user state in:
  - `node_modules/.cache/<script-name>/cache.json`
- **Logging:**
  - `log(...)` — user-facing progress/output (minimal, readable)
  - `debug(...)` — noisy internals, enabled with `--verbose`

## Input rules

- **ALWAYS show prompts** - never hide inputs even when values exist from CLI args or cache
- Prefill prompts with values in this order: **CLI args → cache → fallback default**
- Use the `default` property to prefill all prompts
- **Validate where it makes sense**:
  - `select()` constrains choices (acts as validation)
  - `input()` must include `validate` function for free-form inputs
- On invalid input: return error message from `validate` function or print to **stderr** and exit with code **1**.

## Prompts

Use Inquirer.js modular packages (import individually):

- `import select from '@inquirer/select'` for constrained choices
- `import confirm from '@inquirer/confirm'` for yes/no questions
- `import input from '@inquirer/input'` for free-form text with validation

**CRITICAL**: Always prefill prompts with `default` property from CLI args → cache → fallback. Never conditionally skip prompts.

## Caching behavior

- Cache must live at the repo root under `node_modules/.cache`.
- Namespace cache data by feature inside the JSON.
- Reads must tolerate missing or invalid files.
- Writes must be awaited.

## Execution

- Use zx `$` when executing shell commands.
- Do not force shell usage when it is unnecessary.

## Output requirements

When generating a script, include:

- `## Usage`
- `## Options`
- `## Examples`
- A single, complete TypeScript file unless otherwise requested

## Canonical template

```ts
process.env.FORCE_COLOR ||= '1'

import confirm from '@inquirer/confirm'
import input from '@inquirer/input'
import select from '@inquirer/select'
import path from 'node:path'
import process from 'node:process'
import { fs, minimist, $ } from 'zx'

const SCRIPT_NAME = 'my-script'

// ── args ─────────────────────────────────────────────────────────────

const args = minimist(process.argv.slice(2), {
  boolean: ['verbose', 'help'],
  string: ['platform', 'tag'],
  alias: { v: 'verbose', h: 'help' },
})

const VERBOSE = Boolean(args.verbose)

// ── logging ──────────────────────────────────────────────────────────

function log(...args: Parameters<typeof console.log>) {
  console.log(...args)
}

function debug(...args: Parameters<typeof console.log>) {
  if (VERBOSE) console.log(`[${SCRIPT_NAME}]`, ...args)
}

if (args.help) {
  log(`Usage: tsx ${SCRIPT_NAME}.ts [options]

Options:
  --platform <all|ios|android>
  --tag <string>
  --verbose, -v     Enable debug logs
  --help, -h        Show help
`)
  process.exit(0)
}

// ── cache ────────────────────────────────────────────────────────────

const repoRoot = process.cwd()
const cacheDir = path.join(repoRoot, 'node_modules', '.cache', SCRIPT_NAME)
const cacheFile = path.join(cacheDir, 'cache.json')

type Cache = {
  feature?: {
    platform?: 'all' | 'ios' | 'android'
    tag?: string
  }
}

async function readCache(): Promise<Cache> {
  try {
    return (await fs.readJson(cacheFile)) as Cache
  } catch {
    return {}
  }
}

async function writeCache(cache: Cache) {
  await fs.ensureDir(cacheDir)
  await fs.writeJson(cacheFile, cache, { spaces: 2 })
}

const cache = await readCache()
cache.feature ??= {}

// ── inputs ───────────────────────────────────────────────────────────

// CLI → cache → prompt (ALWAYS show prompts with defaults)
const defaultPlatform = (args.platform as Cache['feature']['platform']) ?? cache.feature.platform
const platform = (await select({
  message: 'Select platform:',
  choices: [
    { name: 'All', value: 'all' },
    { name: 'iOS', value: 'ios' },
    { name: 'Android', value: 'android' },
  ],
  default: defaultPlatform ?? 'all',
})) as 'all' | 'ios' | 'android'

debug('platform:', platform)

// Free-form input with validation (conditionally spread default to avoid undefined)
const defaultTag = args.tag as string | undefined
const tag = await input({
  message: 'Tag (letters/numbers/dash):',
  ...(defaultTag && { default: defaultTag }),
  validate: (value: string) => {
    if (!/^[a-z0-9-]+$/i.test(value)) {
      return 'Invalid tag. Use only letters, numbers, and dashes.'
    }
    return true
  },
})

debug('tag:', tag)

// Confirmation prompt
const proceed = await confirm({
  message: 'Proceed?',
  default: true,
})

if (!proceed) {
  log('Cancelled')
  process.exit(0)
}

// ── optional execution ───────────────────────────────────────────────
// await $`echo ${tag}`

// ── persist ──────────────────────────────────────────────────────────

// Cache all user inputs for next run
if (platform) cache.feature.platform = platform
if (tag) cache.feature.tag = tag
await writeCache(cache)

log('Done')
export {}
```
