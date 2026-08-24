library(spatialdataR)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("SD.io_readers()", {
    x <- SD.io_readers()   # lists methods known to spatialdata-io python module
    expect_is(x, "character")
    expect_true(length(x) > 0)
    expect_true(any(grepl("^(vis|xen)", x)))
})

path_to_10x_xen_demo <- function(
    cache=BiocFileCache::BiocFileCache(),
    zipname="Xenium_V1_human_Breast_2fov_outs.zip", 
    source = "biocOSN_Xenium") {
  info <- BiocFileCache::bfcquery(cache, zipname)
  nrec <- nrow(info)
  if (nrec > 1) {
    message(sprintf("multiple %s found in cache, using last recorded", zipname))
  }
  if (nrec == 1) {
    message("returning path to cached zip")
    return(info$rpath[nrec])
  }
  fp <- file.path(bucket_path(source), zipname)
  message(sprintf("retrieving from %s, caching, and returning path", 
                  bucket_path(source)))
  BiocFileCache::bfcadd(cache, rname=zipname, fpath=fp, rtype="web")
}

test_that("SD.io()", {
  
    # get dataset
    zip <- path_to_10x_xen_demo()
    dir.create(src <- tempfile())
    unzip(zip, exdir=src)

    # directory already exists
    dir.create(out <- tempfile())
    options(sd_version = "0.5.0")
    expect_error(SD.io("xenium", src, out))
    
    # invalid platform specification
    out <- tempfile()
    expect_error(SD.io(".", src, out))
    
    # read'n'write using 'spatialdata-io'
    SD.io("xenium", src, out)
    x <- readSpatialData(out)
    expect_s4_class(x, "SpatialData")
}) 
