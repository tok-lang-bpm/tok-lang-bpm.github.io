# Helpers shared by the chapters. Loaded in index.Rmd.

knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE,
                      fig.align = "center", out.width = "100%")

# The picture of a model in examples/ (the SVG written by tools/examples.sh with tok svg).
diagram <- function(name) {
  svg <- file.path("examples", paste0(name, ".svg"))
  if (!file.exists(svg)) stop("Missing ", svg, ". Run: bash tools/examples.sh")
  knitr::include_graphics(svg)
}

# The text of a .tok file in examples/ as a code block.
tok_code <- function(name) {
  lines <- readLines(file.path("examples", paste0(name, ".tok")), encoding = "UTF-8", warn = FALSE)
  cat("```tok\n", paste(lines, collapse = "\n"), "\n```\n", sep = "")
}

# Download links for a model and its BPMN export.
download_tok <- function(name, text = "Download the model (.tok)") {
  sprintf('<a class="download" href="examples/%s.tok" download>%s</a>', name, text)
}
download_bpmn <- function(name, text = "Download the BPMN export (.bpmn)") {
  sprintf('<a class="download" href="examples/%s.bpmn" download>%s</a>', name, text)
}

# The catalogue of BPMN symbols (symbols/symbols.json, drawn by the tok engine).
symbol_catalogue <- local({
  cache <- NULL
  function() {
    if (is.null(cache)) {
      path <- file.path("symbols", "symbols.json")
      if (!file.exists(path)) stop("Missing ", path, ". Run: bash tools/sync.sh")
      cache <<- jsonlite::fromJSON(path, simplifyVector = FALSE)$symbols
      names(cache) <<- vapply(cache, function(s) s$id, "")
    }
    cache
  }
})

# One symbol as an inline image, with its description as the alternative text.
symbol <- function(id, height = "2em") {
  s <- symbol_catalogue()[[id]]
  if (is.null(s)) stop("Unknown symbol ", id)
  sprintf('<img class="symbol" src="symbols/%s.svg" alt="%s" title="%s" style="height:%s">',
          id, s$en, s$en, height)
}

# A Markdown file inserted without its first-level title.
include_md <- function(path, skip_title = TRUE) {
  lines <- readLines(path, encoding = "UTF-8", warn = FALSE)
  if (skip_title) {
    h1 <- which(grepl("^# ", lines))[1]
    if (!is.na(h1)) lines <- lines[-seq_len(h1)]
  }
  cat(lines, sep = "\n")
}
