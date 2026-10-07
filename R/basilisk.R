# sd version 0.8.0 environment
#' @importFrom basilisk BasiliskEnvironment
.sd_env <- BasiliskEnvironment(
  pkgname="SpatialData.data", 
  envname="sd_env",
  packages=c("python==3.12.0"),
  pip=c("zarr==3.1.5", 
        "spatialdata==0.8.0", 
        "spatialdata_io==0.7.1",
        "dummy-spatialdata==0.1.10",
        "setuptools==75.8.0"))