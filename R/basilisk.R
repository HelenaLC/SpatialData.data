# sd version 0.5.0 environment
#' @importFrom basilisk BasiliskEnvironment
.env_05 <- BasiliskEnvironment(
  pkgname="SpatialData.data", 
  envname="sd_env_05",
  packages=c("python==3.12.0"),
  pip= c("spatialdata==0.5.0", 
         "spatialdata_io==0.6.0",
         "dummy-spatialdata==0.1.7",
         "setuptools==75.8.0"))

# sd version 0.8.0 environment
#' @importFrom basilisk BasiliskEnvironment
.env_080 <- BasiliskEnvironment(
  pkgname="SpatialData.data", 
  envname="sd_env",
  packages=c("python==3.12.0"),
  pip=c("zarr==3.1.5", 
        "ome_zarr==0.13.0", # 0.14.0 fails to due a bug, check scverse/spatialdata #1092
        "spatialdata==0.8.0", 
        "spatialdata_io==0.7.1",
        "dummy-spatialdata==0.1.10",
        "setuptools==75.8.0"))

#' @noRd
.get_basilisk_env <- function(
    sd_version = getOption("sd_version"),
    verbose = TRUE
){
  if(is.null(sd_version)) {
    warning('getOption("sd_version") is NULL, using 0.8.0. ',
            'Set sd_version to 0.5.0 or 0.8.0 for Spatialdata versions.')
    sd_version <- "0.8.0"
  }
  if(verbose)
    message("Using spatialdata version ", sd_version)
  switch (sd_version,
          "0.5.0" = .env_05,
          "0.8.0" = .env_080,
          {
            stop('sd_version should be set to 0.5.0 or 0.8.0.') 
          })
}