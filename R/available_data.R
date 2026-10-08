#' SD.data_available
#' 
#' Function for interrogating files across buckets. Please use 
#' paws.storage::s3' to interrogate buckets for zipped zarr archives or 
#' raw readouts for various platforms.
#' 
#' @param src The name of the query bucket.
#' \describe{
#'    \item{biocOSN}{
#'        Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0, zarr v2)
#'    }
#'    \item{sandbox}{
#'        scverse's spatialdata-sandbox bucket at EMBL.
#'    }
#' }
#' 
#' @return a vector of example (zipped) SpatialData stores available at 
#'    \code{source}
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' if (requireNamespace("paws.storage")) {
#'     SD.data_available("biocOSN")
#' }
#' 
#' @export
SD.data_available <- function(src = "biocOSN"){
    switch(
        src, 
        biocOSN = .available_biocOSN(),
        sandbox = .available_sandbox(), 
        {
            stop(
                "Unknown bucket! Available values are ", 
                "'biocOSN' and 'sandbox'."
            )
        })
}

#' @noRd
.available_biocOSN <- function() {
    .check_paws()
    .check_aws_region()
    message("checking Bioconductor OSN bucket...")
    s3 <- paws.storage::s3(
        credentials=list(anonymous=TRUE),
        endpoint="https://mghp.osn.xsede.org")
    zz <- s3$list_objects(
        Bucket="bir190004-bucket01", 
        Prefix="BiocSpatialData") 
    keys <- lapply(zz$Contents, "[[", "Key")
    basename(grepv("/", keys, fixed = TRUE))
}

# TODO: for now we fix the version to 0.7.1
#' @noRd
.available_sandbox <- function(version = "0.7.1") {
    .check_paws()
    .check_aws_region()
    message("checking scverse spatialdata-sandbox bucket...")
    s3 <-  paws.storage::s3(
        credentials=list(anonymous=TRUE),
        endpoint="https://s3.embl.de/")
    zz <- s3$list_objects(
        Bucket="spatialdata",
        Prefix="spatialdata-sandbox") 
    keys <- lapply(zz$Contents, "[[", "Key")
    keys <- basename(grepv("/", keys, fixed = TRUE))
    keys[!is.na(keys) & endsWith(keys, paste0(version, ".zip"))]
}

.check_paws <- function() {
    if (!requireNamespace("paws.storage", quietly=TRUE)) 
        stop(
            "install 'paws.storage' to use this function; without it",
            " we can't check existence of data in OSN bucket")
}

.check_aws_region <- function() {
    if(is.na(Sys.getenv("AWS_REGION", unset = NA)))
        stop(
            "Please set environmental variable 'AWS_REGION: e.g. ", 
            "Sys.setenv(AWS_REGION = 'us-east-1')" )
}
