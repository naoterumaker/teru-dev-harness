---
name: git-add-explicit
description: git add -A / git add . を禁止し、明示パスで stage する
type: feedback
---

`git add -A` と `git add .` は禁止。
必ず変更したファイルの **パスを明示**して stage する。

理由:

- AI は余計な変更を混ぜやすい（意図しないファイルが混入する）
- レビューと revert が難しくなる
- “1 commit = 1 領域” の原則が崩れる
