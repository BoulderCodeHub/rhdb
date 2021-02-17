
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

test_that("query fails when end_date is before start_date", {
  expect_error(hdb_query(21327, "lc", "m", "2020-09", "2020-08", 3125))

  expect_error(hdb_query(1840, "uc", "d", "2020-09-01", "2020-08-01"))

  expect_error(hdb_query(1792, "uc", "h", "2020-09-01 9:00", "2020-09-01 6:00"))
})
