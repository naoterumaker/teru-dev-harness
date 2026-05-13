
# 04_skills_guide — SKILL.md の書き方

この repo の `skills/**/SKILL.md` は「AI agent に読ませる手順書」です。
コードではなく、**再現性のある運用**を文章で定義します。

## なぜ skills を文書にするのか

- 依頼文の型・禁止事項・成果物の形式を “暗黙知” にしない
- セッションを跨いでも同じ動きを再現できる
- 事故パターン（/tmp、git add -A、secrets）を機械的に回避できる

## フォーマット (必須)

SKILL.md は YAML frontmatter + Markdown 本文で構成する。

```yaml
---
name: skill-name
description: 1 行で何のスキルか + いつ発火するか
---
```

本文は Markdown。

## 推奨セクション

スキル本文は次のセクション構成を推奨する（必要なものだけで OK）。

- **Purpose**: 何を達成するスキルか
- **When to use**: いつ使うか / いつ使わないか
- **Inputs**: 必須情報（repo path / branch / context-file / 出力先）
- **Outputs**: 成果物（ファイル / コマンド / 報告形式）
- **Steps**: 手順（番号付き、最小）
- **Safety**: 禁止事項、secret、破壊的操作の注意
- **Done**: 完了条件（DoD の最小版）

## 設計指針

### 1) “トリガ” を明確にする

- description に「どんな依頼が来たら発火するか」を 1 行で書く
- 例: “handoff を作って次の agent に渡す必要があるとき”

### 2) 入出力を固定する

- “出力ファイル名” を決める（例: `HANDOFF.md`）
- “標準で集める情報” を固定する（git status/log、差分要約、実行コマンド）

### 3) 破壊的操作を避ける

- `rm -rf` のような操作は原則しない
- `git add -A`、`--no-verify`、force push などの禁則は必ず Safety に書く

### 4) スキルは “小さく”

- 1 スキル 1 ゴール（複数やるならスキルを分ける）
- 手順は 5〜12 ステップ程度を目安に

## レビュー観点

- 手順どおりにやれば再現できるか（環境差が出ないか）
- 禁止事項が冒頭で目に入るか
- 成果物が客観的に検証できるか（コマンド / ファイル / 状態）

## この repo の運用メモ

- スキルは `skills/<name>/SKILL.md` に置く
- 変更したら、関連ドキュメント（`docs/01_workflow.md`, `docs/03_handoff_format.md`）との整合も確認する

## 命名規約 (おすすめ)

- `name` は短く、動詞 + 対象（例: `handoff-pack`, `assign-codex`）
- `description` は “いつ使うか” を必ず含める（トリガが曖昧だと暴発する）

例:

```yaml
---
name: handoff-pack
description: セッション終了/中断/委任前に handoff を 1 ファイルに束ねたいときに使う
---
```

## supporting files の使いどころ

SKILL.md を肥大化させないために、同じディレクトリへ補助ファイルを置ける。

- `templates/`（そのスキル専用のテンプレ）
- `scripts/`（実行する補助スクリプト）
- `examples/`（出力例、良い/悪い例）

原則:

- SKILL.md は “入口” と “ナビ” に集中する
- 詳細な参考資料は別ファイルに逃がす

## バージョニング

破壊的変更をした場合は、本文に “変更履歴” を短く残す（任意）。

```
## Version History
- 2026-05-13: initial
```
