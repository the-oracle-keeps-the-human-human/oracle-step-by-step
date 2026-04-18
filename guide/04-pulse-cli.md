# 04 — Pulse CLI

Pulse manages your project board — tasks, timelines, and oracle assignments.

## Setup

```bash
# Initialize pulse in your repo
pulse init

# Set up the GitHub Projects board
pulse setup-board
```

This creates a GitHub Project board linked to your repo for tracking oracle work.

## Core Commands

### Task Management

```bash
# Add a task
pulse add "Set up VPN between nodes" --oracle oracle-alpha --priority P1

# List board
pulse ls

# Sync board checkboxes with daily thread
pulse ls --sync

# View timeline
pulse timeline
```

### Task Fields

| Field | Description |
|-------|-------------|
| `--oracle` | Assign to specific oracle |
| `--priority` | P0 (critical), P1 (high), P2 (normal), P3 (low) |
| `--wt` | Assign to specific worktree |

## Integration with maw

Pulse and maw work together:

```bash
# Create task + wake the assigned oracle
maw pulse add "Fix auth flow" --oracle oracle-alpha

# Wake fleet and resume board items
maw wake all --resume
```

## Board View

```bash
pulse ls
```

Shows a terminal table:

```
#  | Task                    | Oracle       | Priority | Status
---|-------------------------|--------------|----------|--------
1  | Set up VPN              | oracle-alpha | P1       | in_progress
2  | Configure fleet         | oracle-beta  | P2       | todo
3  | Write clinic guide      | oracle-gamma | P2       | done
```

## Daily Workflow

1. `pulse ls` — check what's pending
2. `maw wake <oracle>` — wake the oracle for a task
3. Oracle works, commits, PRs
4. `pulse ls --sync` — update board from PR activity

---

Next: [05 — GitHub Workflows](./05-github-workflows.md)
