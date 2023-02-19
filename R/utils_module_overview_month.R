options("lubridate.week.start" = 1)
prepare_data_for_monthly_plot <- function(data, date_today, n_ref = 5) {
  month_today <- lubridate::month(date_today)
  # as the reference period is smaller than a week, each day will have been unequal
  # times a weekday or a weekend. to avoid very ragged references, therefore calculate
  # a rolling 7 day average, with a central window, filling the first and last 3 values
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
    dplyr::summarise(min_ref = data.table::frollmean(x = min_ref,
                                                     n = 7,
                                                     align = "center"),
                     max_ref = data.table::frollmean(x = max_ref,
                                                     n = 7,
                                                     align = "center"),
                     mean_ref = data.table::frollmean(x = mean_ref,
                                                      n = 7,
                                                      align = "center"),
                     day = day) %>%
    tidyr::fill(c(min_ref, max_ref, mean_ref), .direction = "updown") %>%
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
                     n_entries_per_day = dplyr::n()) %>%
    dplyr::summarise(daily_use = data.table::frollmean(x = daily_use,
                                                       n = 7,
                                                       align = "center"),
                     date = date,
                     n_entries_per_day = n_entries_per_day,
                     day = day) %>%
    tidyr::fill(daily_use, .direction = "updown") %>%
    dplyr::ungroup() %>%
    dplyr::filter(n_entries_per_day > 94) %>% # should have 96 for a complete day
    dplyr::select(-n_entries_per_day) %>%
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
    ggplot2::labs(title = glue::glue("Energy consumption per day [GWh] in {format(min(data_current$date), format = '%B %Y')}"),
                  subtitle = "Seven day rolling average",
                  y = "",
                  x = "Day of the month",
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
    ggplot2::labs(title = glue::glue("Cumulative energy consumption per day [GWh] in {format(min(data_current$date), format = '%B %Y')}"),
                  subtitle = "Seven day rolling average",
                  x = "Day of the month",
                  y = "",
                  caption = "Relative to the previous 4 years")

}
