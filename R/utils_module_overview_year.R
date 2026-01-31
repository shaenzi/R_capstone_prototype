options("lubridate.week.start" = 1)

#' prepare_data_for_yearly_cumulative_plot
#'
#' @description function to prepare reference data and current data for cumulative
#' yearly plot. a utility function in the overview module.
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
prepare_data_for_yearly_cumulative_plot <- function(data, date_today, n_ref = 5) {
  month_today <- lubridate::month(date_today)
  data_ref <- data |>
    dplyr::filter(year < lubridate::year(date_today),
                  year > (lubridate::year(date_today) - n_ref)) |>
    dplyr::group_by(year, month) |>
    dplyr::summarise(monthly_use = sum(gross_energy_kwh)) |>
    dplyr::ungroup() |>
    dplyr::group_by(month) |>
    dplyr::summarise(min_ref = min(monthly_use),
                     max_ref = max(monthly_use),
                     mean_ref = mean(monthly_use)) |>
    dplyr::ungroup() |>
    dplyr::arrange(month) |>
    dplyr::mutate(cum_min = cumsum(min_ref),
                  cum_max = cumsum(max_ref),
                  cum_mean = cumsum(mean_ref))

  # only show months that are (almost) completed
  if (lubridate::day(date_today) < 28) {
    data_filt <- data |>
      dplyr::filter(year == lubridate::year(date_today)) |>
      dplyr::filter(as.numeric(month) < lubridate::month(date_today))
  } else {
    data_filt <- data |>
      dplyr::filter(year == lubridate::year(date_today))
  }

  data_current <- data_filt |>
    dplyr::group_by(month) |>
    dplyr::summarise(monthly_use = sum(gross_energy_kwh),
                     date = lubridate::as_date(min(timestamp)),
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(month) |>
    dplyr::mutate(cum = cumsum(monthly_use))

  results <- list("data_ref" = data_ref, "data_current" = data_current)

  if (nrow(data_current) == 0) {
    print("going one month back")
    # recursively call the same function with a date from the previous year
    # i.e. go one day further back than the day of the year
    current_yday <- lubridate::yday(date_today)
    results <- prepare_data_for_yearly_cumulative_plot(
      data,
      date_today = date_today - (current_yday +1)
    )
  }

  return(results)
}

#' prepare_data_for_yearly_plot
#'
#' @description function to prepare reference data and current data for
#' yearly plot. a utility function in the overview module.
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
prepare_data_for_yearly_plot <- function(data, date_today, n_ref = 5) {
  month_today <- lubridate::month(date_today)
  data_ref <- data |>
    dplyr::filter(year < lubridate::year(date_today),
                  year > (lubridate::year(date_today) - n_ref)) |>
    dplyr::group_by(year, yday) |>
    dplyr::summarise(daily_use = sum(gross_energy_kwh),
                     month = min(month)) |>
    dplyr::ungroup() |>
    dplyr::group_by(year, month) |>
    dplyr::summarise(daily_mean_per_month = mean(daily_use)) |>
    dplyr::ungroup() |>
    dplyr::group_by(month) |>
    dplyr::summarise(min_ref = min(daily_mean_per_month),
                     max_ref = max(daily_mean_per_month),
                     mean_ref = mean(daily_mean_per_month)) |>
    dplyr::ungroup()

  data_current <- data |>
    dplyr::filter(year == lubridate::year(date_today)) |>
    dplyr::group_by(yday) |>
    dplyr::summarise(daily_use = sum(gross_energy_kwh),
                     date = lubridate::as_date(min(timestamp)),
                     month = min(month)) |>
    dplyr::ungroup() |>
    dplyr::group_by(month) |>
    dplyr::summarise(daily_mean_per_month = mean(daily_use),
                     date = max(date))

  results <- list("data_ref" = data_ref, "data_current" = data_current)

  # take last month's data if this month is not yet available
  if (nrow(data_current) == 0) {
    print("going one month back")
    # recursively call the same function with a date from the previous year
    # i.e. go one day further back than the day of the year
    current_yday <- lubridate::yday(date_today)
    results <- prepare_data_for_yearly_plot(
      data,
      date_today = date_today - (current_yday +1)
    )
  }

  return(results)
}

#' plot_year_reference
#'
#' @description function to plot the current data vs. a reference range for a year.
#' A utility function for the overview module.
#'
#' @param data_ref data_ref output from prepare_data_for_yearly_plot function
#' @param data_current data_current output from prepare_data_for_yearly_plot function
#' @param bs_colors named hex color vector with "light", "secondary" and "success" colors
#'
#' @return ggplot
#' @keywords internal
plot_year_reference <- function(data_ref, data_current, bs_colors) {
  data_ref |>
    ggplot2::ggplot(ggplot2::aes(x = month)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min_ref, ymax = max_ref, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = mean_ref, group = 1), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = daily_mean_per_month, group = 1),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001),
                                limits = c(0, NA)) +
    ggplot2::labs(title = glue::glue(
      "Daily energy consumption averaged per month in ",
      "{format(lubridate::year(min(data_current$date)), format = '%Y')}"),
      x = "",
      y = "GWh",
      subtitle = "<span style = 'color:#00bc8c;'>This year's energy use</span> compared to the range of energy use in the same month in the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}

#' plot_year_cumulative
#'
#' @description function to plot the current data vs. a reference range for a year
#' in a cumulative way. A utility function for the overview module.
#'
#' @param data_ref data_ref output from prepare_data_for_yearly_cumulative_plot function
#' @param data_current data_current output from prepare_data_for_yearly_cumulative_plot function
#' @param bs_colors named hex color vector with "light", "secondary" and "success" colors
#'
#' @return ggplot
#' @keywords internal
plot_year_cumulative <- function(data_ref, data_current, bs_colors) {
  data_ref |>
    ggplot2::ggplot(ggplot2::aes(x = month)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = cum_min, ymax = cum_max, group = 1),
                         fill = bs_colors[["light"]], alpha = 0.8) +
    ggplot2::geom_line(ggplot2::aes(y = cum_mean, group = 1), color = bs_colors[["secondary"]]) +
    ggplot2::geom_line(data = data_current, ggplot2::aes(y = cum, group = 1),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001),
                                limits = c(0, NA)) +
    ggplot2::labs(title = glue::glue(
      "Cumulative energy consumption in ",
      "{format(lubridate::year(min(data_current$date)), format = '%Y')}"),
      x = "",
      y = "GWh",
      caption = "Only months that are (almost) complete are shown.",
      subtitle = "<span style = 'color:#00bc8c;'>This year's energy use</span> compared to the range of energy use in the same month in the previous 4 years") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}
