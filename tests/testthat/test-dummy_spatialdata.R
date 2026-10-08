library(spatialdataR)
Sys.setenv(AWS_REGION = "us-east-1")

test_that("generate_dataset()", {
  
  # points work with no coordinate systems
  generate_dataset(points = list(list(n=12L)))
  
  # generate sd zarr object
  zarrfile <- tempfile(fileext = ".zarr")
  generate_dataset(
    file = zarrfile, 
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
  expect_true(file.exists(zarrfile))
})