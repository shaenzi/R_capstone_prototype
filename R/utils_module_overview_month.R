options("lubridate.week.start" = 1)
prepare_data_for_monthly_plot <- function(data, date_today, n_ref = 5) {
  month_today <- lubridate::month(date_today)
  data_ref <- data %>%
    dplyr::filter(as.numeric(month) == month_today,
           year < lubridate::year(date_today),
           year > (lubridate::year(date_today) - n_ref)) %>%
    dplyr::group_by(year, day) %>%
    dplyr::summarise(daily_use = sum(gross_energy_kwh)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(day) %>%
    dplyr::summarise(min_ref = min(daily_use),
                     max_ref = max(daily_use),
                     mean_ref = mean(daily_use)) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(day) %>%
    dplyr::mutate(cum_min = cumsum(min_ref),
           cum_max = cumsum(max_ref),
           cum_mean = cumsum(mean_ref))

  data_current <- data %>%
    dplyr::filter(as.numeric(month) == month_today,
           year == lubridate::year(date_today)) %>%
    dplyr::group_by(day) %>%
    dplyr::summarise(daily_use = sum(gross_energy_kwh),
                     date = lubridate::as_date(min(timestamp)),
                     n_entries_per_day = n()) %>%
    dplyr::ungroup() %>%
    filter(n_entries_per_day > 94) %>% # should have 96 for a complete day
    select(-n_entries_per_day) %>%
    dplyr::arrange(day) %>%
    dplyr::mutate(cum = cumsum(daily_use))

  results <- list("data_ref" = data_ref, "data_current" = data_current)

  # take last month's data if this month is not yet available
  if (nrow(data_current) == 0) {
    print("going one month back")
    # recursively call the same function with a date from the previous month
    # i.e. go one day further back than the day of the month
    current_mday <- lubridate::mday(date_today)
    results <- prepare_data_for_monthly_plot(
      data,
      date_today = date_today - (current_mday +1)
      )
  }

  return(results)
}

plot_month_reference <- function(data_ref, data_current) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = day)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min_ref, ymax = max_ref, group = 1),
                         fill = "lightblue") +
    ggplot2::geom_line(ggplot2::aes(y = mean_ref), color = "#B8B8B8") +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = daily_use)) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "",
         y = "Power consumption [GWh]",
         x = "Day of the month",
         title = glue::glue("{format(min(data_current$date), format = '%B %Y')}"),
         caption = "Relative to the previous 4 years")
}

plot_month_cumulative <- function(data_ref, data_current) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = day)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = cum_min, ymax = cum_max, group = 1),
                         fill = "lightblue") +
    ggplot2::geom_line(ggplot2::aes(y = cum_mean), color = "#B8B8B8") +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = cum)) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::labs(x = "",
         y = "Power consumption [GWh]",
         x = "Day of the month",
         title = glue::glue("{format(min(data_current$date), format = '%B %Y')}"),
         caption = "Relative to the previous 4 years")

}
