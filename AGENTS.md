
# teru-dev-harness — AGENTS.md (universal)

このリポジトリは「個人の開発環境 / AI コーディング agent 運用」をプロジェクト非依存で統一するためのハーネスです。
Claude Code / Codex / Cursor / Gemini CLI 等、どの agent が repo root を読んでも同じ掟で動けることを目的とします。

## 目的 (Why)

- 複数プロジェクトを **同じ運用ルール**（委任 / コンテキスト / セキュリティ / Git 作法）で回す
- AI を「賢い 1 人」ではなく **役割分担したチーム**として運用する
- ハーネス自体を独立 repo として保ち、SynqClaw 等の個別プロジェクトに依存させない

## 役割分担 (固定)

- **Opus = 司令塔**
  - タスク分解、優先順位、DoD/禁止事項の設計、委任の判断を担当
  - 原則「書かない」。書くのは 5 分以内で確実な小修正のみ（誤字、README リンク、1 行の設定など）
- **Codex (GPT-5.5) = 主実装**
  - 変更の大半（コード/ドキュメント/スクリプト）を実装し、テスト・整形・コミットまで完走
  - 迷ったら「まず repo のローカル規約 / docs を読む」を優先
- **Claude Code (Sonnet) = UI / computer-use 専門**
  - 画面操作・ブラウザ操作・フォーム入力・デザイン微調整など、対話 UI に強いタスクを担当
  - 実装も可能だが、原則は補助線（画面観察→手順提示→最小パッチ）
- **openclaw = オーケストレーション層**
  - 「どの agent に何を投げるか」「handoff の形」「コンテキスト束ね」を司る（詳細: `docs/00_overview.md`）

## まず読むべき順番

1. `docs/00_overview.md` — 全体像
2. `docs/01_workflow.md` — 委任の決定木 / 依頼文の型
3. `docs/02_context_engineering.md` — context の設計原則
4. `docs/06_security_sandbox.md` — key / sandbox / short-lived IAM

## 不変ルール (MUST)

### Git

- `git add -A` / `git add .` **禁止**。必ず **変更したパスを明示**して add する
- `--no-verify` **禁止**（pre-commit / commit-msg / pre-push を無効化しない）
- `main` に対する **force push 禁止**（`--force`, `--force-with-lease` を含む）
- コミットは **Conventional Commits**。1 commit = 1 領域（例: docs / skills / templates / bootstrap）
- 仕様外の変更（設計書ロードマップ外の feature 追加、無関係なリファクタ、依存追加）は **勝手にしない**

### 作業ディレクトリ

- `/tmp` と `/private/tmp` 配下での作業 **禁止**（macOS の cleanup で消える）
- 作業は `~/dev/...` など **永続ディレクトリ**で行う

### コンテキストと安全

- API key 等の秘匿情報を **リポジトリに書かない**（テンプレはプレースホルダのみ）
- コマンドの実行前に、破壊的操作（削除・上書き・強制更新）が混ざらないかを必ず確認する
- 迷ったら「最小変更」「スコープを狭く」「ログを残す」

## skills/ の概要

この repo の `skills/` は、主に「委任の型」を文書化したものです（スクリプトではなく手順書）。

- `skills/assign-codex/` — Codex CLI (GPT-5.5) に実装を委任するための手順
- `skills/assign-claudecode/` — Claude Code (Sonnet) に UI/computer-use などを委任するための手順
- `skills/handoff-pack/` — 現状（git 状態・差分・実行コマンド・TODO）を 1 ファイルに束ねる
- `skills/git-commit-conv/` — Conventional Commits + 参照規約 + Co-Authored-By の付与

## templates/ を新プロジェクトに適用する手順

新しいプロジェクトを開始したら、まずテンプレをコピーして「運用の骨格」を入れます。

1. プロジェクト root に以下をコピー
   - `templates/PROJECT_AGENTS.md.tmpl` → `AGENTS.md`
   - `templates/PROJECT_STATUS.md.tmpl` → `PROJECT_STATUS.md`
   - `templates/HANDOFF_CONTEXT.md.tmpl` → `HANDOFF_CONTEXT.md`
2. `PROJECT_STATUS.md` を最初に埋める（ロードマップ / 触って良い範囲 / 地雷を明確化）
3. 以降は **変更前に status を更新**し、handoff 時は `handoff-pack` を使って引き継ぐ

## この repo のスコープ

- ここは「メタ層」です。特定プロジェクトの実装・設定を直接ここへ混ぜない
- 既存の手元環境（`~/.openclaw` など）の実値や秘密は持ち込まない
