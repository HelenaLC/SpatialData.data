library(SpatialData)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("generate_dataset()", {
  
  # points work
  generate_dataset(points = list(list(n_points=12L)))
  
  # points and shapes
  metadata <- list(
    "0.7.2" = "zarr.json",
    "0.5.0" = ".zattrs"
  )
  lapply(names(metadata), function(x){
    zarrfile <- tempfile(fileext = ".zarr")
    generate_dataset(
      file = zarrfile, 
      sd_version = x,
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
    expect_true(
      file.exists(
        file.path(zarrfile, metadata[[x]])
      )
    )
    
    # check read for only 0.5.0
    if(x == "0.5.0"){
      expect_s4_class(readSpatialData(zarrfile), "SpatialData")      
    }
  })
})