#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

say() { printf '%s\n' "$*"; }
err() { printf 'ERROR: %s\n' "$*" >&2; }
has() { command -v "$1" >/dev/null 2>&1; }

missing=()

check_cmd() {
  local cmd="$1"
  if ! has "$cmd"; then
    missing+=("$cmd")
  fi
}

check_cmd git
check_cmd python3
check_cmd node
check_cmd npm

check_cmd codex
check_cmd claude
check_cmd openclaw

if ((${#missing[@]} > 0)); then
  err "Missing required tools: ${missing[*]}"
  say ""
  say "Install hints (manual):"
  say "- git: install via Xcode CLT / package manager"
  say "- python3: install via your package manager (or Xcode CLT on macOS)"
  say "- node/npm: install via fnm (recommended) or package manager"
  say "- codex: npm install -g @openai/codex"
  say "- claude: install Claude Code CLI (see official docs for your OS)"
  say "- openclaw: npm install -g openclaw@latest (or official installer)"
  say ""
  err "Aborting. Install missing tools and rerun: bash \"$ROOT_DIR/bootstrap/install.sh\""
  exit 1
fi

# Soft checks (warn only)
node_major="$(node -v | sed 's/^v//' | cut -d. -f1 || true)"
if [[ -n "${node_major:-}" ]] && [[ "$node_major" -lt 22 ]]; then
  say "WARN: Node.js >= 22 recommended (detected: $(node -v))"
fi

say "OK: required tools are installed."
