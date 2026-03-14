---
name: commit-smart
description: Analyze staged/unstaged changes and create semantic conventional commits with emoji prefixes. Auto-detects commit type, scope, and the right emoji from the diff. Supports optional type/scope arguments. Use this skill whenever the user wants to commit, asks for a commit message, says "commit my changes", or uses /commit-smart. Usage - /commit-smart, /commit-smart fix, /commit-smart refactor api
---

# Smart Commit

Create meaningful conventional commits with emoji by analyzing your actual changes.

## Workflow

### Step 1: Assess the working tree

```bash
git status
git diff --stat
git diff --cached --stat
```

### Step 2: Handle unstaged changes

If nothing is staged (`git diff --cached` is empty):

1. Show the user what files have changed
2. Suggest logical groupings (e.g., "these 3 files are all related to the auth refactor")
3. Ask if they want to stage all, or select specific files
4. Stage the approved files with `git add <files>`

If changes are already staged, proceed.

### Step 3: Analyze the diff

```bash
git diff --cached
```

#### Determine the commit type

| Signal | Type |
|--------|------|
| New files with new functionality | `feat` |
| New test files or test additions | `test` |
| Changes to existing logic fixing incorrect behavior | `fix` |
| Structural changes without behavior change | `refactor` |
| Package, CI, or tooling config changes | `chore` |
| Build/bundler config changes | `build` |
| README, docs, comments only | `docs` |
| Formatting, whitespace, semicolons only | `style` |
| Performance improvements | `perf` |
| CI/CD pipeline changes | `ci` |
| Reverting a previous commit | `revert` |

#### Determine the scope

- `src/api/` → `api`
- `src/components/auth/` → `auth`
- `tests/` → `tests`
- Root config files → omit scope
- Multiple unrelated areas → omit scope

### Step 4: Pick the emoji

Choose the most specific emoji that fits the change. When in doubt, use the base type emoji.

**Base type emojis** (use these as the default for each type):

| Type | Emoji |
|------|-------|
| `feat` | ✨ |
| `fix` | 🐛 |
| `docs` | 📝 |
| `style` | 💄 |
| `refactor` | ♻️ |
| `perf` | ⚡️ |
| `test` | ✅ |
| `chore` | 🔧 |
| `ci` | 🚀 |
| `revert` | ⏪️ |

**Contextual emojis** (override the base when the situation is more specific):

| Situation | Emoji | Type |
|-----------|-------|------|
| Critical hotfix | 🚑️ | `fix` |
| Security fix | 🔒️ | `fix` |
| Fix typo | ✏️ | `fix` |
| Fix CI build | 💚 | `fix` |
| Fix linter/compiler warnings | 🚨 | `fix` |
| Catch errors / error handling | 🥅 | `fix` |
| Simple non-critical fix | 🩹 | `fix` |
| Fix due to external API changes | 👽️ | `fix` |
| Remove logs | 🔇 | `fix` |
| Remove code or files | 🔥 | `fix` |
| Breaking change | 💥 | `feat` |
| Add or update types | 🏷️ | `feat` |
| Business logic | 👔 | `feat` |
| Improve accessibility | ♿️ | `feat` |
| Improve UX/usability | 🚸 | `feat` |
| Responsive design | 📱 | `feat` |
| Analytics / tracking | 📈 | `feat` |
| Feature flags | 🚩 | `feat` |
| Add validation | 🦺 | `feat` |
| Internationalization | 🌐 | `feat` |
| Improve SEO | 🔍️ | `feat` |
| Concurrency / multithreading | 🧵 | `feat` |
| Offline support | ✈️ | `feat` |
| Add logs | 🔊 | `feat` |
| Easter egg | 🥚 | `feat` |
| Animations / transitions | 💫 | `feat` |
| Add comments in source code | 💡 | `docs` |
| Improve code structure/format | 🎨 | `style` |
| Remove dead code | ⚰️ | `refactor` |
| Move or rename resources | 🚚 | `refactor` |
| Architectural changes | 🏗️ | `refactor` |
| Developer experience | 🧑‍💻 | `chore` |
| Add or update .gitignore | 🙈 | `chore` |
| Add dependency | ➕ | `chore` |
| Remove dependency | ➖ | `chore` |
| Pin dependencies | 📌 | `chore` |
| Release / version tags | 🔖 | `chore` |
| Add/update compiled files | 📦️ | `chore` |
| Seed files | 🌱 | `chore` |
| Update contributors | 👥 | `chore` |
| Merge branches | 🔀 | `chore` |
| Begin a project | 🎉 | `chore` |
| Add/update license | 📄 | `chore` |
| Update CI build system | 👷 | `ci` |
| Mock things | 🤡 | `test` |
| Add/update snapshots | 📸 | `test` |
| Add a failing test | 🧪 | `test` |
| Database changes | 🗃️ | `db` |
| Add/update assets | 🍱 | `assets` |
| Experiments | ⚗️ | `experiment` |
| Work in progress | 🚧 | `wip` |

### Step 5: Check for user overrides

If the user provided arguments via `$ARGUMENTS`:
- Single word (e.g., `fix`) → use as commit type
- Two words (e.g., `refactor api`) → use as type and scope
- Otherwise → use auto-detected values

Re-select emoji after applying overrides.

### Step 6: Compose the commit message

Format: `emoji type(scope): imperative short description`

Rules:
- Subject line max 72 characters (including emoji)
- Imperative mood: "add", "fix", "remove" — not "added", "fixes"
- No period at end
- Body explains **WHY**, not what (the diff shows what)
- Skip body for trivial changes (typo, formatting)
- For breaking changes, add `!` after the scope: `feat(api)!: change response format`

**Examples:**
```
✨ feat(auth): add JWT refresh token rotation

Tokens were expiring mid-session for users on slow connections.
Rotating refresh tokens extends sessions without compromising
security — each token can only be used once.
```

```
🔥 fix(api): remove deprecated v1 endpoints

v1 endpoints have been sunset. All clients have migrated to v2.
```

```
🏷️ feat(types): add strict types for user profile schema
```

### Step 7: Detect and run pre-commit checks

Before committing, check for project-defined quality gates:

```bash
# Git hook (runs automatically on commit — just detect it)
ls .git/hooks/pre-commit 2>/dev/null

# pre-commit framework config
ls .pre-commit-config.yaml 2>/dev/null

# Project type signals
ls package.json pyproject.toml uv.lock Makefile justfile 2>/dev/null
ls *.tf 2>/dev/null   # Terraform files
```

**If `.git/hooks/pre-commit` is executable** — it runs automatically on `git commit`. No manual step needed; just inform the user.

**If `.pre-commit-config.yaml` exists** — run `pre-commit run --staged` before committing.

**Otherwise**, detect the project type and run the appropriate checks:

| Project type | Detection | Checks to run |
|---|---|---|
| Node (npm/pnpm/yarn/bun) | `package.json` | `lint`, `typecheck` / `type-check` scripts if present |
| Python (uv) | `uv.lock` or `pyproject.toml` | `uv run ruff check` (if ruff configured), `uv run mypy` (if mypy configured) |
| Python (other) | `pyproject.toml` / `setup.py` | `ruff check`, `flake8`, `mypy` — whichever is installed |
| Terraform | `*.tf` files | `terraform validate`, `terraform fmt -check`, `tflint` (if installed) |
| Makefile / just | `Makefile` / `justfile` | `lint`, `check`, `validate` targets if they exist |

Only run fast quality gates (linting, type checking, format checks). Skip full test suites, builds, or doc generation unless the user explicitly asks — those are too slow for a default commit flow.

If a check **fails**, show the output and ask: fix the issues first, or skip and commit anyway?

### Step 8: Confirm and commit

Show the proposed commit message and ask for confirmation.

If confirmed:
```bash
git commit -m "$(cat <<'EOF'
emoji type(scope): description

optional body here
EOF
)"
```

Then verify:
```bash
git log --oneline -1
```

Show the committed hash and message.

> Note: if a git pre-commit hook runs and fails during `git commit`, do **not** use `--no-verify` to bypass it. Surface the failure to the user and help them fix it.

### Step 9: Offer to push

Ask the user if they want to push the commit to the remote.

If yes, check the tracking branch:
```bash
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
```

- If a tracking branch exists, run `git push`
- If no tracking branch exists, suggest `git push -u origin <current-branch>` and ask for confirmation before running it

Show the push output and confirm success.

## Tips

- Run after completing a logical unit of work, not after every file change
- If the diff is too large, suggest splitting into multiple commits
- The body should answer: "will someone reading this in 6 months understand WHY?"
- For large diffs touching multiple concerns, commit them separately
