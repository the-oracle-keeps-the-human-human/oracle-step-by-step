# 06 — GitHub Flow

The standard workflow for oracle development: branch, PR, auto-close.

## The Flow

```
main ──────────────────────────────── main
       \                          /
        └── feature-branch ──── PR ── merge
```

1. **Branch** from main
2. **Work** — commits on the branch
3. **PR** — open pull request
4. **Review** — oracle or human reviews
5. **Merge** — squash or merge commit
6. **Auto-close** — linked issues close automatically

## Step by Step

### 1. Create Branch

```bash
git checkout -b fix/auth-timeout
```

Naming convention:

| Prefix | Use |
|--------|-----|
| `fix/` | Bug fixes |
| `feat/` | New features |
| `guide/` | Documentation |
| `chore/` | Maintenance |

### 2. Work and Commit

```bash
git add -A
git commit -m "Fix auth timeout by extending session TTL

Fixes #12"
```

> **Key:** Include `Fixes #N` in the commit message to auto-close the issue on merge.

### 3. Push and PR

```bash
git push -u origin fix/auth-timeout

gh pr create --title "Fix auth timeout" --body "## Summary
- Extended session TTL from 15m to 1h
- Added retry logic for token refresh

Fixes #12"
```

### 4. Review

The PR review workflow (from [05](./05-github-workflows.md)) runs automatically. Human or oracle reviews the output.

### 5. Merge

```bash
# Via CLI
gh pr merge --squash

# Or merge via GitHub UI
```

### 6. Auto-Close

When the PR merges, GitHub automatically closes issue #12 because of the `Fixes #12` reference.

## CODEOWNERS

Control who reviews what with `.github/CODEOWNERS`:

```
# Default — oracle reviews everything
* @your-org/oracle-team

# Specific paths
/guide/ @your-org/docs-team
/.github/ @your-org/infra-team
```

When a PR touches files matching a pattern, GitHub auto-requests review from the listed team.

### Setup

1. Create `.github/CODEOWNERS` in your repo
2. Enable "Require review from Code Owners" in branch protection rules

## Branch Protection

Recommended settings for `main`:

- Require pull request reviews (1 approval)
- Require status checks (PR review workflow)
- No direct pushes to main
- No force pushes

Configure in **Settings → Branches → Branch protection rules**.

---

Next: [07 — VPN Private Network](./07-vpn-private-network.md)
