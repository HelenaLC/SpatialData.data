
test_that("get basilisk environment", {
  expect_error(.get_basilisk_env("0.4.1"))
  expect_s4_class(.get_basilisk_env("0.3.0"), "BasiliskEnvironment")
  expect_s4_class(.get_basilisk_env("0.5.0"), "BasiliskEnvironment")
  expect_s4_class(.get_basilisk_env("0.7.2"), "BasiliskEnvironment")
})