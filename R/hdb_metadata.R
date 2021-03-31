#' Get hdb meta data
#'
#' `hdb_metadata()` gets the metadata for a particular hdb server and data type
#' (e.g., reservoir). This allows the user to find the correct SDI when knowing
#' a site name and variable type, rather than having to know the SDI directly.
#' **Currently, this only works for UC and LC reservoir data.** The data frame
#' has different variables depending on whether it is UC or LC.
#'
#' @param server Character scalar of server. Only "uc" or "lc" is valid.
#'
#' @param type Character scalar of data type. Only "reservoir" is valid.
#'
#' @return data frame
#'
#' @export
hdb_metadata <- function(server = "uc", type = "reservoir") {
  assert_that(length(server) == 1 && length(type) == 1)
  server <- tolower(server)
  assert_that(server %in% meta_valid_servers())
  assert_that(type %in% meta_valid_type())

  # right now only uc reservoir data is supported, so we know the url
  if (server == "uc") {
    r <- utils::read.csv(
      "https://www.usbr.gov/uc/water/hydrodata/reservoir_data/meta.csv"
    )
  } else {
    r <- lc_metadata
  }

  r
}

meta_valid_servers <- function() {
  c("uc", "lc")
}

meta_valid_type <- function() {
  c("reservoir")
}
