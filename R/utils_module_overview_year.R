options("lubridate.week.start" = 1)
prepare_data_for_yearly_plot <- function(data, date_today, n_ref = 5) {
  month_today <- lubridate::month(date_today)
  data_ref <- data %>%
    dplyr::filter(year < lubridate::year(date_today),
           year > (lubridate::year(date_today) - n_ref)) %>%
    dplyr::group_by(year, month) %>%
    dplyr::summarise(monthly_use = sum(gross_energy_kwh)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(month) %>%
    dplyr::summarise(min_ref = min(monthly_use),
                     max_ref = max(monthly_use),
                     mean_ref = mean(monthly_use)) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(month) %>%
    dplyr::mutate(cum_min = cumsum(min_ref),
           cum_max = cumsum(max_ref),
           cum_mean = cumsum(mean_ref))

  data_current <- data %>%
    dplyr::filter(year == lubridate::year(date_today)) %>%
    dplyr::group_by(month) %>%
    dplyr::summarise(monthly_use = sum(gross_energy_kwh),
                     date = lubridate::as_date(min(timestamp)),
                     #n_entries_per_month = dplyr::n()
                     ) %>%
    dplyr::ungroup() %>%
    # dplyr::filter(n_entries_per_month > 95*15) %>% # should have 96 for a complete day
    # dplyr::select(-n_entries_per_month) %>%
    dplyr::arrange(month) %>%
    dplyr::mutate(cum = cumsum(monthly_use))

  results <- list("data_ref" = data_ref, "data_current" = data_current)

  # take last month's data if this month is not yet available
  if (nrow(data_current) == 0) {
    print("going one month back")
    # recursively call the same function with a date from the previous year
    # i.e. go one day further back than the day of the year
    current_yday <- lubridate::yday(date_today)
    results <- prepare_data_for_monthly_plot(
      data,
      date_today = date_today - (current_yday +1)
      )
  }

  return(results)
}

plot_year_reference <- function(data_ref, data_current) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = month)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min_ref, ymax = max_ref, group = 1),
                         fill = "lightblue") +
    ggplot2::geom_line(ggplot2::aes(y = mean_ref, group = 1), color = "#B8B8B8") +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = monthly_use, group = 1)) +
    ggplot2::geom_point(data = data_current, ggplot2::aes(y = monthly_use, group = 1)) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "",
         y = "Power consumption per day [GWh]",
         title = glue::glue("{format(lubridate::year(min(data_current$date)), format = '%Y')}"),
         caption = "Relative to the previous 4 years")
}

plot_year_cumulative <- function(data_ref, data_current) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = month)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = cum_min, ymax = cum_max, group = 1),
                         fill = "lightblue") +
    ggplot2::geom_line(ggplot2::aes(y = cum_mean, group = 1), color = "#B8B8B8") +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = cum, group = 1)) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "",
         y = "Power consumption per day [GWh]",
         title = glue::glue("{format(lubridate::year(min(data_current$date)), format = '%Y')}"),
         caption = "Relative to the previous 4 years")

}
