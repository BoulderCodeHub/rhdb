
# verify_dates <- function(start_date, end_date, time_step) ------------
test_that("verify_dates works as expected", {
  vd <- rhdb:::verify_dates
  expect_identical(
    vd("2020-1", "2020-12", "MN"),
    c("2020-1-01T00:00", "2020-12-01T00:00")
  )
  expect_identical(
    vd("2020-1", "2020-12", "MN"),
    vd("2020-1-31", "2020-12-31", "MN")
  )
  expect_identical(
    vd("2020-1", "2020-12", "MN"),
    vd("2020-1-1", "2020-12-17", "MN")
  )
})
