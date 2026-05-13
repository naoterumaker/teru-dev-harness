---
name: assign-codex
description: 実装・テスト・コミットまで一気通貫で進めたいとき、Codex CLI (GPT-5.5) に委任する
---

# assign-codex

Codex CLI を「主実装者」として走らせ、与えた context-file に基づいて変更を完走させるための手順。

## Purpose

- 実装・テスト・コミットまでを Codex に任せ、成果物をレビュー可能な形で残す
- “禁止事項” と “DoD” を強制し、事故（/tmp、git add -A、secrets）を避ける

## When to use

- 既存 repo の修正、ドキュメント整備、スクリプト追加など「実装が主」のタスク
- テストやビルドがある場合に、実行して結果まで報告させたいとき

## When NOT to use

- 画面操作やブラウザ操作が中心（その場合は `assign-claudecode`）
- 仕様が未確定で、まず意思決定・比較検討が必要（Opus が先に分解する）

## Inputs

- `REPO_DIR`（絶対パス推奨。`/tmp` と `/private/tmp` は禁止）
- `BRANCH`（基本は作業ブランチ。`main` 直修正は避ける）
- `CONTEXT_FILE`（委任文 + 禁止事項 + DoD + 現状）
- `OUTPUT_DIR`（成果物ログを残す場所）

## Outputs

- 実装結果（git diff / コミット）
- 実行したコマンド（テスト・ビルド・verify）
- 追加で生成した handoff（必要なら）

## Steps (CLI subprocess の例)

> 実際のコマンドは環境差がある。ここでは “形” を固定する。

1. 作業ディレクトリへ移動（絶対パス）
2. `git status --porcelain` を確認（clean か、変更が意図どおりか）
3. context-file を渡して Codex を起動
4. 終了後に `git status` / `git log` / `git diff --stat` を回収

例:

```bash
cd "$REPO_DIR"

# 事故防止の前提チェック
test "$(pwd | sed 's|^/private||')" = "$(pwd)" || echo "ERROR: /private/tmp is forbidden"

# 起動（例: node 経由で spawn してログをファイルへ）
node -e '
  const { spawnSync } = require("node:child_process");
  const fs = require("node:fs");
  const out = process.env.OUTPUT_FILE || "codex_run.log";
  const args = ["--context-file", process.env.CONTEXT_FILE];
  const r = spawnSync("codex", args, { encoding: "utf8" });
  fs.writeFileSync(out, (r.stdout||"") + (r.stderr||""));
  process.exit(r.status ?? 1);
'
```

## Safety (Non-negotiables)

- MUST NOT: `git add -A` / `git add .`
- MUST NOT: `--no-verify`
- MUST NOT: `/tmp` / `/private/tmp` 配下で作業
- MUST NOT: `main` への force push
- MUST: secrets を repo / ログへ出さない（キー名のみ可、値は不可）

## Done (最低限)

- [ ] DoD を満たす変更がコミットされている（または “未コミット理由” が説明されている）
- [ ] 実行した検証コマンドと結果が残っている
- [ ] 変更範囲が意図した領域に収まっている（無関係な変更がない）
