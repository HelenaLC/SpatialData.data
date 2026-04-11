#' generate_dataset
#' 
#' Generate spatialdata datasets using dummy-spatialdata
#' 
#' @param file location that zarr file will be written
#' @param sd_version spatialdata version, see \link{available_sdio}
#' @param images image element
#' @param labels labels element
#' @param shapes shapes element
#' @param points points element
#' @param tables tables element (anndata)
#' @param coordinate_systems list of coordinate systems
#' @param seed seed
#'
#' @examples
#' options(sd_version = "0.5.0")
#' generate_dataset()
#' 
#' # write spatialdata in 0.5.0 version
#' zarrfile <- tempfile(fileext = ".zarr")
#' generate_dataset(
#'   file = zarrfile, 
#'   sd_version = "0.5.0",
#'   points = list(
#'     list(n=12L)
#'   )
#' )
#' 
#' # write spatialdata in 0.7.2 version
#' generate_dataset(
#'   sd_version = "0.7.2",
#'   images = list(
#'     list(type = "rgb", scale_factors = c(2L,2L,2L), coordinate_system="global"),
#'     list(type = "grayscale", coordinate_system="global")
#'   ),
#'   shapes = list(
#'     list(n=12L, type ="polygon", coordinate_system="global")
#'   ),
#'   points = list(
#'     list(n=12L)
#'   ),
#'   coordinate_systems = list(
#'     global = list(
#'       transformations = list("affine"), 
#'       shape = list(x=2000L, y=2000L)
#'     )
#'   )
#' )
#' @export
generate_dataset <- function(file = tempfile(fileext = ".zarr"),
                             sd_version = getOption("sd_version"),
                             images = NULL, 
                             labels = NULL, 
                             shapes = NULL, 
                             points = NULL, 
                             tables = NULL,
                             coordinate_systems = NULL,
                             seed = 42L) {
  proc <- basilisk::basiliskStart(
    .get_basilisk_env(sd_version)
  ) 
  on.exit(basilisk::basiliskStop(proc))
  basilisk::basiliskRun(proc, function(file) {
    if(dir.exists(file))
      unlink(file, recursive = TRUE)
    dummy_sd <- reticulate::import("dummy_spatialdata")
    sd <- reticulate::import("spatialdata")
    if(is.null(coordinate_systems)){
      temp <- dummy_sd$generate_dataset(
        images = images,
        labels = labels,
        shapes = shapes,
        points = points,
        tables = tables,
        SEED = seed
      ) 
    } else {
      temp <- dummy_sd$generate_dataset(
        images = images,
        labels = labels,
        shapes = shapes,
        points = points,
        tables = tables,
        coordinate_systems = coordinate_systems,
        SEED = seed
      )
    }
    temp$write(file)
    message("SpatialData object written to '", file, "'")
    return(file)
  }, file = file)
}