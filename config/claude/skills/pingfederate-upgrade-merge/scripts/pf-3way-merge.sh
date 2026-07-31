#!/usr/bin/env bash
#
# PingFederate アップグレード用 3-way マージヘルパー（CRLF安全・検証付き）
#
# 使い方:
#   pf-3way-merge.sh BASE CUST THEIRS OUT [ours_conflict_indices...]
#
#   BASE    旧バージョンの素の既定 (<name>-default-<oldver>.xml)
#   CUST    旧バージョンのカスタマイズ版 (正式名ファイル)
#   THEIRS  新バージョンの素の既定 (<name>-default-<newver>.xml)
#   OUT     出力先 (新バージョンの正式名ファイル)
#   ours_conflict_indices  ours(=CUST)側を採用する衝突番号(1始まり)。
#                          省略時は全衝突をtheirs採用。
#
# 推奨フロー:
#   1) まず引数なしで実行 → 衝突数と各衝突の内容を確認
#   2) 解決方針を決め、ours採用する衝突番号を指定して再実行
#   3) 必要ならFILEアペンダー値などをpost-editで適用 (SKILL.md参照)
#   4) 表示される検証結果(xmllint/マーカー/差分スコープ)を確認
#
# 注意: 出力前に OUT を OUT.pre-merge-bak へ自動退避する(既存bakは上書きしない)。

set -euo pipefail

if [ "$#" -lt 4 ]; then
  sed -n '2,25p' "$0"; exit 1
fi

BASE="$1"; CUST="$2"; THEIRS="$3"; OUT="$4"; shift 4
OURS_IDX=" $* "   # スペース区切りで包含判定する

for f in "$BASE" "$CUST" "$THEIRS"; do
  [ -f "$f" ] || { echo "ERROR: 入力が見つかりません: $f" >&2; exit 1; }
done

# 生マージ(diff3形式) を一時生成
RAW="$(mktemp)"
trap 'rm -f "$RAW"' EXIT
# git merge-file は競合時に非0を返すので || true
git merge-file -p --diff3 "$CUST" "$BASE" "$THEIRS" > "$RAW" 2>/dev/null || true

NCONF=$(grep -cE '^<<<<<<< ' "$RAW" || true)
echo "衝突箇所数: $NCONF"

if [ "$NCONF" -gt 0 ] && [ -z "$*" ]; then
  echo "----- 各衝突の内容(確認用) -----"
  awk '
    /^<<<<<<< /{n++; print "###### 衝突#" n " ######"; show=1}
    show{print}
    /^>>>>>>> /{show=0}
  ' "$RAW" | sed 's/\r$//'
  echo "--------------------------------"
  echo "解決方針を決め、ours採用する衝突番号を引数に指定して再実行してください。"
  echo "(例: $(basename "$0") BASE CUST THEIRS OUT 3)"
  exit 0
fi

# 衝突解決 (CRLF安全: =======末尾に$を付けない / \rを保持)
RESOLVED="$(mktemp)"; trap 'rm -f "$RAW" "$RESOLVED"' EXIT
awk -v ours="$OURS_IDX" '
  /^<<<<<<< /{n++; m="o"; next}
  /^\|\|\|\|\|\|\|/{m="b"; next}
  /^=======/{m="t"; next}
  /^>>>>>>> /{m="n"; next}
  {
    if (m=="n" || m=="") print;
    else if (m=="o" && index(ours, " " n " ")) print;       # ours採用指定の衝突
    else if (m=="t" && !index(ours, " " n " ")) print;       # それ以外はtheirs
  }
' "$RAW" > "$RESOLVED"

# バックアップ(既存bakは保護)
if [ -f "$OUT" ] && [ ! -f "$OUT.pre-merge-bak" ]; then
  cp -p "$OUT" "$OUT.pre-merge-bak"
  echo "バックアップ作成: $OUT.pre-merge-bak"
fi

cp "$RESOLVED" "$OUT"
echo "出力: $OUT ($(wc -l < "$OUT" | tr -d ' ')行)"

# ---- 検証 ----
echo "----- 検証 -----"
mark=$(grep -cE '^(<<<<<<<|=======|>>>>>>>|\|\|\|\|\|\|\|)' "$OUT" || true)
echo "  衝突マーカー残留: $mark $([ "$mark" -eq 0 ] && echo OK || echo '★要確認')"
if command -v xmllint >/dev/null 2>&1; then
  if xmllint --noout "$OUT" 2>/dev/null; then echo "  XML整形式: OK"; else echo "  XML整形式: ★NG"; fi
fi
echo "  THEIRS(新既定)との差分行数(=カスタマイズ分): $(diff "$THEIRS" "$OUT" | grep -cE '^[<>]' || true)"
echo "  CUST(旧カスタム)との差分行数(=版改善分):   $(diff "$CUST" "$OUT" | grep -cE '^[<>]' || true)"
echo "post-edit(FILEアペンダー値の適用等)が必要な場合は SKILL.md を参照。"
