predict_2_weeks <- function(data) {
  print("forecasting")
  data %>%
    fabletools::model(stl = fabletools::decomposition_model(
    feasts::STL(gross_energy_kwh ~ season(window = NULL)),
    fable::SNAIVE(season_adjust))) %>%
    fabletools::forecast(h = "2 weeks")
}

plot_prediction <- function(data) {
  print("plotting prediction")
  data %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggdist::stat_lineribbon(ggplot2::aes(ydist = gross_energy_kwh),
                    .width = c(.8, .95),
                    linewidth = 0.5) +
    ggplot2::scale_fill_brewer() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Next two weeks - prediction",
                  subtitle = "Energy used per 15min",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}

plot_prediction_and_actual <- function(data_predicted, data_actual) {
  print("plotting prediction and actual")
  data_predicted %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x = timestamp)) +
    ggdist::stat_lineribbon(ggplot2::aes(ydist = gross_energy_kwh),
                    .width = c(.8, .95),
                    linewidth = 0.5) +
    ggplot2::geom_line(data = data_actual,
                       mapping = ggplot2::aes(x = timestamp, y = gross_energy_kwh),
                       color = "red") +
    ggplot2::scale_fill_brewer() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Last two weeks predicted and actual",
                  subtitle = "Energy used per 15min",
                  y = "MWh") +
    ggplot2::theme(axis.title.y = ggplot2::element_text(angle = 0))
}
