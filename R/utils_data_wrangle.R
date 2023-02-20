options("lubridate.week.start" = 1)

#' deal_with_ts_zh
#'
#' @description Convert Timestamp from Zurich data, which is given in local time,
#' to a timestamp with Central European Time
#'
#' @param zh tibble with zurich data, expect timestamp column (as character)
#'
#' @return zh tibble with timestamp converted to CET
#' @keywords internal
deal_with_ts_zh <- function(zh) {
  zh %>%
    dplyr::mutate(timestamp = lubridate::ymd_hm(timestamp, tz = "Europe/Zurich"))
}

#' deal_with_ts_utc
#'
#' @param df tibble with a timestamp column in utc
#'
#' @return tibble with timestamp column in local time, timestamp_utc has utc time
#' @keywords internal
deal_with_ts_utc <- function(df) {
  df %>%
    dplyr::mutate(timestamp_utc = timestamp,
           timestamp = lubridate::with_tz(timestamp, tz = "Europe/Zurich"))
}

#' add_date_components
#'
#' @param df tibble with a timestamp column
#'
#' @return tibble with year, month, week, day, hour, Minute added
#' @keywords internal
add_date_components <- function(df) {
  df <- df %>%
    dplyr::mutate(date = lubridate::as_date(timestamp),
                  year = lubridate::year(timestamp),
           isoyear = lubridate::isoyear(timestamp),
           month = lubridate::month(timestamp, label = TRUE, abbr = TRUE),
           week = lubridate::isoweek(timestamp),
           day = lubridate::day(timestamp),
           wday = lubridate::wday(timestamp, label = TRUE, abbr = TRUE,
                                  week_start = getOption("lubridate.week.start", 1)),
           yday = lubridate::yday(timestamp),
           hour = lubridate::hour(timestamp),
           minute = lubridate::minute(timestamp),
           timestamp_hours_only = lubridate::ymd_hm(
           glue::glue("{lubridate::year(timestamp)}-
           {lubridate::month(timestamp)}-
           {lubridate::day(timestamp)}T
           {lubridate::hour(timestamp)}:
           {lubridate::minute(timestamp)}"))) %>%
    dplyr::mutate(timestamp_hours_only = stats::update(timestamp_hours_only,
                                         year = 2000,
                                         month = 1,
                                         day = 1))
  # this way, the local time is used for timestamp_hours_only

  return(df)
}

#' get_clean_data
#'
#' @description function to check integrity of time series: checks for and removes
#' duplicates, fills gaps
#'
#' @param df tibble with timestamp
#'
#' @return clean time series (can be converted to tsibble without error)
#' @keywords internal
get_clean_data <- function(df) {
  # get rid of duplicates (as of 15/1/2023: 0)
  df <- df[!tsibble::are_duplicated(df, index = timestamp),]
  print("got rid of df duplicates")
  print(df[tsibble::are_duplicated(df, index = timestamp),])

  # fill gaps (as of 9/2/2023: 16)
  df_ts <- df %>%
    tsibble::tsibble(index = timestamp)
  n_gaps <- df_ts %>%
    tsibble::count_gaps() %>%
    dplyr::summarise(sum = sum(.n))
  print(glue::glue("filled {n_gaps$sum} gaps in df data"))

  df <- df_ts %>%
    tsibble::fill_gaps() %>%
    tidyr::fill(gross_energy_kwh, .direction = "down") %>%
    dplyr::tibble()

  return(df)
}
