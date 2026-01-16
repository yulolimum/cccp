---
name: typescript-script-developer
description: Write TypeScript automation scripts using Inquirer.js modular packages for prompts, zx for fs/shell, top-level await, tsx execution, repo-root node_modules cache, minimist arg parsing, and --verbose debug logging.
---

# TypeScript Script Developer

You write small, focused **TypeScript** scripts for automation and repo maintenance. Prefer correctness, clear UX, and predictable behavior over cleverness.

## Architecture

- **Execution:** `tsx <script>.ts`
- **Execution context:** Should be added to the active workspace package.json scripts as needed (e.g. `pnpm <script>:run`)
- **Language/runtime:** TypeScript + Node (ESM) with **top-level await**
- **Tooling:**
  - **Inquirer.js modular packages** for prompts (install individual: `@inquirer/select`, `@inquirer/input`, `@inquirer/confirm`)
  - **zx** for fs operations and shell commands when needed
- **Args:** parse with **minimist** (shipped with zx)
- **Cache:** persist user state in:
  - `node_modules/.cache/<script-name>/cache.json`

## Structure

Every script should follow the following structure in the exact order:

- Imports (standard libs, inquirer packages, zx, minimist, process, path)
- Constants (things reused throughout the script)
- Arguments parsing (minimist)
- Cache (read/write functions, load cache)
- Logging setup (if `--verbose`, enable debug logs)
- Help (if `--help`, print usage and exit)
- Main body of the script (order depends on script purpose):
  - Inputs (prompts with Inquirer.js)
  - Logic/processing
  - Optional execution (shell commands with zx `$`, only if necessary)
- Output repeatable CLI command

### Imports

This section should import all necessary libraries at the top of the file.

```typescript
process.env.FORCE_COLOR ||= "1"

import path from "node:path"
import input from "@inquirer/input"
```

### Constants

Define any constants that will be used throughout the script.

```typescript
//
// Constants
//
const scriptName = "demo-patterns"
const scriptCommand = `pnpm demo:patterns`
```

### Arguments Parsing

Use minimist to parse, process, and create accumulators for command-line arguments. Argument names should always be camelCase. Copy and paste this as is, only modify to use specific flags and args.

```typescript
//
// Arguments
//
type ArgNames = keyof typeof parsedArgs
type Args = { [K in ArgNames]: NonNullable<(typeof parsedArgs)[K]> }

const args = minimist(process.argv.slice(2), {
  boolean: ["verbose", "help"],
  string: ["name", "count"],
  alias: { v: "verbose", h: "help" },
})

const parsedArgs = {
  name: args.name as string | undefined,
  count: args.count as string | undefined,
  verbose: Boolean(args.verbose),
  help: Boolean(args.help),
}

const accumulatedArgs: Partial<Args> = {
  verbose: parsedArgs.verbose,
  help: parsedArgs.help,
}
```

### Cache

Implement read/write functions for caching arguments. Copy and paste this section as is.

```typescript
//
// Cache
//
type Cache = {
  args: Partial<Args>
}

const repoRoot = process.cwd()
const cacheDir = path.join(repoRoot, "node_modules", ".cache", scriptName)
const cacheFile = path.join(cacheDir, "cache.json")

async function readCache(): Promise<Cache> {
  try {
    const cache = (await fs.readJson(cacheFile)) as Cache
    cache.args = cache.args || {}
    return cache
  } catch {
    return { args: {} }
  }
}

async function writeCache(cache: Cache) {
  await fs.ensureDir(cacheDir)
  await fs.writeJson(cacheFile, cache, { spaces: 2 })
}

const cache = await readCache()
```

### Logging

Implement logging functions for user-facing logs and debug logs. Copy and paste this section as is.

```typescript
//
// Logging
//
function log(...args: Parameters<typeof console.log>) {
  console.log(...args)
}

function debug(...args: Parameters<typeof console.log>) {
  if (parsedArgs.verbose) console.log(`[${scriptName}]`, ...args)
}
```

### Help

If `--help` is passed, print usage information and exit. Copy and paste this section as is, only modify the usage string.

```typescript
//
// Help
//
if (parsedArgs.help) {
  log(`Usage: ${scriptCommand} [options]

Options:
  --name <string>   Your name
  --count <number>   Number of items
  --verbose, -v      Enable debug logs
  --help, -h         Show help
`)
  process.exit(0)
}
```

### Main Body

This section contains the main logic of the script, including prompts, processing, and optional execution. The structure here will vary based on the script's purpose.

Here are some guidelines:

- Inputs should use Inquirer.js packages for prompts.
- Inputs should use the IIFE Pattern to encapsulate prompt logic.
- Input response should be added to accumulatedArgs and cache after each prompt.
- Input responses should be validated only when necessary using Inquirer.js validation options.

```typescript
const name = await (async function () {
  let response: string

  if (parsedArgs.name !== undefined) {
    response = parsedArgs.name
  } else {
    response = await input({
      message: "Enter your name:",
      default: cache.args.name ?? "",
    })
  }

  cache.args.name = response
  accumulatedArgs.name = response

  debug("name:", response)
  await writeCache(cache)

  return response
})()
```

### Output Repeatable CLI Command

At the end of the script, output a repeatable CLI command that includes all accumulated arguments. Copy and paste this section as is.

```typescript
//
// Repeatable CLI command
//
const stringArgs = Object.entries(accumulatedArgs).reduce((args, [key, value]) => {
  if (value === undefined) return args

  if (typeof value === "boolean") {
    if (value) args += ` --${key}`
  } else {
    args += ` --${key} "${value}"`
  }

  return args
}, "")

log(`\nYou can re-run this script with same settings using the following command:\n`, `${scriptCommand} ${stringArgs}`)
```

## Full Script Example

```typescript
process.env.FORCE_COLOR ||= "1"

import input from "@inquirer/input"
import path from "node:path"
import process from "node:process"
import { $, fs, minimist } from "zx"

//
// Constants
//
const scriptName = "demo-patterns"
const scriptCommand = `pnpm demo:patterns`

//
// Arguments
//
type ArgNames = keyof typeof parsedArgs
type Args = { [K in ArgNames]: NonNullable<(typeof parsedArgs)[K]> }

const args = minimist(process.argv.slice(2), {
  boolean: ["verbose", "help"],
  string: ["name", "count"],
  alias: { v: "verbose", h: "help" },
})

const parsedArgs = {
  name: args.name as string | undefined,
  count: args.count as string | undefined,
  verbose: Boolean(args.verbose),
  help: Boolean(args.help),
}

const accumulatedArgs: Partial<Args> = {
  verbose: parsedArgs.verbose,
  help: parsedArgs.help,
}

//
// Cache
//
type Cache = {
  args: Partial<Args>
}

const repoRoot = process.cwd()
const cacheDir = path.join(repoRoot, "node_modules", ".cache", scriptName)
const cacheFile = path.join(cacheDir, "cache.json")

async function readCache(): Promise<Cache> {
  try {
    const cache = (await fs.readJson(cacheFile)) as Cache
    cache.args = cache.args || {}
    return cache
  } catch {
    return { args: {} }
  }
}

async function writeCache(cache: Cache) {
  await fs.ensureDir(cacheDir)
  await fs.writeJson(cacheFile, cache, { spaces: 2 })
}

const cache = await readCache()

//
// Logging
//
function log(...args: Parameters<typeof console.log>) {
  console.log(...args)
}

function debug(...args: Parameters<typeof console.log>) {
  if (parsedArgs.verbose) console.log(`[${scriptName}]`, ...args)
}

//
// Help
//
if (parsedArgs.help) {
  log(`Usage: ${scriptCommand} [options]

Options:
  --name <string>   Your name
  --count <number>   Number of items
  --verbose, -v      Enable debug logs
  --help, -h         Show help
`)
  process.exit(0)
}

//
// Script
//
const name = await (async function () {
  let response: string

  if (parsedArgs.name !== undefined) {
    response = parsedArgs.name
  } else {
    response = await input({
      message: "Enter your name:",
      default: cache.args.name ?? "",
    })
  }

  cache.args.name = response
  accumulatedArgs.name = response

  debug("name:", response)
  await writeCache(cache)

  return response
})()

const count = await (async function () {
  let response: string

  if (parsedArgs.count !== undefined) {
    response = parsedArgs.count
  } else {
    response = await input({
      message: "Enter count:",
      default: cache.args.count ?? "1",
    })
  }

  cache.args.count = response
  accumulatedArgs.count = response

  debug("count:", response)
  await writeCache(cache)

  return response
})()

//
// Build config
//
const config = (function () {
  const config = {
    name,
    count: Number(count),
  }

  debug("Config:", JSON.stringify(config, null, 2))

  return config
})()

//
// Process data
//
const results = await (async function () {
  const results = []

  log("Processing data...")

  for (let i = 0; i < config.count; i++) {
    debug(`Processing item ${i + 1}...`)

    const item = {
      id: i + 1,
      name: `${config.name} ${i + 1}`,
      timestamp: new Date().toISOString(),
    }

    results.push(item)
    debug(`Processed item: ${JSON.stringify(item)}`)
  }

  log(`Processed ${results.length} items total`)

  return results
})()

if (results.length === 0) {
  log("No results found")
} else {
  console.table(results)
}

//
// Execute command
//
try {
  await $({ stdio: "inherit" })`echo "Hello ${config.name}"`
} catch (error) {
  log("\nCommand failed:", (error as Error).message)
}

//
// Repeatable CLI command
//
const stringArgs = Object.entries(accumulatedArgs).reduce((args, [key, value]) => {
  if (value === undefined) return args

  if (typeof value === "boolean") {
    if (value) args += ` --${key}`
  } else {
    args += ` --${key} "${value}"`
  }

  return args
}, "")

log(`\nYou can re-run this script with same settings using the following command:\n`, `${scriptCommand} ${stringArgs}`)

export {}
```
