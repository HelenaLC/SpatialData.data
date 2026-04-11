library(SpatialData)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("generate_dataset()", {
  
  # skip("turn off basilisk on GHA")
  # versions
  versions <- list(
    "0.7.2" = "zarr.json",
    "0.5.0" = ".zattrs"
  )
  
  # points work with no coordinate systems
  generate_dataset(sd_version = "0.7.2", points = list(list(n=12L)))
  
  # full spatialdata object works with 0.5.0 and 0.7.2
  lapply(names(versions), function(x){
    
    # generate sd zarr object
    zarrfile <- tempfile(fileext = ".zarr")
    generate_dataset(
      file = zarrfile, 
      sd_version = x,
      images = list(
        list(type = "rgb", scale_factors = c(2L,2L,2L), coordinate_system="global"),
        list(type = "grayscale", coordinate_system="global")
      ),
      labels = list(
        list(n = 12L, scale_factors = c(2L,2L,2L), coordinate_system="global2"),
        list(n = 12L, coordinate_system="global2")
      ),
      shapes = list(
        list(n=12L, type = "polygon", coordinate_system="global"),
        list(n=20L, type = "polygon")
      ),
      points = list(
        list(n=12L)
      ),
      coordinate_systems = list(
        global = list(
          transformations = list("affine"), 
          shape = list(x=2000L, y=2000L)
        ),
        global2 = list(
          transformations = list("scale", "translation"), 
          shape = list(x=500L, y=500L)
        )
      )
    )
    
    # check zarr version
    expect_true(
      file.exists(
        file.path(zarrfile, versions[[x]])
      )
    )
    
    # check read for only 0.5.0
    if(x == "0.5.0"){
      sd <- readSpatialData(zarrfile)
      expect_s4_class(sd <- readSpatialData(zarrfile), "SpatialData")      
      expect_true(length(images(sd)) > 0)
    }
  })
})