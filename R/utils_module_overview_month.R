options("lubridate.week.start" = 1)

#' prepare_data_for_monthly_plot
#'
#' @description function to prepare reference data and current data for
#' monthly plot. prepares cumulative and non-cumulative data in one go.
#' a utility function in the overview module.
#'
#' @details goes back in time one month at a time from date_today until data is
#' present in the data tibble. Uses recursion for this.
#'
#' @param data tibble wi/bs/zh with year, month, sum_gross_energy columns
#' @param date_today today's date, e.g. with lubridate::today()
#' @param n_ref default 5, number of years to go back as reference (if 5,
#' previous 4 will be the reference)
#'
#' @return list of data_ref and data_current
#' @keywords internal
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
    dplyr::filter(lubridate::as_date(timestamp) > date_today - 38) %>%
    dplyr::group_by(yday) %>%
    dplyr::summarise(daily_use = sum(gross_energy_kwh),
                     date = lubridate::as_date(min(timestamp)),
                     n_entries_per_day = dplyr::n()) %>%
    dplyr::filter(n_entries_per_day > 94) %>% # should have 96 for a complete day, otherwise rolling average skewed
    dplyr::summarise(daily_use = data.table::frollmean(x = daily_use,
                                                       n = 7,
                                                       align = "center"),
                     date = date,
                     n_entries_per_day = n_entries_per_day,
                     yday = yday) %>%
    tidyr::fill(daily_use, .direction = "updown") %>%
    dplyr::ungroup() %>%
    dplyr::select(-n_entries_per_day) %>%
    dplyr::filter(as.numeric(lubridate::month(date)) == month_today) %>%
    dplyr::mutate(day = lubridate::day(date)) %>%
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

#' plot_month_reference
#'
#' @description function to plot the current data vs. a reference range for a month
#' A utility function for the overview module.
#'
#' @param data_ref data_ref output from prepare_data_for_monthly_plot function
#' @param data_current data_current output from prepare_data_for_monthly_plot function
#' @param bs_colors named hex color vector with "light", "secondary" and "success" colors
#'
#' @return ggplot
#' @keywords internal
plot_month_reference <- function(data_ref, data_current, bs_colors) {
  p <- data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = day)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min_ref, ymax = max_ref, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = mean_ref), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = daily_use),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001),
                                limits = c(0, NA)) +
    ggplot2::labs(title = glue::glue("Energy consumption per day in {format(min(data_current$date), format = '%B %Y')}"),
                  caption = "Seven day rolling average",
                  y = "GWh",
                  x = "Day of the month",
                  subtitle = "<span style = 'color:#00bc8c;'>Current energy use</span> compared to the range of energy use in the same month in the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())

  # if there is only one day to plot, plot as a point, not as a line
  if (nrow(data_current) == 1) {
    p <- p + ggplot2::geom_point(data = data_current, ggplot2::aes(y = daily_use),
                        color = bs_colors[["success"]])
  }

  p

}

#' plot_month_cumulative
#'
#' @description function to plot the current data vs. a reference range for a month
#' in a cumulative way. A utility function for the overview module.
#'
#' @param data_ref data_ref output from prepare_data_for_monthly_plot function
#' @param data_current data_current output from prepare_data_for_monthly_plot function
#' @param bs_colors named hex color vector with "light", "secondary" and "success" colors
#'
#' @return ggplot
#' @keywords internal
plot_month_cumulative <- function(data_ref, data_current, bs_colors) {
  data_ref %>%
    ggplot2::ggplot(ggplot2::aes(x = day)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = cum_min, ymax = cum_max, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = cum_mean), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = cum),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001),
                                limits = c(0, NA)) +
    ggplot2::labs(title = glue::glue("Cumulative energy consumption per day in {format(min(data_current$date), format = '%B %Y')}"),
                  caption = "Seven day rolling average",
                  x = "Day of the month",
                  y = "GWh",
                  subtitle = "<span style = 'color:#00bc8c;'>Current energy use</span> compared to the range of energy use in the same month in the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())

}
