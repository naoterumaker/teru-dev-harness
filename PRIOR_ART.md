
# PRIOR_ART

この repo は “世界の既存知” を寄せ集めたハーネスであり、ゼロから発明しない。
参照した repo / 記事と「何を取り入れたか」を記録する。

> 注意: URL は参照用。仕様の SoT は本 repo の `docs/` と `AGENTS.md`。

## Repos / Articles

| Source | Type | What we adopted |
| --- | --- | --- |
| https://github.com/anthropics/skills | repo | SKILL.md の YAML frontmatter（`name`/`description`）+ 手順書としての skills |
| https://github.com/zircote/.claude | repo | Claude Code dotfiles を repo で管理する発想 / ディレクトリ構成の参考 |
| https://github.com/yulonglin/dotfiles | repo | Claude + Codex + Gemini を 1 つの運用に束ねる “統合 dotfiles” の方向性 |
| https://github.com/affaan-m/everything-claude-code | repo | Claude Code の最適化パターン（プロンプト設計、運用小技）の拾い上げ |
| https://github.com/sickn33/antigravity-awesome-skills | repo | 大量 skills カタログの存在を前提にした “skills を運用知として扱う” 発想 |
| https://github.com/openai/codex | repo | Codex CLI / SKILL.md サンプル / 運用上の前提（ローカル実行、approval modes） |
| BuildBetter — AGENTS.md guide | article | “AGENTS.md を universal entrypoint にする” という運用指針 |
| Anthropic Engineering Blog — Context Engineering | article | context をモジュール化し、SoT/階層/圧縮で扱う考え方 |
| OpenAI Agents SDK (v0.6.x) | docs | `# System context` から始まるプロンプト構造（handoff 互換の設計） |

## 取り込み方針

- 参照はするが **コピペで終わらない**。自分の事故と運用からルールに落とす
- “便利” より “安全と再現性” を優先する
- 参照元が増えたらこの表に追記し、`docs/` とテンプレに反映する
