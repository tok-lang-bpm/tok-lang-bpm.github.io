# tok: Process Models as Text

The source of the guide to [tok](https://github.com/tok-lang-bpm/tok), published at **https://tok-lang-bpm.github.io/**: the language, the tools, the programming interfaces, working with AI agents and the integrations, with worked examples and exercises. The site also serves the [playground](https://tok-lang-bpm.github.io/playground/), where tok runs in the browser.

## Contents

| Path | What it holds |
|---|---|
| `index.Rmd`, `01-…Rmd` – `15-…Rmd` | the chapters of the book |
| `90-…Rmd` – `96-…Rmd` | the appendices: BPMN symbols, the language on one page, the commands, the diagnostics, conformance with Camunda 8, glossary, references |
| `examples/` | the models of the chapters with their BPMN exports and pictures; files ending in `-error.tok` are exercises with deliberate errors |
| `reference/`, `symbols/`, `images/` | copies from the tok repository (`tools/sync.sh`) |
| `R/helpers.R`, `style.css` | helpers and style of the book |
| `tools/` | scripts: copying from tok, checking the examples, building and publishing |

## Building

You need R with the package `bookdown`, Pandoc and the `tok` command (`pip install tok-lang`):

```bash
bash tools/sync.sh ../tok            # reference documents and symbols from a checkout of tok
bash tools/examples.sh               # check every example, write its .bpmn and .svg
bash tools/build.sh [PLAYGROUND]     # the site in _book/; with the folder of a built playground
bash tools/publish.sh                # _book/ to the branch gh-pages (GitHub Pages)
```

Corrections and suggestions are welcome in the [issues of tok](https://github.com/tok-lang-bpm/tok/issues).

## Licence

GNU General Public License v3.0 or later, see `LICENSE`.
