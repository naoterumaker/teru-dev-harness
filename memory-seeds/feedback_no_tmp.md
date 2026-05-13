---
name: no-tmp-workdir
description: /tmp と /private/tmp は短命なので作業ディレクトリに使わない
type: feedback
---

作業ディレクトリを `/tmp` や `/private/tmp` に置かない。
macOS の cleanup などで消えるため、成果物・中間ファイルが喪失する。

代替:

- `~/dev/<repo>` のような永続ディレクトリを使う
- workdir は常に **絶対パス**で handoff / 依頼文に書く
