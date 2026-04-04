#' use 'paws::s3' to interrogate an NSF Open Storage Network 
#' bucket for zipped zarr archives for various platforms
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' if (requireNamespace("paws")) {
#'   availableOSN()
#' }
#' @export
availableOSN <- function() {
    .check_paws()
    message("checking Bioconductor OSN bucket...")
    s3 <- paws::s3(
        credentials=list(anonymous=TRUE),
        endpoint="https://mghp.osn.xsede.org")
    zz <- s3$list_objects(
        Bucket="bir190004-bucket01", 
        Prefix="BiocSpatialData") 
    keys <- lapply(zz$Contents, "[[", "Key")
    basename(grepv("/", keys))
}

#' use 'paws::s3' to interrogate an NSF Open Storage Network 
#' bucket for zipped zarr archives for various platforms
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' if (requireNamespace("paws")) {
#'   availableOSN_BiocXen()
#' }
#' @export
availableOSN_BiocXen <- function() {
  .check_paws()
  message("checking Bioconductor OSN bucket...")
  s3 <- paws::s3(
    credentials=list(anonymous=TRUE),
    endpoint="https://mghp.osn.xsede.org")
  zz <- s3$list_objects(
    Bucket="bir190004-bucket01", 
    Prefix="BiocXenDemo") 
  keys <- lapply(zz$Contents, "[[", "Key")
  basename(grepv("/", keys))
}

#' use 'paws::s3' to interrogate the scverse sandbox bucket in EMBL
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' if (requireNamespace("paws")) {
#'   available_scverse_sandbox()
#' }
#' @export
available_scverse_sandbox <- function() {
  .check_paws()
  message("checking scverse spatialdata-sandbox bucket...")
  s3 <- paws::s3(
    credentials=list(anonymous=TRUE),
    endpoint="https://s3.embl.de/")
  zz <- s3$list_objects(
    Bucket="spatialdata",
    Prefix="spatialdata-sandbox") 
  keys <- lapply(zz$Contents, "[[", "Key")
  basename(grepv("/", keys))
}

.check_paws <- function() {
  if (!requireNamespace("paws")) 
    stop("install 'paws' to use this function; without it",
         " we can't check existence of data in OSN bucket")
}
