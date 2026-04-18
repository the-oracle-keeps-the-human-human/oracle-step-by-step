# 01 — Tools Installation

Everything you need to set up an Oracle clinic workstation.

## Prerequisites

- macOS (Apple Silicon recommended) or Linux
- Homebrew (macOS) or apt (Linux)
- GitHub account with SSH key configured

## Install Core Tools

### 1. ghq — Git Repository Manager

```bash
brew install ghq
git config --global ghq.root ~/ghq
```

### 2. Bun — JavaScript Runtime

```bash
curl -fsSL https://bun.sh/install | bash
```

### 3. Claude Code — AI Agent CLI

```bash
npm install -g @anthropic-ai/claude-code
```

### 4. maw — Multi-Agent Workflow

```bash
npm install -g https://github.com/Soul-Brews-Studio/maw-js
```

### 5. direnv — Per-Directory Environment

```bash
brew install direnv
```

Add to your `~/.zshrc`:

```bash
eval "$(direnv hook zsh)"
```

### 6. Pulse CLI — Board Management

```bash
npm install -g @anthropic-ai/pulse-cli
```

## Symlink Strategy

Keep tools accessible from `/usr/local/bin/` so all tmux sessions find them:

```bash
# Find where each tool installed
which ghq maw claude bun direnv

# Symlink to /usr/local/bin/ (adjust source paths)
sudo ln -sf $(which ghq) /usr/local/bin/ghq
sudo ln -sf $(which maw) /usr/local/bin/maw
sudo ln -sf $(which claude) /usr/local/bin/claude
sudo ln -sf $(which bun) /usr/local/bin/bun
sudo ln -sf $(which direnv) /usr/local/bin/direnv
```

> **Why symlinks?** tmux sessions may not load your full shell profile. Symlinks in `/usr/local/bin/` ensure tools are always on `$PATH`.

## Verify Installation

```bash
ghq --version
bun --version
claude --version
maw --version
direnv version
```

All five should print version numbers without errors.

---

Next: [02 — Fleet Config](./02-fleet-config.md)
