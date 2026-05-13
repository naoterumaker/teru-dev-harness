# teru-dev-harness

AI コーディング agent (Claude Code / Codex / openclaw) を 1 つの環境で連携させて、
複数プロジェクトを一貫したルールで開発するためのハーネス。

## 何が入ってるか

- `AGENTS.md` — 全 agent 共通の指示書 (Claude Code / Codex / Cursor / Gemini CLI 等が読む 2026 universal 標準)
- `CLAUDE.md` — Claude 専用 override (最高優先度)
- `docs/` — 開発思想・委任ルール・context engineering・事故事例
- `skills/` — Anthropic 公式 SKILL.md schema 準拠のスキル群
- `templates/` — 新プロジェクト用テンプレート (PROJECT_STATUS / HANDOFF_CONTEXT / 依頼文)
- `bootstrap/` — 新 PC で 1 発セットアップする `install.sh` + dotfiles
- `memory-seeds/` — 初期 memory ファイル (新 Claude セッションが拾える)
- `PRIOR_ART.md` — 参考にした世界の repo 一覧

## クイックスタート

```bash
git clone https://github.com/naoterumaker/teru-dev-harness.git ~/dev/teru-dev-harness
cd ~/dev/teru-dev-harness
bash bootstrap/install.sh
```

詳細は `docs/00_overview.md` から読む。

## 状態

🚧 構築中。骨格と README のみ。中身は順次埋める。
