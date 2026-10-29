#!/usr/bin/env bash
# Publishes _book/ to the branch gh-pages of the repository, from which GitHub Pages serves
# https://tok-lang-bpm.github.io/.
# Usage: bash tools/publish.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
[ -f _book/index.html ] || { echo "Build first: bash tools/build.sh"; exit 1; }
SITE="$(mktemp -d)"
trap 'rm -rf "$SITE"' EXIT
cp -r _book/. "$SITE/"
cd "$SITE"
git init -q -b gh-pages
git config user.name "$(git -C "$ROOT" config user.name)"
git config user.email "$(git -C "$ROOT" config user.email)"
git add -A
git commit -q -m "The guide, $(date +%Y-%m-%d)"
git push -q --force "$(git -C "$ROOT" remote get-url origin)" gh-pages
echo "Published to the branch gh-pages"
