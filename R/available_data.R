#' SD.data_available
#' 
#' Function for interrogating files across buckets. Please use 
#' paws.storage::s3' to interrogate buckets for zipped zarr archives or 
#' raw readouts for various platforms.
#' 
#' @param source The name of the query bucket.
#' \describe{
#'  \item{biocOSN}{
#'    Bioc's Open Storage Network (NSF) OSN bucket (spatialdata v0.3.0, zarr v2)
#'  }
#'  \item{biocOSN_Xenium}{
#'    Raw Xenium readouts from Bioc's Open Storage Network (NSF) OSN bucket.
#'  }
#'  \item{sandbox}{
#'    scverse's spatialdata-sandbox bucket at EMBL.
#'  }
#' }
#' 
#' @examples
#' Sys.setenv(AWS_REGION = "us-east-1")
#' if (requireNamespace("paws.storage")) {
#'   SD.data_available("biocOSN")
#' }
#' @export
SD.data_available <- function(source = "biocOSN"){
  switch(source, 
         biocOSN = .available_biocOSN(),
         biocOSN_Xenium = .available_biocOSN_Xenium(),
         sandbox = .available_sandbox(), 
         {
           stop("Unknown bucket! Available values are ", 
                "'biocOSN', 'biocOSN_Xenium' and 'sandbox'.")
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
    basename(grepv("/", keys))
}

#' @noRd
.available_biocOSN_Xenium <- function() {
  .check_paws()
  .check_aws_region()
  message("checking Bioconductor OSN bucket (Xenium readouts) ...")
  s3 <- paws.storage::s3(
    credentials=list(anonymous=TRUE),
    endpoint="https://mghp.osn.xsede.org")
  zz <- s3$list_objects(
    Bucket="bir190004-bucket01", 
    Prefix="BiocXenDemo") 
  keys <- lapply(zz$Contents, "[[", "Key")
  keys <- basename(grepv("/", keys))
  keys[grepl("\\.zip$", keys)]
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
  keys <- basename(grepv("/", keys))
  keys[grepl(paste0(version, "\\.zip$"), keys)]
}

.check_paws <- function() {
  if (!requireNamespace("paws.storage", quietly=TRUE)) 
    stop("install 'paws.storage' to use this function; without it",
         " we can't check existence of data in OSN bucket")
}

.check_aws_region <- function() {
  if(is.na(Sys.getenv("AWS_REGION", unset = NA)))
    stop("Please set environmental variable 'AWS_REGION: e.g. ", 
         "Sys.setenv(AWS_REGION = 'us-east-1')" )
}
