
#' enumerate modules
#' @examples
#' available_sdio()
#' @export
available_sdio <- function() {
    # avoid package-specific import
    proc <- basilisk::basiliskStart(SpatialData:::.env, testload="spatialdata") 
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
#' # unzip flat files
#' pa <- SpatialData.data:::.path_to_10x_xen_demo()
#' dir.create(td <- tempfile())
#' unzip(pa, exdir=td)
#' 
#' # read & write to .zarr w/ 'spatialdata-io'
#' target <- tempfile()
#' use_sdio("xenium", srcdir=td, dest=target)
#' 
#' # read into R
#' (br2fov <- SpatialData::readSpatialData(target))
#' 
#' @export
use_sdio <- function(platform="xenium", srcdir, dest) {
    if (dir.exists(dest)) 
        stop("Won't write to existing folder;",
            " please provide a non-existent path.")
    # avoid package-specific import
    proc <- basilisk::basiliskStart(SpatialData:::.env, testload="spatialdata") 
    on.exit(basilisk::basiliskStop(proc))
    basilisk::basiliskRun(proc, function(platform, srcdir, dest) {
        sdio <- reticulate::import("spatialdata_io")
        avail <- names(sdio)
        stopifnot(platform %in% available_sdio())
        sdio[[platform]](srcdir)$write(dest)
    }, platform=platform, srcdir=srcdir, dest=dest)
}

