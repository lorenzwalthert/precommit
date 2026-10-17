# old binaries only guaranteed to be available for frozen snapshot
# https://community.rstudio.com/t/binary-packages-removed-once-new-package-version-released-on-ppm/177282/2
lockfile <- renv::lockfile_read()
rspm_url <- lockfile$R$Repositories$RSPM
current_date <- Sys.Date()
cooldown_in_days <- as.integer(Sys.getenv("R_PRECOMMIT_COOLDOWN_IN_DAYS", unset = "5"))

cooled_off_snapshot_day <- current_date - cooldown_in_days
updated_url <- gsub("[0-9]{4}-[0-9]{2}-[0-9]{2}$", cooled_off_snapshot_day, rspm_url)
lockfile$R$Repositories$RSPM <- updated_url
renv::lockfile_write(lockfile = lockfile)
cat(paste0("Snapshot day for PPM moved to ", cooled_off_snapshot_day))
