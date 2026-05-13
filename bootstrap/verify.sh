#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/.bootstrap/verify}"
mkdir -p "$OUT_DIR"

say() { printf '%s\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

run_bg() {
  local name="$1"
  shift
  local out="$OUT_DIR/$name.log"

  (
    set -euo pipefail
    "$@" >"$out" 2>&1
  ) &
  echo $! >"$OUT_DIR/$name.pid"
}

wait_one() {
  local name="$1"
  local pid
  pid="$(cat "$OUT_DIR/$name.pid")"
  if wait "$pid"; then
    echo 0 >"$OUT_DIR/$name.status"
    return 0
  fi
  echo 1 >"$OUT_DIR/$name.status"
  return 1
}

checks=()

if has git; then
  checks+=(git_version)
  run_bg git_version git --version
fi
if has python3; then
  checks+=(python_version)
  run_bg python_version python3 --version
fi
if has node; then
  checks+=(node_version)
  run_bg node_version node --version
fi
if has npm; then
  checks+=(npm_version)
  run_bg npm_version npm --version
fi
if has codex; then
  checks+=(codex_version)
  run_bg codex_version codex --version
fi
if has claude; then
  checks+=(claude_version)
  run_bg claude_version claude --version
fi
if has openclaw; then
  checks+=(openclaw_version)
  run_bg openclaw_version openclaw --version
  checks+=(openclaw_doctor)
  run_bg openclaw_doctor openclaw doctor
fi

fail=0
for name in "${checks[@]}"; do
  if ! wait_one "$name"; then
    fail=1
  fi
done

say ""
say "verify results: $OUT_DIR"
for name in "${checks[@]}"; do
  status="$(cat "$OUT_DIR/$name.status" 2>/dev/null || echo 1)"
  if [[ "$status" == "0" ]]; then
    say "OK  - $name"
  else
    say "FAIL- $name (see $OUT_DIR/$name.log)"
  fi
done

if [[ "$fail" == "1" ]]; then
  exit 1
fi
