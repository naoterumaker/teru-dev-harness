
# 02_context_engineering — Context 設計 (modular architecture)

ここでいう “context” は、LLM に渡すテキスト全体（指示 / 仕様 / 状態 / 既知の地雷）を指す。
Context は「空気」ではなく **設計物**であり、運用で劣化する。よって “Context engineering” をルール化する。

## 目的

- token を増やすのではなく、**必要な情報密度を上げる**
- 「知らない前提で壊す」事故を減らす（地雷・禁則・触って良い範囲）
- handoff しても **同じ判断**が再現される状態を作る

## 基本原則 (覚える)

- **Context は階層化する**（安定→不安定、一般→具体）
- **SoT を 1 つにする**（真実の場所を決め、重複を避ける）
- **スナップショットは圧縮して渡す**（全文貼り付けより “要点 + ポインタ”）
- **地雷は先に書く**（禁止事項 / 触るな / 影響範囲）
- **DoD を先に書く**（ゴールがないと最適化が迷走する）

## モジュール化された context の構成

この repo では、context を次の「モジュール」に分けて扱う。
1 ファイルに全部詰めるのではなく、必要なモジュールだけ合成して `--context-file` に渡す想定。

### L0: 不変ルール (Global Invariants)

- `AGENTS.md`（universal）
- `CLAUDE.md`（Claude override）
- セキュリティ方針（`docs/06_security_sandbox.md`）

特性: ほぼ変わらない。毎回必ず効かせたい。

### L1: プロジェクト状況 (Project Status)

- `PROJECT_STATUS.md`（テンプレ: `templates/PROJECT_STATUS.md.tmpl`）
- 何が動いているか / 何が未達か / ロードマップ / 地雷 / 更新ルール

特性: ゆっくり変わる。新メンバー/新セッションの初手に必要。

### L2: タスク仕様 (Task Spec)

- 6 ブロック依頼文（テンプレ: `templates/delegate_prompt.md.tmpl`）
- タスク固有の禁止事項、DoD、検証方法

特性: そのタスクでだけ有効。最優先で短く明確に。

### L3: リポジトリ状態 (Repo Snapshot)

例:

- `git status --porcelain`
- `git log --oneline -10`
- 変更ファイル一覧（ファイル名だけ、必要なら要点）
- 重要な設定（`.env.example` のキー名、README の起動手順）

特性: すぐ陳腐化する。handoff のたびに更新する。

### L4: 実行ログ / 証跡 (Execution Trace)

- 実行したコマンド
- 失敗したログの要約（全文ではなく原因と次アクション）
- 実験結果（比較表、測定値、スクショの説明）

特性: タスクに依存。必要なときだけ追加する。

## “薄い SoT” を作らない

ありがちな失敗は「同じ情報が 3 箇所にある」こと。
特に次の重複は避ける:

- README と PROJECT_STATUS の起動手順がズレる
- 禁止事項が依頼文にはあるが AGENTS にない
- “最新の真実” が chat の発言にしかない

対策:

- 変更が発生したら **SoT を更新**し、handoff には “更新した” と書く
- handoff は “全文” ではなく “更新点 + SoT へのポインタ” を基本にする

## コンテキストの圧縮指針

- **全文貼り付け**より「要点 5 行 + ファイルパス」を優先
- 大きい diff は “変更意図” と “影響範囲” を先に説明し、必要なら該当ファイルだけ開く
- ログは “最初のエラー” と “結論” を書けば足りることが多い

## Context を渡す順序

LLM が誤解しにくい順序がある。

推奨:

1. 不変ルール（MUST / MUST NOT）
2. 目的（Why）と DoD（受け入れ条件）
3. 現状（Repo snapshot）
4. 実行してよいコマンド / できないこと
5. 参考資料（リンク / prior art）

## Handoff と Context の関係

- handoff は「次の agent が走るための最小限の context」の束
- handoff の本体は `docs/03_handoff_format.md` に定義する
- 生成は `skills/handoff-pack/` を使う

## チェックリスト (渡す前)

- [ ] 禁止事項が先頭付近にある
- [ ] DoD が測定可能（コマンド / ファイル / 状態）になっている
- [ ] 作業 dir が絶対パスで書かれている
- [ ] /tmp 系のパスが混ざっていない
- [ ] 秘密情報が入っていない（キー名は OK、値は NG）

次は `docs/03_handoff_format.md` で handoff の具体フォーマットを読む。
