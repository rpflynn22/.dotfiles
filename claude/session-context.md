# Session Context and Working Model

These instructions help Claude Code understand ongoing work when starting fresh sessions.

## Understanding Branch Progress

**When asked to review branch progress or "what we've done on this branch"**:

⚠️ **CRITICAL**: You MUST run these TWO commands in parallel. DO NOT use `git diff main...HEAD` or similar commands.

**Required commands:**
1. `git diff` - Shows uncommitted work in progress
2. `git diff HEAD~1..HEAD` - Shows ONLY the current commit (if created on this branch)

**Why these specific commands:**
- `HEAD~1..HEAD` shows only the current commit's changes
- This avoids showing extra changes from base branch merges/fast-forwards
- Using `main...HEAD` will show ALL branch history, which is usually too much

**Do NOT use:**
- ❌ `git diff main...HEAD`
- ❌ `git diff main..HEAD`
- ❌ `git log -p`

This two-part check provides complete context:
- The commit diff shows what's already been committed and will be in the PR
- The uncommitted diff shows what's currently being worked on but not yet committed
