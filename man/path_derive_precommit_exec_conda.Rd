% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exec.R
\name{path_derive_precommit_exec_conda}
\alias{path_derive_precommit_exec_conda}
\title{Derive the path to the conda pre-commit executable}
\usage{
path_derive_precommit_exec_conda()
}
\description{
Only checks the conda env \code{r-precommit}.
If we can't find the executable, the empty string is returned.
}
\keyword{internal}
