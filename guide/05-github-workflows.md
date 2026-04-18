# 05 — GitHub Actions Workflows

Automate oracle operations with GitHub Actions: PR reviews, notifications, and fleet sync.

## 1. PR Review Workflow

Auto-review PRs with Claude:

```yaml
# .github/workflows/pr-review.yml
name: Oracle PR Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Review PR
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          DIFF=$(git diff origin/main...HEAD)
          claude --print "Review this PR diff. Flag security issues, bugs, and style problems. Be concise. Diff: $DIFF" > review.md

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: `## Oracle Review\n\n${review}`
            });
```

## 2. Notify Workflow

Send maw notifications when PRs are merged:

```yaml
# .github/workflows/notify.yml
name: Oracle Notify

on:
  pull_request:
    types: [closed]

jobs:
  notify:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Notify via webhook
        run: |
          curl -X POST "${{ secrets.MAW_WEBHOOK_URL }}" \
            -H "Content-Type: application/json" \
            -d "{\"event\": \"pr_merged\", \"title\": \"${{ github.event.pull_request.title }}\", \"repo\": \"${{ github.repository }}\"}"
```

## 3. Fleet Sync (Daily Cron)

Keep fleet configs in sync across machines:

```yaml
# .github/workflows/fleet-sync.yml
name: Fleet Sync

on:
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM UTC
  workflow_dispatch:       # Manual trigger

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate fleet configs
        run: |
          for f in fleet/*.json; do
            echo "Validating $f..."
            python3 -c "import json; json.load(open('$f'))" || exit 1
          done
          echo "All fleet configs valid."

      - name: Check for conflicts
        run: |
          # Extract all session names, check for duplicates
          names=$(cat fleet/*.json | python3 -c "
          import json, sys
          configs = [json.loads(l) for l in sys.stdin if l.strip()]
          names = [c['name'] for c in configs]
          dupes = [n for n in names if names.count(n) > 1]
          if dupes:
              print(f'CONFLICT: duplicate names: {set(dupes)}')
              sys.exit(1)
          print(f'OK: {len(names)} configs, no conflicts')
          ")
          echo "$names"
```

## Secrets Required

| Secret | Purpose |
|--------|---------|
| `ANTHROPIC_API_KEY` | Claude API access for PR review |
| `MAW_WEBHOOK_URL` | Notification endpoint (optional) |

Add these in **Settings → Secrets and variables → Actions**.

## Tips

- Use `workflow_dispatch` on all workflows so you can trigger manually
- Keep review prompts short — long prompts eat tokens
- Set concurrency limits to avoid parallel review conflicts

---

Next: [06 — GitHub Flow](./06-github-flow.md)
