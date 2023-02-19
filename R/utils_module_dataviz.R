plot_daily_per_year <- function(data) {
  data %>%
    dplyr::group_by(year, yday) %>%
    dplyr::summarise(daily_sum = sum(gross_energy_kwh),
                     n_entries_per_day = dplyr::n()) %>%
    dplyr::ungroup() %>%
    # calculate 7 day average
    dplyr::mutate(daily_rolling_mean = data.table::frollmean(x = daily_sum,
                                                             n = 7,
                                                             align = "center")) %>%
    # leave the 3 NAs at the beginning and end, as filling with daily sum values gives large jumps
    #filter out incomplete days
    dplyr::filter(n_entries_per_day > 95) %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = yday,
                                           y = daily_rolling_mean,
                                           color = factor(year),
                                           group = year)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_color_viridis_d(option = "E") +
    ggplot2::labs(title = "Daily energy consumption",
                  x = "Day of the year",
                  y = "GWh",
                  color = "year",
                  subtitle = "Seven day rolling average") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
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
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_color_viridis_d(option = "E") +
    ggplot2::labs(title = "Weekly energy consumption",
                  x = "Week of the year",
                  y = "GWh",
                  color = "year") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
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
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_color_viridis_d(option = "E") +
    ggplot2::labs(title = "Monthly energy consumption",
                  x = "Month of the year",
                  y = "GWh",
                  color = "year") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}

#' heatmap_tod_date
#'
#' @description heatmeap with time of day on x and date on y axis, energy as colour
#'
#' @param df tibble with timestamp_hours_only, date, gross_energy_kwh columns
#' @param title string to be used as title
heatmap_tod_date <- function(data) {
  year <- unique(data$year)
  data %>%
    ggplot2::ggplot(ggplot2::aes(x = timestamp_hours_only, y = as.numeric(yday), fill = gross_energy_kwh)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_distiller(labels = scales::label_number(scale = 0.001),
                                  direction = 1) +
    ggplot2::scale_y_continuous(n.breaks = 6,
                                breaks = ggplot2::waiver(),
                                labels = ~ format(lubridate::as_date(.x, origin = "2022-01-01"),
                                                  format = "%b"),
                                trans = "reverse"
    ) +
    ggplot2::scale_x_datetime(labels = ~ format(.x, format = "%H:%M")) +
    ggplot2::labs(x = "Time of day",
                  y = "",
                  fill = "energy \nused [Mwh]",
                  title = year)
}
