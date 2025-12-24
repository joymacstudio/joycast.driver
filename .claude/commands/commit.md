# Commit

Commit current changes.

## Steps

1. **Review changes**
   ```bash
   git status
   git diff --stat
   ```

2. **Security check**

   Before staging, verify no sensitive data will be committed:
   - `.env`, `.env.*` files
   - Files with `secret`, `credential`, `token`, `apikey` in name
   - Private keys (`*.pem`, `*.key`, `id_rsa*`)
   - Config files that might contain secrets

   If found:
   - Check if already in `.gitignore`
   - If not — **add to .gitignore first**, then proceed
   - Warn the user about what was excluded

3. **Check recent commit style**
   ```bash
   git log --oneline -5
   ```

4. **Stage changes**
   - Stage all relevant changes
   - Skip sensitive and generated files

5. **Create commit**
   - Use conventional commit format: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
   - Title: max 50 chars, imperative mood
   - Body: bullet points for key changes (if multiple)
   - Footer: Claude signature

6. **Ask about push**
   - Ask: "Push to remote?"
   - If yes — push and report branch
   - If no — done

7. **Report**
   - Commit hash
   - What was committed
   - Any files that were excluded (and why)

## Commit Message Format

```
type: short description

- Key change 1
- Key change 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Guidelines

- Match the existing commit style in the repo
- One logical change per commit
- If changes are unrelated — suggest splitting into multiple commits
