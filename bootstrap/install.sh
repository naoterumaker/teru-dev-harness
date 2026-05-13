#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

say() { printf '%s\n' "$*"; }
err() { printf 'ERROR: %s\n' "$*" >&2; }

say "== teru-dev-harness bootstrap/install.sh =="
say "root: $ROOT_DIR"
say ""

say "== 1) tools check =="
bash "$ROOT_DIR/bootstrap/tools.sh"
say ""

say "== 2) deploy dotfiles (safe copy) =="
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
TERU_HOME="${TERU_HOME:-$HOME/.config/teru-dev-harness}"

mkdir -p "$CODEX_HOME" "$OPENCLAW_HOME" "$TERU_HOME"

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"

deploy_file() {
  local src="$1"
  local dst="$2"

  if [[ -f "$dst" ]]; then
    local bak="$dst.bak.$timestamp"
    cp -p "$dst" "$bak"
    say "backup: $bak"
  fi
  cp -p "$src" "$dst"
  say "write:  $dst"
}

# Codex config
deploy_file "$ROOT_DIR/bootstrap/dotfiles/codex-config.toml" "$CODEX_HOME/config.toml"

# OpenClaw config template (do not overwrite existing openclaw.json silently)
if [[ -f "$OPENCLAW_HOME/openclaw.json" ]]; then
  cp -p "$ROOT_DIR/bootstrap/dotfiles/openclaw.json.tmpl" "$OPENCLAW_HOME/openclaw.json.teru-dev-harness.tmpl"
  say "write:  $OPENCLAW_HOME/openclaw.json.teru-dev-harness.tmpl"
else
  deploy_file "$ROOT_DIR/bootstrap/dotfiles/openclaw.json.tmpl" "$OPENCLAW_HOME/openclaw.json"
fi

# env example
cp -p "$ROOT_DIR/bootstrap/dotfiles/env.example" "$TERU_HOME/env.example"
say "write:  $TERU_HOME/env.example"

say ""
say "== 3) copy skills (personal installs) =="
mkdir -p "$CODEX_HOME/skills" "$OPENCLAW_HOME/skills" "$HOME/.claude/skills"

copy_skill_tree() {
  local target_root="$1"
  local dst="$target_root/teru-dev-harness"
  if [[ -e "$dst" ]]; then
    local bak="$dst.bak.$timestamp"
    mv "$dst" "$bak"
    say "backup: $bak"
  fi
  mkdir -p "$dst"
  cp -R "$ROOT_DIR/skills/." "$dst/"
  say "write:  $dst"
}

copy_skill_tree "$CODEX_HOME/skills"
copy_skill_tree "$OPENCLAW_HOME/skills"
copy_skill_tree "$HOME/.claude/skills"

say ""
say "== 4) verify =="
bash "$ROOT_DIR/bootstrap/verify.sh"

say ""
say "DONE."
