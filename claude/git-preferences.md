# Git Preferences

## Branch Workflow

- **Do NOT offer to create commits**: NEVER proactively offer to create, amend, or commit changes unless the user explicitly asks for it. Only create or amend commits when directly requested.
- **One commit per branch**: Each feature branch should have exactly one commit beyond the source branch (main/master)
- **Always amend**: When making subsequent changes on a branch, ALWAYS amend the existing commit rather than creating new commits
- **Update commit message**: When amending, update the commit message if the changes warrant it
- **Compare against main branch**: When amending a commit, ALWAYS use `git diff main...HEAD` (or the appropriate base branch) to see the full set of changes. This ensures the commit message accurately reflects ALL changes in the branch, not just the incremental changes being added
- **Force push**: After amending, use `git push --force-with-lease` to update the remote branch

## Commit Message Guidelines

- **Commit messages MUST be one line maximum**
- **Do NOT include multi-line attribution footers** (no Claude Code attribution, no Co-Authored-By lines, no generated-by footers)
- Attempt to keep commit messages to 80 characters
- Hard limit: 120 characters maximum
- Before creating any commit, ask the user if there is a Jira ticket number
- If a ticket number is provided, prefix the commit message with `<ticket-number>: `
  - Example: `FINPLAT-12345: Add outbox publisher support for generic mappers`
- Focus on the "why" rather than the "what" in commit messages
- Keep messages concise and meaningful
