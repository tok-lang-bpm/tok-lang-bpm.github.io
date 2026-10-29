#!/usr/bin/env bash
# Copies what the book takes from a checkout of the tok repository: the reference documents of
# the appendices (relative links rewritten to the repository on GitHub), the catalogue of BPMN
# symbols and the picture of the example of the README.
# Usage: bash tools/sync.sh PATH/TO/tok
set -euo pipefail
TOK="${1:?usage: tools/sync.sh PATH/TO/tok}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BLOB=https://github.com/tok-lang-bpm/tok/blob/main
mkdir -p "$ROOT/reference" "$ROOT/symbols" "$ROOT/images"
for f in cheatsheet cli diagnostics conformance-camunda; do
  # links to other documents of docs/ ("spec.md", "spec.md#x") point to GitHub
  sed -E "s#\]\(([a-z0-9-]+\.md)(\#[^)]*)?\)#](${BLOB}/docs/\1\2)#g" "$TOK/docs/$f.md" > "$ROOT/reference/$f.md"
done
rm -f "$ROOT/symbols/"*
cp "$TOK/docs/symbols/"*.svg "$TOK/docs/symbols/symbols.json" "$ROOT/symbols/"
cp "$TOK/docs/images/interlibrary-loan.svg" "$ROOT/images/"
echo "reference documents, $(ls "$ROOT/symbols" | grep -c svg) symbols and images copied from $TOK"
