#!/usr/bin/env bash
# Builds the guide into _book/: the book, the downloadable models of examples/, the symbols, the
# images, and the playground when a built playground is given.
# Usage: bash tools/build.sh [PLAYGROUND_FOLDER]
#   PLAYGROUND_FOLDER: the folder written by tools/playground.sh of the tok repository
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
Rscript -e 'bookdown::render_book("index.Rmd", quiet = TRUE)'
mkdir -p _book/examples _book/symbols _book/images
find examples -maxdepth 1 \( -name "*.tok" -o -name "*.bpmn" -o -name "*.dmn" -o -name "*.form" -o -name "*.csv" \) -exec cp {} _book/examples/ \;
cp symbols/* _book/symbols/
cp images/* _book/images/
if [ -n "${1:-}" ]; then
  rm -rf _book/playground
  cp -r "$1" _book/playground
  echo "  playground: _book/playground"
fi
# a plain-text map of the site for programs and AI agents (llms.txt)
{
  echo "# tok: Process Models as Text"
  echo
  echo "> The guide to tok, a plain-text language for BPMN 2.0 process models and DMN decisions: the language, the tools, the programming interfaces, AI agents and integrations."
  echo
  echo "## Chapters"
  echo
  # the chapters in the order of the book: the id of the first heading of each file
  for rmd in $(sed -n 's/^  - "\(.*\.Rmd\)"$/\1/p' _bookdown.yml); do
    if [ "$rmd" = index.Rmd ]; then
      echo "- [Preface](https://tok-lang-bpm.github.io/index.html)"
      continue
    fi
    line="$(grep -m1 '^# [^(]' "$rmd")"
    id="$(sed -n 's/.*{#\([a-z0-9-]*\)}.*/\1/p' <<< "$line")"
    title="$(sed 's/^# //; s/ {#.*//' <<< "$line")"
    echo "- [$title](https://tok-lang-bpm.github.io/$id.html)"
  done
  echo
  echo "## Reference"
  echo
  echo "- [Language on one page](https://github.com/tok-lang-bpm/tok/blob/main/docs/cheatsheet.md)"
  echo "- [Specification](https://github.com/tok-lang-bpm/tok/blob/main/docs/spec.md)"
  echo "- [Diagnostics](https://github.com/tok-lang-bpm/tok/blob/main/docs/diagnostics.md)"
  echo "- [MCP server](https://github.com/tok-lang-bpm/tok/blob/main/docs/mcp.md)"
  echo "- [Agent bundle: skill and MCP server](https://github.com/tok-lang-bpm/tok-agent)"
} > _book/llms.txt
touch _book/.nojekyll
echo "Built: _book/index.html"
