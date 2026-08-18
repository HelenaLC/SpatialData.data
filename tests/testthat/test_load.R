test_that("invalid id", {
  expect_error(SD.data_load("dataset"), "Dataset not found")
})

test_that("source list", {
  expect_true(all(unlist(strsplit(SD.data_list()$S3_buckets, ", ")) %in%
                    c("biocOSN", "biocOSN_Xenium", "sandbox")))
})

test_that("invalid source", {
  expect_error(SD.data_load("ColorectalCarcinomaMIBITOF", source = "source"), 
               "Unknown source/bucket")
})

