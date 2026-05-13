---
name: handoff-pack
description: セッション終了/中断/委任前に、git 状態・差分・実行コマンド・次手を 1 ファイルに束ねて handoff したいときに使う
---

# handoff-pack

handoff は「次の agent が 5 分以内に再開できる」ことがゴール。
このスキルは handoff の材料を機械的に集め、`docs/03_handoff_format.md` の型に整形する。

## Purpose

- 現状（repo snapshot / 変更 / 検証 / 次手）を 1 ファイルにまとめる
- セッションを跨いでも同じ判断ができるようにする

## When to use

- タスクを中断する、別 agent に渡す、PR 作成前にチェックポイントを作りたい
- “今の状態” を言語化せずに終わりそうなとき（事故防止）

## Inputs

- `REPO_DIR`（絶対パス）
- `OUTPUT_FILE`（例: `HANDOFF.md`）
- `PROJECT_STATUS.md`（存在するなら読む）

## Outputs

- `HANDOFF.md`（または `handoffs/YYYYMMDD_HHMM.md`）

## Steps

1. まず禁止事項と DoD を先頭に書く（空でも見出しだけ作る）
2. repo snapshot を取る
3. 変更点を “高レベル” に要約する（ファイル列挙だけで終わらない）
4. 実行したコマンドと結果を書く（失敗は “原因+次手” で要約）
5. 次の 1〜3 手を番号付きで書く

## Commands (例)

```bash
cd "$REPO_DIR"

git status --porcelain
git log --oneline -10
git diff --stat

# 内容が大きい diff を全文貼らない。必要なら該当ファイルだけ参照。
```

## Template

- 形式は `docs/03_handoff_format.md` の “Handoff Header Template” を使う
- プロジェクト repo に `HANDOFF_CONTEXT.md` がある場合は、環境前提をそこから引用する

## Safety

- secrets を書かない（キー値、cookie、token、個人情報）
- ログ全文を貼りすぎない（必要箇所を要約し、再現コマンドを残す）
- 作業 dir は `/tmp` / `/private/tmp` を使わない

## Done

- [ ] “何をしていたか” が 10 行で説明できる
- [ ] “次に何をするか” が 3 手以内で書かれている
- [ ] 再現コマンドが残っている（`cd` + `git status` + テスト等）
