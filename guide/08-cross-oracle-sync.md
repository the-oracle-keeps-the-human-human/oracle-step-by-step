# 08 — Cross-Oracle Sync & Federation

How oracles communicate, share knowledge, and coordinate across machines.

## maw hey — Real-Time Messaging

Send a message to any oracle in your fleet:

```bash
# Local (same machine)
maw hey oracle-beta "PR #42 is ready for review"

# Remote (over VPN)
maw wire oracle-gamma "Deploy config updated, please pull"
```

## maw federation

Federation connects multiple maw instances across machines:

```bash
# Check peer connectivity
maw federation status

# Ping all peers
maw ping

# Ping specific node
maw ping 10.0.0.2
```

### How It Works

```
Machine A (10.0.0.1)          Machine B (10.0.0.2)
┌──────────────────┐          ┌──────────────────┐
│ maw serve 3456   │◄────────►│ maw serve 3456   │
│                  │  HTTP/WG  │                  │
│ oracle-alpha     │          │ oracle-gamma      │
│ oracle-beta      │          │ oracle-delta      │
└──────────────────┘          └──────────────────┘
```

Each machine runs `maw serve` which exposes the local fleet over HTTP. Over WireGuard, machines discover and message each other's oracles.

### Start the Server

```bash
# Basic
maw serve

# With MQTT broker for pub/sub messaging
maw serve --mqtt
```

## Transport Layers

maw supports multiple transport methods:

| Transport | Use Case |
|-----------|----------|
| **tmux** | Local oracle messaging (same machine) |
| **HTTP** | Cross-machine via `maw serve` + VPN |
| **MQTT** | Pub/sub for broadcast messages |

Check status:

```bash
maw transport status
```

## Workspace Sharing

Share oracles across teams:

```bash
# Create a shared workspace
maw workspace create clinic-team

# Get invite code
maw workspace invite

# Share oracles to workspace
maw workspace share oracle-alpha oracle-beta

# Another machine joins
maw workspace join <invite-code>

# See all shared oracles
maw workspace agents
```

## Sync Patterns

### Memory Sync (maw reunion)

Sync oracle memory from worktrees back to the main repo:

```bash
# Sync specific oracle's memory
maw reunion oracle-alpha

# This copies ψ/memory/ from worktree → main repo
```

### Fleet Sync

Keep fleet configs consistent:

```bash
# Push local fleet configs to repo
maw fleet sync

# CI validates daily (see 05-github-workflows.md)
```

### Chat History

View oracle conversations:

```bash
# Chat bubbles view
maw chat oracle-alpha

# Full log
maw log chat oracle-alpha
```

## Clinic Federation Checklist

- [ ] WireGuard VPN running between all nodes ([guide](./07-vpn-private-network.md))
- [ ] `maw serve` running on each machine
- [ ] `MAW_HOST` set to VPN address
- [ ] `maw ping` succeeds across nodes
- [ ] Workspace created and oracles shared
- [ ] Fleet configs synced

## Example: Two-Node Clinic

```bash
# Machine A (reception)
maw serve 3456
maw wake oracle-reception

# Machine B (backend)
maw serve 3456
maw wake oracle-backend

# From Machine A, message Machine B's oracle
maw wire oracle-backend "New patient form submitted, process intake"

# Check federation
maw federation status
```

---

That's it. Your clinic oracle fleet is connected and talking.

Back to: [01 — Tools Install](./01-tools-install.md)
