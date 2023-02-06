plot_daily_per_year <- function(data) {
  data %>%
    dplyr::group_by(year, yday) %>%
    dplyr::summarise(daily_sum = sum(gross_energy_kwh),
                     n_entries_per_day = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::filter(n_entries_per_day > 94) %>% # should have 96 for a complete day
    ggplot2::ggplot(mapping = ggplot2::aes(x = yday, y = daily_sum, color = factor(year))) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "Day of the year",
                  y = "Daily energy consumption [GWh]",
                  color = "year")
}

plot_weekly_per_year <- function(data) {
  data %>%
    dplyr::group_by(isoyear, week) %>%
    dplyr::summarise(weekly_sum = sum(gross_energy_kwh),
                     n_entries_per_week = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::filter(n_entries_per_week > (94*7)) %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = week,
                                           y = weekly_sum,
                                           color = factor(isoyear),
                                           group = isoyear)) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "Week of the year",
                  y = "Weekly energy consumption [GWh]",
                  color = "year")
}

plot_monthly_per_year <- function(data) {
  data %>%
    dplyr::group_by(year, month) %>%
    dplyr::summarise(monthly_sum = sum(gross_energy_kwh),
                     n_entries_per_month = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::filter(n_entries_per_month >= (96*28)) %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = month,
                                           y = monthly_sum,
                                           color = factor(year),
                                           group = year)) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "Month of the year",
                  y = "Monthly energy consumption [GWh]",
                  color = "year")
}

#' heatmap_tod_date
#'
#' @description heatmeap with time of day on x and date on y axis, energy as colour
#'
#' @param df tibble with timestamp_hours_only, date, gross_energy_kwh columns
#' @param title string to be used as title
#'
#' @return
#' @export
#'
#' @examples
heatmap_tod_date <- function(data) {
  data %>%
    ggplot2::ggplot(ggplot2::aes(x = timestamp_hours_only, y = as.numeric(yday), fill = gross_energy_kwh)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_continuous(labels = scales::label_number(scale = 0.001)) +
    # rcartocolor::scale_fill_carto_c(palette = "Emrld",
    #                                 ) +
    ggplot2::scale_y_continuous(n.breaks = 6,
                                breaks = ggplot2::waiver(),
                                labels = ~ format(lubridate::as_date(.x, origin = "2022-01-01"),
                                                  format = "%b"),
                                trans = "reverse") +
    ggplot2::scale_x_datetime(labels = ~ format(.x, format = "%H:%M")) +
    ggplot2::labs(x = "",
                  y = "",
                  fill = "gross energy \nused [Mwh]")
}
