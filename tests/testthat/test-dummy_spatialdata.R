library(SpatialData)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("generate_dataset()", {
  
  skip("turn off basilisk on GHA")
  # versions
  versions <- list(
    "0.7.2" = "zarr.json",
    "0.5.0" = ".zattrs"
  )
  
  # points work
  generate_dataset(sd_version = "0.7.2", 
                   points = list(list(n_points=12L)))
  
  # full spatialdata object works with 0.5.0 and 0.7.2
  lapply(names(versions), function(x){
    zarrfile <- tempfile(fileext = ".zarr")
    generate_dataset(
      file = zarrfile, 
      sd_version = x,
      images = list(
        list(type = "rgb", n_layers = 4L, coordinate_system="global"),
        list(type = "grayscale", n_layers = 1L, coordinate_system="global")
      ),
      labels = list(
        list(n_labels = 12L, n_layers = 4L, coordinate_system="global2"),
        list(n_labels = 12L, n_layers = 0L, coordinate_system="global2")
      ),
      shapes = list(
        list(n_shapes=12L, coordinate_system="global"),
        list(n_shapes=20L)
      ),
      points = list(
        list(n_points=12L)
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
    # TODO: read spatial data for v0.7.2
    if(x == "0.5.0"){
      sd <- readSpatialData(zarrfile)
      expect_s4_class(readSpatialData(zarrfile), "SpatialData")      
      expect_true(length(images(x)) > 0)
    }
  })
})