#!/usr/bin/env bash
# Checks every model in examples/ and writes its BPMN export and its picture next to it.
# A model whose name ends in -error is an exercise with deliberate errors: it is checked
# (the errors are expected) but not exported. A document with decisions only has nothing to
# draw, so it is checked and not exported.
# Usage: bash tools/examples.sh        (the tok program from PATH, or the one named by TOK)
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/examples"
TOK="${TOK:-tok}"
fail=0
for f in *.tok; do
  name="${f%.tok}"
  case "$name" in
    *-error)
      if "$TOK" check "$f" > /dev/null; then
        echo "$f: expected errors, found none"; fail=1
      fi
      continue ;;
  esac
  if ! "$TOK" check "$f" > /dev/null; then "$TOK" check "$f"; fail=1; continue; fi
  if out="$("$TOK" bpmn "$f" -o "$name.bpmn" 2>&1)"; then
    "$TOK" svg "$f" -o "$name.svg" > /dev/null || fail=1
  elif ! grep -q "nothing to draw" <<< "$out"; then
    echo "$out"; fail=1
  fi
done
[ "$fail" = 0 ] && echo "examples: every model checked and exported"
exit "$fail"
