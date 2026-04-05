#' generate spatialdata datasets using dummy-spatialdata
#' 
#' @examples
#' generate_dataset()
#' 
#' # write spatialdata in 0.5.0 version
#' zarrfile <- tempfile(fileext = ".zarr")
#' generate_dataset(
#'   file = zarrfile, 
#'   sd_version = "0.5.0",
#'   points = list(
#'     list(n_points=12L)
#'   )
#' )
#' 
#' # write spatialdata in 0.7.2 version
#' generate_dataset(
#'   sd_version = "0.7.2",
#'   images = list(
#'     list(type = "rgb", n_layers = 4L, coordinate_system="global"),
#'     list(type = "grayscale", n_layers = 1L, coordinate_system="global")
#'   ),
#'   labels = list(
#'     list(n_labels = 12L, n_layers = 4L")
#'   ),
#'   shapes = list(
#'     list(n_shapes=12L, coordinate_system="global")
#'   ),
#'   points = list(
#'     list(n_points=12L)
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
  basilisk::basiliskRun(proc, function() {
    unlink(file, recursive = TRUE)
    dummy_sd <- reticulate::import("dummy_spatialdata")
    sd <- reticulate::import("spatialdata")
    temp <- dummy_sd$generate_dataset(
      images = images,
      labels = labels,
      shapes = shapes,
      points = points,
      tables = tables,
      coordinate_systems = coordinate_systems,
      SEED = seed
    )
    temp$write(file)
    message("SpatialData object written to '", file, "'")
    return(file)
  })
}