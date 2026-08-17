#' SD.io_available
#' 
#' enumerate modules
#' 
#' @param sd_version spatialdata version, should be set to 0.3.0, 0.5.0 or 
#' 0.7.2. Default: 0.7.
#' @param verbose verbose
#' @import basilisk
#' 
#' @examples
#' SD.io_available()
#' 
#' @export
SD.io_available <- function(sd_version = getOption("sd_version"), 
                           verbose = TRUE) {
    proc <- basilisk::basiliskStart(.get_basilisk_env(sd_version, 
                                                      verbose = verbose)) 
    on.exit(basilisk::basiliskStop(proc))
    basilisk::basiliskRun(proc, function() {
        sdio <- reticulate::import("spatialdata_io")
        setdiff(names(sdio), c("readers", "version"))
    })
}

#' Use Python's 'spatialdata-io' to transform manufacturer 
#' output to .zarr with specific folder structure.
#' 
#' @param platform character(1) must be an element of `SD.io_available()` output
#' @param srcdir character(1) path to folder holding manufacturer output files
#' @param dest character(1) a path to a desired destination for zarr representation
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' 
#' # read & write to .zarr w/ 'spatialdata-io'
#' target <- tempfile()
#' options(sd_version = "0.3.0")
#' # turn of basilisk on GHA
#' # SD.io("xenium", srcdir=td, dest=target)
#' 
#' # read with spatialdataR
#' # br2fov <- spatialdataR::readSpatialData(target)
#' # br2fov
#' 
#' @export
SD.io <- function(platform="xenium", srcdir, dest) {
    if (dir.exists(dest)) 
        stop("Won't write to existing folder;",
            " please provide a non-existent path.")
    proc <- basilisk::basiliskStart(.get_basilisk_env()) 
    on.exit(basilisk::basiliskStop(proc))
    basilisk::basiliskRun(proc, function(platform, srcdir, dest) {
        sdio <- reticulate::import("spatialdata_io")
        avail <- names(sdio)
        stopifnot(platform %in% avail)
        sdio[[platform]](srcdir)$write(dest)
    }, platform=platform, srcdir=srcdir, dest=dest)
}