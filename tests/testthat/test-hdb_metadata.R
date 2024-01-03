test_that("hdb_metadata() errors correctly", {
  expect_error(hdb_metadata(server = "ecao"))
  expect_error(hdb_metadata(type = "gage"))
  expect_error(hdb_metadata(c("uc", "lc")))
  expect_error(hdb_metadata(type = c("reservoir", "gage")))
})

test_that("hdb_metadata() returns correctly", {
  expect_s3_class(hdb_metadata(), "data.frame")
})
