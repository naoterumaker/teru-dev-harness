---
name: assign-claudecode
description: UI 操作・ブラウザ操作・computer-use が必要なタスクを Claude Code (Sonnet) に委任するときに使う
---

# assign-claudecode

Claude Code を “UI/computer-use 専門” として走らせるための委任手順。
Codex が主実装で、Claude は画面操作・UI 依存の検証・デザイン微調整を担当する。

## Purpose

- UI の状態確認、操作手順の実行、視覚確認が必要なタスクを任せる
- 結果を「次に実装が進む形」（チェックリスト、スクショ説明、パッチ）で返す

## When to use

- ブラウザ操作、フォーム入力、画面遷移の確認が必要
- UI の before/after を言語化したい
- “どう操作すれば再現できるか” を確定したい

## When NOT to use

- 実装主体で、git 操作まで含めて完走したい（`assign-codex` が第一候補）
- 仕様が未確定で意思決定が必要（まず Opus に戻す）

## Inputs

- `REPO_DIR`（絶対パス。`/tmp` と `/private/tmp` は禁止）
- `CONTEXT_FILE`（6 ブロック依頼文 + 禁止事項 + DoD + UI 操作の期待）
- `OUTPUT_DIR`（ログ/メモを残す場所）

## Outputs

- UI 操作結果（観察メモ、スクショの説明、再現手順）
- 可能なら最小パッチ（CSS/文言/手順修正）
- 次アクション（Codex が実装できる粒度の TODO）

## Steps (委任のコツ)

1. DoD を UI の観点で書く
   - 例: “この画面で {{LABEL}} が表示される”、 “ボタン押下でエラーが出ない”
2. “何を見れば完了か” を明示する
   - 画面名 / URL / 期待する状態 / NG 例
3. 操作手順を番号付きで渡す
4. 結果は “観察 → 結論 → 次手” の順で返してもらう

## CLI subprocess の例

> 実際の起動方法は環境差がある。ここでは “ログをファイルに残す” 形を示す。

```bash
cd "$REPO_DIR"

node -e '
  const { spawnSync } = require("node:child_process");
  const fs = require("node:fs");
  const out = process.env.OUTPUT_FILE || "claude_run.log";
  const r = spawnSync("claude", ["--context-file", process.env.CONTEXT_FILE], { encoding: "utf8" });
  fs.writeFileSync(out, (r.stdout||"") + (r.stderr||""));
  process.exit(r.status ?? 1);
'
```

## Safety (Non-negotiables)

- MUST NOT: secrets を貼り付ける（キー値、cookie、token、個人情報）
- MUST NOT: `/tmp` / `/private/tmp` 作業
- MUST NOT: `git add -A` / `--no-verify` / `main` force push
- MUST: UI 操作で外部サービスを触る場合は “操作対象（dev/staging/prod）” を明示する

## Done (最低限)

- [ ] 依頼された UI の DoD が満たされたか YES/NO が明確
- [ ] 再現手順が番号付きで残っている
- [ ] 次に Codex が進める TODO が粒度よく書かれている
