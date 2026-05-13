
# 06_security_sandbox — sandbox / IAM / key 管理

AI agent は「高速に書く」代わりに、誤操作・過剰権限・secret 混入のリスクが上がる。
ここでは “運用で守るべき安全ライン” を定義する。

## 目的

- 秘密情報（API keys / tokens）を repo やログに残さない
- 書き込み先・実行環境を制限し、事故の blast radius を小さくする
- “短命な権限” を使い、漏れても被害が限定される形にする

## 脅威モデル (ざっくり)

- **誤コミット**: `.env` やトークンを git に入れる
- **誤操作**: `rm -rf`、誤った DB への接続、プロダクション破壊
- **過剰権限**: broad scope の API key / IAM が漏れる
- **依存汚染**: 無闇な依存追加、サプライチェーン
- **ログ漏れ**: CI / cron / agent log に secret が出る

## 原則

- **最小権限 (least privilege)**: “必要最小の scope / duration”
- **短命 credential**: long-lived key を避け、期限付きに寄せる
- **分離 (isolation)**: 重要なものほど環境を分ける（local / container / cloud sandbox）
- **監査可能性**: 誰が何をしたか、再現できるログを残す（ただし secret は残さない）

## API key 管理

### 絶対ルール

- secret の値を repo に書かない（例外なし）
- `.env` は gitignore（この repo も `.env` は ignore）
- 共有が必要なキー名だけを `bootstrap/dotfiles/env.example` に列挙する（値は空）

### 推奨運用

- ローカル: OS keychain / 1Password / gpg など “秘匿保管庫” に置く
- CI: GitHub Actions secrets 等、プラットフォームの secret store を使う
- ログ: “キーの存在チェック” はしてよいが、値は絶対に出さない

## short-lived IAM (考え方)

本番級のリソースに触れる場合は、次の方向へ寄せる:

- 期限付き token / session credential（数十分〜数時間）
- 環境ごとに分離（dev / staging / prod）
- 操作単位で scope を狭める（read-only / write を分ける）

## sandbox 戦略

### ローカル (最小)

- 作業 dir を固定（/tmp 禁止）
- 破壊的コマンドは 2 段階（dry-run → 実行）
- Git は明示パス add（`git add -A` 禁止）

### Docker sandbox

やる理由:

- 依存関係の汚染を防ぐ
- “危ないコマンド” の被害範囲をコンテナに閉じ込める

最低限の方針:

- read-only mount を基本にし、書き込みは指定ディレクトリのみに絞る
- ネットワークを必要時だけ許可する（可能なら）
- `.env` は mount ではなく secret store を使う

### Northflank 等のクラウド sandbox

目的:

- “実運用に近い” 形で短命環境を作り、確認後に捨てる
- 社内/個人のホスト環境を汚さない

注意:

- secrets の注入経路（UI / API / vault）を統一し、ログに出ない設計にする
- 永続化が必要なデータは明示的に volume/DB を使い、勝手に残さない

## 実行前チェック (AI agent 用)

- [ ] 操作対象は dev/staging か（prod ではないか）
- [ ] 破壊的操作の可能性があるか（delete/migrate/overwrite）
- [ ] 必須 env が揃っているか（キー名の存在、空でない）
- [ ] ログに secret が出ないか（verbose オプションに注意）
- [ ] 終了後に verify/doctor を回せるか

## 運用に落とすポイント

- `bootstrap/verify.sh` に “最低限の健康診断” を入れる（バージョン、doctor）
- `docs/03_handoff_format.md` の Non-negotiables に secret 禁止を固定で入れる
- 事故が起きたら `docs/05_lessons.md` に追記し、テンプレに反映する
