#' generate_dataset
#' 
#' Generate spatialdata datasets using dummy-spatialdata
#' 
#' @param file location that zarr file will be written
#' @param images image element
#' @param labels labels element
#' @param shapes shapes element
#' @param points points element
#' @param tables tables element (anndata)
#' @param coordinate_systems list of coordinate systems
#' @param seed seed
#' 
#' @return the path to the SpatialData store (.zarr)
#' 
#' @examples
#' generate_dataset()
#' 
#' # write spatialdata to a zarr file
#' zarrfile <- tempfile(fileext = ".zarr")
#' generate_dataset(
#'   file = zarrfile, 
#'   points = list(
#'     list(n=12L)
#'   )
#' )
#' 
#' # write spatialdata to a zarr file
#' generate_dataset(
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
#' 
#' @export
generate_dataset <- function(file = tempfile(fileext = ".zarr"),
                             images = NULL, 
                             labels = NULL, 
                             shapes = NULL, 
                             points = NULL, 
                             tables = NULL,
                             coordinate_systems = NULL,
                             seed = 42L) {
  proc <- basilisk::basiliskStart(.sd_env) 
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