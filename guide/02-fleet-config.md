# 02 — Fleet Configuration

Fleet configs tell maw which oracles exist, what repos they work in, and how to wake them.

## Config Location

```
~/.config/maw/fleet/
├── 01-oracle-alpha.json
├── 02-oracle-beta.json
└── 03-oracle-gamma.json
```

Each file is one tmux session (one oracle). The numeric prefix sets the session order.

## Config Format

```json
{
  "name": "oracle-alpha",
  "windows": [
    {
      "name": "alpha-oracle",
      "repo": "your-org/alpha-repo"
    }
  ]
}
```

| Field | Description |
|-------|-------------|
| `name` | tmux session name (also the oracle identity) |
| `windows[].name` | tmux window name within the session |
| `windows[].repo` | GitHub repo (resolved via `ghq root`) |

## Multiple Windows

An oracle can have multiple workspaces:

```json
{
  "name": "oracle-alpha",
  "windows": [
    {
      "name": "alpha-oracle",
      "repo": "your-org/main-repo"
    },
    {
      "name": "alpha-tools",
      "repo": "your-org/tools-repo"
    }
  ]
}
```

## Fleet Commands

```bash
# Initialize fleet from ghq repos
maw fleet init

# List all fleet configs
maw fleet ls

# Validate configs (check for dupes, conflicts)
maw fleet validate

# Fix numbering gaps
maw fleet renumber

# Sync configs
maw fleet sync
```

## Wake the Fleet

```bash
# Wake a single oracle
maw wake oracle-alpha

# Wake all oracles (01-15)
maw wake all

# Wake all including dormant (20+)
maw wake all --all
```

## Naming Convention

| Prefix | Purpose |
|--------|---------|
| `01-09` | Core oracles (always on) |
| `10-15` | Support oracles |
| `20+` | Dormant / on-demand |
| `99` | Special purpose |

---

Next: [03 — Environment & Tokens](./03-envrc-token.md)
