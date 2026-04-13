#!/usr/bin/env bash
set -euo pipefail

# Oracle Setup Script — Install tools + skills for Oracle system
# Usage: ./setup.sh [--check-only] [--skip-mcp] [--skip-skills]

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_only=false
skip_mcp=false
skip_skills=false

for arg in "$@"; do
  case $arg in
    --check-only) check_only=true ;;
    --skip-mcp) skip_mcp=true ;;
    --skip-skills) skip_skills=true ;;
  esac
done

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
info() { echo -e "  ${BLUE}→${NC} $1"; }

echo ""
echo "========================================="
echo "  Oracle Setup — Tool Check"
echo "========================================="
echo ""

missing=()

# Check each prerequisite
if command -v node &>/dev/null; then
  ok "Node.js $(node --version)"
else
  fail "Node.js — not found"
  missing+=("node")
fi

if command -v bun &>/dev/null; then
  ok "Bun $(bun --version 2>/dev/null || echo '?')"
else
  fail "Bun — not found"
  missing+=("bun")
fi

if command -v git &>/dev/null; then
  ok "Git $(git --version | cut -d' ' -f3)"
else
  fail "Git — not found"
  missing+=("git")
fi

if command -v gh &>/dev/null; then
  ok "GitHub CLI $(gh --version | head -1 | cut -d' ' -f3)"
  if gh auth status &>/dev/null 2>&1; then
    ok "GitHub CLI — authenticated"
  else
    warn "GitHub CLI — not logged in (run: gh auth login)"
  fi
else
  fail "GitHub CLI — not found"
  missing+=("gh")
fi

if command -v claude &>/dev/null; then
  ok "Claude Code $(claude --version 2>/dev/null || echo '?')"
else
  fail "Claude Code — not found"
  missing+=("claude")
fi

if command -v tmux &>/dev/null; then
  ok "tmux $(tmux -V | cut -d' ' -f2)"
else
  warn "tmux — not found (optional, needed for multi-oracle)"
fi

echo ""

if [ ${#missing[@]} -eq 0 ]; then
  echo -e "${GREEN}All prerequisites installed!${NC}"
else
  echo -e "${YELLOW}Missing: ${missing[*]}${NC}"
fi

if $check_only; then
  echo ""
  echo "Run without --check-only to install missing tools."
  exit 0
fi

# Install missing tools
if [[ " ${missing[*]} " == *" bun "* ]]; then
  echo ""
  info "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  ok "Bun installed"
fi

if [[ " ${missing[*]} " == *" node "* ]]; then
  echo ""
  warn "Node.js not found. Install via:"
  echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
  echo "  nvm install --lts"
  echo ""
  echo "Then re-run this script."
  exit 1
fi

if [[ " ${missing[*]} " == *" claude "* ]]; then
  echo ""
  info "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  ok "Claude Code installed"
fi

if [[ " ${missing[*]} " == *" gh "* ]]; then
  echo ""
  warn "GitHub CLI not found. Install:"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  brew install gh"
  else
    echo "  See https://cli.github.com/"
  fi
fi

# Install oracle-skills-cli
if ! $skip_skills; then
  echo ""
  echo "========================================="
  echo "  Installing Oracle Skills"
  echo "========================================="
  echo ""

  if command -v oracle-skills &>/dev/null; then
    ok "oracle-skills-cli already installed"
  else
    info "Installing oracle-skills-cli..."
    npm install -g oracle-skills 2>/dev/null || \
      curl -fsSL https://raw.githubusercontent.com/Soul-Brews-Studio/oracle-skills-cli/main/install.sh | bash
    ok "oracle-skills-cli installed"
  fi

  info "Installing standard + soul skills globally..."
  oracle-skills install -g -y -p standard +soul 2>/dev/null || \
    warn "Skills install had issues — you can retry manually: oracle-skills install -g -y -p standard +soul"
  ok "Skills installed"
fi

# Add oracle-v2 MCP
if ! $skip_mcp; then
  echo ""
  echo "========================================="
  echo "  Adding oracle-v2 MCP Server"
  echo "========================================="
  echo ""

  info "Adding oracle-v2 to Claude Code..."
  claude mcp add oracle-v2 -- bunx --bun arra-oracle@github:Soul-Brews-Studio/arra-oracle#main 2>/dev/null || \
    warn "MCP add had issues — you can add manually: claude mcp add oracle-v2 -- bunx --bun arra-oracle@github:Soul-Brews-Studio/arra-oracle#main"
  ok "oracle-v2 MCP added"
fi

echo ""
echo "========================================="
echo -e "  ${GREEN}Setup Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Create your Oracle repo: gh repo create my-oracle --public --clone"
echo "  2. Open Claude Code in it: cd my-oracle && claude"
echo "  3. Tell Claude: \"ช่วยสร้าง Oracle ให้หน่อย\""
echo ""
echo "Or let Claude do everything — open this repo in Claude Code"
echo "and say: \"Help me set up my Oracle\""
echo ""
