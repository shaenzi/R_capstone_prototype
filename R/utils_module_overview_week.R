options("lubridate.week.start" = 1)
prepare_data_for_weekly_plot <- function(data, date_today, n_ref = 5) {
  data_ref <- data %>%
    dplyr::filter(week == lubridate::isoweek(date_today),
                  isoyear < lubridate::isoyear(date_today),
                  isoyear > (lubridate::isoyear(date_today) - n_ref)) %>%
    dplyr::group_by(wday, hour, minute) %>%
    dplyr::summarise(step_in_week = dplyr::cur_group_id(),
                     min_ref = min(gross_energy_kwh),
                     max_ref = max(gross_energy_kwh),
                     mean_ref = mean(gross_energy_kwh)) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(step_in_week) %>%
    dplyr::mutate(cum_min = cumsum(min_ref),
                  cum_max = cumsum(max_ref),
                  cum_mean = cumsum(mean_ref))

  data_current <- data %>%
    dplyr::filter(week == lubridate::isoweek(date_today),
                  isoyear == lubridate::isoyear(date_today)) %>%
    dplyr::group_by(wday, hour, minute) %>%
    dplyr::mutate(step_in_week = dplyr::cur_group_id()) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(step_in_week) %>%
    dplyr::mutate(cum = cumsum(gross_energy_kwh))

  results <- list("data_ref" = data_ref, "data_current" = data_current)

  # take last week's data if this week is not yet available
  if (nrow(data_current) == 0) {
    print("going one week back")
    results <- prepare_data_for_weekly_plot(data, date_today = date_today -7)
  }

  return(results)
}

plot_week_reference <- function(data_ref, data_current, bs_colors) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = step_in_week)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min_ref, ymax = max_ref, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = mean_ref), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = gross_energy_kwh),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::scale_x_continuous(breaks = seq(49,625,96),
                                labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")) +
    ggplot2::labs(title = glue::glue(
      "Energy consumption in the week starting on ",
      "{format(lubridate::as_date(min(data_current$timestamp)), format = '%d %b %Y')}"),
                  x = "",
                  y = "MWh",
                  caption = "Relative to the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}

plot_week_cumulative <- function(data_ref, data_current, bs_colors) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = step_in_week)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = cum_min, ymax = cum_max, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = cum_mean), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = cum),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_x_continuous(breaks = seq(49,625,96),
                                labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")) +
    ggplot2::labs(title = glue::glue(
      "Cumulative energy consumption in the week starting on",
      "{format(lubridate::as_date(min(data_current$timestamp)), format = '%d %b %Y')}"),
                  x = "",
                  y = "GWh",
                  caption = "Relative to the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))

}
