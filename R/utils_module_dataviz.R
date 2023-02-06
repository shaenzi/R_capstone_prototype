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
