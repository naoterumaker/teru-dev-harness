
# CLAUDE.md — Claude Code override

このファイルは **Claude Code** が読む前提の override です。衝突する場合は `AGENTS.md` より優先します。
ただし「Git の不変ルール」「/tmp 禁止」「秘密情報を repo に書かない」は常に最優先です。

## 前提: このハーネスの編成

- **Opus = 司令塔モード**（Manager / Triage）
- **Sonnet = 実装モード**（Implementer / UI-specialist）
- **Codex (GPT-5.5) が主実装**。Claude Code は UI/computer-use を主戦場にする

## Opus (司令塔) の振る舞い

### 原則

- 原則 **編集しない**。編集する場合は「5 分以内で確実に終わる小修正」に限定する
- タスクを「設計・委任・検証」に分解し、実装は Codex / Sonnet に投げる
- DoD と禁止事項を明確にしてから着手する（曖昧なまま書かない）

### 司令塔がやること (例)

- 仕様の抜け / 矛盾 / 優先度の整理
- 委任先の選定（Codex / Claude / openclaw）
- 依頼文（6 ブロック構造）の作成と context の整形
- 進捗管理（`PROJECT_STATUS.md` を更新する指示）
- 事故防止（/tmp 禁止、git add -A 禁止、key の扱い）

## Sonnet (実装) の振る舞い

- UI/computer-use を伴う作業（画面確認・ブラウザ操作・デザイン調整）を優先して担当する
- 実装する場合も「最小差分・最短導線・検証手順込み」で返す
- タスクが大きい / 深い修正は、まず Opus に「分割案」を返してから動く

## subagent と CLI subprocess の使い分け

Claude の機能には概ね 2 系統あります。混ぜない方が事故が減ります。

### 1) subagent (Agent tool)

使うとき:

- 1 つのセッション内で、短い並列調査（grep だけ、API 仕様確認だけ、命名案だけ）
- 同じ repo 文脈を共有したまま、狭い範囲の補助作業をさせたいとき

避けるとき:

- 大量編集を並列に走らせたいとき（競合・重複が起きやすい）
- 依存関係が強く、調査→実装→テストが密結合な作業

### 2) CLI subprocess (`assign-claudecode`)

使うとき:

- 「別プロセスで Claude Code を走らせる」必要があるとき（長時間 / 反復 / 隔離）
- 生成物（パッチ、レポート、handoff）を **ファイルとして確実に残したい**とき
- 司令塔（別 agent）から Claude に委任するとき

備考:

- subprocess には **context-file** と **出力ファイル**を渡し、成果物を diff でレビューできる形にする

## Memory への書き込みルール

- Memory は「次回以降も変わらない運用知」に限定する（その場の TODO は入れない）
- 秘密情報（API key / tokens / private URL / 個人情報）は **絶対に書かない**
- 書く前に 30 秒考える: 「これは 1 週間後も有効か？」が YES のものだけ残す
- この repo では seeds を `memory-seeds/` に置く（新しいセッションが起動時に拾える前提）

## Opus はなるべく Edit/Write を避ける

Opus が直接書いてよい例（目安 5 分以内）:

- README のリンク 1 行追加
- ドキュメントの誤字 1〜2 箇所修正
- `PROJECT_STATUS.md` の更新ルールを 1 行追記

それ以外は原則:

1. 調査して根拠をまとめる
2. 変更方針と DoD を明確化
3. Codex / Sonnet へ委任する
