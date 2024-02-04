# old binaries only guaranteed to be available for frozen snapshot
# https://community.rstudio.com/t/binary-packages-removed-once-new-package-version-released-on-ppm/177282/2
lockfile <- renv::lockfile_read()
rspm_url <- lockfile$R$Repositories$RSPM
current_date <- Sys.Date() - 3 # available for sure

to_substract <- max(0, as.integer(strftime(current_date, "%u")) - 5)
ensured_weekday <- current_date - to_substract
updated_url <- gsub("[0-9]{4}-[0-9]{2}-[0-9]{2}$", ensured_weekday, rspm_url)
lockfile$R$Repositories$RSPM <- updated_url
renv::lockfile_write(lockfile = lockfile)
cat(paste0("Snapshot day for PPM moved to ", ensured_weekday))
