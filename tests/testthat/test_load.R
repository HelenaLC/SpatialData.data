test_that("invalid id", {
  expect_error(SD.data_load("dataset"), 
               "Dataset 'dataset' not found!")
})

test_that("source list", {
  expect_true(all(unlist(strsplit(SD.data_list(TRUE)$`S3 buckets`, ", ")) %in%
                    c("biocOSN", "sandbox")))
})

test_that("invalid source", {
  expect_error(SD.data_load("ColorectalCarcinomaMIBITOF", src = "source"), 
               "Mismatching source/bucket")
})

test_that("source and dataset mismatch", {
  expect_error(SD.data_load("MouseBrainVisHD", src = "biocOSN"), 
               "Mismatching source/bucket")
})
