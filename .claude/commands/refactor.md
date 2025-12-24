# Refactor

Comprehensive codebase analysis and refactoring.

**Arguments:** $ARGUMENTS

If argument provided — focus on that area. If empty — full codebase audit.

## Philosophy

The best code is no code. Every line must justify its existence.

- Simplicity over flexibility
- Deletion beats refactoring
- Fewer abstractions, more concrete code
- Don't fix what isn't broken

## Phase 1: Scope Selection

If no scope specified, ask the user:
1. **Full codebase** — comprehensive review
2. **Specific area** — focus on a subsystem
3. **Recent changes** — review last N commits

## Phase 2: Analysis

Read CLAUDE.md first — understand architecture and conventions.

Then analyze the selected scope:

### Dead Code
- Unused functions, types, properties, files
- Commented-out code
- Unreachable code paths
- Stale TODO/FIXME

### Potential Bugs
- Race conditions
- Unhandled errors
- Memory issues
- Incorrect state transitions

### Simplification Opportunities
- Duplicate logic
- Unnecessary abstractions
- Long functions, deep nesting
- Verbose patterns with cleaner alternatives

### Performance
- Inefficient algorithms
- Unnecessary allocations
- Missing caching

## Phase 3: Verification

**Before flagging any issue:**

1. Read the actual code at that location
2. Check if it's intentional (documented in CLAUDE.md?)
3. Check for false positives:
   - "Unused" code that's called dynamically?
   - "Race condition" already protected by actor/lock?
   - "Duplication" that's intentional UI buffer?
4. If not a real issue — **add a clarifying comment** to prevent future false positives:
   ```
   // NOTE: Looks like race condition but safe — protected by @MainActor
   // NOTE: Appears unused but called via NotificationCenter
   // NOTE: Intentional duplication — UI buffer for TextField binding
   ```
   This accumulates knowledge and saves time on future refactoring runs.

## Phase 4: Planning

Present findings by priority:

### 🔴 Critical (bugs, crashes, data loss)
### 🟡 Important (dead code, simplification)
### 🟢 Nice to have (optimizations, style)

For each finding:
- File and line reference
- What the issue is
- Suggested fix

**Wait for user approval before making changes.**

## Phase 5: Execution

Work incrementally:
1. Make minimal change
2. Verify it compiles/works
3. Move to next item

Order:
1. Dead code removal (safe)
2. Bug fixes (critical)
3. Simplification
4. Optimizations

## Phase 6: Documentation Sync

After refactoring, check if documentation needs updates:
- CLAUDE.md — architecture still accurate?
- README.md — instructions still valid?
- Other docs — any stale references?

Update only what changed.

## Constraints

- **DO NOT** add new functionality
- **DO NOT** create abstractions "for the future"
- **DO NOT** refactor working code without clear issues
- **DO NOT** change public APIs unnecessarily

## Report

At the end:
- Issues found and their status
- Changes made
- Build verification result
