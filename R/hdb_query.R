#' Query HDB
#'
#' Query Bureau of Reclamation's public hydrologic database (HDB). A UI is
#' available at https://www.usbr.gov/lc/region/g4000/riverops/_HdbWebQuery.html.
#' Both observed data and modeled data can be queried.
#'
#' For specifying the start and end dates, they must be specified at the highest
#' precision required for the `time_step`, i.e., year and month for monthly,
#' year, month, day for daily, and year, month, day, hour minute for hourly and
#' instantaneous. Should be specified in yyyy-mm-dd hh:mm format. Days are
#' ignored if specified for monthly data.
#'
#' @param sdi Vector of all sdis to query from the specified server. It is up
#'   to the user to know what sdis are required and what server they are found
#'   on.
#'
#' @param server The (single) server to use.
#'
#' @param time_step The (single) time step of the data. Can also use the first
#'   letter, i.e., "i", "h", "d", or "m", respectively.
#'
#' @param start_date,end_date Start and end dates as character scalars. Must be
#'   specified to the highest precision necessary for the `time_step` in
#'   "yyyy-mm-dd hh:mm" format. See **Details**.
#'
#' @param mrid The model run ID. `NULL` to query observed data, otherwise
#'   specify the model run ID as a single numerical value.
#'
#' @export
hdb_query <- function(
  sdi,
  server = c("lc", "uc", "ecao", "yao", "lbao"),
  time_step = c("instantaneous", "hourly", "daily", "monthly"),
  start_date, end_date, mrid = NULL)
{
  assert_that(length(sdi) >= 1 && is.numeric(sdi))
  if (!is.null(mrid)) {
    assert_that(length(mrid) == 1 && is.numeric(mrid))
  }

  server <- match.arg(tolower(server), servers())
  server <- server_map()[server]
  time_step <- match.arg(tolower(time_step), time_steps())
  time_step <- ts_map()[time_step]

  # TODO: verify dates
  dates <- verify_dates(start_date, end_date, time_step)

  query_url <- construct_url(sdi, server, time_step, dates[1], dates[2], mrid)
  message("query url:\n", query_url)

  x <- get_data(query_url)

  x
}

construct_url <- function(sdi, server, time_step, start_date, end_date,
                          mrid = NULL) {
  sdi <- paste0("sdi=", paste(sdi, collapse = "%2C"))
  server <- paste0("svr=", server)
  time_step <- paste0("tstp=", time_step)
  start_date <- paste0("t1=", start_date)
  end_date <- paste0("t2=", end_date)

  if (is.null(mrid)) {
    # observed data
    table <- "table=R"
    mrid <- "mrid=0"
  } else {
    table <- "table=M"
    mrid <- paste0("mrid=", mrid)
  }

  format <- "format=json"

  params <- paste(sdi, server, time_step, start_date, end_date, table, mrid,
                  format, sep = "&")

  paste0(base_url(), params)
}

# x is url
get_data <- function(x) {

  # try the url multiple times since it seems like this is necessary
  # based on known working urls returning the html instead of JSON
  keep_trying <- TRUE
  try_count <- 1

  while (keep_trying) {
    if (try_count > 1) {
      message("Trying url ... try # ", try_count)
    }

    try_error <- try(y <- jsonlite::fromJSON(x, flatten = TRUE), silent = TRUE)

    if (methods::is(try_error, "try-error")) {
      if (try_count > getOption("rhdb.try_url_n")) {
        stop("Reached maximum number of tries without a successful response.\n",
             "Try again, or consider increasing the 'rhdb.try_url_n' option.")
      }
      try_count <- try_count + 1
    } else {
      keep_trying <- FALSE
    }
  }

  # convert the list into a data frame with attributes
  # data frame will have sdi, time_step, value, mrid, and units column
  # attributes will include QueryDate, StartDate, EndDate, TimeStep, DateSource
  # and Series that are all returned in the JSON file. Series will be converted
  # to sdi_metadata as it is its own data frame containing metadata associated
  # with the sdi
  sdi <- y$Series$SDI
  tsdata <- y$Series$Data
  names(tsdata) <- sdi

  tsdata <- lapply(sdi, function(ss) {
    tmp <- tsdata[[ss]]
    tmp[["sdi"]] <- ss

    # get mrid and units from the series data
    i <- match(ss, y$Series$SDI)
    tmp[["mrid"]] <- y$Series$MRID[i]
    tmp[["units"]] <- y$Series$DataTypeUnit[i]

    tmp
  })

  tsdata <- do.call(rbind, lapply(tsdata, function(i) as.data.frame(i)))

  # can return valid url with no data. If so, there is no "v" or "t" field
  if (!("v" %in% colnames(tsdata))) {
    tsdata$t <- ""
    tsdata$v <- ""
  }

  # reorder columns and change t v names to time_step, value
  tsdata <- tsdata[, c("sdi", "t", "mrid", "v", "units")]
  names(tsdata)[2] <- "time_step"
  names(tsdata)[4] <- "value"
  tsdata$sdi <- as.numeric(tsdata$sdi)
  tsdata$value <- as.numeric(tsdata$value)

  # add attributes
  attr(tsdata, "QueryDate") <- y$QueryDate
  attr(tsdata, "StartDate") <- y$StartDate
  attr(tsdata, "EndDate") <- y$EndDate
  attr(tsdata, "TimeStep") <- y$TimeStep
  attr(tsdata, "DataSource") <- y$DataSource
  attr(tsdata, "sdi_metadata") <- y$Series

  tsdata
}

base_url <- function() {
  "https://www.usbr.gov/pn-bin/hdb/hdb.pl?"
}

time_steps <- function() {
  c("instantaneous", "hourly", "daily", "monthly", "i", "h", "d", "m")
}

ts_map <- function() {
  x <- rep(c("IN", "HR", "DY", "MN"), 2)
  names(x) <- time_steps()
  x
}

servers <- function() {
  c("lc", "uc", "ecao", "yao", "lbao")
}

server_map <- function() {
  x <- c("lchdb", "uchdb2", "ecohdb", "yaohdb", "lbohdb")
  names(x) <- servers()
  x
}

verify_dates <- function(start_date, end_date, time_step) {
  assert_that(length(start_date) == 1 && length(end_date) == 1)
  assert_that(is.character(start_date) && is.character(end_date))

  dates <- c(start_date, end_date)

  if (time_step == "MN") {
    # monthly - always use 1 of month at 12:00 am regardless of what was passed
    # in for day
    dates <- lubridate::ymd(dates, truncated = 2)
    check_date_parse(dates)

    dates <- paste0(
      lubridate::year(dates),"-",lubridate::month(dates), "-01T00:00"
    )
  } else if (time_step == "DY") {
    # daily - use provided days
    dates <- lubridate::ymd(dates)
    check_date_parse(dates)

    dates <- paste0(dates, "T00:00")
  } else {
    # hourly/instantaneous
    dates <- lubridate::ymd_hm(dates)
    check_date_parse(dates)

    dates <- paste0(lubridate::year(dates), "-", lubridate::month(dates), "-",
                    lubridate::day(dates), "T",
                    sprintf("%02d", lubridate::hour(dates)), ":",
                    sprintf("%02d", lubridate::minute(dates)))
  }

  dates
}

check_date_parse <- function(x) {
  assert_that(
    !anyNA(x),
    msg = paste0(
      "Parsing dates failed.\n",
    "Please ensure `start_date` and `end_date` are provided in expected format."
    )
  )

  assert_that(
    x[2] >= x[1],
    msg = "`start_date` must be before or the same as `end_date`."
  )

  invisible(x)
}
