
# 00_overview — teru-dev-harness 全体俯瞰

この repo は「AI agent を複数使い分ける前提」で、個人の dev 環境を統一するためのメタ層です。
個別プロジェクトに依存しない形で **運用ルール / 委任 / context / handoff / bootstrap** を提供します。

## ゴール

- どのプロジェクトでも同じ作法で開発できる
- 「最初の 30 分」で環境が立ち上がる（新 PC / 新 repo）
- 人間が司令塔になり、AI は役割分担して継続的に成果を積む
- 事故（/tmp 喪失、secret 混入、巨大 revert、Operator mode 事故）を仕組みで防ぐ

## 主要コンポーネント

- **AGENTS.md**: 全 agent 共通の掟（universal）
- **CLAUDE.md**: Claude Code 専用 override
- **docs/**: 委任・context engineering・handoff・事故・セキュリティ
- **skills/**: SKILL.md（Anthropic schema 準拠）で「委任の型」を文書化
- **templates/**: 新プロジェクトに最初にコピーするテンプレ群
- **bootstrap/**: 新 PC で 1 発セットアップするスクリプト + dotfiles 雛形
- **memory-seeds/**: 新しい Claude セッションで拾わせたい運用知の種
- **PRIOR_ART.md**: 参照した世界の repo / article の一覧

## エージェント編成 (固定)

- **Opus**: 司令塔（計画・委任・検証）
- **Codex (GPT-5.5)**: 主実装（実装・テスト・コミット）
- **Claude Code (Sonnet)**: UI/computer-use・画面操作系
- **openclaw**: オーケストレーション（handoff / context-file / 自動束ね）

## 全体図 (ASCII)

```
                 ┌──────────────────────────┐
                 │          Human           │
                 │   goals / constraints    │
                 └───────────┬──────────────┘
                             │
                             ▼
                 ┌──────────────────────────┐
                 │      Opus (Commander)    │
                 │ plan / DoD / delegate    │
                 └───────────┬──────────────┘
                             │ delegate (6 blocks)
        ┌────────────────────┼─────────────────────┐
        │                    │                     │
        ▼                    ▼                     ▼
┌────────────────┐  ┌────────────────┐   ┌────────────────────┐
│ Codex (GPT-5.5)│  │ Claude (Sonnet)│   │ openclaw (orchestr) │
│ implement + git │  │ UI/computer-use│   │ context/handoff pack │
└───────┬────────┘  └───────┬────────┘   └──────────┬─────────┘
        │                   │                        │
        ▼                   ▼                        ▼
  code/docs changes     UI ops /      handoff.md / context-file
  tests + commits       screenshots    for next agent/session
```

## 典型的な 1 サイクル

1. **Opus が分解**: 目的 → スコープ → 禁止事項 → DoD
2. **Context を整える**: `PROJECT_STATUS.md` と差分状況を揃える
3. **委任**: 6 ブロック依頼文で Codex / Claude / openclaw に投げる
4. **実装**: Codex が実装・テスト・コミット（`git add -A` は使わない）
5. **handoff**: `handoff-pack` で次の agent/次セッションへ引き継げる状態に束ねる
6. **振り返り**: 事故が起きたら `docs/05_lessons.md` に追記し、掟に反映

## 新プロジェクト開始の流れ

新しい repo を作った直後に、最初に「運用の型」を入れることが重要です。

1. `templates/` をプロジェクト root にコピー
   - `PROJECT_AGENTS.md.tmpl` → `AGENTS.md`
   - `PROJECT_STATUS.md.tmpl` → `PROJECT_STATUS.md`
   - `HANDOFF_CONTEXT.md.tmpl` → `HANDOFF_CONTEXT.md`
2. `PROJECT_STATUS.md` の「触って良い範囲」「ロードマップ」「地雷」を埋める
3. 以降は「着手前に status を更新」「handoff 時に pack」を守る

## ファイル構成メモ

```
teru-dev-harness/
  AGENTS.md                 universal rules (MUST)
  CLAUDE.md                 Claude Code override
  docs/                     system design + workflow + lessons
  skills/                   skill books (YAML frontmatter + markdown)
  templates/                new project templates (copy-first)
  bootstrap/                setup scripts + sanitized dotfiles
  memory-seeds/             stable feedback seeds (no secrets)
  PRIOR_ART.md              references + what we adopted
```

## この repo で「しないこと」

- 特定プロジェクトの実装・依存追加をここに混ぜない
- API key を書かない（テンプレはプレースホルダのみ）
- 便利そうな機能を思いつきで増やさない（まず docs のロードマップに落とす）

次は `docs/01_workflow.md` に進んで、委任の決定木と依頼文の型を読む。
