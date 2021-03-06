% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/testing.R
\name{hook_state_create}
\alias{hook_state_create}
\title{Create a hook state}
\usage{
hook_state_create(
  tempdir,
  path_candidate_temp,
  path_executable,
  cmd_args,
  path_stdout,
  path_stderr,
  env
)
}
\description{
Runs the hook script to create a hook state, i.e. exit code, transformed
files and emitted messages of the hook run.
}
\keyword{internal}
