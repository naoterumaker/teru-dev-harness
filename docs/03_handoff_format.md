
# 03_handoff_format — handoff の形式 (OpenAI v0.6.0 互換)

handoff は「次の agent / 次のセッション」が **即座に作業再開できる**ための最小パッケージです。
この repo では、Markdown で handoff を作り、必要に応じて `--context-file` として流用します。

## “OpenAI v0.6.0 互換” の意味

OpenAI Agents SDK (v0.6.x) の推奨プロンプトは `# System context` という見出しから始まる。
本ハーネスの handoff も先頭を **`# System context`** に統一し、他の agent/runner でも取り回せる形にする。

## 1 ファイル handoff の基本ルール

- **1 ファイルで完結**する（リンク先は OK だが、handoff 自体は読めば動ける）
- 先頭に **禁止事項と DoD** を置く（事故防止が最優先）
- **絶対パス**で作業 dir を固定する（/tmp 禁止）
- 秘密情報は書かない（キー名は OK、値は NG）
- 実行したコマンドは「コピペで再現できる」形で残す

## Handoff Header Template (コピペ用)

以下をそのまま新規ファイルに貼り、空欄を埋める。

```md
# System context

- Date: {{YYYY-MM-DD}}
- Repo: {{REPO_URL_OR_PATH}}
- Branch: {{BRANCH}}
- Workdir (absolute): {{ABS_PATH}}
- Agent roles: Opus=commander / Codex=primary implementer / Claude=UI specialist

## Non-negotiables (MUST / MUST NOT)

- MUST NOT: git add -A / git add .
- MUST NOT: --no-verify
- MUST NOT: work under /tmp or /private/tmp
- MUST NOT: force push to main
- MUST: no secrets (API keys, tokens) in repo or logs

## Task

{{WHAT_WE_WERE_TRYING_TO_DO}}

## Definition of Done (DoD)

- [ ] {{DOD_1}}
- [ ] {{DOD_2}}

## Current status

- What is done: {{DONE_SUMMARY}}
- What is pending: {{PENDING_SUMMARY}}
- Risks / unknowns: {{RISKS}}

## Repo snapshot

```bash
cd {{ABS_PATH}}
git status --porcelain
git log --oneline -10
```

## Changes (high level)

- {{CHANGE_1}}
- {{CHANGE_2}}

## Commands I ran

```bash
{{COMMANDS}}
```

## Verification

- Tests: {{TEST_COMMANDS_OR_NA}}
- Result: {{PASS_FAIL}}

## Next steps

1. {{NEXT_1}}
2. {{NEXT_2}}
```

## どこに置くか

推奨:

- プロジェクト repo: `HANDOFF.md`（短期）または `handoffs/YYYYMMDD_HHMM.md`（履歴）
- 長期運用は `PROJECT_STATUS.md` を SoT にし、handoff は “差分と再開点” に寄せる

## handoff-pack との関係

- 手動で書くのが理想だが、忙しいときは `skills/handoff-pack/` の手順で機械的に作る
- 自動生成物は「Repo snapshot / Commands / Diff summary」になりやすいので、
  最低限 `Non-negotiables` と `DoD` だけは人間が追記する

## アンチパターン

- “差分だけ貼って終わり” → 何が目的で、次に何をするかが消える
- “ログ全文” → token を食い、重要なエラーが埋もれる（要約 + 再現コマンドにする）
- “相対パスだけ” → 作業ディレクトリがズレて事故る（絶対パスを残す）
- “禁止事項が後ろ” → 読まれずに踏む（先頭付近に固定）

## チェックリスト (handoff を書いた後)

- [ ] 5 分で再開できる（`cd` → `git status` → 次コマンドがある）
- [ ] secrets が入っていない（値がない）
- [ ] /tmp 系パスが出てこない
- [ ] “次手” が 1〜3 個で書かれている
