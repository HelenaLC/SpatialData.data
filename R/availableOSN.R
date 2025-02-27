#' use 'paws::s3' to interrogate an NSF Open Storage Network 
#' bucket for zipped zarr archives for various platforms
#' @examples
#' if (requireNamespace("paws")) {
#'   availableOSN()
#' }
#' @export
availableOSN <- function() {
    if (!requireNamespace("paws")) 
        stop("install 'paws' to use this function; without it",
            " we can't check existence of data in OSN bucket")
#  x = curl::curl("https://mghp.osn.xsede.org/bir190004-bucket01")
#  y = xml2::read_xml(x)
#  z = xml2::as_list(y)
    message("checking Bioconductor OSN bucket...")
    s3 <- paws::s3(
        credentials=list(anonymous=TRUE),
        endpoint="https://mghp.osn.xsede.org")
    zz <- s3$list_objects("bir190004-bucket01") 
    allk <- lapply(zz$Contents, "[[", "Key")
    basename(grep("BiocSpatialData\\/", allk, value=TRUE))
}

