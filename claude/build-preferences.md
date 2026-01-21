# Build and Artifact Preferences

## Build Output Guidelines

- **Never output compiled binaries to directories tracked by git**
- Always check for existing `.gitignore` patterns before running build commands
- Use dedicated output directories that are git-ignored (e.g., `bin/`, `build/`, `dist/`, `target/`)
- Before building, verify the output location won't be picked up by git
- If a build command would output to a git-tracked location, either:
  - Modify the command to use a different output directory
  - Add the output path to `.gitignore` first
  - Alert the user about the potential issue

## Go Build Commands - CRITICAL RULES

**NEVER EVER run `go build` without specifying an output directory.**

### ❌ FORBIDDEN - These commands are NEVER allowed:
```bash
go build ./cmd/service-name          # Creates binary in current directory!
go build ./path/to/package           # Creates binary in current directory!
go build .                           # Creates binary in current directory!
```

### ✅ REQUIRED - Always use explicit output to git-ignored directory:
```bash
go build -o bin/service-name ./cmd/service-name
go build -o build/binary ./path/to/package
```

### ✅ ALTERNATIVE - Build without creating artifacts (verification only):
```bash
go build -o /dev/null ./cmd/service-name    # Verify compilation only, no binary created
```

### Enforcement Rules:
1. **BEFORE** running any `go build` command, you MUST verify the output location
2. ALWAYS include `-o <git-ignored-path>` with every `go build` command
3. Default to using `-o bin/<binary-name>` for most projects
4. When only verifying compilation (not creating a binary), use `-o /dev/null`
5. If unsure about the correct output directory, ask the user

## Generated Files

- Avoid committing generated files (binaries, coverage reports, compiled assets, etc.)
- Check `git status` before creating commits to catch accidentally staged build artifacts
- When writing build scripts, include appropriate `.gitignore` entries
