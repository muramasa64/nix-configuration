---
name: pingfederate-upgrade-merge
description: PingFederateのアップグレード後に、旧バージョンのカスタマイズ済み設定/テンプレート（log4j2.xml, server/default/conf/template配下のHTML等）を新バージョンへ3-wayマージで移行する手順。お客様独自のカスタマイズとPing社の版改善の双方を保持する。「PingFederateのlog4j2/templateを移行」「アップグレード後の設定マージ」「12.x→へのカスタムファイル引き継ぎ」等のときに使用する。
---

# PingFederate アップグレード設定マージ

PingFederate のアップグレードユーティリティ実行後に必要となる、カスタマイズ済みファイルの新バージョンへの移行手順。
**全面上書きは禁止**。必ず3-wayマージで「お客様カスタマイズ」と「Ping社の版改善」を両立させる。

## 前提知識

- アップグレードユーティリティの挙動: 新バージョンの既定ファイルを `<name>-default-<newver>.xml` にリネームして退避し、旧バージョンのファイルを正式名にコピーする。
  - 例: `log4j2.xml`（=旧カスタム版がコピーされた状態）と `log4j2-default-12.3.6.xml`（=新バージョンの素の既定）が併存する。
- テンプレート（HTML/Velocity）はユーティリティが自動マージしない。手動で対応する。
- ノード構成: console（IDPMGR/SPMGR）と engine（IDP/SP）。engineにはエンドユーザー画面や監査ログ（CEF syslog）のカスタマイズが入りやすい。console側は最小限のことが多い。

## 3つの入力ファイル（用語）

| 役割 | 内容 | 入手元 |
|---|---|---|
| BASE | 旧バージョンの**素の既定** | `<name>-default-<oldver>.xml`（旧conf内に退避されている）。なければ他ノードの同ファイル（ノード間で同一） |
| CUST | 旧バージョンの**カスタマイズ版** | 旧installの正式名ファイル（例 `pingfederate-11.3.1/.../log4j2.xml`） |
| THEIRS | 新バージョンの**素の既定** | `<name>-default-<newver>.xml`（新conf内） |

### 重要な落とし穴

1. **改行コードがCRLF**のことがある。区切り行は `=======\r` になるため、`/^=======$/` だと不一致になる。**`/^=======/`（末尾`$`を付けない）** を使い、出力もCRLFを維持する。
2. BASE/THEIRSはノード間で同一なはず（md5で確認）。SPMGR等でBASEが欠落していたら他ノードのものを流用してよい。

## 手順

### 1. 対象ノード・ファイルの棚卸し
- 各ノードに新バージョンディレクトリ（`pingfederate-<newver>`）が存在するか確認（無ければ未アップグレード、対象外）。
- 対象ファイル候補: `server/default/conf/log4j2.xml`、`server/default/conf/template/` 配下。

### 2. カスタマイズの有無を判定（3-wayの前段）
- `diff BASE CUST`。**差分なし → 移行不要**（新バージョンの既定をそのまま使う）。
- テンプレートはディレクトリ全体を `diff -rq BASE_DIR CUST_DIR` し、`differ` のファイルだけが対象。`Only in CUST` の `*_origin.html` `*-BF*.html` `*.html-YYYYMMDD` 等は管理者の手動バックアップであり移行対象外。

### 3. 3-wayマージ
- 同梱スクリプト `scripts/pf-3way-merge.sh` を使う（CRLF安全・検証付き）。
  ```
  scripts/pf-3way-merge.sh BASE CUST THEIRS OUT [ours_conflict_indices...]
  ```
- まず引数 `ours_conflict_indices` なしで実行し、**衝突箇所数と各衝突の内容**を確認する。
- 衝突の解決方針を決める:
  - **再整形系（新構造を採用すべきだが値はカスタム）**: 例）log4j2のFILEアペンダー。新バージョンで1行形式化やFILE-JSON追加等により衝突する。→ 解決は「theirs採用」とし、**マージ後にカスタム値だけを再適用**（後述のpost-edit）。
  - **お客様固有の機能ブロック**: 例）CEF syslog監査アペンダー、ログイン画面のFAQリンク、`type="text"`→`type="password"`、revealボタン無効化。→ その衝突は **ours採用**（`ours_conflict_indices` に当該番号を渡す）。
- log4j2のFILEアペンダー値（サイズ・世代）はpost-editで適用:
  ```
  perl -0777 -pe 's/size="<旧値> KB"/size="<新値> KB"/; s/<DefaultRolloverStrategy max="<旧値>" \/>/<DefaultRolloverStrategy max="<新値>" \/>/' in > out
  ```
  （先頭一致＝FILEアペンダー。FILE-JSONは既定維持される）

### 4. バックアップ
- 上書き前に必ず退避: `cp -p OUT OUT.pre-merge-bak`
- 新バージョンの素 `*-default-<newver>.xml` は消さずに残す（将来の再マージ基準になる）。

### 5. 検証（全項目必須）
スクリプトが自動実行するが、手動でも以下を確認:
- `xmllint --noout OUT` が成功（整形式）。
- 衝突マーカー残留0: `grep -cE '^(<<<<<<<|=======|>>>>>>>|\|\|\|\|\|\|\|)' OUT` → 0。
- **差分スコープ**: `diff THEIRS OUT` がカスタマイズ分だけになっている（想定外の変更がない）。
- **カスタム保持**: お客様固有要素（syslogアペンダー名・logger参照、FAQリンク等）が CUST と一致。
  ```
  diff <(grep -oE '(name|ref)="...独自..."' CUST|sort) <(grep -oE '(name|ref)="...独自..."' OUT|sort)
  ```
- **版改善の取り込み**: 新バージョンの新規要素（log4j2なら `FILE-JSON` / `JsonTemplateLayout` / `createOnDemand`）が OUT に存在。
- log4j2: FILEアペンダーが意図値、FILE-JSONは既定維持。

## language-packs (.properties) は扱いが違う — 原則「検証のみ」

`server/default/conf/language-packs/*.properties` は、アップグレードユーティリティが**プロパティ（key=value）単位で自動マージ**する。log4j2/templateのような手動マージは原則不要で、**カスタマイズが正しく反映されたかをキー単位で検証**する。

- **行単位diffは使わない**。改行コードが変わる（例: 11.3.1=CRLF → 12.3.6=LF）うえ、キー順序も変わるため無意味。必ず **key=value 単位**で比較する。
- 検証手順:
  1. カスタマイズキーを特定: 素の旧版(BASE)とノードの旧版(CUST)を**CR除去後**にkey単位比較し、値が異なるキーを抽出。
  2. 各カスタマイズキーについて、新版(THEIRS)の値が CUST と一致するか確認。
  3. 全件一致なら**対応不要**。不一致があればそのキーだけ新版側へ手動反映。
- 落とし穴:
  - **空値カスタマイズ**に注意（例 `global.bestRegards=`）。空をキー無しと誤判定しないこと。grepで実バイト確認すると確実。
  - 先頭の**BOM(U+FEFF)**やコメント行(`#`)がkey誤検出の原因になる。コメント/空行/BOMは除外する。
  - `*_origin.properties` `*-YYYYMMDD` 等は管理者の手動バックアップで対象外。
- 検証スニペット例:
  ```bash
  dump() { sed 's/\r$//' "$1" | grep -vE '^\xef\xbb\xbf?\s*#|^\s*#|^\s*$' | grep -E '^[^=]+='; }
  # BASE,CUST,THEIRS をdumpし、CUST!=BASE のキーで THEIRS==CUST を確認する
  ```

## デプロイ固有の値の置き場所

FILEアペンダーのサイズ・世代、syslog送信先のホスト/ポート、アペンダー名、`ours_conflict_indices`
の値、BASE/THEIRS の md5 といった**案件固有の値はこのスキルに書かない**。
このリポジトリは public なので、案件ごとの作業ディレクトリ側（`<案件dir>/.claude/CLAUDE.md` 等）に置く。

## 参照

- マージ実行・検証ヘルパー: `scripts/pf-3way-merge.sh`
