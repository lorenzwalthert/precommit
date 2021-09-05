# also see corresponding files to update
# options(renv.snapshot.filter = function(root) {
#   out <- renv::dependencies("inst/hooks/exported/")$Packages
#   return(out)
# })

renv::activate()
renv::snapshot(packages = c('precommit', 'styler'))
