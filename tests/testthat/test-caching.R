library(SpatialData)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("available_sdio()", {
    skip("TODO: turn off basilisk in GHA for now")
    x <- available_sdio()   # lists methods known to spatialdata-io python module
    expect_is(x, "character")
    expect_true(length(x) > 0)
    expect_true(any(grepl("^(vis|xen)", x)))
})

# TODO: turn off basilisk on GHA
# is no longer available via spatialdata_io
test_that("use_sdio()", {
  
    # get dataset
    zip <- SpatialData.data:::.path_to_10x_xen_demo()
    dir.create(src <- tempfile())
    unzip(zip, exdir=src)
    
    # directory already exists
    dir.create(out <- tempfile())
    options(sd_version = "0.3.0")
    # expect_error(use_sdio("xenium", src, out))
    
    # invalid platform specification
    out <- tempfile()
    # expect_error(use_sdio(".", src, out))
    
    # read'n'write using 'spatialdata-io'
    # use_sdio("xenium", src, out)
    # x <- readSpatialData(out)
    # expect_s4_class(x, "SpatialData")
}) 

.clean_cache <- \(zip) {
    ca <- BiocFileCache::BiocFileCache()
    qu <- BiocFileCache::bfcquery(ca, zip)
    if (nrow(qu) > 0) BiocFileCache::bfcremove(ca, qu$rid)
}
