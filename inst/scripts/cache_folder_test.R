cache <- BiocFileCache::BiocFileCache()
fpath <- "https://s3.embl.de/spatialdata/spatialdata-sandbox/visium_spatialdata_0.7.1.zip"
zipname <- "visium_spatialdata_0.7.1.zip"
loc <- BiocFileCache::bfcadd(cache, rname=zipname, fpath=fpath, rtype="web")
td_old <- file.path(tempdir(), tools::file_path_sans_ext(zipname))
unzip(loc, exdir = td_old)
td_old <- dir(td_old, full.names = TRUE)
td <- file.path(tempdir(), paste0(tools::file_path_sans_ext(zipname), ".zarr"))
dir.create(td)
file.rename(td_old, td)
loc <- BiocFileCache::bfcadd(cache, rname=basename(td), fpath=td)