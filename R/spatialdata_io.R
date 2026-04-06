#' available_sdio
#' 
#' enumerate modules
#' 
#' @param sd_version spatialdata version, should be set to 0.3.0, 0.5.0 or 
#' 0.7.2. Default: 0.7.
#' @param verbose verbose
#' @import basilisk
#' 
#' @examples
#' # TODO: turn off basilisk on GHA
#' # available_sdio()
#' 
#' @export
available_sdio <- function(sd_version = getOption("sd_version"), 
                           verbose = TRUE) {
    proc <- basilisk::basiliskStart(.get_basilisk_env(sd_version, 
                                                      verbose = TRUE)) 
    on.exit(basilisk::basiliskStop(proc))
    basilisk::basiliskRun(proc, function() {
        sdio <- reticulate::import("spatialdata_io")
        setdiff(names(sdio), c("readers", "version"))
    })
}

#' Use Python's 'spatialdata-io' to transform manufacturer 
#' output to .zarr with specific folder structure.
#' 
#' @param platform character(1) must be an element of `available_sdio()` output
#' @param srcdir character(1) path to folder holding manufacturer output files
#' @param dest character(1) a path to a desired destination for zarr representation
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' 
#' # unzip flat files
#' pa <- SpatialData.data:::.path_to_10x_xen_demo()
#' dir.create(td <- tempfile())
#' unzip(pa, exdir=td)
#' 
#' # read & write to .zarr w/ 'spatialdata-io'
#' target <- tempfile()
#' options(sd_version = "0.3.0")
#' # turn of basilisk on GHA
#' # use_sdio("xenium", srcdir=td, dest=target)
#' 
#' # read with SpatialData
#' # br2fov <- SpatialData::readSpatialData(target)
#' # br2fov
#' 
#' @export
use_sdio <- function(platform="xenium", srcdir, dest) {
    if (dir.exists(dest)) 
        stop("Won't write to existing folder;",
            " please provide a non-existent path.")
    avail <- available_sdio(verbose = FALSE) # run before basilisk
    proc <- basilisk::basiliskStart(.get_basilisk_env()) 
    on.exit(basilisk::basiliskStop(proc))
    basilisk::basiliskRun(proc, function(platform, srcdir, dest, avail) {
        sdio <- reticulate::import("spatialdata_io")
        avail <- names(sdio)
        stopifnot(platform %in% avail)
        sdio[[platform]](srcdir)$write(dest)
    }, platform=platform, srcdir=srcdir, dest=dest, 
    avail = avail)
}