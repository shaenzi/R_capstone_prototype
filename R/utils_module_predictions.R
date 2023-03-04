#' predict_2_weeks
#'
#' @description function to predict the next two weeks' energy used based on
#' the past use, simple seasonal model with SNAIVE
#'
#' @param data tsibble with gross_energy_kwh and timestamp as index
#'
#' @return a fabletools forecast for the next two weeks with 80 and 95% extracted separately
#' @keywords internal
predict_2_weeks <- function(data) {
  print("forecasting")
  data %>%
    fabletools::model(stl = fabletools::decomposition_model(
    feasts::STL(gross_energy_kwh ~ season(window = NULL)),
    fable::SNAIVE(season_adjust))) %>%
    fabletools::forecast(h = "2 weeks") %>%
    dplyr::mutate(level80 = fabletools::hilo(gross_energy_kwh, 80),
                  level95 = fabletools::hilo(gross_energy_kwh, 95)) %>%
    dplyr::mutate(lower80 = level80$lower,
                  upper80 = level80$upper,
                  lower95 = level95$lower,
                  upper95 = level95$upper)
}

#' plot_prediction
#'
#' @param data fabletools forecast from predict_2_weeks
#' @param bs_colors named color vector with "secondary" color
#'
#' @return ggplot
#' @keywords internal
plot_prediction <- function(data, bs_colors) {
  print("plotting prediction")
  data %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower95, ymax = upper95),
                       fill = "#f0f0f0") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower80, ymax = upper80),
                       fill = "#bdbdbd") +
    ggplot2::geom_line(mapping = ggplot2::aes(y = .mean),
              color = bs_colors[["secondary"]],
              linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Next two weeks - predicting the energy use for every 15min",
                  subtitle = "Mean prediction with 80% (darker) and 95% (lighter) confidence level",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}

#' plot_prediction_and_actual
#'
#' @param data_predicted fabletools forecast from predict_2_weeks
#' @param data_actual tsibble on which the forecast is based
#' @param bs_colors named color vector with "secondary" color
#'
#' @return ggplot
#' @keywords internal
plot_prediction_and_actual <- function(data_predicted, data_actual, bs_colors) {
  print("plotting prediction and actual")
  data_predicted %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower95, ymax = upper95),
                         fill = "#f0f0f0") +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = lower80, ymax = upper80),
                         fill = "#bdbdbd") +
    ggplot2::geom_line(mapping = ggplot2::aes(y = .mean),
                       color = bs_colors[["secondary"]],
                       linewidth = 1) +
    ggplot2::geom_line(data = data_actual,
                       mapping = ggplot2::aes(x = timestamp, y = gross_energy_kwh),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Last two weeks predicted and actual energy use",
                  subtitle = "Mean prediction with 80% (darker) and 95% (lighter) confidence level vs. the <span style = 'color:#00bc8c;'>actual use</span>",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}
