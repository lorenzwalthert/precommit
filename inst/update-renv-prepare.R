options(
  install.packages.check.source = "no", # don't check if source packages are available
  install.packages.compile.from.source = "never" # probably redundant with the above 'no': If source package is available, only use source if no code needs to be compiled (needs compilation flag on CRAN).
)
