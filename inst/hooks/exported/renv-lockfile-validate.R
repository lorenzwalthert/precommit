#!/usr/bin/env Rscript

"Validate renv lockfiles
See `?renv::lockfile_validate()`.
Usage:
  lockfile_validate [--schema=<schema>] [--greedy --error --verbose --strict] <files>...
Options:
  --schema Path. Path to a custom schema.
  --greedy  Continue after first error?
  --error  Throw an error on parse failure?
  --verbose  If `TRUE`, then an attribute `errors` will list validation failures as a `data.frame`.
  --strict  Set whether the schema should be parsed strictly or not.
" -> doc

if (!require(renv, quietly = TRUE)) {
  stop("{renv} could not be loaded, please install it.")
}
if (packageVersion("renv") < package_version("1.0.8")) {
  rlang::abort("You need at least version 1.0.8 of {renv} to run this hook.")
}
if (!require(jsonvalidate, quietly = TRUE)) {
  stop("{jsonvalidate} could not be loaded, please install it.")
}

arguments <- precommit::precommit_docopt(doc)
arguments$files <- normalizePath(arguments$files)
if (!is.null(arguments$schema)) {
  arguments$schema <- normalizePath(arguments$schema)
}

renv::lockfile_validate(
  lockfile = arguments$files,
  schema = arguments$schema,
  greedy = arguments$greedy,
  error = arguments$error,
  verbose = arguments$verbose,
  strict = arguments$strict
)
