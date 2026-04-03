# 03 — Environment & Token Management

Use direnv to load credentials per-repo without leaking them into global shell state.

## The .envrc Pattern

In each oracle's repo root, create `.envrc`:

```bash
# .envrc
export CLAUDE_TOKEN=<your-token-here>
```

Then allow it:

```bash
direnv allow
```

> **Security:** `.envrc` is gitignored by default. Never commit tokens.

## .gitignore

Make sure every repo has:

```gitignore
.envrc
.env
*.local
```

## zshrc Claude Wrapper

Add this to `~/.zshrc` so Claude auto-loads the token and handles session fallback:

```bash
claude() {
  # direnv auto-loads CLAUDE_TOKEN when you cd into a repo
  if [[ -z "$CLAUDE_TOKEN" ]]; then
    echo "warn: CLAUDE_TOKEN not set (missing .envrc?)"
  fi

  # Try --continue first, fall back to new session
  if [[ "$1" == "--continue" ]] || [[ -z "$1" ]]; then
    command claude --continue 2>/dev/null || command claude "$@"
  else
    command claude "$@"
  fi
}
```

## Multiple Tokens

For clinics with multiple API accounts, use different `.envrc` per repo:

```bash
# Repo A — account 1
export CLAUDE_TOKEN=<account-1-token>

# Repo B — account 2
export CLAUDE_TOKEN=<account-2-token>
```

direnv handles the switching automatically when you `cd` between repos.

## Verifying

```bash
cd /path/to/oracle-repo
echo $CLAUDE_TOKEN  # should show your token
cd ~
echo $CLAUDE_TOKEN  # should be empty
```

---

Next: [04 — Pulse CLI](./04-pulse-cli.md)
