#' prepare_zh_details_years
#'
#' @description wrangle zh_details data into values per year in long format
#'
#' @param zh_details tibble with timestamp, value_n5, valuene7 columns
#'
#' @return tibble yearly values by ne (Netzebene)
#' @keywords internal
prepare_zh_details_years <- function(zh_details){
  zh_details |>
    dplyr::mutate(year = lubridate::year(timestamp)) |>
    dplyr::filter(year < lubridate::year(lubridate::today())) |>
    dplyr::group_by(year) |>
    dplyr::summarise(ne5 = sum(value_ne5),
                     ne7 = sum(value_ne7)) |>
    tidyr::pivot_longer(cols = c("ne5", "ne7"),
                        names_to = "category",
                        values_to = "value")
}

#' plot_zh_details_years
#'
#' @description function to plot one value per year for the household/industry
#' as an area plot. a utility for the zh_details module
#'
#' @param zh_details_yearly tibble prepared by prepare_zh_details_years
#' @param bs_colors named color vector with success and primary colors
#'
#' @return ggplot
#' @keywords internal
plot_zh_details_years <- function(zh_details_yearly, bs_colors) {
  zh_details_yearly |>
    ggplot2::ggplot(ggplot2::aes(x = year, y = value, fill = category))+
    ggplot2::geom_area()+
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_x_continuous(breaks = seq(2010, 2022, 3)) +
    ggplot2::scale_fill_manual(values = c(bs_colors[["success"]], bs_colors[["primary"]]),
                               labels = c("ne5" = "industry", "ne7" = "households")) +
    ggplot2::labs(title = "Total energy consumption per year",
                  y = "GWh",
                  x = "",
                  fill = "") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}

#' prepare_zh_details_last_week
#'
#' @description wrangle zh_details data into values for last week in long format
#'
#' @param zh_details tibble with timestamp, value_n5, valuene7 columns
#'
#' @return tibble with values over one week values by ne (Netzebene)
#' @keywords internal
prepare_zh_details_last_week <- function(zh_details){
  latest_date <- max(lubridate::as_date(zh_details$timestamp))
  zh_details |>
    dplyr::select(-timestamp_utc) |>
    dplyr::filter(timestamp >= lubridate::floor_date(latest_date, unit = "week")) |>
    dplyr::group_by(lubridate::wday(timestamp),
                    lubridate::hour(timestamp),
                    lubridate::minute(timestamp)) |>
    dplyr::mutate(step_in_week = dplyr::cur_group_id()) |>
    dplyr::ungroup() |>
    dplyr::arrange(step_in_week) |>
    dplyr::mutate(cum_ne5 = cumsum(value_ne5),
                  cum_ne7 = cumsum(value_ne7)) |>
    tidyr::pivot_longer(cols = c(value_ne5, value_ne7),
                        names_to = "category")
}

#' plot_zh_details_last_week
#'
#' @description function to plot the last week for the household/industry
#' as an area plot. a utility for the zh_details module
#'
#' @param zh_details_week tibble prepared by prepare_zh_details_last_week
#' @param bs_colors named color vector with success and primary colors
#'
#' @return ggplot
#' @keywords internal
plot_zh_details_last_week <- function(zh_details_week, bs_colors){
  zh_details_week |>
    dplyr::mutate(category = forcats::fct_rev(category)) |>
    ggplot2::ggplot(ggplot2::aes(x = step_in_week, y = value, fill = category)) +
    ggplot2::geom_area() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::scale_x_continuous(breaks = seq(49,625,96),
                       labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")) +
    ggplot2::scale_fill_manual(values = c(bs_colors[["success"]], bs_colors[["primary"]]),
                               labels = c("value_ne5" = "industry", "value_ne7" = "households etc.")) +
    ggplot2::labs(x = "",
         y = "MWh",
         title = paste0(
           "Energy consumption in the week starting on ",
           format(lubridate::as_date(min(zh_details_week$timestamp)),
                  format = '%d %b %Y')),
         fill = "") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}

#' prepare_zh_details_last_year
#'
#' @description wrangle zh_details data into values for last year in long format
#'
#' @param zh_details tibble with timestamp, value_n5, valuene7 columns
#'
#' @return tibble with monthly values for last year by ne (Netzebene)
#' @keywords internal
prepare_zh_details_last_year <- function(zh_details){
  latest_date <- max(lubridate::as_date(zh_details$timestamp))
  last_year  <- lubridate::year(latest_date - 365)
  zh_details |>
    dplyr::filter(lubridate::year(timestamp) == last_year) |>
    dplyr::select(-timestamp_utc) |>
    dplyr::mutate(date = lubridate::as_date(timestamp)) |>
    dplyr::group_by(date) |>
    dplyr::summarise(daily_ne5 = cumsum(value_ne5),
                     daily_ne7 = cumsum(value_ne7))  |>
    dplyr::ungroup() |>
    dplyr::mutate(year = lubridate::year(date),
                  month = lubridate::month(date)) |>
    dplyr::group_by(year, month) |>
    dplyr::summarise(monthly_avg_ne5 = mean(daily_ne5),
                     monthly_avg_ne7 = mean(daily_ne7))|>
    tidyr::pivot_longer(cols = dplyr::starts_with("monthly"),
                        names_to = "category")
}

#' plot_zh_details_last_year
#'
#' @description function to plot last year's monthly values for the household/industry
#' as an area plot. a utility for the zh_details module
#'
#' @param zh_details_last_year tibble prepared by prepare_zh_details_last_year
#' @param bs_colors named color vector with success and primary colors
#'
#' @return ggplot
#' @keywords internal
plot_zh_details_last_year <- function(zh_details_last_year, bs_colors) {
  year <- zh_details_last_year$year[[1]]
  zh_details_last_year  |>
    ggplot2::ggplot(ggplot2::aes(x = month, y = value, fill = category)) +
    ggplot2::geom_area()+
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_x_continuous(breaks = seq(12)) +
    ggplot2::scale_fill_manual(values = c(bs_colors[["success"]], bs_colors[["primary"]]),
                               labels = c("monthly_avg_ne5" = "industry",
                                            "monthly_avg_ne7" = "households")) +
    ggplot2::labs(x = "month",
         y = "GWh",
         title = paste0("Daily energy consumption in Zurich in ", year),
         subtitle = "Averaged per month",
         fill = "") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}
