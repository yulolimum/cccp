# General Programming Rules

## Comments
Default to NO comments. Only add when code genuinely confuses senior developers. Explain WHY, not WHAT.

## Self-Documenting Code
- Use descriptive variable and function names
- Break complex logic into well-named functions
- Choose clarity over cleverness
- Use meaningful constants instead of magic numbers

## File Naming Conventions
- Hooks: camelCase (same as exported hook)
- Utils and lib: kebab-case
- Services and React components: PascalCase

## Module Export Patterns
- Always use named exports (never default exports)
- Export inline with the declaration
- Never collect exports at bottom of file
- No barrel index files

## Function Definitions
- Prefer function declarations over arrow functions for named functions
- Use arrow functions for small inline callbacks and closures
- Never destructure props/arguments in function signature
- Always destructure at top of function body. If the argument is optional, use nullish coalescing: `const { prop } = input ?? {}`

## Function Naming

### Event Handlers - No "handle" Prefix
Never use "handle" prefix. Function names should describe the action directly.
- ❌ `handleSendMessage()` → ✅ `sendMessage()`
- ❌ `handleUpdateText()` → ✅ `updateText()`
- ❌ `handleOpenSheet()` → ✅ `openSheet()`

## Boolean Variable Naming

### Never Use "is" Prefix
Use descriptive adjectives instead of "is" prefix for all booleans.
- ❌ `isLoading`, `isDisabled`, `isVisible`, `isValid`, `isRequired` 
- ✅ `loading`, `disabled`, `visible`, `valid`, `required`

### Mutually Exclusive States - Use String Literals
When states are mutually exclusive, use single status variable with string literals instead of multiple booleans.
- ❌ `isLoading`, `isSuccess`, `isError`, `isIdle` (can conflict)
- ✅ `status: 'idle' | 'loading' | 'success' | 'error'` (only one state possible)