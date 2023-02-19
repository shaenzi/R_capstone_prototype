predict_2_weeks <- function(data) {
  print("forecasting")
  data %>%
    fabletools::model(stl = fabletools::decomposition_model(
    feasts::STL(gross_energy_kwh ~ season(window = NULL)),
    fable::SNAIVE(season_adjust))) %>%
    fabletools::forecast(h = "2 weeks")
}

plot_prediction <- function(data, bs_colors) {
  print("plotting prediction")
  data %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggdist::stat_lineribbon(ggplot2::aes(ydist = gross_energy_kwh),
                    .width = c(.8, .95),
                    linewidth = 0.1) +
    ggplot2::geom_line(mapping = ggplot2::aes(y = .mean),
              color = bs_colors[["secondary"]],
              linewidth = 1) +
    ggplot2::scale_fill_brewer(palette = "Greys") +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Next two weeks - predicting the energy use for every 15min",
                  subtitle = "Mean prediction with 80% (darker) and 95% (lighter) confidence level",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}

plot_prediction_and_actual <- function(data_predicted, data_actual, bs_colors) {
  print("plotting prediction and actual")
  data_predicted %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggdist::stat_lineribbon(ggplot2::aes(ydist = gross_energy_kwh),
                    .width = c(.8, .95),
                    linewidth = 0.1) +
    ggplot2::geom_line(mapping = ggplot2::aes(y = .mean),
                       color = bs_colors[["secondary"]],
                       linewidth = 1) +
    ggplot2::geom_line(data = data_actual,
                       mapping = ggplot2::aes(x = timestamp, y = gross_energy_kwh),
                       color = bs_colors[["success"]],
                       linewidth = 1) +
    ggplot2::scale_fill_brewer(palette = "Greys") +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Last two weeks predicted and actual energy use",
                  subtitle = "Mean prediction with 80% (darker) and 95% (lighter) confidence level vs. the <span style = 'color:#00bc8c;'>actual use</span>",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0),
                   plot.subtitle = ggtext::element_markdown())
}
