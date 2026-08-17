library(spatialdataR)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("SD.io_available()", {
    x <- SD.io_available()   # lists methods known to spatialdata-io python module
    expect_is(x, "character")
    expect_true(length(x) > 0)
    expect_true(any(grepl("^(vis|xen)", x)))
})

test_that("SD.io()", {
    
    # directory already exists
    dir.create(out <- tempfile())
    options(sd_version = "0.3.0")
    expect_error(SD.io("xenium", src, out))
    
    # invalid platform specification
    out <- tempfile()
    expect_error(SD.io(".", src, out))
    
    # read'n'write using 'spatialdata-io'
    SD.io("xenium", src, out)
    x <- readSpatialData(out)
    expect_s4_class(x, "SpatialData")
}) 
