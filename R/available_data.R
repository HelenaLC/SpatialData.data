#' available
#' 
#' Function for interrogating files across buckets. Please use 'paws::s3' to 
#' interrogate buckets for zipped zarr archives or raw readouts for various 
#' platforms.
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
#' # TODO: turn off basilisk on GHA
#' # if (requireNamespace("paws")) {
#' #    available("biocOSN")
#' # }
#' @export
available <- function(source = "biocOSN"){
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

#' @noRd
.available_biocOSN_Xenium <- function() {
  .check_paws()
  message("checking Bioconductor OSN bucket (Xenium readouts) ...")
  s3 <- paws::s3(
    credentials=list(anonymous=TRUE),
    endpoint="https://mghp.osn.xsede.org")
  zz <- s3$list_objects(
    Bucket="bir190004-bucket01", 
    Prefix="BiocXenDemo") 
  keys <- lapply(zz$Contents, "[[", "Key")
  basename(grepv("/", keys))
}

#' @noRd
.available_sandbox <- function() {
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
