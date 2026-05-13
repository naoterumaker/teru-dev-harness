---
name: git-commit-conv
description: Conventional Commits で安全にコミットを切り、設計書セクション参照と Co-Authored-By を付けたいときに使う
---

# git-commit-conv

コミットは「レビュー可能な単位」で切る。AI 開発では特に重要。
このスキルは Conventional Commits を前提に、禁止事項と運用上の “型” を固定する。

## Purpose

- 1 commit = 1 領域を徹底し、手戻り・revert を容易にする
- “どの設計セクションに紐づく変更か” を追跡しやすくする
- AI 共同作業の証跡（Co-Authored-By）を残す

## Non-negotiables

- MUST NOT: `git add -A` / `git add .`
- MUST NOT: `git commit --no-verify`
- MUST NOT: `main` force push

## Conventional Commits (要点)

形式:

```
<type>(<scope>): <subject>
```

例:

- `docs(agents): add universal harness rules`
- `feat(bootstrap): add install/verify scripts`
- `chore(dotfiles): add sanitized templates`

## Scope の使い方

- `agents` / `claude` / `harness` / `skills` / `templates` / `bootstrap` / `seeds` / `prior-art`
- 迷ったら “変更の受け皿ディレクトリ” を scope にする

## 設計書セクション参照 (任意だが推奨)

コミット本文に “参照” を残す（例）。

```
Refs: docs/01_workflow.md
Refs: docs/03_handoff_format.md
```

## Co-Authored-By (推奨)

AI の共同作業がある場合は trailer を付ける（例）。

```
Co-Authored-By: Codex <codex@local>
Co-Authored-By: Claude <claude@local>
```

## Steps

1. 変更の単位を決める（混ぜない）
2. 明示パスで stage する
3. 必要な検証（最小テスト）を実行する
4. Conventional Commits で commit する（`--no-verify` は使わない）

例:

```bash
# 明示パス add
git add docs/01_workflow.md docs/02_context_engineering.md

# commit
git commit -m "docs(harness): refine workflow + context docs" \
  -m "Refs: docs/01_workflow.md" \
  -m "Refs: docs/02_context_engineering.md" \
  -m "Co-Authored-By: Codex <codex@local>"
```

## Done

- [ ] `git status --porcelain` が意図どおり（余計なファイルが stage されていない）
- [ ] commit message が type/scope を満たす
- [ ] 参照（Refs）と Co-Authored-By が必要なら入っている
