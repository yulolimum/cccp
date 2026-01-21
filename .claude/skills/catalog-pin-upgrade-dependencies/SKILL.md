---
name: catalog-pin-upgrade-dependencies
description: Consolidates all monorepo dependencies into root catalog, pins versions, and upgrades to latest
disable-model-invocation: true
---

# Catalog, Pin, and Upgrade Dependencies

This skill consolidates all dependencies from a monorepo into a centralized catalog, pins their versions, and upgrades them to the latest versions one at a time.

## Overview

1. **Catalog**: Move all dependencies to root-level catalog (pnpm-workspace.yaml or bun's package.json catalog)
2. **Pin**: Remove version prefixes (`^`, `~`) to lock exact versions
3. **Upgrade**: Update each dependency to latest version one at a time
4. **Report**: Display a comprehensive summary table

## Execution Steps

### Step 1: Detect Package Manager

Check for lock files to determine the package manager:

```bash
# Check in order of precedence
ls pnpm-lock.yaml 2>/dev/null && echo "pnpm"
ls bun.lockb 2>/dev/null && echo "bun"
ls yarn.lock 2>/dev/null && echo "yarn"
ls package-lock.json 2>/dev/null && echo "npm"
```

**Supported package managers:**
- **pnpm**: Uses `pnpm-workspace.yaml` with `catalog:` section
- **bun**: Uses `package.json` with `catalog` field at root

If neither pnpm nor bun is detected, inform the user this skill only supports pnpm and bun catalogs.

### Step 2: Find All package.json Files

```bash
find . -name "package.json" -not -path "*/node_modules/*" -not -path "*/.git/*"
```

Read each package.json and extract:
- `dependencies`
- `devDependencies`
- `peerDependencies` (optional - ask user if they want to include these)

### Step 3: Build Dependency Map

Create a map tracking:
- Package name
- All versions found across workspaces
- Which workspaces use it
- Whether it's a dev dependency

Example structure:
```
{
  "react": {
    versions: ["^18.2.0", "~18.1.0", "18.0.0"],
    workspaces: ["packages/app", "packages/ui", "packages/web"],
    devDep: false
  }
}
```

### Step 4: Determine Catalog Versions

For each dependency:
1. If all workspaces use the same version (ignoring prefixes), use that version
2. If versions differ, use the **highest** version found
3. **Pin the version** by removing `^` and `~` prefixes

### Step 5: Update Catalog

**For pnpm** - Update `pnpm-workspace.yaml`:
```yaml
catalog:
  react: 18.2.0
  typescript: 5.3.0
  # ... all dependencies
```

**For bun** - Update root `package.json`:
```json
{
  "catalog": {
    "react": "18.2.0",
    "typescript": "5.3.0"
  }
}
```

### Step 6: Update Workspace package.json Files

Replace version specifiers with catalog references:

**For pnpm:**
```json
{
  "dependencies": {
    "react": "catalog:"
  }
}
```

**For bun:**
```json
{
  "dependencies": {
    "react": "catalog:react"
  }
}
```

### Step 7: Upgrade Dependencies One at a Time

For each cataloged dependency:

**For pnpm:**
```bash
pnpm update <package-name> --latest
```

**For bun:**
```bash
bun update <package-name> --latest
```

After each upgrade:
1. Record the new version
2. Note if upgrade succeeded or failed
3. Calculate version change type (patch/minor/major)

### Step 8: Generate Summary Table

Display a markdown table with the following columns:

| Package | Cataloged | Pinned | Upgraded | Old Version | New Version | Change | Workspaces | Status |
|---------|-----------|--------|----------|-------------|-------------|--------|------------|--------|

**Status Color Coding:**

Use these indicators in the Status column:

- **GREEN** (`SAFE`): Patch-level update only (e.g., 1.0.0 → 1.0.1)
- **ORANGE** (`WARN`): Minor-level update (e.g., 1.0.0 → 1.1.0) OR multiple workspaces had different minor versions
- **RED** (`RISK`): Major-level update (e.g., 1.0.0 → 2.0.0) OR multiple workspaces had different major versions

**Change Type Column:**
- `patch` - Only patch version changed
- `minor` - Minor version changed
- `major` - Major version changed
- `none` - No change (already latest)

**Example Output:**

```
## Dependency Catalog Summary

Package Manager: pnpm
Total Dependencies Processed: 45
Workspaces Affected: 8

| Package | Cataloged | Pinned | Upgraded | Old Version | New Version | Change | Workspaces | Status |
|---------|-----------|--------|----------|-------------|-------------|--------|------------|--------|
| react | ✓ | ✓ | ✓ | 18.2.0 | 18.3.1 | minor | app, ui, web | WARN |
| typescript | ✓ | ✓ | ✓ | 5.3.0 | 5.4.0 | minor | * (all) | WARN |
| lodash | ✓ | ✓ | ✓ | 4.17.20 | 4.17.21 | patch | utils | SAFE |
| next | ✓ | ✓ | ✓ | 13.5.0 | 14.1.0 | major | app, web | RISK |
| zod | ✓ | ✓ | ✗ | 3.22.0 | 3.22.0 | none | api, shared | SAFE |

### Risk Summary
- SAFE (patch/none): 30 packages
- WARN (minor): 12 packages
- RISK (major): 3 packages

### Version Conflicts Detected
The following packages had different versions across workspaces:
- react: ^18.2.0 (app), ~18.1.0 (ui), 18.0.0 (web) → unified to 18.3.1
- lodash: ^4.17.20 (utils), ^4.17.19 (shared) → unified to 4.17.21
```

## Important Notes

1. **Backup**: Consider committing current state before running
2. **Lock File**: The lock file will be regenerated after updates
3. **Breaking Changes**: Pay attention to RED/RISK items - these may require code changes
4. **Testing**: Run tests after completion to verify nothing broke

## Error Handling

- If a package fails to upgrade, log the error and continue with the next package
- Include failed packages in the summary with an `✗` in the Upgraded column
- Suggest manual intervention for failed packages at the end

## Post-Completion

After displaying the summary:
1. Remind user to run tests
2. Highlight any packages that failed to upgrade
3. Suggest reviewing RED/RISK packages for breaking changes
4. Offer to help investigate any specific package upgrade issues
